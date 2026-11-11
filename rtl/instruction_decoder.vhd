library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity instruction_decoder is
    Port(
        clk : in std_logic;
        request_enable : in std_logic;
        instruction : in std_logic_vector(31 downto 0);
        read_address_1 : out std_logic_vector(4 downto 0);
        read_address_2 : out std_logic_vector(4 downto 0);
        R_add : out std_logic;
        R_sub : out std_logic;
        R_mul : out std_logic;
        R_xor : out std_logic;
        R_or : out std_logic;
        R_and : out std_logic;
        I_addi : out std_logic; 
        I_xori : out std_logic; 
        I_ori : out std_logic; 
        I_andi : out std_logic;
        B_beq : out std_logic;
        B_bne : out std_logic;    
        B_blt : out std_logic;
        B_bge : out std_logic; 
        J_jal : out std_logic; 
        S_sw : out std_logic;  
        I_lw : out std_logic;
        acknowledge_enable : out std_logic
    );
end instruction_decoder;

architecture Behavioral of instruction_decoder is

    signal opcode_a0 : std_logic := '0';
    signal opcode_a1 : std_logic := '0';
    signal opcode_a2 : std_logic := '0';
    signal opcode_a3 : std_logic := '0';
    signal opcode_a4 : std_logic := '0';
    signal opcode_a5 : std_logic := '0';
    signal opcode_a6 : std_logic := '0';
    
    signal opcode_a0_not : std_logic := '0';
    signal opcode_a1_not : std_logic := '0';
    signal opcode_a2_not : std_logic := '0';
    signal opcode_a3_not : std_logic := '0';
    signal opcode_a4_not : std_logic := '0';
    signal opcode_a5_not : std_logic := '0';
    signal opcode_a6_not : std_logic := '0';
    
    signal funct3_a0 : std_logic := '0';
    signal funct3_a1 : std_logic := '0';
    signal funct3_a2 : std_logic := '0';
    
    signal funct3_a0_not : std_logic := '0';
    signal funct3_a1_not : std_logic := '0';
    signal funct3_a2_not : std_logic := '0';
    
    signal funct7_a0 : std_logic := '0';
    signal funct7_a1 : std_logic := '0';
    signal funct7_a2 : std_logic := '0';
    signal funct7_a3 : std_logic := '0';
    signal funct7_a4 : std_logic := '0';
    signal funct7_a5 : std_logic := '0';
    signal funct7_a6 : std_logic := '0';
    
    signal funct7_a0_not : std_logic := '0';
    signal funct7_a1_not : std_logic := '0';
    signal funct7_a2_not : std_logic := '0';
    signal funct7_a3_not : std_logic := '0';
    signal funct7_a4_not : std_logic := '0';
    signal funct7_a5_not : std_logic := '0';
    signal funct7_a6_not : std_logic := '0';
    
    signal R_add_temp : std_logic := '0';
    signal R_sub_temp : std_logic := '0';
    signal R_mul_temp : std_logic := '0';
    signal R_xor_temp : std_logic := '0';
    signal R_or_temp : std_logic := '0';
    signal R_and_temp : std_logic := '0';
    signal I_addi_temp : std_logic := '0';
    signal I_xori_temp : std_logic := '0';
    signal I_ori_temp : std_logic := '0';
    signal I_andi_temp : std_logic := '0';
    signal B_beq_temp : std_logic := '0';
    signal B_bne_temp : std_logic := '0';
    signal B_blt_temp : std_logic := '0';
    signal B_bge_temp : std_logic := '0';
    signal J_jal_temp : std_logic := '0';
    signal S_sw_temp : std_logic := '0';
    signal I_lw_temp : std_logic := '0';
    
    signal acknowledge_enable_temp : std_logic := '0';
    
    signal read_address_1_temp : std_logic_vector(4 downto 0) := (others => '0');
    signal read_address_2_temp : std_logic_vector(4 downto 0) := (others => '0');
    
begin

    opcode_a0 <= instruction(0);
    opcode_a1 <= instruction(1);
    opcode_a2 <= instruction(2);
    opcode_a3 <= instruction(3);
    opcode_a4 <= instruction(4);
    opcode_a5 <= instruction(5);
    opcode_a6 <= instruction(6);
    
    opcode_a0_not <= not opcode_a0;
    opcode_a1_not <= not opcode_a1;
    opcode_a2_not <= not opcode_a2;
    opcode_a3_not <= not opcode_a3;
    opcode_a4_not <= not opcode_a4;
    opcode_a5_not <= not opcode_a5;
    opcode_a6_not <= not opcode_a6;
    
    funct3_a0 <= instruction(12);
    funct3_a1 <= instruction(13);
    funct3_a2 <= instruction(14);
  
    funct3_a0_not <= not funct3_a0;
    funct3_a1_not <= not funct3_a1;
    funct3_a2_not <= not funct3_a2;
    
    funct7_a0 <= instruction(25);
    funct7_a1 <= instruction(26);
    funct7_a2 <= instruction(27);
    funct7_a3 <= instruction(28);
    funct7_a4 <= instruction(29);
    funct7_a5 <= instruction(30);
    funct7_a6 <= instruction(31);
  
    funct7_a0_not <= not funct7_a0;
    funct7_a1_not <= not funct7_a1;
    funct7_a2_not <= not funct7_a2;
    funct7_a3_not <= not funct7_a3;
    funct7_a4_not <= not funct7_a4;
    funct7_a5_not <= not funct7_a5;
    funct7_a6_not <= not funct7_a6;
    
    -- read_address_1 <= instruction(19 downto 15) when ((opcode_a0 and opcode_a1 and opcode_a2_not and opcode_a3_not and opcode_a4 and opcode_a5 and opcode_a6_not) or (opcode_a0 and opcode_a1 and opcode_a2_not and opcode_a3_not and opcode_a4_not and opcode_a5 and opcode_a6_not) or (opcode_a0 and opcode_a1 and opcode_a2_not and opcode_a3_not and opcode_a4_not and opcode_a5 and opcode_a6) or (opcode_a0 and opcode_a1 and opcode_a2_not and opcode_a3_not and opcode_a4 and opcode_a5_not and opcode_a6_not) or (opcode_a0 and opcode_a1 and opcode_a2_not and opcode_a3_not and opcode_a4_not and opcode_a5_not and opcode_a6_not) or (opcode_a0 and opcode_a1 and opcode_a2 and opcode_a3_not and opcode_a4_not and opcode_a5 and opcode_a6) or (opcode_a0 and opcode_a1 and opcode_a2_not and opcode_a3_not and opcode_a4 and opcode_a5 and opcode_a6)) = '1' else (others => '0');
    -- read_address_2 <= instruction(24 downto 20) when (opcode_a0 and opcode_a1 and opcode_a2_not and opcode_a3_not and opcode_a4 and opcode_a5 and opcode_a6_not) = '1' else (others => '0');

    R_add_temp <= (opcode_a0 and opcode_a1 and opcode_a2_not and opcode_a3_not and opcode_a4 and opcode_a5 and opcode_a6_not) and (funct3_a0_not and funct3_a1_not and funct3_a2_not) and (funct7_a0_not and funct7_a1_not and funct7_a2_not and funct7_a3_not and funct7_a4_not and funct7_a5_not and funct7_a6_not);
    R_sub_temp <= (opcode_a0 and opcode_a1 and opcode_a2_not and opcode_a3_not and opcode_a4 and opcode_a5 and opcode_a6_not) and (funct3_a0_not and funct3_a1_not and funct3_a2_not) and (funct7_a0_not and funct7_a1_not and funct7_a2_not and funct7_a3_not and funct7_a4_not and funct7_a5 and funct7_a6_not);
    R_mul_temp <= (opcode_a0 and opcode_a1 and opcode_a2_not and opcode_a3_not and opcode_a4 and opcode_a5 and opcode_a6_not) and (funct3_a0_not and funct3_a1_not and funct3_a2_not) and (funct7_a0 and funct7_a1_not and funct7_a2_not and funct7_a3_not and funct7_a4_not and funct7_a5_not and funct7_a6_not);
    R_xor_temp <= (opcode_a0 and opcode_a1 and opcode_a2_not and opcode_a3_not and opcode_a4 and opcode_a5 and opcode_a6_not) and (funct3_a0_not and funct3_a1_not and funct3_a2) and (funct7_a0_not and funct7_a1_not and funct7_a2_not and funct7_a3_not and funct7_a4_not and funct7_a5_not and funct7_a6_not);
    R_or_temp <= (opcode_a0 and opcode_a1 and opcode_a2_not and opcode_a3_not and opcode_a4 and opcode_a5 and opcode_a6_not) and (funct3_a0_not and funct3_a1 and funct3_a2) and (funct7_a0_not and funct7_a1_not and funct7_a2_not and funct7_a3_not and funct7_a4_not and funct7_a5_not and funct7_a6_not);
    R_and_temp <= (opcode_a0 and opcode_a1 and opcode_a2_not and opcode_a3_not and opcode_a4 and opcode_a5 and opcode_a6_not) and (funct3_a0 and funct3_a1 and funct3_a2) and (funct7_a0_not and funct7_a1_not and funct7_a2_not and funct7_a3_not and funct7_a4_not and funct7_a5_not and funct7_a6_not);
    I_addi_temp <= (opcode_a0 and opcode_a1 and opcode_a2_not and opcode_a3_not and opcode_a4 and opcode_a5_not and opcode_a6_not) and (funct3_a0_not and funct3_a1_not and funct3_a2_not);
    I_xori_temp <= (opcode_a0 and opcode_a1 and opcode_a2_not and opcode_a3_not and opcode_a4 and opcode_a5_not and opcode_a6_not) and (funct3_a0_not and funct3_a1_not and funct3_a2);
    I_ori_temp <= (opcode_a0 and opcode_a1 and opcode_a2_not and opcode_a3_not and opcode_a4 and opcode_a5_not and opcode_a6_not) and (funct3_a0_not and funct3_a1 and funct3_a2);
    I_andi_temp <= (opcode_a0 and opcode_a1 and opcode_a2_not and opcode_a3_not and opcode_a4 and opcode_a5_not and opcode_a6_not) and (funct3_a0 and funct3_a1 and funct3_a2);
    B_beq_temp <= (opcode_a0 and opcode_a1 and opcode_a2_not and opcode_a3_not and opcode_a4_not and opcode_a5 and opcode_a6) and (funct3_a0_not and funct3_a1_not and funct3_a2_not);
    B_bne_temp <= (opcode_a0 and opcode_a1 and opcode_a2_not and opcode_a3_not and opcode_a4_not and opcode_a5 and opcode_a6) and (funct3_a0 and funct3_a1_not and funct3_a2_not);
    B_blt_temp <= (opcode_a0 and opcode_a1 and opcode_a2_not and opcode_a3_not and opcode_a4_not and opcode_a5 and opcode_a6) and (funct3_a0_not and funct3_a1_not and funct3_a2);
    B_bge_temp <= (opcode_a0 and opcode_a1 and opcode_a2_not and opcode_a3_not and opcode_a4_not and opcode_a5 and opcode_a6) and (funct3_a0 and funct3_a1_not and funct3_a2);
    J_jal_temp <= (opcode_a0 and opcode_a1 and opcode_a2 and opcode_a3 and opcode_a4_not and opcode_a5 and opcode_a6);    
    S_sw_temp <= (opcode_a0 and opcode_a1 and opcode_a2_not and opcode_a3_not and opcode_a4_not and opcode_a5 and opcode_a6_not) and (funct3_a0_not and funct3_a1 and funct3_a2_not);    
    I_lw_temp <= (opcode_a0 and opcode_a1 and opcode_a2_not and opcode_a3_not and opcode_a4_not and opcode_a5_not and opcode_a6_not) and (funct3_a0_not and funct3_a1 and funct3_a2_not);    
    
    R_add <= R_add_temp;
    R_sub <= R_sub_temp;
    R_mul <= R_mul_temp;
    R_xor <= R_xor_temp;
    R_or <= R_or_temp;
    R_and <= R_and_temp;
    I_addi <= I_addi_temp;
    I_xori <= I_xori_temp;
    I_ori <= I_ori_temp;
    I_andi <= I_andi_temp;
    B_beq <= B_beq_temp;
    B_bne <= B_bne_temp;
    B_blt <= B_blt_temp;
    B_bge <= B_bge_temp;
    J_jal <= J_jal_temp;
    S_sw <= S_sw_temp;
    I_lw <= I_lw_temp;
    
    acknowledge_enable <= acknowledge_enable_temp;
    
    process(instruction)
    begin
        if (instruction(6 downto 0) = "0110011" or instruction(6 downto 0) = "1100011" or instruction(6 downto 0) = "0100011" or instruction(6 downto 0) = "0000011") then
            read_address_1 <= instruction(19 downto 15);
            read_address_2 <= instruction(24 downto 20);
        else
            read_address_1 <= instruction(19 downto 15);
            read_address_2 <= (others => '0');
        end if;
    end process;
                
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

end Behavioral;