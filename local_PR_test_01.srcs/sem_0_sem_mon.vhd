---------------------------------------------------------------------------------------------------------------------------------
-- Company:                 Montana State University
-- Engineer:                Chris Major
--
-- Create Date:             1/17/2020
-- Design Name:             RadPC Lite
-- Module Name:             SEM Monitor
-- Project Name:            RadPC - Radiation Tolerant Computer System
-- Target Devices:          Basys A7 XC7A35T CPG236-1
-- Tool Versions:           Vivado 2019.2
-- Description:             Component for the RS232 monitor for the Soft Error Mitigation 
--
-- Dependencies:            sem_0_sem_mon_fifo.vhd
--                          sem_0_sem_mon_piso.vhd
--                          sem_0_sem_mon_sipo.vhd
--
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
entity sem_monitor is
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
end entity sem_monitor;


-- ARCHITECTURE
---------------------------------------------------------------------------------------------------------------------------------
architecture Behavorial of sem_monitor is


    -- COMPONENT DECLARATIONS
    -----------------------------------------------------------------------------------------------------------------------------

    -- Declare a FIFO Component
    component sem_0_sem_mon_fifo
    port (
        icap_clk                        : in    std_logic;
        data_in                         : in    std_logic_vector(7 downto 0);
        data_out                        : out   std_logic_vector(7 downto 0);
        write                           : in    std_logic;
        read                            : in    std_logic;
        full                            : out   std_logic;
        data_present                    : out   std_logic
    );
    end component;
    
    -- Declare a PISO Component
    component sem_0_sem_mon_piso
    port (
        icap_clk                        : in    std_logic;
        data_in                         : in    std_logic_vector(7 downto 0);
        send_character                  : in    std_logic;
        en_16_x_baud                    : in    std_logic;
        serial_out                      : out   std_logic;
        tx_complete                     : out   std_logic
    );
    end component;
    
    -- Declare a SIPO Component
    component sem_0_sem_mon_sipo
    port (
        icap_clk                        : in    std_logic;
        data_out                        : out   std_logic_vector(7 downto 0);
        serial_in                       : in    std_logic;
        en_16_x_baud                    : in    std_logic;
        data_strobe                     : out   std_logic
    );
    end component;


    -- CONSTANT DECLARATIONS
    -----------------------------------------------------------------------------------------------------------------------------
    constant c_tcq                              : time                              := 1 ps;
    constant c_enabletime                       : integer                           := 103;       -- See pg. 39 of SEM datasheet
    --constant c_enabletime                       : integer                           := 53;

    -- SIGNAL DECLARATIONS
    -----------------------------------------------------------------------------------------------------------------------------
    signal r_en_16_x_counter                    : std_logic_vector(11 downto 0)     := X"000";      -- Register for baud rate counter
    signal w_en_16_x_baud                       : std_logic;                                        -- Signal for Baud enable                                     
    
    signal w_fifo_read                          : std_logic;                                        -- Signal for FIFO reading             
    signal w_fifo_data_present                  : std_logic;                                        -- Signal for FIFO data present
    signal r_fifo_data_out                      : std_logic_vector(7 downto 0);                     -- Signal for FIFO data output
    
    signal w_tx_full_p                          : std_logic;                                        -- Signal to represent transmit full flag
    
    signal w_fifo_write                         : std_logic;                                        --
    signal r_fifo_data_in                       : std_logic_vector(7 downto 0);                     --
    signal w_fifo_unused                        : std_logic;                                        --
    
    signal w_rx_empty_n                         : std_logic;                                        -- Signal to represent receive empty flag


begin


    -- 16X ENABLE SIGNAL PROCESS
    -- Process to create the 16x enable signal for baud rate generation
    EN_16X_ENABLE_PROC : process (i_clk)
    begin
        if rising_edge( i_clk ) then
            
            if (w_en_16_x_baud = '1') then
                r_en_16_x_counter <= X"000" after c_tcq;
            else
                r_en_16_x_counter <= r_en_16_x_counter + X"001" after c_tcq;
            end if;
            
        end if;
    end process;


    -- Instantiate a FIFO for the Transmit channel
    TX_FIFO : sem_0_sem_mon_fifo
    port map (
        data_in             => i_monitor_tx_data,
        data_out            => r_fifo_data_out,
        write               => i_monitor_tx_write,
        read                => w_fifo_read,
        full                => w_tx_full_p,
        data_present        => w_fifo_data_present,
        icap_clk            => i_clk
    );


    -- Instantiate a PISO for the Transmit channel
    TX_PISO : sem_0_sem_mon_piso
    port map (
        data_in             => r_fifo_data_out,
        send_character      => w_fifo_data_present,
        en_16_x_baud        => w_en_16_x_baud,
        serial_out          => o_monitor_tx,
        tx_complete         => w_fifo_read,
        icap_clk            => i_clk
    );


    -- Instantiate a SIPO for the Receive channel
    RX_SIPO : sem_0_sem_mon_sipo
    port map (
        serial_in           => i_monitor_rx,
        data_out            => r_fifo_data_in,
        data_strobe         => w_fifo_write,
        en_16_x_baud        => w_en_16_x_baud,
        icap_clk            => i_clk
    );


    -- Instantiate a FIFO for the Receive channel
    RX_FIFO : sem_0_sem_mon_fifo
    port map (
        data_in             => r_fifo_data_in,
        data_out            => o_monitor_rx_data,
        write               => w_fifo_write,
        read                => i_monitor_rx_read,
        full                => w_fifo_unused,
        data_present        => w_rx_empty_n,
        icap_clk            => i_clk
    );

    -- Assign receive empty signal to output
    o_monitor_rx_empty  <= not w_rx_empty_n;

    -- Assign transmit full signal to output
    o_monitor_tx_full   <= w_tx_full_p;

    -- Assign to the Baud Enable signal
    w_en_16_x_baud      <= '1' when( r_en_16_x_counter = conv_std_logic_vector(c_enabletime, 12) ) else '0';


end architecture Behavorial;
---------------------------------------------------------------------------------------------------------------------------------
-- END OF CODE