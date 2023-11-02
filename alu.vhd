LIBRARY IEEE;
USE IEEE.numeric_bit.ALL;

ENTITY alu IS
    GENERIC (
        size : NATURAL := 64
    );
    PORT (
        A, B : IN bit_vector(size - 1 DOWNTO 0);
        F : OUT bit_vector(size - 1 DOWNTO 0);
        S : IN bit_vector(3 DOWNTO 0);
        Z : OUT BIT;
        Ov : OUT BIT;
        Co : OUT BIT
    );
END ENTITY alu;

ARCHITECTURE alu_arc OF alu IS
    COMPONENT alu_1bit IS
        PORT (
            a, b, less, cin : IN BIT;
            result, cout, set, overflow : OUT BIT;
            ainvert, binvert : IN BIT;
            operation : IN bit_vector(1 DOWNTO 0)
        );
    END COMPONENT alu_1bit;

    TYPE cables IS ARRAY (0 TO size - 1) OF BIT;
    SIGNAL co_cable : cables;
    SIGNAL zero_check : cables;
    SIGNAL ov_check : cables;
    SIGNAL check : bit_vector(size - 1 DOWNTO 0);
    SIGNAL zero_comp : bit_vector(size - 1 DOWNTO 0);
    SIGNAL subtraction : BIT;
BEGIN
    ALU_GEN : FOR i IN 0 TO size - 1 GENERATE
        LOWERBIT : IF i = 0 GENERATE
            ALU0 : alu_1bit PORT MAP(A(0), B(0), zero_check(size - 1), subtraction, check(0), co_cable(0), zero_check(0), ov_check(0), S(3), S(2), S(1 DOWNTO 0));
        END GENERATE LOWERBIT;
        MIDBITS : IF (i /= 0 AND i /= (size - 1)) GENERATE
            ALUX : alu_1bit PORT MAP(A(i), B(i), '0', co_cable(i - 1), check(i), co_cable(i), zero_check(i), ov_check(i), S(3), S(2), S(1 DOWNTO 0));
        END GENERATE MIDBITS;
        ENDBIT : IF (i /= 0 AND i = (size - 1)) GENERATE
            ALUF : alu_1bit PORT MAP(A(size - 1), B(size - 1), '0', co_cable(size - 2), check(size - 1), co_cable(size - 1), zero_check(size - 1), ov_check(size - 1), S(3), S(2), S(1 DOWNTO 0));
        END GENERATE ENDBIT;
    END GENERATE ALU_GEN;
    Ov <= ov_check(size - 1);
    Co <= co_cable(size - 1);
    F <= check;
    zero_comp <= (OTHERS => '0');
    Z <= '1' WHEN (check = zero_comp) ELSE
        '0';
    subtraction <= (S(2) AND S(1)) OR (S(3) AND S(2));
END ARCHITECTURE alu_arc;