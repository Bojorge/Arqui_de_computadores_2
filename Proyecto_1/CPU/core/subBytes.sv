module subBytes (
    input  [7:0] byte_in,  // Entrada de 8 bits
    output reg [7:0] byte_out  // Salida de 8 bits
);

    // la S-Box como una memoria de 8x16
    reg [7:0] SBox [0:15][0:15];

    // Inicializamos la S-Box
    initial begin
        SBox[0][0] = 8'h63; SBox[0][1] = 8'h7c; SBox[0][2] = 8'h77; SBox[0][3] = 8'h7b; SBox[0][4] = 8'hf2; SBox[0][5] = 8'h6b; SBox[0][6] = 8'h6f; SBox[0][7] = 8'hc5; 
        SBox[0][8] = 8'h30; SBox[0][9] = 8'h01; SBox[0][10] = 8'h67; SBox[0][11] = 8'h2b; SBox[0][12] = 8'hfe; SBox[0][13] = 8'hd7; SBox[0][14] = 8'hab; SBox[0][15] = 8'h76;
        
        SBox[1][0] = 8'hca; SBox[1][1] = 8'h82; SBox[1][2] = 8'hc9; SBox[1][3] = 8'h7d; SBox[1][4] = 8'hfa; SBox[1][5] = 8'h59; SBox[1][6] = 8'h47; SBox[1][7] = 8'hf0;
        SBox[1][8] = 8'had; SBox[1][9] = 8'hd4; SBox[1][10] = 8'ha2; SBox[1][11] = 8'haf; SBox[1][12] = 8'h9c; SBox[1][13] = 8'ha4; SBox[1][14] = 8'h72; SBox[1][15] = 8'hc0;

        SBox[2][0] = 8'hb7; SBox[2][1] = 8'hfd; SBox[2][2] = 8'h93; SBox[2][3] = 8'h26; SBox[2][4] = 8'h36; SBox[2][5] = 8'h3f; SBox[2][6] = 8'hf7; SBox[2][7] = 8'hcc;
        SBox[2][8] = 8'h34; SBox[2][9] = 8'ha5; SBox[2][10] = 8'he5; SBox[2][11] = 8'hf1; SBox[2][12] = 8'h71; SBox[2][13] = 8'hd8; SBox[2][14] = 8'h31; SBox[2][15] = 8'h15;

        SBox[3][0] = 8'h04; SBox[3][1] = 8'hc7; SBox[3][2] = 8'h23; SBox[3][3] = 8'hc3; SBox[3][4] = 8'h18; SBox[3][5] = 8'h96; SBox[3][6] = 8'h05; SBox[3][7] = 8'h9a;
        SBox[3][8] = 8'h07; SBox[3][9] = 8'h12; SBox[3][10] = 8'h80; SBox[3][11] = 8'he2; SBox[3][12] = 8'heb; SBox[3][13] = 8'h27; SBox[3][14] = 8'hb2; SBox[3][15] = 8'h75;

        SBox[4][0] = 8'h09; SBox[4][1] = 8'h83; SBox[4][2] = 8'h2c; SBox[4][3] = 8'h1a; SBox[4][4] = 8'h1b; SBox[4][5] = 8'h6e; SBox[4][6] = 8'h5a; SBox[4][7] = 8'ha0;
        SBox[4][8] = 8'h52; SBox[4][9] = 8'h3b; SBox[4][10] = 8'hd6; SBox[4][11] = 8'hb3; SBox[4][12] = 8'h29; SBox[4][13] = 8'he3; SBox[4][14] = 8'h2f; SBox[4][15] = 8'h84;

        SBox[5][0] = 8'h53; SBox[5][1] = 8'hd1; SBox[5][2] = 8'h00; SBox[5][3] = 8'hed; SBox[5][4] = 8'h20; SBox[5][5] = 8'hfc; SBox[5][6] = 8'hb1; SBox[5][7] = 8'h5b;
        SBox[5][8] = 8'h6a; SBox[5][9] = 8'hcb; SBox[5][10] = 8'hbe; SBox[5][11] = 8'h39; SBox[5][12] = 8'h4a; SBox[5][13] = 8'h4c; SBox[5][14] = 8'h58; SBox[5][15] = 8'hcf;

        SBox[6][0] = 8'hd0; SBox[6][1] = 8'hef; SBox[6][2] = 8'haa; SBox[6][3] = 8'hfb; SBox[6][4] = 8'h43; SBox[6][5] = 8'h4d; SBox[6][6] = 8'h33; SBox[6][7] = 8'h85;
        SBox[6][8] = 8'h45; SBox[6][9] = 8'hf9; SBox[6][10] = 8'h02; SBox[6][11] = 8'h7f; SBox[6][12] = 8'h50; SBox[6][13] = 8'h3c; SBox[6][14] = 8'h9f; SBox[6][15] = 8'ha8;

        SBox[7][0] = 8'h51; SBox[7][1] = 8'ha3; SBox[7][2] = 8'h40; SBox[7][3] = 8'h8f; SBox[7][4] = 8'h92; SBox[7][5] = 8'h9d; SBox[7][6] = 8'h38; SBox[7][7] = 8'hf5;
        SBox[7][8] = 8'hbc; SBox[7][9] = 8'hb6; SBox[7][10] = 8'hda; SBox[7][11] = 8'h21; SBox[7][12] = 8'h10; SBox[7][13] = 8'hff; SBox[7][14] = 8'hf3; SBox[7][15] = 8'hd2;

        SBox[8][0] = 8'hcd; SBox[8][1] = 8'h0c; SBox[8][2] = 8'h13; SBox[8][3] = 8'hec; SBox[8][4] = 8'h5f; SBox[8][5] = 8'h97; SBox[8][6] = 8'h44; SBox[8][7] = 8'h17;
        SBox[8][8] = 8'hc4; SBox[8][9] = 8'ha7; SBox[8][10] = 8'h7e; SBox[8][11] = 8'h3d; SBox[8][12] = 8'h64; SBox[8][13] = 8'h5d; SBox[8][14] = 8'h19; SBox[8][15] = 8'h73;

        SBox[9][0] = 8'h60; SBox[9][1] = 8'h81; SBox[9][2] = 8'h4f; SBox[9][3] = 8'hdc; SBox[9][4] = 8'h22; SBox[9][5] = 8'h2a; SBox[9][6] = 8'h90; SBox[9][7] = 8'h88;
        SBox[9][8] = 8'h46; SBox[9][9] = 8'hee; SBox[9][10] = 8'hb8; SBox[9][11] = 8'h14; SBox[9][12] = 8'hde; SBox[9][13] = 8'h5e; SBox[9][14] = 8'h0b; SBox[9][15] = 8'hdb;

        SBox[10][0] = 8'he0; SBox[10][1] = 8'h32; SBox[10][2] = 8'h3a; SBox[10][3] = 8'h0a; SBox[10][4] = 8'h49; SBox[10][5] = 8'h06; SBox[10][6] = 8'h24; SBox[10][7] = 8'h5c;
        SBox[10][8] = 8'hc2; SBox[10][9] = 8'hd3; SBox[10][10] = 8'hac; SBox[10][11] = 8'h62; SBox[10][12] = 8'h91; SBox[10][13] = 8'h95; SBox[10][14] = 8'he4; SBox[10][15] = 8'h79;

        SBox[11][0] = 8'he7; SBox[11][1] = 8'hc8; SBox[11][2] = 8'h37; SBox[11][3] = 8'h6d; SBox[11][4] = 8'h8d; SBox[11][5] = 8'hd5; SBox[11][6] = 8'h4e; SBox[11][7] = 8'ha9;
        SBox[11][8] = 8'h6c; SBox[11][9] = 8'h56; SBox[11][10] = 8'hf4; SBox[11][11] = 8'hea; SBox[11][12] = 8'h65; SBox[11][13] = 8'h7a; SBox[11][14] = 8'hae; SBox[11][15] = 8'h08;

        SBox[12][0] = 8'hba; SBox[12][1] = 8'h78; SBox[12][2] = 8'h25; SBox[12][3] = 8'h2e; SBox[12][4] = 8'h1c; SBox[12][5] = 8'ha6; SBox[12][6] = 8'hb4; SBox[12][7] = 8'hc6;
        SBox[12][8] = 8'he8; SBox[12][9] = 8'hdd; SBox[12][10] = 8'h74; SBox[12][11] = 8'h1f; SBox[12][12] = 8'h4b; SBox[12][13] = 8'hbd; SBox[12][14] = 8'h8b; SBox[12][15] = 8'h8a;

        SBox[13][0] = 8'h70; SBox[13][1] = 8'h3e; SBox[13][2] = 8'hb5; SBox[13][3] = 8'h66; SBox[13][4] = 8'h48; SBox[13][5] = 8'h03; SBox[13][6] = 8'hf6; SBox[13][7] = 8'h0e;
        SBox[13][8] = 8'h61; SBox[13][9] = 8'h35; SBox[13][10] = 8'h57; SBox[13][11] = 8'hb9; SBox[13][12] = 8'h86; SBox[13][13] = 8'hc1; SBox[13][14] = 8'h1d; SBox[13][15] = 8'h9e;

        SBox[14][0] = 8'he1; SBox[14][1] = 8'hf8; SBox[14][2] = 8'h98; SBox[14][3] = 8'h11; SBox[14][4] = 8'h69; SBox[14][5] = 8'hd9; SBox[14][6] = 8'h8e; SBox[14][7] = 8'h94;
        SBox[14][8] = 8'h9b; SBox[14][9] = 8'h1e; SBox[14][10] = 8'h87; SBox[14][11] = 8'he9; SBox[14][12] = 8'hce; SBox[14][13] = 8'h55; SBox[14][14] = 8'h28; SBox[14][15] = 8'hdf;

        SBox[15][0] = 8'h8c; SBox[15][1] = 8'ha1; SBox[15][2] = 8'h89; SBox[15][3] = 8'h0d; SBox[15][4] = 8'hbf; SBox[15][5] = 8'he6; SBox[15][6] = 8'h42; SBox[15][7] = 8'h68;
        SBox[15][8] = 8'h41; SBox[15][9] = 8'h99; SBox[15][10] = 8'h2d; SBox[15][11] = 8'h0f; SBox[15][12] = 8'hb0; SBox[15][13] = 8'h54; SBox[15][14] = 8'hbb; SBox[15][15] = 8'h16;
    end

    // Lógica de búsqueda en la S-Box
    always @(*) begin
        // Fila: 4 bits más significativos (MSB), Columna: 4 bits menos significativos (LSB)
        byte_out = SBox[byte_in[7:4]][byte_in[3:0]];
    end

endmodule


