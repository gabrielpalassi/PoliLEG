LIBRARY IEEE;
USE IEEE.numeric_bit.ALL;

ENTITY alu_1bit IS
    PORT (
        a, b, less, cin : IN BIT;
        result, cout, set, overflow : OUT BIT;
        ainvert, binvert : IN BIT;
        operation : IN bit_vector(1 DOWNTO 0)
    );
END ENTITY alu_1bit;

ARCHITECTURE alu_1bit_arc OF alu_1bit IS
    COMPONENT fulladder IS
        PORT (
            a, b, cin : IN BIT;
            s, cout : OUT BIT
        );
    END COMPONENT fulladder;

    SIGNAL sum : BIT;
    SIGNAL a_internal : BIT;
    SIGNAL b_internal : BIT;
    SIGNAL s_to_mux : BIT;
    SIGNAL and_internal : BIT;
    SIGNAL cout_internal : BIT;
    SIGNAL or_internal : BIT;
BEGIN
    ADDER : fulladder PORT MAP(a => a_internal, b => b_internal, cin => cin, s => s_to_mux, cout => cout_internal);
    a_internal <= a WHEN (ainvert = '0') ELSE
        NOT(a);
    b_internal <= b WHEN (binvert = '0') ELSE
        NOT(b);
    and_internal <= a_internal AND b_internal;
    or_internal <= a_internal OR b_internal;
    set <= s_to_mux;
    cout <= cout_internal;
    result <= s_to_mux WHEN (operation = "10") ELSE
        and_internal WHEN (operation = "00") ELSE
        or_internal WHEN (operation = "01") ELSE
        less WHEN (operation = "11");
    overflow <= cin XOR cout_internal;
END ARCHITECTURE alu_1bit_arc;