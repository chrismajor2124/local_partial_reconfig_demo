----------------------------------------------------------------------------------------------------------------------------------------
--
--	Reconfiguration Handler
--
--	Created by Chris Major
-- 	4/13/2021
--
--	A component to handle RadPC device reconfiguration, between both the SEM and the PR-controller
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
entity reconfiguration_handler is
port(
    i_clk_16MHz                     : in	std_logic;			            -- Clock (16 MHz)
	i_clk_8MHz	                    : in	std_logic;			            -- Clock (8 MHz)
	
    i_reset_n			            : in	std_logic;                      -- Active Low Reset
    i_locked                        : in    std_logic;                      -- Locked MB Clock Signal
	
    i_sem_rx                        : in    std_logic;                      -- SEM UART RX
    o_sem_tx                        : out   std_logic;                      -- SEM UART TX
	
    i_pr_rx 			            : in	std_logic;                      -- SEM PR RX
    o_pr_tx                         : out   std_logic;                      -- SEM PR TX
	
    i_SPI_clk                       : inout	std_logic;                      -- SPI Clock
    i_SPI_SS                        : inout std_logic;                      -- SPI Slave Select
    i_SPI_MOSI                      : inout std_logic;                      -- SPI Master Out Slave In (Input)
    o_SPI_MISO                      : inout std_logic;                      -- SPI Master In Slave Out (Output)
	
    o_SEM_status                    : out   std_logic_vector(7 downto 0)    -- SEM Status Bits
);
end entity;


----------------------------------------------------------------------------------------------------------------------------------------
-- ARCHITECTURE
----------------------------------------------------------------------------------------------------------------------------------------
architecture reconfiguration_handler_arch of reconfiguration_handler is


	------------------------------------------------------------------------------------------------------------------------------------
	-- COMPONENT DECLARATIONS
	------------------------------------------------------------------------------------------------------------------------------------

    -- Declare the Microblaze component
    component mb_pr_01_wrapper is
    port (
        i_clk_16MHz                 : in    STD_LOGIC;
        i_reset_n                   : in    STD_LOGIC;
        i_locked                    : in    STD_LOGIC;
        
        i_icap_grant                : in    STD_LOGIC;
        i_icap_i                    : in    STD_LOGIC_VECTOR ( 31 downto 0 );
        i_icap_rel                  : in    STD_LOGIC;
        
        o_icap_csib                 : out   STD_LOGIC;
        o_icap_rdwrb                : out   STD_LOGIC;
        o_icap_req                  : out   STD_LOGIC;
        o_icap_o                    : out   STD_LOGIC_VECTOR ( 31 downto 0 );        
        
        spi_rtl_0_io0_io            : inout STD_LOGIC;
        spi_rtl_0_io1_io            : inout STD_LOGIC;
        spi_rtl_0_ss_io             : inout STD_LOGIC_VECTOR ( 0 to 0 );
 
        uart_rtl_0_rxd              : in    STD_LOGIC;
        uart_rtl_0_txd              : out   STD_LOGIC;

        i_sem_status_tri_i          : in    STD_LOGIC_VECTOR ( 7 downto 0 );       
        
        o_sem_command_tri_o         : out   STD_LOGIC_VECTOR ( 3 downto 0 );
        o_sem_strobe_tri_o          : out   STD_LOGIC_VECTOR ( 0 to 0 );

        o_arbiter_control_tri_o     : out   STD_LOGIC_VECTOR ( 0 to 0 )
    );
    end component;
    
    -- Declare the arbiter component
    component arbiter is
    port(
        i_select                                       : in    std_logic;                              -- ICAP Device Select
        
        i_pr_csib                                      : in    std_logic;                              -- PR Device ICAP Enable
        i_pr_rdwrb                                     : in    std_logic;	                           -- PR Device ICAP Read/Write
        i_pr_o                                         : in    std_logic_vector(31 downto 0);          -- PR Device ICAP Output Data
        o_pr_i                                         : out   std_logic_vector(31 downto 0);          -- PR Device ICAP Input Data
        
        o_pr_grant                                     : out   std_logic;                              -- PR Device ICAP Access Grant
        i_pr_request                                   : in    std_logic;                              -- PR Device ICAP Access Request

        i_sem_csib                                     : in    std_logic;                              -- SEM Device ICAP Enable
        i_sem_rdwrb                                    : in    std_logic;	                           -- SEM Device ICAP Read/Write
        i_sem_o                                        : in    std_logic_vector(31 downto 0);          -- SEM Device ICAP Output Data
        o_sem_i                                        : out   std_logic_vector(31 downto 0);          -- SEM Device ICAP Input Data
        
        o_sem_grant                                    : out   std_logic;                              -- SEM Device ICAP Access Grant
        i_sem_request                                  : in    std_logic;                              -- SEM Device ICAP Access Request
        
        i_icap_o                                       : in    std_logic_vector(31 downto 0);          -- ICAP Device Output Data  (O)
        o_icap_i                                       : out   std_logic_vector(31 downto 0);          -- ICAP Device Input Data   (I)
        o_icap_csib                                    : out   std_logic;                              -- ICAP Device Enable       (CSIB)
        o_icap_rdwrb                                   : out   std_logic                               -- ICAP Device Read/Write   (RDWRB)
    );
    end component;
    
    -- Declare the component for the Soft Error Mitigation device (sem_0.xci)
    component sem_0
    port (
        status_heartbeat                : out   std_logic;
        status_initialization           : out   std_logic;
        status_observation              : out   std_logic;
        status_correction               : out   std_logic;
        status_classification           : out   std_logic;
        status_injection                : out   std_logic;
        status_essential                : out   std_logic;
        status_uncorrectable            : out   std_logic;
        
        monitor_txdata                  : out   std_logic_vector(7 downto 0);
        monitor_txwrite                 : out   std_logic;
        monitor_txfull                  : in    std_logic;
        
        monitor_rxdata                  : in    std_logic_vector(7 downto 0);
        monitor_rxread                  : out   std_logic;
        monitor_rxempty                 : in    std_logic;
        
        inject_strobe                   : in    std_logic;
        inject_address                  : in    std_logic_vector(39 downto 0);
        
        fecc_crcerr                     : in    std_logic;
        fecc_eccerr                     : in    std_logic;
        fecc_eccerrsingle               : in    std_logic;
        fecc_syndromevalid              : in    std_logic;
        fecc_syndrome                   : in    std_logic_vector(12 downto 0);
        fecc_far                        : in    std_logic_vector(25 downto 0);
        fecc_synbit                     : in    std_logic_vector(4 downto 0);
        fecc_synword                    : in    std_logic_vector(6 downto 0);
        
        icap_o                          : in    std_logic_vector(31 downto 0);
        icap_i                          : out   std_logic_vector(31 downto 0);
        icap_csib                       : out   std_logic;
        icap_rdwrb                      : out   std_logic;
        icap_clk                        : in    std_logic;
        icap_request                    : out   std_logic;
        icap_grant                      : in    std_logic
    );
    end component;

    -- Declare the component for the SEM monitor interface (sem_0_sem_mon.vhd)
    component sem_monitor
    port (
        i_clk                           : in    std_logic;                              -- Input clock
       
        i_monitor_rx                    : in    std_logic;                              -- Monitor UART Receive 
        o_monitor_tx                    : out   std_logic;                              -- Monitor UART Transmit
        
        i_monitor_tx_data               : in    std_logic_vector(7 downto 0);           -- Transmit Data Buffer
        i_monitor_tx_write              : in    std_logic;                              -- Transmit buffer write enable
        o_monitor_tx_full               : out   std_logic;                              -- Transmit buffer full flag
        
        o_monitor_rx_data               : out   std_logic_vector(7 downto 0);           -- Receive Data Buffer
        i_monitor_rx_read               : in    std_logic;                              -- Receive buffer read enable
        o_monitor_rx_empty              : out   std_logic                               -- Receive buffer empty flag
    );
    end component;


	------------------------------------------------------------------------------------------------------------------------------------
	-- SIGNAL DECLARATIONS
	------------------------------------------------------------------------------------------------------------------------------------
	
	signal r_sem_status                            : std_logic_vector( 7 downto 0 );

    signal w_sem_strobe                            : std_logic;
    signal r_sem_command                           : std_logic_vector( 3 downto 0 );
    signal r_sem_interface                         : std_logic_vector( 39 downto 0 );

    signal r_monitor_tx_data                       : std_logic_vector(7 downto 0);     -- Register for Monitor internal transmit buffer
    signal w_monitor_tx_write                      : std_logic;                        -- Signal for Monitor transmit buffer write enable
    signal w_monitor_tx_full                       : std_logic;                        -- Signal for Monitor transmit buffer full/empty state
    
    signal r_monitor_rx_data                       : std_logic_vector(7 downto 0);     -- Register for Monitor internal receive buffer
    signal w_monitor_rx_read                       : std_logic;                        -- Signal for Monitor receive buffer read enable
    signal w_monitor_rx_empty                      : std_logic;                        -- Signal for Monitor receive buffer full/empty state
    
    signal w_fecc_crcerr                           : std_logic;                        -- Signal for FRAME_ECC status indicating CRC check failed
    signal w_fecc_eccerr                           : std_logic;                        -- Signal for FRAME_ECC status indicating ECC check failed
    signal w_fecc_eccerrsingle                     : std_logic;                        -- Signal for FRAME_ECC status indicating single-bit error
    signal w_fecc_syndromevalid                    : std_logic;                        -- Signal for FRAME_ECC status indicating syndrome is valid
    signal r_fecc_syndrome                         : std_logic_vector(12 downto 0);    -- Register for FRAME_ECC syndrome
    signal r_fecc_far                              : std_logic_vector(25 downto 0);    -- Register for FRAME_ECC status showing FAR or EFAR
    signal r_fecc_synbit                           : std_logic_vector(4 downto 0);     -- Register for FRAME_ECC location of error in a word
    signal r_fecc_synword                          : std_logic_vector(6 downto 0);     -- Register for FRAME_ECC location of error word in a frame

    signal r_icap_o                                : std_logic_vector(31 downto 0);    -- Register for ICAP port output
    signal r_icap_i                                : std_logic_vector(31 downto 0);    -- Register for ICAP port input
    signal w_icap_csib                             : std_logic;                        -- Signal to enable the ICAP chip for read/write
    signal w_icap_rdwrb                            : std_logic;                        -- Signal to enable the ICAP write for read/write
    signal w_icap_unused                           : std_logic;                        -- Signal for unused ICAP ports
    signal w_icap_grant                            : std_logic;                        -- Signal to grant device access to the ICAP ports
    
    signal r_mb_icap_o                             : std_logic_vector(31 downto 0);    -- Register for ICAP port output
    signal r_mb_icap_i                             : std_logic_vector(31 downto 0);    -- Register for ICAP port input
    signal w_mb_icap_csib                          : std_logic;                        -- Signal to enable the ICAP chip for read/write
    signal w_mb_icap_rdwrb                         : std_logic;                        -- Signal to enable the ICAP write for read/write
    signal w_mb_icap_unused                        : std_logic;                        -- Signal for unused ICAP ports
    signal w_mb_icap_grant                         : std_logic;                        -- Signal to grant device access to the ICAP ports
    signal w_mb_icap_rel                           : std_logic;
    signal w_mb_icap_req                           : std_logic;
    
    signal r_sem_icap_o                            : std_logic_vector(31 downto 0);    -- Register for ICAP port output
    signal r_sem_icap_i                            : std_logic_vector(31 downto 0);    -- Register for ICAP port input
    signal w_sem_icap_csib                         : std_logic;                        -- Signal to enable the ICAP chip for read/write
    signal w_sem_icap_rdwrb                        : std_logic;                        -- Signal to enable the ICAP write for read/write
    signal w_sem_icap_unused                       : std_logic;                        -- Signal for unused ICAP ports
    signal w_sem_icap_grant                        : std_logic;                        -- Signal to grant device access to the ICAP ports
    
    signal w_arbiter_select                        : std_logic;
	

begin


	------------------------------------------------------------------------------------------------------------------------------------
	-- RECONFIGURATION COMPONENTS
	------------------------------------------------------------------------------------------------------------------------------------

	-- Instantiate the Microblaze
    MB_01: mb_pr_01_wrapper 
    port map (
        i_clk_16MHz                     => i_clk_16MHz,
        i_reset_n                       => i_reset_n,
        i_locked                        => i_locked,
        
        i_icap_grant                    => w_mb_icap_grant,
        i_icap_i                        => r_mb_icap_i,
        i_icap_rel                      => w_mb_icap_rel,
        
        o_icap_csib                     => w_mb_icap_csib,
        o_icap_o                        => r_mb_icap_o,
        o_icap_req                      => w_mb_icap_req,
        o_icap_rdwrb                    => w_mb_icap_rdwrb,
       
        spi_rtl_0_ss_io(0)              => i_SPI_SS,             
        spi_rtl_0_io0_io                => i_SPI_MOSI,           
        spi_rtl_0_io1_io                => o_SPI_MISO,       

        uart_rtl_0_rxd                  => i_pr_rx,
        uart_rtl_0_txd                  => o_pr_tx,
        
        i_sem_status_tri_i              => r_sem_status,
        
        o_sem_command_tri_o             => r_sem_command,
        o_sem_strobe_tri_o(0)           => w_sem_strobe,       
         
        o_arbiter_control_tri_o(0)      => w_arbiter_select
    );

    -- Instantiate the Arbiter (WORT WORT)
    ARB_01 : arbiter
    port map(
        i_select                        => w_arbiter_select,
        
        i_pr_csib                       => w_mb_icap_csib,
        i_pr_rdwrb                      => w_mb_icap_rdwrb,
        i_pr_o                          => r_mb_icap_o,
        o_pr_i                          => r_mb_icap_i,
        
        o_pr_grant                      => w_mb_icap_grant,
        i_pr_request                    => w_mb_icap_req,

        i_sem_csib                      => w_sem_icap_csib,
        i_sem_rdwrb                     => w_sem_icap_rdwrb,
        i_sem_o                         => r_sem_icap_i,
        o_sem_i                         => r_sem_icap_o,
        
        o_sem_grant                     => w_sem_icap_grant,
        i_sem_request                   => w_sem_icap_unused,
        
        i_icap_o                        => r_icap_o,
        o_icap_i                        => r_icap_i,
        o_icap_csib                     => w_icap_csib,
        o_icap_rdwrb                    => w_icap_rdwrb
    );

    -- Instantiate the SEM device based on the Xilinx IP core
    SEM_DEVICE_0 : sem_0 
    port map (
        status_heartbeat                => r_sem_status(7),
        status_initialization           => r_sem_status(6),
        status_observation              => r_sem_status(5),
        status_correction               => r_sem_status(4),
        status_classification           => r_sem_status(3),
        status_injection                => r_sem_status(2),
        status_essential                => r_sem_status(1),
        status_uncorrectable            => r_sem_status(0),
        
        monitor_txdata                  => r_monitor_tx_data,
        monitor_txwrite                 => w_monitor_tx_write,
        monitor_txfull                  => w_monitor_tx_full,
        
        monitor_rxdata                  => r_monitor_rx_data,
        monitor_rxread                  => w_monitor_rx_read,
        monitor_rxempty                 => w_monitor_rx_empty,
        
        inject_strobe                   => w_sem_strobe,
        inject_address                  => r_sem_interface,
        
        fecc_crcerr                     => w_fecc_crcerr,
        fecc_eccerr                     => w_fecc_eccerr,
        fecc_eccerrsingle               => w_fecc_eccerrsingle,
        fecc_syndromevalid              => w_fecc_syndromevalid,
        fecc_syndrome                   => r_fecc_syndrome,
        fecc_far                        => r_fecc_far,
        fecc_synbit                     => r_fecc_synbit,
        fecc_synword                    => r_fecc_synword,
        
        icap_o                          => r_sem_icap_o,
        icap_i                          => r_sem_icap_i,
        icap_csib                       => w_sem_icap_csib,
        icap_rdwrb                      => w_sem_icap_rdwrb,
        icap_clk                        => i_clk_16MHz,
        icap_request                    => w_sem_icap_unused,
        icap_grant                      => w_sem_icap_grant
    );

    -- Instantiate the SEM Monitor component
    MONITOR_0 : sem_monitor port map (
        i_clk                           => i_clk_16MHz,
        
        i_monitor_rx                    => i_sem_rx,
        o_monitor_tx                    => o_sem_tx,

        i_monitor_tx_data               => r_monitor_tx_data,
        i_monitor_tx_write              => w_monitor_tx_write,
        o_monitor_tx_full               => w_monitor_tx_full,
        
        o_monitor_rx_data               => r_monitor_rx_data,
        i_monitor_rx_read               => w_monitor_rx_read,
        o_monitor_rx_empty              => w_monitor_rx_empty
    );


	------------------------------------------------------------------------------------------------------------------------------------
	-- PRIMITIVES
	------------------------------------------------------------------------------------------------------------------------------------

    -- Instantiate the FRAME_ECC Primitive
    FRAME_ECC_0 : FRAME_ECCE2
    generic map (
        FRAME_RBT_IN_FILENAME           => "NONE",
        FARSRC                          => "EFAR"
    )
    port map (
        CRCERROR                        => w_fecc_crcerr,
        ECCERROR                        => w_fecc_eccerr,
        ECCERRORSINGLE                  => w_fecc_eccerrsingle,
        FAR                             => r_fecc_far,
        SYNBIT                          => r_fecc_synbit,
        SYNDROME                        => r_fecc_syndrome,
        SYNDROMEVALID                   => w_fecc_syndromevalid,
        SYNWORD                         => r_fecc_synword
    );
    
    
    -- Instantiate the ICAP primitive
    ICAP_0 : ICAPE2
    generic map (
        SIM_CFG_FILE_NAME               => "NONE",
        DEVICE_ID                       => X"FFFFFFFF",
        ICAP_WIDTH                      => "X32"
    )
    port map (
        O                               => r_icap_o,
        CLK                             => i_clk_16MHz,
        CSIB                            => w_icap_csib,
        I                               => r_icap_i,
        RDWRB                           => w_icap_rdwrb
    );
    

	------------------------------------------------------------------------------------------------------------------------------------
	-- SIGNAL ASSIGNMENTS
	------------------------------------------------------------------------------------------------------------------------------------
	
	-- Route the SEM status signals to the output
	o_SEM_status       <= r_sem_status;

	-- Route the SEM command to the SEM interface, pad with 0's for the Don't Care bits
    r_sem_interface    <= r_sem_command & x"000000000";
    

end architecture;
----------------------------------------------------------------------------------------------------------------------------------------
-- END OF CODE