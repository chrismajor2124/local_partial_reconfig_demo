---------------------------------------------------------------------------------------------------------------------------------
-- Company:                 Montana State University
-- Engineer:                Chris Major
--
-- Create Date:             1/17/2020
-- Design Name:             RadPC Lite
-- Module Name:             SEM
-- Project Name:            RadPC - Radiation Tolerant Computer System
-- Target Devices:          Basys A7 XC7A35T CPG236-1
-- Tool Versions:           Vivado 2019.2
-- Description:             Component for the Soft Error Mitigation Controller, based on the SEM IP Example Project
--
-- Dependencies:            sem_0.xci 
--                          sem_0_sem_mon.vhd
--
--                          ICAP2 (Xilinx Unisim Library)
--                          FRAME_ECCE2 (Xilinx Unisim Library)
--
-- Revision:                1.0
--                          Revision 0.01 - File Created
--
---------------------------------------------------------------------------------------------------------------------------------


-- LIBRARIES
---------------------------------------------------------------------------------------------------------------------------------

-- Standard IEEE libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Xilinx primitive libraries
library unisim;
use unisim.vcomponents.all;


-- ENTITY
---------------------------------------------------------------------------------------------------------------------------------
entity sem_controller is
port (
        i_clk                           : in    std_logic;
        
        i_inject_strobe                 : in    std_logic;
        i_inject_address                : in    std_logic_vector(39 downto 0);
        
        o_status_heartbeat              : out   std_logic;
        o_status_initialization         : out   std_logic;
        o_status_observation            : out   std_logic;
        o_status_correction             : out   std_logic;
        o_status_classification         : out   std_logic;
        o_status_injection              : out   std_logic;
        o_status_essential              : out   std_logic;
        o_status_uncorrectable          : out   std_logic;

        i_monitor_rx                    : in    std_logic;
        o_monitor_tx                    : out   std_logic
);
end entity sem_controller;


-- ARCHITECTURE
---------------------------------------------------------------------------------------------------------------------------------
architecture Behavorial of sem_controller is


    -- COMPONENT DECLARATIONS
    -----------------------------------------------------------------------------------------------------------------------------
    
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
    

    -- SIGNAL DECLARATIONS
    -----------------------------------------------------------------------------------------------------------------------------
    signal w_status_heartbeat                   : std_logic;                        -- Signal for SEM Heartbeat
    signal w_status_initialization              : std_logic;                        -- Signal for SEM initialization
    signal w_status_observation                 : std_logic;                        -- Signal for SEM Observation state
    signal w_status_correction                  : std_logic;                        -- Signal for SEM Correction state
    signal w_status_classification              : std_logic;                        -- Signal for SEM Classification state
    signal w_status_injection                   : std_logic;                        -- Signal for SEM Injection state
    signal w_status_essential                   : std_logic;                        -- Signal for SEM Essential Bit state
    signal w_status_uncorrectable               : std_logic;                        -- Signal for SEM Uncorrectable state
    
    signal r_monitor_tx_data                    : std_logic_vector(7 downto 0);     -- Register for Monitor internal transmit buffer
    signal w_monitor_tx_write                   : std_logic;                        -- Signal for Monitor transmit buffer write enable
    signal w_monitor_tx_full                    : std_logic;                        -- Signal for Monitor transmit buffer full/empty state
    
    signal r_monitor_rx_data                    : std_logic_vector(7 downto 0);     -- Register for Monitor internal receive buffer
    signal w_monitor_rx_read                    : std_logic;                        -- Signal for Monitor receive buffer read enable
    signal w_monitor_rx_empty                   : std_logic;                        -- Signal for Monitor receive buffer full/empty state
    
    signal w_fecc_crcerr                        : std_logic;                        -- Signal for FRAME_ECC status indicating CRC check failed
    signal w_fecc_eccerr                        : std_logic;                        -- Signal for FRAME_ECC status indicating ECC check failed
    signal w_fecc_eccerrsingle                  : std_logic;                        -- Signal for FRAME_ECC status indicating single-bit error
    signal w_fecc_syndromevalid                 : std_logic;                        -- Signal for FRAME_ECC status indicating syndrome is valid
    signal r_fecc_syndrome                      : std_logic_vector(12 downto 0);    -- Register for FRAME_ECC syndrome
    signal r_fecc_far                           : std_logic_vector(25 downto 0);    -- Register for FRAME_ECC status showing FAR or EFAR
    signal r_fecc_synbit                        : std_logic_vector(4 downto 0);     -- Register for FRAME_ECC location of error in a word
    signal r_fecc_synword                       : std_logic_vector(6 downto 0);     -- Register for FRAME_ECC location of error word in a frame
    
    signal r_icap_o                             : std_logic_vector(31 downto 0);    -- Register for ICAP port output
    signal r_icap_i                             : std_logic_vector(31 downto 0);    -- Register for ICAP port input
    signal w_icap_csib                          : std_logic;                        -- Signal to enable the ICAP chip for read/write
    signal w_icap_rdwrb                         : std_logic;                        -- Signal to enable the ICAP write for read/write
    signal w_icap_unused                        : std_logic;                        -- Signal for unused ICAP ports
    signal w_icap_grant                         : std_logic;                        -- Signal to grant device access to the ICAP ports


begin


    -- Instantiate the SEM device based on the Xilinx IP core
    SEM_DEVICE_0 : sem_0 port map (
        status_heartbeat                => w_status_heartbeat,
        status_initialization           => w_status_initialization,
        status_observation              => w_status_observation,
        status_correction               => w_status_correction,
        status_classification           => w_status_classification,
        status_injection                => w_status_injection,
        status_essential                => w_status_essential,
        status_uncorrectable            => w_status_uncorrectable,
        
        monitor_txdata                  => r_monitor_tx_data,
        monitor_txwrite                 => w_monitor_tx_write,
        monitor_txfull                  => w_monitor_tx_full,
        
        monitor_rxdata                  => r_monitor_rx_data,
        monitor_rxread                  => w_monitor_rx_read,
        monitor_rxempty                 => w_monitor_rx_empty,
        
        inject_strobe                   => i_inject_strobe,
        inject_address                  => i_inject_address,
        
        fecc_crcerr                     => w_fecc_crcerr,
        fecc_eccerr                     => w_fecc_eccerr,
        fecc_eccerrsingle               => w_fecc_eccerrsingle,
        fecc_syndromevalid              => w_fecc_syndromevalid,
        fecc_syndrome                   => r_fecc_syndrome,
        fecc_far                        => r_fecc_far,
        fecc_synbit                     => r_fecc_synbit,
        fecc_synword                    => r_fecc_synword,
        
        icap_o                          => r_icap_o,
        icap_i                          => r_icap_i,
        icap_csib                       => w_icap_csib,
        icap_rdwrb                      => w_icap_rdwrb,
        icap_clk                        => i_clk,
        icap_request                    => w_icap_unused,
        icap_grant                      => w_icap_grant
    );

    -- Instantiate the SEM Monitor component
    MONITOR_0 : sem_monitor port map (
        i_clk                           => i_clk,
        
        i_monitor_rx                    => i_monitor_rx,
        o_monitor_tx                    => o_monitor_tx,

        i_monitor_tx_data               => r_monitor_tx_data,
        i_monitor_tx_write              => w_monitor_tx_write,
        o_monitor_tx_full               => w_monitor_tx_full,
        
        o_monitor_rx_data               => r_monitor_rx_data,
        i_monitor_rx_read               => w_monitor_rx_read,
        o_monitor_rx_empty              => w_monitor_rx_empty
    );


    -- Instantiate the FRAME_ECC Primitive
    FRAME_ECC_0 : FRAME_ECCE2
    generic map (
        FRAME_RBT_IN_FILENAME   => "NONE",
        FARSRC                  => "EFAR"
    )
    port map (
        CRCERROR                => w_fecc_crcerr,
        ECCERROR                => w_fecc_eccerr,
        ECCERRORSINGLE          => w_fecc_eccerrsingle,
        FAR                     => r_fecc_far,
        SYNBIT                  => r_fecc_synbit,
        SYNDROME                => r_fecc_syndrome,
        SYNDROMEVALID           => w_fecc_syndromevalid,
        SYNWORD                 => r_fecc_synword
    );


    -- Instantiate the ICAP primitive
    ICAP_0 : ICAPE2
    generic map (
        SIM_CFG_FILE_NAME       => "NONE",
        DEVICE_ID               => X"FFFFFFFF",
        ICAP_WIDTH              => "X32"
    )
    port map (
        O                       => r_icap_o,
        CLK                     => i_clk,
        CSIB                    => w_icap_csib,
        I                       => r_icap_i,
        RDWRB                   => w_icap_rdwrb
    );


    -- Set the ICAP Grant signal to 1 to allow Internal Configuration Access Port connection
    w_icap_grant  <= '1';
    
    -- Route the SEM status signals to their outputs
    o_status_heartbeat                  <= w_status_heartbeat;
    o_status_initialization             <= w_status_initialization;
    o_status_observation                <= w_status_observation;
    o_status_correction                 <= w_status_correction;
    o_status_classification             <= w_status_classification;
    o_status_injection                  <= w_status_injection;
    o_status_essential                  <= w_status_essential;
    o_status_uncorrectable              <= w_status_uncorrectable;


end architecture Behavorial;
---------------------------------------------------------------------------------------------------------------------------------
-- END OF CODE