library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity instruction_register is
    Port(
        clk : in std_logic;
        request_enable : in std_logic;
        instruction_in : in std_logic_vector(31 downto 0);
        instruction_out : out std_logic_vector(31 downto 0);
        acknowledge_enable : out std_logic
    );
end instruction_register;

architecture Behavioral of instruction_register is

    signal instruction_out_temp : std_logic_vector(31 downto 0) := (others => '0');
    signal acknowledge_enable_temp : std_logic := '0';

begin

    process(clk)
    begin
        if (rising_edge(clk)) then
            acknowledge_enable_temp <= '0';
            if (request_enable = '1') then
                instruction_out_temp <= instruction_in;
                acknowledge_enable_temp <= '1';
            end if;
        end if;
    end process;

    instruction_out <= instruction_out_temp;
    acknowledge_enable <= acknowledge_enable_temp;

end Behavioral;