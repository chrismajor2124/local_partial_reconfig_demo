/*
 * main.h
 *
 *  Created on: Dec 12, 2013
 *      Author: georged
 */

#ifndef MAIN_H_
#define MAIN_H_

#endif /* MAIN_H_ */

#define RECIEVE_BUFFER_SIZE 32

/*
 * The following constants define the commands which may be sent to the EEPROM
 * device that are used for this sw application.
 */
#define WRITE_STATUS_CMD	1
#define WRITE_CMD				2
#define READ_CMD				3
#define WRITE_DISABLE_CMD	4
#define READ_STATUS_CMD		5
#define WRITE_ENABLE_CMD	6
#define BULK_ERASE_CMD		0xC7
#define SECTOR_ERASE_CMD	0xD8

/*
 * The following constants define the offsets within a EepromBuffer data
 * type for each kind of data.  Note that the read data offset is not the
 * same as the write data because the SPI driver is designed to allow full
 * duplex transfers such that the number of bytes received is the number
 * sent and received.
 */
#define COMMAND_OFFSET		0 		/* EEPROM instruction */
#define ADDRESS_MSB_OFFSET	1 		/* MSB of address to read or write */
#define ADDRESS_LSB_OFFSET	2 		/* LSB of address to read or write */
#define DATA_OFFSET			4
#define WRITE_DATA_OFFSET	4  	/* Start of data to write to the EEPROM */
#define READ_DATA_OFFSET	6  	/* Start of data read from the EEPROM */


/*COMMANDS FOR ICAP CONTROL
 *
 *
 *
 *
 *
 *
 */
#define ICAP_SELECT 1
#define ICAP_WRITE  2
