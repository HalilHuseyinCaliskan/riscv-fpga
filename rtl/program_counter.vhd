library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity program_counter is
    Port(
        clk                     : in std_logic;
        request_enable          : in std_logic;
        branch_enable           : in std_logic;
        branch_imm              : in std_logic_vector(12 downto 0);
        current_program_count   : out std_logic_vector(11 downto 0);
        acknowledge_enable      : out std_logic
    );
end program_counter;

architecture Behavioral of program_counter is
    
    signal current_program_counter : std_logic_vector(11 downto 0) := (others => '0'); 
    signal next_program_counter : std_logic_vector(11 downto 0) := (others => '0'); 
    signal acknowledge_enable_temp : std_logic := '0';
    

begin

    process(clk)
    begin
        if (rising_edge(clk)) then
            acknowledge_enable_temp <= '0';      
            if (request_enable = '1') then
                if (branch_enable = '1') then
                    current_program_counter <= std_logic_vector(unsigned(current_program_counter) + resize(unsigned(branch_imm), 12));
                    next_program_counter <= std_logic_vector(unsigned(current_program_counter) + resize(unsigned(branch_imm), 12) + 4);
                else
                    next_program_counter <= std_logic_vector(unsigned(next_program_counter) + 4);
                    current_program_counter <= next_program_counter;
                end if;
                
                acknowledge_enable_temp <= '1';
                
            end if;
        end if;
    end process;

    current_program_count <= current_program_counter;
    acknowledge_enable <= acknowledge_enable_temp;

end Behavioral;