//--------------------------------------------------------------------------------------------------------------------------------------
//
//	PROJECT_TITLE
//
//	Created by [NAME]
// 	[DATE]
//
//	[DESCRIPTION]
//
//--------------------------------------------------------------------------------------------------------------------------------------


//--------------------------------------------------------------------------------------------------------------------------------------
// LIBRARIES
//--------------------------------------------------------------------------------------------------------------------------------------

#include <xparameters.h>
#include <xil_io.h>
#include <xstatus.h>
#include <stdlib.h>
#include "xhwicap_i.h"
#include "xhwicap.h"
#include "xuartlite_l.h"
#include "main.h"
#include "xuartlite_i.h"
#include "xspi.h"
#include "xspi_l.h"
#include "xgpio.h"
#include "sleep.h"


//--------------------------------------------------------------------------------------------------------------------------------------
// MACROS
//--------------------------------------------------------------------------------------------------------------------------------------


#define	SEM_IDLE	0xE
#define SEM_OBSV	0xA
#define SEM_RST		0xB


//--------------------------------------------------------------------------------------------------------------------------------------
// GLOBAL VARIABLES
//--------------------------------------------------------------------------------------------------------------------------------------

static XGpio 		GPIO_0;				// GPIO to send SEM commands
static XGpio 		GPIO_1;				// GPIO to monitor SEM and ICAP

static XHwIcap  	HwIcap_SLR0;		// The instance of the HWICAP device
static XHwIcap  	*curIcap;			// ICAP currently being used

static XUartLite 	Uart; 				// The instance of the UART device

static XSpi			SPI_Device;			// The instance of the SPI device


//--------------------------------------------------------------------------------------------------------------------------------------
// FUNCTION PROTOTYPES
//--------------------------------------------------------------------------------------------------------------------------------------

// Function to initialize all IP Devices
int initIp();


// Function to initialize GPIO Devices 1 and 2
int init_GPIO( XGpio_Config *GPIO_0_config, XGpio_Config *GPIO_1_config );

// Function to initialize the UART Device
int init_UART( XUartLite_Config *UART_Config );

// Function to initialize the ICAP Device
int init_ICAP( XHwIcap_Config *ICAP_config );

// Function to initialize the SPI Device
int init_SPI( XSpi_Config *SPI_config );


// Function to put the SEM in IDLE
int sem_idle();

// Function to put the SEM in OBSERVATION
int sem_observation();

// Function to put the SEM in OBSERVATION
int sem_reset();


// Function to perform the partial reconfiguration
int recPartial(XHwIcap *icapTarget, u32 numBytes);


// Function to return ICAP ID code
u32 readIdCode(XHwIcap *icapTarget);


// Function to print the menu
void menu();


//--------------------------------------------------------------------------------------------------------------------------------------
// MAIN FUNCTION
//--------------------------------------------------------------------------------------------------------------------------------------

// Main function
int main (void) {

	u8 Exit 			= 0;
	u8 operation 		= 0;

	u32 i 				= 0;			// Variable for loops
	u32 partialSize		= 112700; 		// Size in bytes of partial bitstream to be received
	u32 dev_id;  						// Device id code and word to be written to ICAP

	int Status;							// Variable for AXI Device status
	int charCount 		= 0; 			// Count of characters in bitstream size

	char size [10];
	char key 			= 0;			// Hold trigger byte
	char READY_BYTE 	= 'y';			// Char to send after getting trigger byte from PC

	char SPI_send[]		= { 'D', 'A', 'N', 'K', ' ', 'M', 'E', 'M', 'E', 'S' };

	// Assign ICAP device
	curIcap = &HwIcap_SLR0;

	xil_printf("\033[0m");
	xil_printf("\r\nInitializing...\r\n");


	while(i<10000){
		i++;
	}


	// Initialize IPs
	Status = initIp();

	if (Status != XST_SUCCESS) {
		xil_printf("Initialization failure. Returned error code %d. RIP in pieces", Status);
		return XST_FAILURE;
	}

	xil_printf("Initialization complete. Brace for impact.\r\n");


	usleep(1);


	while(Exit != 1) {

		menu();

		operation = XUartLite_RecvByte(XPAR_UARTLITE_0_BASEADDR);

		xil_printf(" %x \033[0m", operation);

		switch (operation) {

			// BITSTREAM SIZING
			case '1':
				xil_printf("\r\n\r\nPlease enter size of bitstream in bytes and then hit return. Hint: should be a multiple of 4. ");
				charCount =0;
				key ='0';
				while(key != '\r'){
					key = XUartLite_RecvByte(XPAR_UARTLITE_0_BASEADDR);
					if(key != '\r'){
						size[charCount] = key;
					}
					xil_printf("%c",key);
					charCount++;
				}
				xil_printf("\n");
				partialSize = atoi(size);
				xil_printf("\r\n Partial bitstream size set as %d Bytes \n\r\n\r", partialSize);
				break;

			// PARTIAL RECONFIGURATION
			case '2':

				// If the partial size is greater than 1 (which it should be), configure
				if(partialSize > 1){

					// Put the SEM in IDLE
					sem_idle();

					// Give ICAP access to the processor
					XGpio_DiscreteWrite( &GPIO_1, 2, 0x1);

					// Print Messages
					xil_printf("\r\n\r\nPlease now use Tera Term to send partial bitstream file in binary format (.bin). Be sure to checkmark \"binary\"");
					xil_printf("\r\nWARNING: Do not type any more characters in the terminal until transfer is complete. These will be sent to ICAP and will mess up your FPGA and shatter your fragile dreams. \r\n\r\n");

					// Perform the Partial Reconfiguration
					Status = recPartial(curIcap,partialSize);

					if (Status != XST_SUCCESS) {
						xil_printf("\r\nRecongifuration failure. Returned error code %d.",Status);
						return XST_FAILURE;
					}

					// Give ICAP back to the SEM
					XGpio_DiscreteWrite( &GPIO_1, 2, 0x0);

					// Reset the SEM
					sem_reset();

					// Print messages
					xil_printf("\r\n\r\nPartial reconfiguration success.\r\n\r\n");

				// Else, do not reconfigure
				} else {

					// Print Messages
					xil_printf("\r\n######### WARNING: PLEASE ENTER A BITSTREAM SIZE BEFORE ATTEMPTING TO SEND A PARTIAL #########\r\n\r\n");

				}

				break;

			// READ THE ICAP ID
			case '3':

				// Put the SEM in IDLE
				sem_idle();

				// Give ICAP access to the Processor
				XGpio_DiscreteWrite( &GPIO_1, 2, 0x1);

				// Grab the ID code
				dev_id = readIdCode(curIcap);
				xil_printf("\r\n\nDevice0 IDcode is %lx \r\n", dev_id);

				// Give ICAP access back to the SEM
				XGpio_DiscreteWrite( &GPIO_1, 2, 0x0);

				// Put the SEM in OBSERVATION
				sem_observation();

				break;

			// PERFORM A SPI TEST
			case '4':
				Status = XSpi_Transfer( &SPI_Device, SPI_send, NULL, 10 );
				xil_printf("\r\n\nSPI STATUS: %d\r\n", Status);
				break;

			// PUT SEM IN IDLE
			case '5':
				sem_idle();
				xil_printf("\r\n\nSEM is now in IDLE\r\n" );
				break;

			// PUT SEM IN OBSERVATION
			case '6':
				sem_observation();
				xil_printf("\r\n\nSEM is now in OBSERVATION\r\n" );
				break;

			// PUT SEM IN RESET
			case '7':
				Status = sem_reset();
				if( Status == XST_SUCCESS) {
					xil_printf("\r\n\n SEM is RESET\r\n" );

				} else {
					xil_printf("\r\n\n SEM failed to RESET, place in IDLE first\r\n" );
				}

				break;

			// EXIT THE APPLICATION
			case '8':
				Exit = 1;
				xil_printf("\n\r Exiting application!\n\r\n\r");
				break;

		}
	}

		while(key != '?'){
			key = XUartLite_RecvByte(XPAR_UARTLITE_0_BASEADDR );
		}

		//Send ready byte to PC signaling it to send first byte of bitstream.
		XUartLite_SendByte(XPAR_UARTLITE_0_BASEADDR, READY_BYTE);


	// Exit
	return 0;
}


//--------------------------------------------------------------------------------------------------------------------------------------
// FUNCTION DECLARATIONS
//--------------------------------------------------------------------------------------------------------------------------------------

// Function to initialize all IP Devices
int initIp() {

	// Set configuration pointers
	XGpio_Config		*GPIO_0_Config;
	XGpio_Config		*GPIO_1_Config;
	XHwIcap_Config 		*ICAP_Config;
	XUartLite_Config 	*UART_Config;
	XSpi_Config 		*SPI_Config;

	// Set status variables
	int status;

	xil_printf("\r\n");

	// Initialize the UART device
	status = init_UART( UART_Config );

	// Print UART device status
	switch( status ) {

		case XST_SUCCESS:
			xil_printf("\033[0;32m - Code %d: UART initialized successfully.\033[0m\n\r", status);
			break;

		case XST_FAILURE:
			xil_printf("\033[0;31m - Code %d: UART initialization failed.\033[0m\n\r", status);
			break;

		case XST_DEVICE_NOT_FOUND:
			xil_printf("\033[0;31m - Code %d: UART device not found.\033[0m\n\r", status);
			break;

	}

	// Initialize the GPIO devices
	status = init_GPIO( GPIO_0_Config, GPIO_1_Config );

	// Print UART device status
	switch( status ) {

		case XST_SUCCESS:
			xil_printf("\033[0;32m - Code %d: GPIO initialized successfully.\033[0m\n\r", status);
			break;

		case XST_FAILURE:
			xil_printf("\033[0;31m - Code %d: GPIO initialization failed.\033[0m\n\r", status);
			break;

		case XST_DEVICE_NOT_FOUND:
			xil_printf("\033[0;31m - Code %d: GPIO device not found.\033[0m\n\r", status);
			break;

	}

	// Initialize the ICAP device
	XGpio_DiscreteWrite( &GPIO_1, 2, 0x1);
	status = init_ICAP( ICAP_Config );
	XGpio_DiscreteWrite( &GPIO_1, 2, 0x0 );

	// Print the ICAP device status
	switch( status ) {

		case XST_SUCCESS:
			xil_printf("\033[0;32m - Code %d: ICAP initialized successfully.\033[0m\n\r", status);
			break;

		case XST_FAILURE:
			xil_printf("\033[0;31m - Code %d: ICAP initialization failed.\033[0m\n\r", status);
			break;

		case XST_DEVICE_NOT_FOUND:
			xil_printf("\033[0;31m - Code %d: ICAP device not found.\033[0m\n\r", status);
			break;

	}

	// Initialize the SPI device
	status = init_SPI( SPI_Config );

	// Print the SPI device status
	switch( status ) {

		case XST_SUCCESS:
			xil_printf("\033[0;32m - Code %d: SPI initialized successfully.\033[0m\n\r", status);
			break;

		case XST_FAILURE:
			xil_printf("\033[0;31m - Code %d: SPI initialization failed.\033[0m\n\r", status);
			break;

		case XST_DEVICE_NOT_FOUND:
			xil_printf("\033[0;31m - Code %d: SPI device not found.\033[0m\n\r", status);
			break;

		default:
			xil_printf("\033[0;31m - Code %d: SPI self test failed.\033[0m\n\r", status);

	}

	xil_printf("\r\n");

	// Return command
	return XST_SUCCESS;
}


// Function to initialize GPIO Devices 1 and 2
int init_GPIO( XGpio_Config *GPIO_0_config, XGpio_Config *GPIO_1_config ) {

	// Set up status variables
	int status;

	// Initialize GPIO devices 1 and 2
	GPIO_0_config = XGpio_LookupConfig( XPAR_AXI_GPIO_0_DEVICE_ID );
	GPIO_1_config = XGpio_LookupConfig( XPAR_AXI_GPIO_1_DEVICE_ID );
	if ( GPIO_0_config == NULL || GPIO_1_config == NULL ) {
		return XST_DEVICE_NOT_FOUND;
	}

	// Initialize GPIO with configuration pointer and check for success
	status = XGpio_CfgInitialize( &GPIO_0, GPIO_0_config, GPIO_0_config->BaseAddress );
	if ( status != XST_SUCCESS ) {
		return XST_FAILURE;
	}

	status = XGpio_CfgInitialize( &GPIO_1, GPIO_1_config, GPIO_1_config->BaseAddress );
	if ( status != XST_SUCCESS ) {
		return XST_FAILURE;
	}

	// Set outputs for SEM command handler
	XGpio_SetDataDirection( &GPIO_0, 1, 0x0000);
	XGpio_SetDataDirection( &GPIO_0, 2, 0x0000);

	// Set inputs for SEM status sensor
	XGpio_SetDataDirection( &GPIO_1, 1, 0xFFFF);

	// Set the outputs for the Arbiter controller
	XGpio_SetDataDirection( &GPIO_1, 2, 0x0000);

	// If everything goes well, return success code
	return XST_SUCCESS;
}

// Function to initialize the UART Device
int init_UART( XUartLite_Config *UART_Config ) {

	// Set up status variables
	int status;

	// Initialize the UART driver
	UART_Config = XUartLite_LookupConfig( XPAR_UARTLITE_0_DEVICE_ID );
	if ( UART_Config == NULL ) {
		return XST_DEVICE_NOT_FOUND;
	}

	// Initialize UART with configuration pointer and check for success
	status = XUartLite_CfgInitialize( &Uart, UART_Config, UART_Config->RegBaseAddr );
	if ( status != XST_SUCCESS ) {
		return XST_FAILURE;
	}

	// If everything goes well, return success code
	return XST_SUCCESS;
}

// Function to initialize the ICAP Device
int init_ICAP( XHwIcap_Config *ICAP_config ) {

	// Set up status variables
	int status;

	// Initialize the ICAP driver
	ICAP_config = XHwIcap_LookupConfig( XPAR_AXI_HWICAP_0_DEVICE_ID );
	if ( ICAP_config == NULL ) {
		return XST_DEVICE_NOT_FOUND;
	}

	// Initialize UART with configuration pointer and check for success
	status = XHwIcap_CfgInitialize( &HwIcap_SLR0, ICAP_config, ICAP_config->BaseAddress );
	if ( status != XST_SUCCESS ) {
		return XST_FAILURE;
	}

	// If everything goes well, return success code
	return XST_SUCCESS;
}

// Function to initialize the SPI Device
int init_SPI( XSpi_Config *SPI_config ) {

	// Set up status variables
	int status;

	// Initialize the SPI driver
	SPI_config = XSpi_LookupConfig( XPAR_AXI_QUAD_SPI_0_DEVICE_ID );
	if (SPI_config == NULL) {
		return XST_DEVICE_NOT_FOUND;
	}

	// Initialize SPI with config and check for success
	status = XSpi_CfgInitialize( &SPI_Device, SPI_config, SPI_config->BaseAddress);
	if (status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	// Run the SPI self-test
	status = XSpi_SelfTest( &SPI_Device );
	if (status != XST_SUCCESS) {
		return status;
	}

	// Set the SPI in Master mode
	status = XSpi_SetOptions( &SPI_Device, XSP_MASTER_OPTION );
	if (status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	// Grab the slave device
	status =  XSpi_SetSlaveSelect( &SPI_Device, 0x1 );
	if (status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	// Start SPI device
	XSpi_Start( &SPI_Device );

	// Disable interrupts
	XSpi_IntrGlobalDisable( &SPI_Device );

	// If everything goes well, return success code
	return XST_SUCCESS;
}


// Function to put the SEM in IDLE
int sem_idle() {

	// If the SEM is already IDLE, exit
	if( XGpio_DiscreteRead( &GPIO_1, 1 ) == 0x00 ) {
		return XST_SUCCESS;

	// Otherwise, manually set IDLE
	} else {

		// Write the IDLE command
		XGpio_DiscreteWrite( &GPIO_0, 1, SEM_IDLE );

		// Pulse the clock
		XGpio_DiscreteWrite( &GPIO_0, 2, 0x1 );
		XGpio_DiscreteWrite( &GPIO_0, 2, 0x0 );

		// Return message
		return XST_SUCCESS;
	}
}

// Function to put the SEM in OBSERVATION
int sem_observation() {

	// If the SEM is already OBSERVATION, exit
	if( XGpio_DiscreteRead( &GPIO_1, 1 ) != 0x00 ) {
		return XST_SUCCESS;

	// Otherwise, manually set OBSERVATION
	} else {

		// Write the OBSERVATION command
		XGpio_DiscreteWrite( &GPIO_0, 1, SEM_OBSV );

		// Pulse the clock
		XGpio_DiscreteWrite( &GPIO_0, 2, 0x1 );
		XGpio_DiscreteWrite( &GPIO_0, 2, 0x0 );

		// Return message
		return XST_SUCCESS;
	}
}

// Function to put the SEM in OBSERVATION
int sem_reset() {

	// If the SEM is already IDLE, exit
	if( XGpio_DiscreteRead( &GPIO_1, 1 ) == 0x00 ) {

		// Write the OBSERVATION command
		XGpio_DiscreteWrite( &GPIO_0, 1, SEM_RST );

		// Pulse the clock
		XGpio_DiscreteWrite( &GPIO_0, 2, 0x1 );
		XGpio_DiscreteWrite( &GPIO_0, 2, 0x0 );

		// Return message
		return XST_SUCCESS;

	} else {

		// Return message
		return XST_FAILURE;

	}
}


// Function to perform the partial reconfiguration
int recPartial(XHwIcap *icapTarget, u32 numBytes){

	// Declare variables
	u32 i = 0;
	u32 word;
	int Status;

	// Bytes to hold received bitstream
	u8 byte0;
	u8 byte1;
	u8 byte2;
	u8 byte3;

	//Loop until end of bitstream
	while( i < (numBytes / 4) ) {

		// Grab the 32-bit word for the ICAP in 4 pieces
		byte0 = XUartLite_RecvByte( XPAR_UARTLITE_0_BASEADDR ); //MSB
		byte1 = XUartLite_RecvByte( XPAR_UARTLITE_0_BASEADDR );
		byte2 = XUartLite_RecvByte( XPAR_UARTLITE_0_BASEADDR );
		byte3 = XUartLite_RecvByte( XPAR_UARTLITE_0_BASEADDR ); //LSB

		// Bit shift the bytes to reassemble a 32-bit word
		word = ((byte0 << 24) | (byte1 << 16) | (byte2 << 8) | (byte3));

		//Write word to ICAP
		Status = XHwIcap_DeviceWrite(icapTarget, &word, 1);

		if (Status != XST_SUCCESS) {

			 //Error writing to ICAP
			 return XST_FAILURE;
		}

		// Increment
		i++;
	}

	xil_printf("Done!\n" );

	return XST_SUCCESS;
}


// Function to return ICAP ID code
u32 readIdCode(XHwIcap *icapTarget) {
	int Status;
	u32 dev_id;

	Status = XHwIcap_GetConfigReg(icapTarget, XHI_IDCODE, &dev_id);
	if (Status != XST_SUCCESS) {
		icapTarget->IsReady = 0;
		return XST_FAILURE;
	}

	return dev_id;
}


// Function to print the menu
void menu(){

	xil_printf("\r\nCHRIS' RADPC PARTIAL RECONFIGURATION DEMO\r\n");
	xil_printf("    1: Set bitstream size\n\r");
	xil_printf("    2: Send bitstream\n\r");
	xil_printf("    3: Read device id from ICAP port\n\r");
	xil_printf("    4: Test your possibly defective SPI module\n\r");
	xil_printf("    5: SEM Idle\n\r");
	xil_printf("    6: SEM Observation\n\r");
	xil_printf("    7: SEM Reset\n\r");
	xil_printf("    8: Exit and re-evaluate your life choices\n\r");
	print("\n\r\033[0;34m> ");
}


//--------------------------------------------------------------------------------------------------------------------------------------
// END OF CODE
