library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity instruction_memory is
    Port(
        clk : in std_logic;
        request_enable : in std_logic;
        address_in : in std_logic_vector(11 downto 0);
        instruction_out : out std_logic_vector(31 downto 0);
        acknowledge_enable : out std_logic
    );
end instruction_memory;

architecture Behavioral of instruction_memory is

    component BLOCK_RAM IS
        PORT (
            clka : IN STD_LOGIC;
            ena : IN STD_LOGIC;
            wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
            dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    end component;
    
    signal acknowledge_enable_temp : std_logic := '0';

begin

    INSTRUCTION_MEMORY: BLOCK_RAM port map (
        clka => clk,
        ena => request_enable,
        wea => "0",
        addra => address_in(11 downto 2),
        dina => (others => '0'),
        douta => instruction_out
    );
    
    process(clk)
    begin
        if (rising_edge(clk)) then
            acknowledge_enable_temp <= request_enable;
        end if;
    end process;

    acknowledge_enable <= acknowledge_enable_temp;
    
end Behavioral;
