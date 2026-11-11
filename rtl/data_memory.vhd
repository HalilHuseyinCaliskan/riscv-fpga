library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity data_ram is
    Port(
        clk : in std_logic;
        memory_read_enable : in std_logic;
        we : in std_logic;
        instruction : in std_logic_vector(31 downto 0);
        waddr : in std_logic_vector(7 downto 0);
        raddr : in std_logic_vector(7 downto 0);
        wdata : in std_logic_vector(31 downto 0);
        rdata : out std_logic_vector(31 downto 0);
        rd_address : out std_logic_vector(4 downto 0);
        register_file_write_enable : out std_logic;
        acknowledge_enable : out std_logic
    );
end data_ram;

architecture Behavioral of data_ram is

    constant DEPTH : integer := 2**8;
    type ram_type is Array (0 to DEPTH - 1) of std_logic_vector(31 downto 0);
    signal ram : ram_type;

    attribute ram_style : string;
    attribute ram_style of ram : signal is "distributed";

    signal acknowledge_enable_temp : std_logic := '0';
    
    signal rd_address_temp : std_logic_vector(4 downto 0) := (others => '0');
    signal register_file_write_enable_temp : std_logic := '0';
    
    -- Senkronizasyon için ara sinyaller (Registers)
    signal rdata_reg : std_logic_vector(31 downto 0) := (others => '0');
    signal rd_address_reg : std_logic_vector(4 downto 0) := (others => '0');

begin

    rd_address_temp <= instruction(11 downto 7);
    
    process(clk)
    begin
        if (rising_edge(clk)) then
            acknowledge_enable_temp <= '0';
            register_file_write_enable_temp <= '0';
            
            if (we = '1') then
                ram(to_integer(unsigned(waddr))) <= wdata;
                acknowledge_enable_temp <= '1';
                
            elsif (memory_read_enable = '1') then
                rdata_reg <= ram(to_integer(unsigned(raddr)));
                rd_address_reg <= rd_address_temp;
                register_file_write_enable_temp <= '1';
                acknowledge_enable_temp <= '1';
            end if;
        end if;
    end process;

    rdata <= rdata_reg;
    rd_address <= rd_address_reg;
    register_file_write_enable <= register_file_write_enable_temp;
    acknowledge_enable <= acknowledge_enable_temp; 

end Behavioral;