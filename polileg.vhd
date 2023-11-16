LIBRARY IEEE;
USE IEEE.numeric_bit.ALL;

ENTITY polileg IS
    PORT (
        clock, reset : IN BIT;
        -- Data Memory
        dmem_addr : OUT bit_vector(63 DOWNTO 0);
        dmem_dati : OUT bit_vector(63 DOWNTO 0);
        dmem_dato : IN bit_vector(63 DOWNTO 0);
        dmem_we : OUT BIT;
        -- Instruction Memory
        imem_addr : OUT bit_vector(63 DOWNTO 0);
        imem_data : IN bit_vector(31 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE polileg_arc OF polileg IS
    COMPONENT controlunit IS
        PORT (
            --To Datapath
            reg2loc : OUT BIT;
            uncondBranch : OUT BIT;
            branch : OUT BIT;
            memRead : OUT BIT;
            memToReg : OUT BIT;
            aluOp : OUT bit_vector(1 DOWNTO 0);
            memWrite : OUT BIT;
            aluSrc : OUT BIT;
            regWrite : OUT BIT;
            --From Datapath
            opcode : IN bit_vector(10 DOWNTO 0)
        );
    END COMPONENT controlunit;
    COMPONENT alucontrol IS
        PORT (
            aluop : IN bit_vector(1 DOWNTO 0);
            opcode : IN bit_vector(10 DOWNTO 0);
            aluCtrl : OUT bit_vector(3 DOWNTO 0)
        );
    END COMPONENT alucontrol;
    COMPONENT datapath IS
        PORT (
            --Common
            clock : IN BIT;
            reset : IN BIT;
            --From Control Unit
            reg2loc : IN BIT;
            pcsrc : IN BIT;
            memToReg : IN BIT;
            aluCtrl : IN bit_vector(3 DOWNTO 0);
            aluSrc : IN BIT;
            regWrite : IN BIT;
            --To Control Unit:
            opcode : OUT bit_vector(10 DOWNTO 0);
            zero : OUT BIT;
            --Instruction Memory Interface
            imAddr : OUT bit_vector(63 DOWNTO 0);
            imOut : IN bit_vector(31 DOWNTO 0);
            --Data Memory Interface
            dmAddr : OUT bit_vector(63 DOWNTO 0);
            dmIn : OUT bit_vector(63 DOWNTO 0);
            dmOut : IN bit_vector(63 DOWNTO 0)
        );
    END COMPONENT datapath;

    SIGNAL reg2loc_signal : BIT;
    SIGNAL uncondBranch_signal : BIT;
    SIGNAL branch_signal : BIT;
    SIGNAL memToReg_signal : BIT;
    SIGNAL aluOp_signal : bit_vector(1 DOWNTO 0);
    SIGNAL aluSrc_signal : BIT;
    SIGNAL regWrite_signal : BIT;
    SIGNAL opcode_signal : bit_vector(10 DOWNTO 0);
    SIGNAL aluCtrl_signal : bit_vector(3 DOWNTO 0);
    SIGNAL pcsrc_signal : BIT;
    SIGNAL zero_signal : BIT;
BEGIN
    controlunit_internal : COMPONENT controlunit
        PORT MAP(
            reg2loc => reg2loc_signal,
            uncondBranch => uncondBranch_signal,
            branch => branch_signal,
            memRead => OPEN,
            memToReg => memToReg_signal,
            aluOp => aluOp_signal,
            memWrite => dmem_we,
            aluSrc => aluSrc_signal,
            regWrite => regWrite_signal,
            opcode => opcode_signal
        );
        datapath_internal : COMPONENT datapath
            PORT MAP(
                clock => clock,
                reset => reset,
                --From Control Unit
                reg2loc => reg2loc_signal,
                pcsrc => pcsrc_signal,
                memToReg => memToReg_signal,
                aluCtrl => aluCtrl_signal,
                aluSrc => aluSrc_signal,
                regWrite => regWrite_signal,
                --To Control Unit:
                opcode => opcode_signal,
                zero => zero_signal,
                --Instruction Memory Interface
                imAddr => imem_addr,
                imOut => imem_data,
                --Data Memory Interface
                dmAddr => dmem_addr,
                dmIn => dmem_dati,
                dmOut => dmem_dato
            );
            pcsrc_signal <= (uncondBranch_signal OR (branch_signal AND zero_signal));
            alucontrol_internal : COMPONENT alucontrol
                PORT MAP(
                    aluop => aluOp_signal,
                    opcode => opcode_signal,
                    aluCtrl => aluCtrl_signal
                );
            END ARCHITECTURE polileg_arc;