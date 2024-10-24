module roundKey (
    input  logic [127:0] key_in,     // Entrada de 128 bits (4 columnas de 32 bits cada una)
    input  logic [3:0]   round,      // Número de ronda para seleccionar el valor de Rcon
    output logic [127:0] key_out     // Salida de 128 bits (nueva clave)
);

    logic [31:0] col1, col2, col3, col4;         // Columnas de la llave de entrada
    logic [31:0] temp_col, temp_col_subBytes;    // Columna temporal para operaciones intermedias
    logic [31:0] new_col1, new_col2, new_col3, new_col4;  // Columnas de la nueva llave
    logic [7:0]  subByte_val [3:0];              // Valores de subBytes para cada fila de la columna
    logic [7:0]  rcon_val;                       // Valor de Rcon para la primera fila de la columna

    // Dividir la entrada en 4 columnas de 32 bits
    assign col1 = key_in[127:96];
    assign col2 = key_in[95:64];
    assign col3 = key_in[63:32];
    assign col4 = key_in[31:0];

    // Paso 1: Rotar la última columna
    rotWord rot_inst (
        .word_in(col4),
        .word_out(temp_col)
    );

    // Paso 2: Aplicar subBytes a cada fila de la columna rotada
    sbox_rom_comb sbox_inst0 (.address(temp_col[31:24]), .q(subByte_val[0]));
    sbox_rom_comb sbox_inst1 (.address(temp_col[23:16]), .q(subByte_val[1]));
    sbox_rom_comb sbox_inst2 (.address(temp_col[15:8]),  .q(subByte_val[2]));
    sbox_rom_comb sbox_inst3 (.address(temp_col[7:0]),   .q(subByte_val[3]));

    // Columna con subBytes aplicado
    assign temp_col_subBytes = {subByte_val[0], subByte_val[1], subByte_val[2], subByte_val[3]};

    // Paso 3: Obtener el valor de Rcon para la ronda actual
    Rcon rcon_inst (
        .index(round),
        .rcon_val(rcon_val)
    );

    // Paso 4: Aplicar addRoundKey entre la primera columna y temp_col_subBytes + Rcon
    addRoundKey_gar #(32) add_round_key_inst0 (
        .in1(col1),
        .in2({rcon_val, 24'b0} ^ temp_col_subBytes),  // Sumar Rcon solo a la primera fila
        .out(new_col1)
    );

    // Paso 5: Calcular la nueva segunda columna
    addRoundKey_gar #(32) add_round_key_inst1 (
        .in1(col2),
        .in2(new_col1),
        .out(new_col2)
    );

    // Paso 6: Calcular la nueva tercera columna
    addRoundKey_gar #(32) add_round_key_inst2 (
        .in1(col3),
        .in2(new_col2),
        .out(new_col3)
    );

    // Paso 7: Calcular la nueva cuarta columna
    addRoundKey_gar #(32) add_round_key_inst3 (
        .in1(col4),
        .in2(new_col3),
        .out(new_col4)
    );

    // Combinar las nuevas columnas para formar la nueva llave
    assign key_out = {new_col1, new_col2, new_col3, new_col4};

endmodule