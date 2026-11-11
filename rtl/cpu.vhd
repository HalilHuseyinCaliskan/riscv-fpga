library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cpu is
    Port(
        clk : in std_logic;
        outputs : out std_logic_vector(9 downto 0)
    );
end cpu;

architecture Behavioral of cpu is

    component core is
        Port(
            clk : in std_logic;
            core_out : out std_logic_vector(9 downto 0)
        );
    end component;
    
    component CLK_WIZARD is
        Port(
            clk_100mhz : in std_logic;
            clk_50mhz : out std_logic        
        );
    end component;
    
    component ILA is
        Port(
            clk    : in std_logic;
            probe0 : in std_logic_vector(0 downto 0);
            probe1 : in std_logic_vector(0 downto 0);
            probe2 : in std_logic_vector(0 downto 0);
            probe3 : in std_logic_vector(0 downto 0); 
            probe4 : in std_logic_vector(0 downto 0);
            probe5 : in std_logic_vector(0 downto 0);
            probe6 : in std_logic_vector(0 downto 0);
            probe7 : in std_logic_vector(0 downto 0);
            probe8 : in std_logic_vector(0 downto 0);
            probe9 : in std_logic_vector(0 downto 0)
        );
    end component;
  
    signal clk_50mhz_temp : std_logic := '0';
    signal outputs_temp : std_logic_vector(9 downto 0) := (others => '0');

begin

    CORE_50MHZ: core port map (
        clk => clk_50mhz_temp,
        core_out => outputs_temp
    );
    
    CLOCK_WIZARD: CLK_WIZARD port map (
        clk_100mhz => clk,
        clk_50mhz => clk_50mhz_temp
    );
    
    ILA_BLOCK: ILA port map (
        clk => clk_50mhz_temp,
        probe0(0) => outputs_temp(0),
        probe1(0) => outputs_temp(1),
        probe2(0) => outputs_temp(2),
        probe3(0) => outputs_temp(3),
        probe4(0) => outputs_temp(4),
        probe5(0) => outputs_temp(5),
        probe6(0) => outputs_temp(6),
        probe7(0) => outputs_temp(7),
        probe8(0) => outputs_temp(8),
        probe9(0) => outputs_temp(9)
    );
    
    outputs <= outputs_temp;

end Behavioral;
