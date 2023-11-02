LIBRARY IEEE;
USE IEEE.numeric_bit.ALL;

ENTITY reg IS
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
END reg;

ARCHITECTURE reg_arc OF reg IS
    SIGNAL d_internal : bit_vector(word_s - 1 DOWNTO 0);
BEGIN
    PROCESS (clock, reset, load)
    BEGIN
        IF (reset = '1') THEN
            d_internal <= (OTHERS => '0');
        ELSIF (rising_edge(clock) AND load = '1') THEN
            d_internal <= d;
        END IF;
    END PROCESS;
    q <= d_internal;
END ARCHITECTURE reg_arc;