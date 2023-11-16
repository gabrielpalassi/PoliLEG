LIBRARY IEEE;
USE IEEE.numeric_bit.ALL;
USE std.textio.ALL;

ENTITY rom IS
    GENERIC (
        addr_s : NATURAL := 64; -- Size in bits
        word_s : NATURAL := 32; -- Width in bits
        init_f : STRING := "rom.dat"
    );
    PORT (
        addr : IN bit_vector(addr_s - 1 DOWNTO 0);
        data : OUT bit_vector(word_s - 1 DOWNTO 0)
    );
END rom;

ARCHITECTURE rom_arc OF rom IS
    TYPE mem_type IS ARRAY (0 TO (2 ** addr_s - 1)) OF bit_vector(word_s - 1 DOWNTO 0);
    IMPURE FUNCTION rom_init RETURN mem_type IS
        FILE archive : text OPEN read_mode IS init_f;
        VARIABLE line_read : line;
        VARIABLE rom_data : mem_type;
    BEGIN
        FOR i IN 0 TO (2 ** addr_s - 1) LOOP
            readline(archive, line_read);
            read(line_read, rom_data(i));
        END LOOP;
        RETURN rom_data;
    END;
    SIGNAL rom : mem_type := rom_init;
BEGIN
    data <= rom(to_integer(unsigned(addr)));
END ARCHITECTURE rom_arc;