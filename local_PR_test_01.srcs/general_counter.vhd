----------------------------------------------------------------------------------------------------------------------------------------
--
--	VHDL GENERAL USE COUNTER
--
--	Created by Chris Major
-- 	3/17/2021
--
--	A general-use up-down counter designed in VHDL.
--
----------------------------------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------------------------------
-- LIBRARIES
----------------------------------------------------------------------------------------------------------------------------------------

-- IEE Standard Library
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


----------------------------------------------------------------------------------------------------------------------------------------
-- ENTITY
----------------------------------------------------------------------------------------------------------------------------------------
entity counter is
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
end entity;


----------------------------------------------------------------------------------------------------------------------------------------
-- ARCHITECTURE
----------------------------------------------------------------------------------------------------------------------------------------
architecture counter_arch of counter is


	------------------------------------------------------------------------------------------------------------------------------------
	-- SIGNAL DECLARATIONS
	------------------------------------------------------------------------------------------------------------------------------------
	
	signal r_count				: unsigned( (g_count_size - 1) downto 0 );					-- Internal count register

	
begin


	-- Process to handle counter
	CNT_01 : process( i_clk )
	begin
	
		-- On reset, set count value to 0
		if( i_reset_n = '0') then
			r_count <= (others => '0');
			
		-- On rising edge of clock, perform count operation
		elsif rising_edge( i_clk ) then
		
			-- If counting UP, perform addition
			if( i_up_down = '1' ) then
			
				-- If the count value is greater than or equal to the maximum, reset to 0
				if( r_count >= g_count_max ) then
					r_count <= (others => '0');
					
				-- Else, increment the count value
				else
					r_count <= r_count + 1;
					
				end if;
				
				
			-- If counting DOWN, perform subtraction
			else
			
				-- If the count value is greater than or equal to the maximum, reset to 0
				if( r_count <= 0 ) then
					r_count <= to_unsigned( g_count_max, g_count_size );
					
				-- Else, increment the count value
				else
					r_count <= r_count - 1;
					
				end if;		
			
			end if;

		end if;
	
	end process;


	-- Assign internal count register to output
	o_count <= std_logic_vector( r_count );


end architecture;
----------------------------------------------------------------------------------------------------------------------------------------
-- END OF CODE