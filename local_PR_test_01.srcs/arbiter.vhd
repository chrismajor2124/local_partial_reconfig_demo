----------------------------------------------------------------------------------------------------------------------------------------
--
--	ICAP Port Arbiter
--
--	Created by Chris Major
-- 	4/8/2021
--
--	“What would you have your Arbiter do?”
--      - Thel 'Vadam, Halo 2
--
--  "I dunno, make RadPC work or something!"
--      - Chris Major, RadPC Lab
--
----------------------------------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------------------------------
-- LIBRARIES
----------------------------------------------------------------------------------------------------------------------------------------

-- IEE Standard Library
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


----------------------------------------------------------------------------------------------------------------------------------------
-- ENTITY
----------------------------------------------------------------------------------------------------------------------------------------
entity arbiter is
port(
	i_select                                       : in    std_logic;                              -- ICAP Device Select
	
	-- PARTIAL RECONFIGURATION (PR) DEVICE PORTS
	i_pr_csib                                      : in    std_logic;                              -- PR Device ICAP Enable
	i_pr_rdwrb                                     : in    std_logic;	                           -- PR Device ICAP Read/Write
	i_pr_o                                         : in    std_logic_vector(31 downto 0);          -- PR Device ICAP Output Data
	o_pr_i                                         : out   std_logic_vector(31 downto 0);          -- PR Device ICAP Input Data
	
	o_pr_grant                                     : out   std_logic;                              -- PR Device ICAP Access Grant
	i_pr_request                                   : in    std_logic;                              -- PR Device ICAP Access Request
	
	-- SOFT ERROR MITIGATION (SEM) DEVICE PORTS
	i_sem_csib                                     : in    std_logic;                              -- SEM Device ICAP Enable
	i_sem_rdwrb                                    : in    std_logic;	                           -- SEM Device ICAP Read/Write
	i_sem_o                                        : in    std_logic_vector(31 downto 0);          -- SEM Device ICAP Output Data
	o_sem_i                                        : out   std_logic_vector(31 downto 0);          -- SEM Device ICAP Input Data
	
	o_sem_grant                                    : out   std_logic;                              -- SEM Device ICAP Access Grant
	i_sem_request                                  : in    std_logic;                              -- SEM Device ICAP Access Request
	
	-- INTERNAL CONFIGURATION ACCESS PORT (ICAP) DEVICE PORTS
	i_icap_o                                       : in    std_logic_vector(31 downto 0);          -- ICAP Device Output Data  (O)
    o_icap_i                                       : out   std_logic_vector(31 downto 0);          -- ICAP Device Input Data   (I)
	o_icap_csib                                    : out   std_logic;                              -- ICAP Device Enable       (CSIB)
	o_icap_rdwrb                                   : out   std_logic                               -- ICAP Device Read/Write   (RDWRB)
);
end entity;


----------------------------------------------------------------------------------------------------------------------------------------
-- ARCHITECTURE
----------------------------------------------------------------------------------------------------------------------------------------
architecture arbiter_arch of arbiter is


	------------------------------------------------------------------------------------------------------------------------------------
	-- CONSTANT DECLARATIONS
	------------------------------------------------------------------------------------------------------------------------------------
	constant c_PR_ICAP_CONTROL                     : std_logic := '1';         -- Constant for PR device ICAP Control
	constant c_SEM_ICAP_CONTROL                    : std_logic := '0';         -- Constant for SEM device ICAP Control
	

begin


	------------------------------------------------------------------------------------------------------------------------------------
	-- ICAP PORT ARBITRATION
	------------------------------------------------------------------------------------------------------------------------------------

    -- Set the Active-Low ICAP enable (CSIB) depending on the switch configuration
    o_icap_csib         <= i_pr_csib            when i_select = c_PR_ICAP_CONTROL           else i_sem_csib;
         
    -- Set the Read/Write Select Input (RDWRB) depending on the switch configuration
    o_icap_rdwrb        <= i_pr_rdwrb           when i_select = c_PR_ICAP_CONTROL           else i_sem_rdwrb;
    
    -- Set the ICAP input (I) depending on the switch configuration    
    o_icap_i            <= i_pr_o               when i_select = c_PR_ICAP_CONTROL           else i_sem_o;   
    
    -- Set the ICAP output (O) to the correct device depending on the switch configuration
    o_pr_i              <= i_icap_o             when i_select = c_PR_ICAP_CONTROL           else (others => '0');    
    o_sem_i             <= i_icap_o             when i_select = c_SEM_ICAP_CONTROL          else (others => '0');
    
    
    ------------------------------------------------------------------------------------------------------------------------------------
	-- ICAP PERMISSION GRANTING
	------------------------------------------------------------------------------------------------------------------------------------
    
    -- Set the ICAP Grant signal depending on the switch configuration
    o_pr_grant          <= '1'                  when i_select = c_PR_ICAP_CONTROL           else '0';
    o_sem_grant         <= '1'                  when i_select = c_SEM_ICAP_CONTROL          else '0';


end architecture;
----------------------------------------------------------------------------------------------------------------------------------------
-- END OF CODE