----------------------------------------------------------------------------------------------------------------------------------------
--
--	BASYS 3 BOARD 7 SEGMENT DISPLAY
--
--	Created by Chris Major
-- 	3/19/2021
--
--	The Basys 3 board from Digilent uses a state machine to drive its 7 segment display, included in this component.
-- 	https://store.digilentinc.com/basys-3-artix-7-fpga-beginner-board-recommended-for-introductory-users/
--
----------------------------------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------------------------------
-- LIBRARIES
----------------------------------------------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;


----------------------------------------------------------------------------------------------------------------------------------------
-- ENTITY
----------------------------------------------------------------------------------------------------------------------------------------
entity basys_7seg is
port (  
	i_clk						: in	std_logic;											-- Clock
	i_reset_n					: in	std_logic;											-- Active Low Reset
        
    i_input_number              : in    std_logic_vector(15 downto 0);                      -- Binary input number
	
    o_anode_act            		: out   std_logic_vector (3 downto 0);                      -- Active Anode Flag
    o_led_out                   : out   std_logic_vector (6 downto 0)                       -- BCD Value Output
);
end basys_7seg;


----------------------------------------------------------------------------------------------------------------------------------------
-- ARCHITECTURE
----------------------------------------------------------------------------------------------------------------------------------------
architecture basys_7seg_arch of basys_7seg is


	------------------------------------------------------------------------------------------------------------------------------------
	-- SIGNAL DECLARATIONS
	------------------------------------------------------------------------------------------------------------------------------------  
    signal r_seg_refresh_counter                : std_logic_vector (27 downto 0);							-- Segment Refresh Counter
    signal r_val_refresh_counter                : std_logic_vector (19 downto 0);							-- Value Refresh Counter	
	 
    signal r_displayed_number                   : std_logic_vector (15 downto 0);							-- Number to be displayed
    signal r_led_bcd                            : std_logic_vector (3 downto 0);							-- Binary Decimal Value
	
    signal r_anode                    			: std_logic_vector (1 downto 0);							-- Active anode flags


begin


    -- CLOCKING PROCESS
    -- Handle clock and reset signals through counter
    CLOCK : process( i_clk, i_reset_n)
    begin 
    
		-- On reset, set the Value Refresh Counter to 0
        if( i_reset_n = '0' ) then
            r_val_refresh_counter <= (others => '0');
        
		-- On clock rising edge, increment Value Refresh Counter
        elsif( rising_edge(i_clk) ) then
            r_val_refresh_counter <= r_val_refresh_counter + 1;
            
        end if;
    
	end process;


    -- SEVEN SEGMENT PROCESS
    -- Process for Binary Count Decimal (BCD) 7-segment display
    SEVEN_SEG : process( r_led_bcd )
    begin
	
		-- Assign BCD value to 7 segment display given binary input
        case r_led_bcd is
            when "0000" => o_led_out <= "0000001";  
            when "0001" => o_led_out <= "1001111";
            when "0010" => o_led_out <= "0010010";
            when "0011" => o_led_out <= "0000110";
            
            when "0100" => o_led_out <= "1001100";
            when "0101" => o_led_out <= "0100100";
            when "0110" => o_led_out <= "0100000";
            when "0111" => o_led_out <= "0001111";
            
            when "1000" => o_led_out <= "0000000";
            when "1001" => o_led_out <= "0000100";
            when "1010" => o_led_out <= "0000010";
            when "1011" => o_led_out <= "1100000";
            
            when "1100" => o_led_out <= "0110001";
            when "1101" => o_led_out <= "1000010";
            when "1110" => o_led_out <= "0110000";
            when "1111" => o_led_out <= "0111000";
        end case;
		
    end process;


    -- ANODE ACTIVATE PROCESS
    -- Process to activate 7-segment displays
    process( r_anode )
    begin
    
		-- Determine which 7 segment display is written to given the flags
        case r_anode is
            when "00" =>
                o_anode_act             <= "0111"; 
                r_led_bcd               <= r_displayed_number(15 downto 12);

            when "01" =>
                o_anode_act             <= "1011"; 
                r_led_bcd               <= r_displayed_number(11 downto 8);

            when "10" =>
                o_anode_act             <= "1101"; 
                r_led_bcd               <= r_displayed_number(7 downto 4);
       
            when "11" =>
                o_anode_act             <= "1110"; 
                r_led_bcd               <= r_displayed_number(3 downto 0);
    
        end case;  
		
    end process;


    -- REFRESH COUNTER PROCESS
    -- Counter Process
    REFRESH_COUNTER : process( i_clk, i_reset_n )
    begin
    
		-- On reset, set the Segment Refresh Counter to 0 
		if( i_reset_n = '0' ) then
			r_seg_refresh_counter <= (others => '0');
			
		-- On clock rising edge ... 
		elsif( rising_edge(i_clk) ) then
		
			-- If Segment Refresh Counter hits the upper limit, set to 0
			if( r_seg_refresh_counter >= x"5F5E0FF") then
				r_seg_refresh_counter <= (others => '0');
				
			-- If not, increment Segment Refresh Counter
			else
				r_seg_refresh_counter <= r_seg_refresh_counter + "0000001";
				
			end if;
			
		end if;
		
    end process;
    
    
    -- Assign signals to route processes
    r_anode           			<= r_val_refresh_counter(19 downto 18);
    r_displayed_number          <= i_input_number;
    
    
end basys_7seg_arch;
----------------------------------------------------------------------------------------------------------------------------------------
-- END OF CODE