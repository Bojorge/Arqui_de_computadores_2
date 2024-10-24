module inverseSubBytes (
    input  [7:0] byte_in, 
    output reg [7:0] byte_out 
);

    // la S-Box inversa como una memoria de 8x16
    reg [7:0] invSBox [0:15][0:15];

    // Inicializamos la S-Box inversa
    initial begin
        invSBox[0][0] = 8'h52; invSBox[0][1] = 8'h09; invSBox[0][2] = 8'h6a; invSBox[0][3] = 8'hd5; invSBox[0][4] = 8'h30; invSBox[0][5] = 8'h36; invSBox[0][6] = 8'ha5; invSBox[0][7] = 8'h38; 
        invSBox[0][8] = 8'hbf; invSBox[0][9] = 8'h40; invSBox[0][10] = 8'ha3; invSBox[0][11] = 8'h9e; invSBox[0][12] = 8'h81; invSBox[0][13] = 8'hf3; invSBox[0][14] = 8'hd7; invSBox[0][15] = 8'hfb;

        invSBox[1][0] = 8'h7c; invSBox[1][1] = 8'he3; invSBox[1][2] = 8'h39; invSBox[1][3] = 8'h82; invSBox[1][4] = 8'h9b; invSBox[1][5] = 8'h2f; invSBox[1][6] = 8'hff; invSBox[1][7] = 8'h87;
        invSBox[1][8] = 8'h34; invSBox[1][9] = 8'h8e; invSBox[1][10] = 8'h43; invSBox[1][11] = 8'h44; invSBox[1][12] = 8'hc4; invSBox[1][13] = 8'hde; invSBox[1][14] = 8'he9; invSBox[1][15] = 8'hcb;

        invSBox[2][0] = 8'h54; invSBox[2][1] = 8'h7b; invSBox[2][2] = 8'h94; invSBox[2][3] = 8'h32; invSBox[2][4] = 8'ha6; invSBox[2][5] = 8'hc2; invSBox[2][6] = 8'h23; invSBox[2][7] = 8'h3d;
        invSBox[2][8] = 8'hee; invSBox[2][9] = 8'h4c; invSBox[2][10] = 8'h95; invSBox[2][11] = 8'h0b; invSBox[2][12] = 8'h42; invSBox[2][13] = 8'hfa; invSBox[2][14] = 8'hc3; invSBox[2][15] = 8'h4e;

        invSBox[3][0] = 8'h08; invSBox[3][1] = 8'hf6; invSBox[3][2] = 8'h67; invSBox[3][3] = 8'h2b; invSBox[3][4] = 8'h9e; invSBox[3][5] = 8'h54; invSBox[3][6] = 8'hb7; invSBox[3][7] = 8'h4d;
        invSBox[3][8] = 8'h1d; invSBox[3][9] = 8'h0c; invSBox[3][10] = 8'h9f; invSBox[3][11] = 8'h1e; invSBox[3][12] = 8'h87; invSBox[3][13] = 8'he9; invSBox[3][14] = 8'hce; invSBox[3][15] = 8'h55;

        invSBox[4][0] = 8'h28; invSBox[4][1] = 8'hdf; invSBox[4][2] = 8'h8c; invSBox[4][3] = 8'ha1; invSBox[4][4] = 8'h89; invSBox[4][5] = 8'h0d; invSBox[4][6] = 8'hbf; invSBox[4][7] = 8'hb6;
        invSBox[4][8] = 8'hc6; invSBox[4][9] = 8'hc5; invSBox[4][10] = 8'h47; invSBox[4][11] = 8'hf0; invSBox[4][12] = 8'hf1; invSBox[4][13] = 8'h71; invSBox[4][14] = 8'h7a; invSBox[4][15] = 8'hcb;

        invSBox[5][0] = 8'hd9; invSBox[5][1] = 8'h28; invSBox[5][2] = 8'hb5; invSBox[5][3] = 8'h88; invSBox[5][4] = 8'h3c; invSBox[5][5] = 8'h0e; invSBox[5][6] = 8'h3e; invSBox[5][7] = 8'h61;
        invSBox[5][8] = 8'h91; invSBox[5][9] = 8'hc8; invSBox[5][10] = 8'h0f; invSBox[5][11] = 8'hf5; invSBox[5][12] = 8'h9a; invSBox[5][13] = 8'hf5; invSBox[5][14] = 8'h61; invSBox[5][15] = 8'h1d;

        invSBox[6][0] = 8'h63; invSBox[6][1] = 8'h36; invSBox[6][2] = 8'h7c; invSBox[6][3] = 8'h5e; invSBox[6][4] = 8'h77; invSBox[6][5] = 8'h1a; invSBox[6][6] = 8'hba; invSBox[6][7] = 8'h29;
        invSBox[6][8] = 8'hb3; invSBox[6][9] = 8'h8c; invSBox[6][10] = 8'hf8; invSBox[6][11] = 8'h13; invSBox[6][12] = 8'h54; invSBox[6][13] = 8'h1b; invSBox[6][14] = 8'h6c; invSBox[6][15] = 8'hf4;

        invSBox[7][0] = 8'h63; invSBox[7][1] = 8'h39; invSBox[7][2] = 8'h22; invSBox[7][3] = 8'h3e; invSBox[7][4] = 8'h59; invSBox[7][5] = 8'h60; invSBox[7][6] = 8'hb5; invSBox[7][7] = 8'hb7;
        invSBox[7][8] = 8'h3d; invSBox[7][9] = 8'h9c; invSBox[7][10] = 8'hdd; invSBox[7][11] = 8'h04; invSBox[7][12] = 8'h2f; invSBox[7][13] = 8'h66; invSBox[7][14] = 8'h0e; invSBox[7][15] = 8'h57;

        invSBox[8][0] = 8'h00; invSBox[8][1] = 8'h25; invSBox[8][2] = 8'h78; invSBox[8][3] = 8'h70; invSBox[8][4] = 8'hb9; invSBox[8][5] = 8'h5c; invSBox[8][6] = 8'h49; invSBox[8][7] = 8'h4e;
        invSBox[8][8] = 8'h74; invSBox[8][9] = 8'h7e; invSBox[8][10] = 8'hb6; invSBox[8][11] = 8'hde; invSBox[8][12] = 8'h0d; invSBox[8][13] = 8'h28; invSBox[8][14] = 8'h26; invSBox[8][15] = 8'h79;

        invSBox[9][0] = 8'hb4; invSBox[9][1] = 8'h02; invSBox[9][2] = 8'h34; invSBox[9][3] = 8'hf6; invSBox[9][4] = 8'h9f; invSBox[9][5] = 8'hc7; invSBox[9][6] = 8'hd3; invSBox[9][7] = 8'hf7;
        invSBox[9][8] = 8'h7e; invSBox[9][9] = 8'h0f; invSBox[9][10] = 8'hc0; invSBox[9][11] = 8'hbc; invSBox[9][12] = 8'h2b; invSBox[9][13] = 8'h48; invSBox[9][14] = 8'h60; invSBox[9][15] = 8'h41;

        invSBox[10][0] = 8'h67; invSBox[10][1] = 8'h6b; invSBox[10][2] = 8'hb3; invSBox[10][3] = 8'h3f; invSBox[10][4] = 8'hc3; invSBox[10][5] = 8'h09; invSBox[10][6] = 8'h76; invSBox[10][7] = 8'h57;
        invSBox[10][8] = 8'h16; invSBox[10][9] = 8'hd4; invSBox[10][10] = 8'h8e; invSBox[10][11] = 8'hc9; invSBox[10][12] = 8'h9e; invSBox[10][13] = 8'h6b; invSBox[10][14] = 8'h79; invSBox[10][15] = 8'h64;

        invSBox[11][0] = 8'h2a; invSBox[11][1] = 8'h7d; invSBox[11][2] = 8'hf5; invSBox[11][3] = 8'h8e; invSBox[11][4] = 8'h27; invSBox[11][5] = 8'h98; invSBox[11][6] = 8'hc8; invSBox[11][7] = 8'hb6;
        invSBox[11][8] = 8'h89; invSBox[11][9] = 8'h6d; invSBox[11][10] = 8'hd8; invSBox[11][11] = 8'h6e; invSBox[11][12] = 8'h44; invSBox[11][13] = 8'h4d; invSBox[11][14] = 8'h53; invSBox[11][15] = 8'hf8;

        invSBox[12][0] = 8'h33; invSBox[12][1] = 8'hf2; invSBox[12][2] = 8'h18; invSBox[12][3] = 8'hf0; invSBox[12][4] = 8'h4c; invSBox[12][5] = 8'h70; invSBox[12][6] = 8'h96; invSBox[12][7] = 8'h9c;
        invSBox[12][8] = 8'hc7; invSBox[12][9] = 8'h31; invSBox[12][10] = 8'h66; invSBox[12][11] = 8'h1a; invSBox[12][12] = 8'h27; invSBox[12][13] = 8'h47; invSBox[12][14] = 8'h79; invSBox[12][15] = 8'h88;

        invSBox[13][0] = 8'h26; invSBox[13][1] = 8'h78; invSBox[13][2] = 8'h69; invSBox[13][3] = 8'hb1; invSBox[13][4] = 8'h11; invSBox[13][5] = 8'hd5; invSBox[13][6] = 8'h63; invSBox[13][7] = 8'h62;
        invSBox[13][8] = 8'h6e; invSBox[13][9] = 8'hfd; invSBox[13][10] = 8'h05; invSBox[13][11] = 8'h3e; invSBox[13][12] = 8'h16; invSBox[13][13] = 8'h3f; invSBox[13][14] = 8'h25; invSBox[13][15] = 8'hd2;

        invSBox[14][0] = 8'hb7; invSBox[14][1] = 8'h8a; invSBox[14][2] = 8'hf2; invSBox[14][3] = 8'h8e; invSBox[14][4] = 8'h1d; invSBox[14][5] = 8'h0f; invSBox[14][6] = 8'hb6; invSBox[14][7] = 8'h65;
        invSBox[14][8] = 8'h88; invSBox[14][9] = 8'h9d; invSBox[14][10] = 8'h93; invSBox[14][11] = 8'h07; invSBox[14][12] = 8'h83; invSBox[14][13] = 8'h84; invSBox[14][14] = 8'h1e; invSBox[14][15] = 8'hd6;

        invSBox[15][0] = 8'hc9; invSBox[15][1] = 8'h2e; invSBox[15][2] = 8'hb9; invSBox[15][3] = 8'h8c; invSBox[15][4] = 8'h73; invSBox[15][5] = 8'h1f; invSBox[15][6] = 8'h59; invSBox[15][7] = 8'h96;
        invSBox[15][8] = 8'h44; invSBox[15][9] = 8'hb8; invSBox[15][10] = 8'hbe; invSBox[15][11] = 8'h68; invSBox[15][12] = 8'h49; invSBox[15][13] = 8'h26; invSBox[15][14] = 8'h30; invSBox[15][15] = 8'h7e;
    end

    // Lógica para buscar en la S-Box inversa
    always @* begin
        byte_out = invSBox[byte_in[7:4]][byte_in[3:0]];
    end
endmodule
