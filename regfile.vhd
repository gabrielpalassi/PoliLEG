LIBRARY IEEE;
USE IEEE.numeric_bit.ALL;
USE IEEE.math_real.ceil;
USE IEEE.math_real.log2;

ENTITY regfile IS
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
END ENTITY regfile;

ARCHITECTURE regfile_arc OF regfile IS
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

    TYPE reg_array IS ARRAY(0 TO reg_n - 1) OF bit_vector(word_s - 1 DOWNTO 0);
    SIGNAL out_data_signal : reg_array;
    SIGNAL data_signal : reg_array;

    TYPE write_array IS ARRAY(0 TO reg_n - 1) OF BIT;
    SIGNAL write_signal : write_array;
BEGIN
    REG_GEN : FOR i IN 0 TO reg_n - 2 GENERATE
        REGX : reg
        GENERIC MAP(word_s => word_s)
        PORT MAP(clock => clock, reset => reset, load => write_signal(i), d => data_signal(i), q => out_data_signal(i));
    END GENERATE REG_GEN;
    REG0 : reg
    GENERIC MAP(word_s => word_s)
    PORT MAP(clock => clock, reset => '1', load => write_signal(reg_n - 1), d => data_signal(reg_n - 1), q => out_data_signal(reg_n - 1));
    write_signal(to_integer(unsigned(wr))) <= regWrite;
    data_signal(to_integer(unsigned(wr))) <= d;
    q1 <= out_data_signal(to_integer(unsigned(rr1)));
    q2 <= out_data_signal(to_integer(unsigned(rr2)));
END ARCHITECTURE regfile_arc;