----------------------------------------------------------------------------------------------------------------------------------------
--
--	LOCAL PARTIAL RECONFIGURATION TEST
--
--	Created by Chris Major
-- 	3/17/2021
--
--	Testing partial reconfiguration of an FPGA from a local Microblaze, accessing an ICAP port
--
----------------------------------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------------------------------
-- LIBRARIES
----------------------------------------------------------------------------------------------------------------------------------------

-- IEE Standard Library
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


-- Xilinx primitive libraries
library unisim;
use unisim.vcomponents.all;


----------------------------------------------------------------------------------------------------------------------------------------
-- ENTITY
----------------------------------------------------------------------------------------------------------------------------------------
entity top is
port(
	i_clk			               : in    std_logic;			               -- Clock
	i_reset					       : in	   std_logic;			               -- Active Low Reset
	
	i_switch                       : in    std_logic_vector(15 downto 0);      -- Switches
	
	i_rx                           : in    std_logic;	                       -- Receive Signal
	o_tx                           : out   std_logic;                          -- Transmit Signal
	
	o_led                          : out   std_logic_vector(15 downto 0);      -- Output LEDs
	
	o_seven_seg_anode              : out   std_logic_vector(3 downto 0);       -- 7 Segment Anode
	o_seven_seg_data               : out   std_logic_vector(7 downto 0);       -- 7 Segment LEDs
	
	o_pmod_ja                      : inout   std_logic_vector(7 downto 0);     -- PMOD A	
	o_pmod_jb                      : inout   std_logic_vector(7 downto 0);     -- PMOD B
	o_pmod_jc                      : inout   std_logic_vector(7 downto 0)      -- PMOD C
);
end entity;


----------------------------------------------------------------------------------------------------------------------------------------
-- ARCHITECTURE
----------------------------------------------------------------------------------------------------------------------------------------
architecture top_arch of top is


	------------------------------------------------------------------------------------------------------------------------------------
	-- COMPONENT DECLARATIONS
	------------------------------------------------------------------------------------------------------------------------------------

    -- Declare the Clock Divider
    component clk_wiz_0 
    port (
        i_clk_100MHz                : in	std_logic;
        
        resetn                      : in	std_logic;

        o_clk_16MHz                 : out   std_logic;
        o_clk_8MHz                  : out   std_logic;
    
        locked                      : out   std_logic
    );
    end component;

    -- Declare the reconfiguration handler component
    component reconfiguration_handler is
    port(
        i_clk_16MHz					: in	std_logic;			-- Clock (16 MHz)
        i_clk_8MHz					: in	std_logic;			-- Clock (8 MHz)
        
        i_reset_n					: in	std_logic;			-- Active Low Reset
        i_locked                    : in    std_logic;          -- Locked MB Clock Signal
        
        i_sem_rx 					: in	std_logic;          -- SEM UART RX
        o_sem_tx                    : out   std_logic;          -- SEM UART TX
        
        i_pr_rx 					: in	std_logic;          -- SEM PR RX
        o_pr_tx                     : out   std_logic;          -- SEM PR TX
        
        i_SPI_clk                   : inout	std_logic;          -- SPI Clock
        i_SPI_SS                    : inout std_logic;          -- SPI Slave Select
        i_SPI_MOSI                  : inout std_logic;          -- SPI Master Out Slave In (Input)
        o_SPI_MISO                  : inout std_logic;          -- SPI Master In Slave Out (Output)

        o_SEM_status                : out   std_logic_vector(7 downto 0)    -- SEM Status Bits            
    );
    end component;

	-- Declare the Counter component (general_counter.vhd)
	component counter is
    generic(
        g_count_max					: integer 	:= 255;											-- Maximum value (unsigned)
        g_count_size				: integer	:= 8											-- Count output size (bits)
    );
    port(
        i_clk						: in	std_logic;											-- Clock
        i_reset_n					: in	std_logic;											-- Active Low Reset
        
        i_up_down					: in	std_logic;											-- Up/Down signal (1 = Up, 0 = Down)
    
        o_count						: out	std_logic_vector( (g_count_size - 1) downto 0 )		-- Count Value
    );
    end component;


    -- Declare the 7 Segment Display component
    component basys_7seg is
    port (  
        i_clk						: in	std_logic;											-- Clock
        i_reset_n					: in	std_logic;											-- Active Low Reset
            
        i_input_number              : in    std_logic_vector(15 downto 0);
        
        o_anode_act            		: out   std_logic_vector (3 downto 0);
        o_led_out                   : out   std_logic_vector (6 downto 0)
    );
    end component;


	------------------------------------------------------------------------------------------------------------------------------------
	-- SIGNAL DECLARATIONS
	------------------------------------------------------------------------------------------------------------------------------------

	signal w_reset_n                               : std_logic;				            -- Signal to convert the reset to active-low
	signal r_count                                 : std_logic_vector(15 downto 0);     -- Signal for count value
	signal w_locked                                : std_logic;
	
	signal w_clk_8MHz                              : std_logic;
	signal w_clk_16MHz                             : std_logic;
	
	signal w_SPI_clk                               : std_logic;
	signal w_SPI_SS                                : std_logic;
	signal w_SPI_MOSI                              : std_logic;
	signal w_SPI_MISO                              : std_logic;
	
	signal r_sem_status                            : std_logic_vector( 7 downto 0 );   -- Signal for SEM Status


begin


    ------------------------------------------------------------------------------------------------------------------------------------
	-- RECONFIGURATION COMPONENTS
	------------------------------------------------------------------------------------------------------------------------------------

    -- Instantiate the clocking wizard
    CLK_01 : clk_wiz_0 
    port map (
        i_clk_100MHz                => i_clk,
        
        resetn                      => w_reset_n,

        o_clk_16MHz                 => w_clk_16MHz,
        o_clk_8MHz                  => w_clk_8MHz,
        
        locked                      => w_locked
    );
    
    -- Instantiate the reconfiguration handler
    RECON_01 : reconfiguration_handler
    port map(
        i_clk_16MHz					=> w_clk_16MHz,
        i_clk_8MHz					=> w_clk_8MHz,
        
        i_reset_n					=> w_reset_n,
        i_locked                    => w_locked,
        
        i_sem_rx 					=> o_pmod_jc(6),
        o_sem_tx                    => o_pmod_jc(5),
        
        i_pr_rx 					=> i_rx,
        o_pr_tx                     => o_tx,
        
        i_SPI_clk                   => w_SPI_clk,  
        i_SPI_SS                    => w_SPI_SS,         
        i_SPI_MOSI                  => w_SPI_MOSI,
        o_SPI_MISO                  => w_SPI_MISO,

        o_SEM_status                => r_SEM_status

    );

	-- Instantiate the counter
	CNTR : counter 
    generic map (
        g_count_max					    => 65536,											
        g_count_size				    => 16
    )
    port map (
        i_clk						    => w_clk_8MHz,
        i_reset_n	                    => w_reset_n,
        
        i_up_down					    => '1',
    
        o_count						    => r_count
    );


    -- Instantiate the 7 Segment Display component
    B_7SEG : basys_7seg
    port map (  
        i_clk						    => i_clk,
        i_reset_n	                    => w_reset_n,
            
        i_input_number                  => r_count,
        
        o_anode_act                     => o_seven_seg_anode,
        o_led_out                       => o_seven_seg_data(7 downto 1)
    );


    ------------------------------------------------------------------------------------------------------------------------------------
	-- SIGNAL ASSIGNMENTS
	------------------------------------------------------------------------------------------------------------------------------------

    -- Turn off 7 seg decimal point (active low)
    o_seven_seg_data(0) <= '1';

    -- Route clock to SPI
    w_SPI_clk <= w_clk_8MHz;

    -- Route out SPI signals
    o_pmod_ja(7) <= w_SPI_clk;
	o_pmod_ja(6) <= w_SPI_SS; 
	o_pmod_ja(5) <= w_SPI_MOSI; 
	o_pmod_ja(4) <= w_SPI_MISO;  
    
    
    -- Route to PMOD LEDs
    o_pmod_jb(7) <= r_SEM_status(7);
    o_pmod_jb(6) <= r_SEM_status(6);
    o_pmod_jb(5) <= r_SEM_status(5);
    o_pmod_jb(4) <= r_SEM_status(4);
    o_pmod_jb(3) <= r_SEM_status(3);
    o_pmod_jb(2) <= r_SEM_status(2);
    o_pmod_jb(1) <= r_SEM_status(1);
    o_pmod_jb(0) <= r_SEM_status(0);

    -- Convert to active-low reset
    w_reset_n <= not i_reset;


end architecture;
----------------------------------------------------------------------------------------------------------------------------------------
-- END OF CODE