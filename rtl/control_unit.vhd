library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_unit is
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
end control_unit;

architecture Behavioral of control_unit is

    type states is (PC, IM, IR, ID, E, MW, WB);
    signal current_state : states := PC;
    signal next_state : states;
    
    signal request_enable_pc_temp : std_logic;
    signal request_enable_im_temp : std_logic;
    signal request_enable_ir_temp : std_logic;
    signal request_enable_id_temp : std_logic;
    signal request_enable_e_temp : std_logic;
    signal write_enable_temp : std_logic;

begin

    process(clk)
    begin
        if (rising_edge(clk)) then
            current_state <= next_state;
        end if;
    end process;

    process(current_state, acknowledge_enable_pc, acknowledge_enable_im, acknowledge_enable_ir, acknowledge_enable_id, acknowledge_enable_e, memory_write_enable, acknowledge_enable_mw)
    begin
        
        request_enable_pc_temp <= '0';
        request_enable_im_temp <= '0';
        request_enable_ir_temp <= '0';
        request_enable_id_temp <= '0';
        request_enable_e_temp <= '0';
        write_enable_temp <= '0';
              
        case current_state is
            when PC =>
                if (acknowledge_enable_pc = '1') then 
                    next_state <= IM;
                else
                    request_enable_pc_temp <= '1'; 
                    next_state <= PC;
                end if;
                
            when IM =>
                if (acknowledge_enable_im = '1') then 
                    next_state <= IR;
                else
                    request_enable_im_temp <= '1'; 
                    next_state <= IM;
                end if;

            when IR =>
                if (acknowledge_enable_ir = '1') then 
                    next_state <= ID;
                else
                    request_enable_ir_temp <= '1'; 
                    next_state <= IR;
                end if;   
                
            when ID =>
                if (acknowledge_enable_id = '1') then 
                    next_state <= E;
                else
                    request_enable_id_temp <= '1'; 
                    next_state <= ID;
                end if;
                
            when E =>
                if (acknowledge_enable_e = '1' and memory_write_enable = '0' and memory_read_enable = '0') then 
                    next_state <= PC;
                elsif (acknowledge_enable_e = '1' and memory_write_enable = '1' and memory_read_enable = '0') then
                    next_state <= MW; 
                elsif (acknowledge_enable_e = '1' and memory_write_enable = '0' and memory_read_enable = '1') then
                    next_state <= WB;       
                else
                    request_enable_e_temp <= '1'; 
                    write_enable_temp <= '1';
                    next_state <= E;
                end if;
                
            when MW =>
                if (acknowledge_enable_mw = '1') then 
                    next_state <= PC;
                else
                    next_state <= MW;
                end if;
                
            when WB =>  
                next_state <= PC;
                                                                             
        end case;       
    end process;
    
    request_enable_pc <= request_enable_pc_temp;
    request_enable_im <= request_enable_im_temp;
    request_enable_ir <= request_enable_ir_temp;
    request_enable_id <= request_enable_id_temp;
    request_enable_e <= request_enable_e_temp;
    write_enable <= write_enable_temp;
    
end Behavioral;