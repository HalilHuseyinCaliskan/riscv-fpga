library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.NUMERIC_STD.ALL;

entity register_file is
    Port(
        clk : in std_logic;
        request_enable : in std_logic;
        data_memory_data_in : in std_logic_vector(31 downto 0);
        rd_address : in std_logic_vector(4 downto 0);
        register_file_write_enable : in std_logic;
        write_address : in std_logic_vector(4 downto 0);
        write_data : in std_logic_vector(31 downto 0);
        read_address_1 : in std_logic_vector(4 downto 0);
        read_address_2 : in std_logic_vector(4 downto 0);
        read_data_1 : out std_logic_vector(31 downto 0);
        read_data_2 : out std_logic_vector(31 downto 0);
        acknowledge_enable : out std_logic
    );
end register_file;

architecture Behavioral of register_file is

    type register_array is Array (0 to 31) of std_logic_vector(31 downto 0);
    signal registers : register_array := (others => (others => '0'));
    
    signal acknowledge_enable_temp : std_logic := '0';

begin

    process(clk)
    begin
        if (rising_edge(clk)) then
            acknowledge_enable_temp <= '0';
            if (request_enable = '1') then
                registers(to_integer(unsigned(write_address))) <= write_data;
                acknowledge_enable_temp <= '1';
            elsif (register_file_write_enable = '1') then
                registers(to_integer(unsigned(rd_address))) <= data_memory_data_in;
                acknowledge_enable_temp <= '1';
            end if;
        end if;
    end process;
    
    read_data_1 <= registers(to_integer(unsigned(read_address_1)));
    read_data_2 <= registers(to_integer(unsigned(read_address_2)));
    
end Behavioral;