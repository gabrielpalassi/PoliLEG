LIBRARY IEEE;
USE IEEE.numeric_bit.ALL;
USE IEEE.math_real.ceil;
USE IEEE.math_real.log2;

ENTITY datapath IS
    PORT (
        -- Common
        clock : IN BIT;
        reset : IN BIT;
        -- From Control Unit
        reg2loc : IN BIT;
        pcsrc : IN BIT;
        memToReg : IN BIT;
        aluCtrl : IN bit_vector(3 DOWNTO 0);
        aluSrc : IN BIT;
        regWrite : IN BIT;
        -- To Control Unit
        opcode : OUT bit_vector(10 DOWNTO 0);
        zero : OUT BIT;
        -- Im Interface
        imAddr : OUT bit_vector(63 DOWNTO 0);
        imOut : IN bit_vector(31 DOWNTO 0);
        -- DM interface
        dmAddr : OUT bit_vector(63 DOWNTO 0);
        dmIn : OUT bit_vector(63 DOWNTO 0);
        dmOut : IN bit_vector(63 DOWNTO 0)
    );
END ENTITY datapath;

ARCHITECTURE datapath_arc OF datapath IS
    -- Alu
    COMPONENT alu IS
        GENERIC (
            size : NATURAL := 64
        );
        PORT (
            A, B : IN bit_vector(size - 1 DOWNTO 0);
            F : OUT bit_vector(size - 1 DOWNTO 0);
            S : IN bit_vector(3 DOWNTO 0);
            Z, Ov, Co : OUT BIT
        );
    END COMPONENT alu;
    CONSTANT size : NATURAL := 64;
    SIGNAL A, B : bit_vector(size - 1 DOWNTO 0);
    SIGNAL F : bit_vector(size - 1 DOWNTO 0);
    SIGNAL S : bit_vector (3 DOWNTO 0);
    SIGNAL Z, Ov, Co : BIT;

    -- Register bank
    COMPONENT regfile IS
        GENERIC (
            reg_n : NATURAL := 10;
            word_s : NATURAL := 64
        );
        PORT (
            clock : IN BIT;
            reset : IN BIT;
            regWrite : IN BIT;
            rr1, rr2, wr : IN bit_vector(NATURAL(ceil(log2(real(reg_n)))) - 1 DOWNTO 0);
            d : IN bit_vector(word_s - 1 DOWNTO 0);
            q1, q2 : OUT bit_vector(word_s - 1 DOWNTO 0)
        );
    END COMPONENT regfile;
    CONSTANT reg_n : NATURAL := 32;
    CONSTANT word_s : NATURAL := 64;
    SIGNAL rr1, rr2, wr : bit_vector(NATURAL(ceil(log2(real(reg_n)))) - 1 DOWNTO 0);
    SIGNAL d : bit_vector(word_s - 1 DOWNTO 0);
    SIGNAL q1, q2 : bit_vector(word_s - 1 DOWNTO 0);

    -- Double shit left
    COMPONENT shiftleft2 IS
        GENERIC (
            ws : NATURAL := 64
        );
        PORT (
            i : IN bit_vector(ws - 1 DOWNTO 0);
            o : OUT bit_vector(ws - 1 DOWNTO 0)
        );
    END COMPONENT shiftleft2;
    CONSTANT ws : NATURAL := 64;
    SIGNAL i : bit_vector(ws - 1 DOWNTO 0);
    SIGNAL o : bit_vector(ws - 1 DOWNTO 0);

    -- Sign extend
    COMPONENT signextend IS
        PORT (
            i : IN bit_vector(31 DOWNTO 0);
            o : OUT bit_vector(63 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL i2 : bit_vector(31 DOWNTO 0);
    SIGNAL o2 : bit_vector(63 DOWNTO 0);

    -- Register (PC)
    COMPONENT reg IS
        GENERIC (
            word_s : NATURAL := 64
        );
        PORT (
            clock : IN BIT;
            reset : IN BIT;
            load : IN BIT;
            d : IN bit_vector(word_s - 1 DOWNTO 0);
            q : OUT bit_vector(word_s - 1 DOWNTO 0)
        );
    END COMPONENT reg;

    SIGNAL dPC : bit_vector(63 DOWNTO 0);
    SIGNAL qPC : bit_vector(63 DOWNTO 0);
    -- Add A + 4
    CONSTANT add4 : bit_vector (63 DOWNTO 0) := (2 => '1', OTHERS => '0');
    SIGNAL F_add4 : bit_vector(size - 1 DOWNTO 0);
    SIGNAL Z_add4, Ov_add4, Co_add4 : BIT;

    -- Add A + Double shift left
    SIGNAL F_shiftleft2 : bit_vector(size - 1 DOWNTO 0);
    SIGNAL Z_shiftleft2, Ov_shiftleft2, Co_shiftleft2 : BIT;
BEGIN
    alu_internal : COMPONENT alu GENERIC MAP(size) PORT MAP(A, B, F, S, Z, Ov, Co);
    regfile_internal : COMPONENT regfile GENERIC MAP(reg_n, word_s) PORT MAP(clock, reset, regWrite, rr1, rr2, wr, d, q1, q2);
    shiftleft2_internal : COMPONENT shiftleft2 GENERIC MAP(ws) PORT MAP(i, o);
    signextend_internal : COMPONENT signextend PORT MAP(i2, o2);

    rr1 <= imOut(9 DOWNTO 5);
    rr2 <= imOut(20 DOWNTO 16) WHEN reg2loc = '0' ELSE
        imOut(4 DOWNTO 0);
    wr <= imOut(4 DOWNTO 0);
    d <= dmOut WHEN memToReg = '1' ELSE
        f;
    i2 <= imOut;
    A <= q1;
    B <= q2 WHEN aluSrc = '0' ELSE
        o2;
    S <= aluCtrl;
    zero <= Z;
    dmAddr <= F;
    dmIn <= q2;
    opcode <= imOut(31 DOWNTO 21);
    i <= o2;

    PC_internal : COMPONENT reg GENERIC MAP(size) PORT MAP(clock, reset, '1', dPC, qPC);

    imAddr <= qPC;
    dPC <= F_add4 WHEN pcSrc = '0' ELSE
        F_shiftleft2;
        
    alu_internal_add4 : COMPONENT alu GENERIC MAP(size) PORT MAP(qPC, add4, F_add4, "0010", Z_add4, Ov_add4, Co_add4);
    minha_add_shift : COMPONENT alu GENERIC MAP(size) PORT MAP(qPC, o, F_shiftleft2, "0010", Z_shiftleft2, Ov_shiftleft2, Co_shiftleft2);
END ARCHITECTURE datapath_arc;