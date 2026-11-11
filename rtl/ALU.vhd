library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    Port(
        clk                : in  std_logic;
        request_enable     : in  std_logic;
        data_1_in          : in  std_logic_vector(31 downto 0);
        data_2_in          : in  std_logic_vector(31 downto 0);
        instruction        : in  std_logic_vector(31 downto 0);
        R_add              : in  std_logic;
        R_sub              : in  std_logic;
        R_mul              : in  std_logic;
        R_xor              : in  std_logic;
        R_or               : in  std_logic;
        R_and              : in  std_logic;
        I_addi             : in  std_logic;
        I_xori             : in  std_logic;
        I_ori              : in  std_logic;
        I_andi             : in  std_logic;
        B_beq              : in  std_logic;
        B_bne              : in  std_logic;
        B_blt              : in  std_logic;
        B_bge              : in  std_logic;
        J_jal              : in  std_logic;
        S_sw               : in  std_logic;
        I_lw               : in  std_logic;
        write_address      : out std_logic_vector(4 downto 0);
        write_data         : out std_logic_vector(31 downto 0);
        branch_enable      : out std_logic;
        branch_imm         : out std_logic_vector(12 downto 0);
        write_address_memory : out std_logic_vector(7 downto 0);
        write_data_memory : out std_logic_vector(31 downto 0);
        memory_write_enable : out std_logic;
        read_address_memory : out std_logic_vector(7 downto 0);
        memory_read_enable : out std_logic;
        acknowledge_enable : out std_logic
    );
end ALU;

architecture Behavioral of ALU is

    signal acknowledge_enable_temp : std_logic := '0';
    signal write_address_temp : std_logic_vector(4 downto 0) := (others => '0');
    signal write_data_temp : std_logic_vector(31 downto 0) := (others => '0');
    signal branch_enable_temp : std_logic := '0';
    signal branch_imm_temp : std_logic_vector(12 downto 0) := (others => '0');
    signal offet_memory_temp : std_logic_vector(11 downto 0) := (others => '0');
    signal write_address_memory_temp : std_logic_vector(7 downto 0) := (others => '0');
    signal write_data_memory_temp : std_logic_vector(31 downto 0) := (others => '0');
    signal memory_write_enable_temp : std_logic := '0';
    signal offet_memory_read_temp : std_logic_vector(11 downto 0) := (others => '0');
    signal read_address_memory_temp : std_logic_vector(7 downto 0) := (others => '0');
    signal memory_read_enable_temp : std_logic := '0';

begin

    acknowledge_enable <= acknowledge_enable_temp;

    process(clk)
    begin
        if (rising_edge(clk)) then
            if (request_enable = '1') then
                 acknowledge_enable_temp <= '1';
            else
                 acknowledge_enable_temp <= '0';
            end if;
        end if;
    end process;
    
    process(data_1_in, data_2_in, instruction, R_add, R_sub, R_mul, R_xor, R_or, R_and, I_addi, I_xori, I_ori, I_andi, B_beq, B_bne, B_blt, B_bge, J_jal, S_sw, I_lw)
    begin
    
        write_address_temp         <= (others => '0');
        write_data_temp            <= (others => '0');
        branch_enable_temp         <= '0';
        branch_imm_temp            <= (others => '0');
        memory_write_enable_temp   <= '0';
        memory_read_enable_temp    <= '0';
        offet_memory_temp          <= (others => '0');
        write_address_memory_temp  <= (others => '0');
        write_data_memory_temp     <= (others => '0');
        offet_memory_read_temp     <= (others => '0');
        read_address_memory_temp   <= (others => '0');
        
        if (R_add = '1') then
            write_address_temp <= instruction(11 downto 7);
            write_data_temp <= std_logic_vector(unsigned(data_1_in) + unsigned(data_2_in));
        elsif (R_sub = '1') then
            write_address_temp <= instruction(11 downto 7);
            write_data_temp <= std_logic_vector(unsigned(data_1_in) - unsigned(data_2_in));
        elsif (R_mul = '1') then
            write_address_temp <= instruction(11 downto 7);
            write_data_temp <= std_logic_vector(resize(unsigned(data_1_in) * unsigned(data_2_in), 32));
        elsif (R_xor = '1') then
            write_address_temp <= instruction(11 downto 7);
            write_data_temp <= data_1_in xor data_2_in;
        elsif (R_or = '1') then
            write_address_temp <= instruction(11 downto 7);
            write_data_temp <= data_1_in or data_2_in;
        elsif (R_and = '1') then
            write_address_temp <= instruction(11 downto 7);
            write_data_temp <= data_1_in and data_2_in;
        elsif (I_addi = '1') then
            write_address_temp <= instruction(11 downto 7);
            write_data_temp <= std_logic_vector(unsigned(data_1_in) + resize(unsigned(instruction(31 downto 20)), 32));
        elsif (I_xori = '1') then
            write_address_temp <= instruction(11 downto 7);
            write_data_temp <= std_logic_vector(unsigned(data_1_in) xor resize(unsigned(instruction(31 downto 20)), 32));
         elsif (I_ori = '1') then
            write_address_temp <= instruction(11 downto 7);
            write_data_temp <= std_logic_vector(unsigned(data_1_in) or resize(unsigned(instruction(31 downto 20)), 32));
         elsif (I_andi = '1') then
            write_address_temp <= instruction(11 downto 7);
            write_data_temp <= std_logic_vector(unsigned(data_1_in) and resize(unsigned(instruction(31 downto 20)), 32));
         elsif (B_beq = '1') then
            if (unsigned(data_1_in) = unsigned(data_2_in)) then
                branch_enable_temp <= '1';
                branch_imm_temp <= instruction(31) & instruction(7) & instruction(30 downto 25) & instruction(11 downto 8) & '0';
            end if;
         elsif (B_bne = '1') then
            if (unsigned(data_1_in) /= unsigned(data_2_in)) then
                branch_enable_temp <= '1';
                branch_imm_temp <= instruction(31) & instruction(7) & instruction(30 downto 25) & instruction(11 downto 8) & '0';
            end if;
         elsif (B_blt = '1') then
            if (unsigned(data_1_in) <= unsigned(data_2_in)) then
                branch_enable_temp <= '1';
                branch_imm_temp <= instruction(31) & instruction(7) & instruction(30 downto 25) & instruction(11 downto 8) & '0';
            end if;
         elsif (B_bge = '1') then
            if (unsigned(data_1_in) >= unsigned(data_2_in)) then
                branch_enable_temp <= '1';
                branch_imm_temp <= instruction(31) & instruction(7) & instruction(30 downto 25) & instruction(11 downto 8) & '0';
            end if;
        elsif (J_jal = '1') then
            branch_enable_temp <= '1';
            branch_imm_temp <= std_logic_vector(resize(unsigned(instruction(31) & instruction(19 downto 12) & instruction(20) & instruction(30 downto 21) & '0'), 13));
        elsif (S_sw = '1') then
            -- offet_memory_temp <= instruction(31 downto 25) & instruction(11 downto 7); 
            write_address_memory_temp <= std_logic_vector(resize(unsigned(data_1_in) + unsigned(instruction(31 downto 25) & instruction(11 downto 7)), 8)); --resize edilecek
            write_data_memory_temp <= std_logic_vector(unsigned(data_2_in));
            memory_write_enable_temp <= '1';
        elsif (I_lw = '1') then
            -- offet_memory_read_temp <= instruction(31 downto 20); 
            read_address_memory_temp <= std_logic_vector(resize(unsigned(data_1_in) + unsigned(instruction(31 downto 20)), 8)); --resize edilecek
            memory_read_enable_temp <= '1';
        end if;
    end process;
    
    write_address <= write_address_temp;
    write_data <= write_data_temp;
    branch_enable <= branch_enable_temp;
    branch_imm <= branch_imm_temp;
    write_address_memory <= write_address_memory_temp;
    write_data_memory <= write_data_memory_temp;
    memory_write_enable <= memory_write_enable_temp;
    read_address_memory <= read_address_memory_temp;
    memory_read_enable <= memory_read_enable_temp;
    acknowledge_enable <= acknowledge_enable_temp;

end Behavioral;