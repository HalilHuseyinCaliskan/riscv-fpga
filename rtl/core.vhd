library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity core is
    Port(
        clk : in std_logic;
        core_out : out std_logic_vector(9 downto 0)
    );
end core;

architecture Behavioral of core is

    component program_counter is
        Port(
            clk                     : in std_logic;
            request_enable          : in std_logic;
            branch_enable           : in std_logic;
            branch_imm              : in std_logic_vector(12 downto 0);
            current_program_count   : out std_logic_vector(11 downto 0);
            acknowledge_enable      : out std_logic
        );
    end component;
    
    component instruction_memory is
        Port(
            clk : in std_logic;
            request_enable : in std_logic;
            address_in : in std_logic_vector(11 downto 0);
            instruction_out : out std_logic_vector(31 downto 0);
            acknowledge_enable : out std_logic
        );
    end component;
    
    component instruction_register is
        Port(
            clk : in std_logic;
            request_enable : in std_logic;
            instruction_in : in std_logic_vector(31 downto 0);
            instruction_out : out std_logic_vector(31 downto 0);
            acknowledge_enable : out std_logic
        );
    end component;
    
    component control_unit is
        Port(
            clk : in std_logic;
            acknowledge_enable_pc : in std_logic;
            acknowledge_enable_im : in std_logic;   
            acknowledge_enable_ir : in std_logic;   
            acknowledge_enable_id : in std_logic;
            acknowledge_enable_e : in std_logic;
            memory_write_enable : in std_logic;
            memory_read_enable : in std_logic;
            acknowledge_enable_mw : in std_logic;
            request_enable_pc : out std_logic;
            request_enable_im : out std_logic;
            request_enable_ir : out std_logic;
            request_enable_id : out std_logic; 
            request_enable_e : out std_logic;
            write_enable : out std_logic     
        );
    end component;
    
    component instruction_decoder is
        Port(
            clk : in std_logic;
            request_enable : in std_logic;
            instruction : in std_logic_vector(31 downto 0);
            read_address_1 : out std_logic_vector(4 downto 0);
            read_address_2 : out std_logic_vector(4 downto 0);
            R_add : out std_logic;
            R_sub : out std_logic;
            R_mul: out std_logic;
            R_xor : out std_logic;
            R_or : out std_logic;
            R_and : out std_logic;
            I_addi : out std_logic;  
            I_xori : out std_logic;
            I_ori : out std_logic;
            I_andi : out std_logic;
            B_beq : out  std_logic;
            B_bne : out  std_logic;
            B_blt : out  std_logic;
            B_bge : out  std_logic;
            J_jal : out  std_logic;
            S_sw : out std_logic; 
            I_lw : out std_logic;
            acknowledge_enable : out std_logic
        );
    end component;
    
    component register_file is
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
    end component;
    
    component ALU is
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
    end component;
    
    component data_ram is
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
    end component;

    signal request_enable_pc_temp : std_logic;
    signal request_enable_im_temp : std_logic;
    signal request_enable_ir_temp : std_logic;
    signal request_enable_id_temp : std_logic;
    signal request_enable_e_temp : std_logic;
    signal write_enable_temp : std_logic;
    
    signal acknowledge_enable_pc_temp : std_logic := '0';
    signal acknowledge_enable_im_temp : std_logic := '0';
    signal acknowledge_enable_ir_temp : std_logic := '0';
    signal acknowledge_enable_id_temp : std_logic := '0';
    signal acknowledge_enable_e_temp : std_logic := '0';
    
    signal current_program_count : std_logic_vector(11 downto 0);
    signal instruction_out_memory : std_logic_vector(31 downto 0);
    signal instruction_out_regsiter : std_logic_vector(31 downto 0);
    
    signal read_address_1_temp : std_logic_vector(4 downto 0);
    signal read_address_2_temp : std_logic_vector(4 downto 0);
    signal write_address_temp : std_logic_vector(4 downto 0);
    
    signal R_add_temp, R_sub_temp, R_mul_temp, R_xor_temp, R_or_temp, R_and_temp, I_addi_temp, I_xori_temp, I_ori_temp, I_andi_temp, B_beq_temp, B_bne_temp, B_blt_temp, B_bge_temp, J_jal_temp, S_sw_temp, I_lw_temp : std_logic;
    
    signal read_data_1_temp : std_logic_vector(31 downto 0);
    signal read_data_2_temp : std_logic_vector(31 downto 0);
    signal write_data_temp : std_logic_vector(31 downto 0);
    
    signal branch_enable_temp : std_logic := '0';
    signal branch_imm_temp : std_logic_vector(12 downto 0);
    
    signal write_address_memory_temp : std_logic_vector(7 downto 0);
    signal write_data_memory_temp : std_logic_vector(31 downto 0);
    signal memory_write_enable_temp : std_logic := '0';
    signal acknowledge_enable_mw_temp : std_logic := '0';
    
    signal read_address_memory_temp : std_logic_vector(7 downto 0) := (others => '0');
    signal read_data_memory_temp : std_logic_vector(31 downto 0) := (others => '0');
    signal memory_read_enable_temp : std_logic := '0';
    
    signal rd_address_temp : std_logic_vector(4 downto 0) := (others => '0');
    signal register_file_write_enable_temp : std_logic := '0';
    
begin

    BLOCK1: control_unit port map (
        clk => clk,
        acknowledge_enable_pc => acknowledge_enable_pc_temp,
        acknowledge_enable_im => acknowledge_enable_im_temp,
        acknowledge_enable_ir => acknowledge_enable_ir_temp,
        acknowledge_enable_id => acknowledge_enable_id_temp,
        acknowledge_enable_e => acknowledge_enable_e_temp,
        memory_write_enable => memory_write_enable_temp,
        memory_read_enable => memory_read_enable_temp,
        acknowledge_enable_mw => acknowledge_enable_mw_temp,
        request_enable_pc => request_enable_pc_temp,
        request_enable_im => request_enable_im_temp,
        request_enable_ir => request_enable_ir_temp,
        request_enable_id => request_enable_id_temp,
        request_enable_e => request_enable_e_temp,
        write_enable => write_enable_temp
    );

    BLOCK2: program_counter port map (
        clk => clk,
        request_enable => request_enable_pc_temp,
        branch_enable => branch_enable_temp,
        branch_imm => branch_imm_temp,
        current_program_count => current_program_count,
        acknowledge_enable => acknowledge_enable_pc_temp
    );
    
    BLOCK3: instruction_memory port map (
        clk => clk,
        request_enable => request_enable_im_temp,
        address_in => current_program_count,
        instruction_out => instruction_out_memory,
        acknowledge_enable => acknowledge_enable_im_temp
    );
    
    BLOCK4: instruction_register port map (
        clk => clk,
        request_enable => request_enable_ir_temp,
        instruction_in => instruction_out_memory,
        instruction_out => instruction_out_regsiter,
        acknowledge_enable => acknowledge_enable_ir_temp
    );
    
    BLOCK5: instruction_decoder port map (
        clk => clk,
        request_enable => request_enable_id_temp,
        instruction => instruction_out_regsiter,
        read_address_1 => read_address_1_temp,
        read_address_2 => read_address_2_temp,
        R_add => R_add_temp,
        R_sub => R_sub_temp,
        R_mul => R_mul_temp,
        R_xor => R_xor_temp,
        R_or => R_or_temp,
        R_and => R_and_temp,
        I_addi => I_addi_temp,
        I_xori => I_xori_temp,
        I_ori => I_ori_temp,
        I_andi => I_andi_temp,
        B_beq => B_beq_temp,
        B_bne => B_bne_temp,
        B_blt => B_blt_temp,
        B_bge => B_bge_temp,
        J_jal => J_jal_temp,
        S_sw => S_sw_temp,
        I_lw => I_lw_temp,
        acknowledge_enable => acknowledge_enable_id_temp
    );
    
    BLOCK6: register_file port map (
        clk => clk,
        request_enable => write_enable_temp,
        data_memory_data_in => read_data_memory_temp,
        rd_address => rd_address_temp,
        register_file_write_enable => register_file_write_enable_temp,
        write_address => write_address_temp,
        write_data => write_data_temp,
        read_address_1 => read_address_1_temp,
        read_address_2 => read_address_2_temp,
        read_data_1 => read_data_1_temp,
        read_data_2 => read_data_2_temp
    );
    
     BLOCK7: ALU port map (
        clk => clk,
        request_enable => request_enable_e_temp,
        data_1_in => read_data_1_temp,
        data_2_in => read_data_2_temp,
        instruction => instruction_out_regsiter,
        R_add => R_add_temp,
        R_sub => R_sub_temp,
        R_mul => R_mul_temp,
        R_xor => R_xor_temp,
        R_or => R_or_temp,
        R_and => R_and_temp,
        I_addi => I_addi_temp,
        I_xori => I_xori_temp,
        I_ori => I_ori_temp,
        I_andi => I_andi_temp,
        B_beq => B_beq_temp,
        B_bne => B_bne_temp,
        B_blt => B_blt_temp,
        B_bge => B_bge_temp,
        J_jal => J_jal_temp,
        S_sw => S_sw_temp,
        I_lw => I_lw_temp,
        write_address => write_address_temp,
        write_data => write_data_temp,
        branch_enable => branch_enable_temp,
        branch_imm => branch_imm_temp,
        write_address_memory => write_address_memory_temp,
        write_data_memory => write_data_memory_temp,
        memory_write_enable => memory_write_enable_temp,
        read_address_memory => read_address_memory_temp,
        memory_read_enable => memory_read_enable_temp,
        acknowledge_enable => acknowledge_enable_e_temp  
    );
   
   -- data_ram'den belirtilen adresten okumak için veri çıkışı var ama bu çıkış register file'a bağlı değil
   
    BLOCK8: data_ram port map (
        clk => clk,
        memory_read_enable =>  memory_read_enable_temp,
        we => memory_write_enable_temp,
        instruction => instruction_out_regsiter,
        waddr => write_address_memory_temp,
        raddr => read_address_memory_temp,
        wdata => write_data_memory_temp,
        rdata => read_data_memory_temp,
        rd_address => rd_address_temp,
        register_file_write_enable => register_file_write_enable_temp,
        acknowledge_enable => acknowledge_enable_mw_temp
    ); 
    
    core_out(0) <= request_enable_pc_temp;
    core_out(1) <= acknowledge_enable_pc_temp;
    core_out(2) <= request_enable_im_temp;
    core_out(3) <= acknowledge_enable_im_temp;
    core_out(4) <= request_enable_ir_temp;
    core_out(5) <= acknowledge_enable_ir_temp;
    core_out(6) <= request_enable_id_temp;
    core_out(7) <= acknowledge_enable_id_temp;
    core_out(8) <= request_enable_e_temp;
    core_out(9) <= acknowledge_enable_e_temp;

end Behavioral;