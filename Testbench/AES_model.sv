class AES_model;
 
    function bit[7:0] sbox(bit[7:0] a);  
        static reg [7:0] sbox_array [0:255] = {
            8'h63, 8'h7c, 8'h77, 8'h7b, 8'hf2, 8'h6b, 8'h6f, 8'hc5, 8'h30, 8'h01, 8'h67, 8'h2b, 8'hfe, 8'hd7, 8'hab, 8'h76,
            8'hca, 8'h82, 8'hc9, 8'h7d, 8'hfa, 8'h59, 8'h47, 8'hf0, 8'had, 8'hd4, 8'ha2, 8'haf, 8'h9c, 8'ha4, 8'h72, 8'hc0,
            8'hb7, 8'hfd, 8'h93, 8'h26, 8'h36, 8'h3f, 8'hf7, 8'hcc, 8'h34, 8'ha5, 8'he5, 8'hf1, 8'h71, 8'hd8, 8'h31, 8'h15,
            8'h04, 8'hc7, 8'h23, 8'hc3, 8'h18, 8'h96, 8'h05, 8'h9a, 8'h07, 8'h12, 8'h80, 8'he2, 8'heb, 8'h27, 8'hb2, 8'h75,
            8'h09, 8'h83, 8'h2c, 8'h1a, 8'h1b, 8'h6e, 8'h5a, 8'ha0, 8'h52, 8'h3b, 8'hd6, 8'hb3, 8'h29, 8'he3, 8'h2f, 8'h84,
            8'h53, 8'hd1, 8'h00, 8'hed, 8'h20, 8'hfc, 8'hb1, 8'h5b, 8'h6a, 8'hcb, 8'hbe, 8'h39, 8'h4a, 8'h4c, 8'h58, 8'hcf,
            8'hd0, 8'hef, 8'haa, 8'hfb, 8'h43, 8'h4d, 8'h33, 8'h85, 8'h45, 8'hf9, 8'h02, 8'h7f, 8'h50, 8'h3c, 8'h9f, 8'ha8,
            8'h51, 8'ha3, 8'h40, 8'h8f, 8'h92, 8'h9d, 8'h38, 8'hf5, 8'hbc, 8'hb6, 8'hda, 8'h21, 8'h10, 8'hff, 8'hf3, 8'hd2,
            8'hcd, 8'h0c, 8'h13, 8'hec, 8'h5f, 8'h97, 8'h44, 8'h17, 8'hc4, 8'ha7, 8'h7e, 8'h3d, 8'h64, 8'h5d, 8'h19, 8'h73,
            8'h60, 8'h81, 8'h4f, 8'hdc, 8'h22, 8'h2a, 8'h90, 8'h88, 8'h46, 8'hee, 8'hb8, 8'h14, 8'hde, 8'h5e, 8'h0b, 8'hdb,
            8'he0, 8'h32, 8'h3a, 8'h0a, 8'h49, 8'h06, 8'h24, 8'h5c, 8'hc2, 8'hd3, 8'hac, 8'h62, 8'h91, 8'h95, 8'he4, 8'h79,
            8'he7, 8'hc8, 8'h37, 8'h6d, 8'h8d, 8'hd5, 8'h4e, 8'ha9, 8'h6c, 8'h56, 8'hf4, 8'hea, 8'h65, 8'h7a, 8'hae, 8'h08,
            8'hba, 8'h78, 8'h25, 8'h2e, 8'h1c, 8'ha6, 8'hb4, 8'hc6, 8'he8, 8'hdd, 8'h74, 8'h1f, 8'h4b, 8'hbd, 8'h8b, 8'h8a,
            8'h70, 8'h3e, 8'hb5, 8'h66, 8'h48, 8'h03, 8'hf6, 8'h0e, 8'h61, 8'h35, 8'h57, 8'hb9, 8'h86, 8'hc1, 8'h1d, 8'h9e,
            8'he1, 8'hf8, 8'h98, 8'h11, 8'h69, 8'hd9, 8'h8e, 8'h94, 8'h9b, 8'h1e, 8'h87, 8'he9, 8'hce, 8'h55, 8'h28, 8'hdf,
            8'h8c, 8'ha1, 8'h89, 8'h0d, 8'hbf, 8'he6, 8'h42, 8'h68, 8'h41, 8'h99, 8'h2d, 8'h0f, 8'hb0, 8'h54, 8'hbb, 8'h16
        };
        return sbox_array[a];
    endfunction

    function bit[127:0] subBytes(bit[127:0] input_data);
        bit[127:0] output_data;
        integer i;
        for (i = 0; i < 128 ; i = i + 8)begin
            output_data[i +: 8] = sbox(input_data[i +: 8 ]);
        end

        return output_data;
    endfunction

    function bit[127:0] shiftRows(bit[127:0] input_data);
        bit[127:0] output_data;
        // first row
        output_data[127 : 120] = input_data[127 : 120];
        output_data[95  : 88]  = input_data[95  : 88];
        output_data[63  : 56]  = input_data[63  : 56];
        output_data[31  : 24]  = input_data[31  : 24];

        // second row
        output_data[119 : 112] = input_data[87  : 80];
        output_data[87  : 80]  = input_data[55  : 48];
        output_data[55  : 48]  = input_data[23  : 16];
        output_data[23  : 16]  = input_data[119 : 112];

        // third row
        output_data[111 : 104] = input_data[47  : 40];
        output_data[79  : 72]  = input_data[15  : 8];
        output_data[47  : 40]  = input_data[111 : 104];
        output_data[15  :  8]  = input_data[79  : 72];
        
        // fourth row
        output_data[103 : 96] = input_data[7   : 0];
        output_data[71  : 64] = input_data[103 : 96];
        output_data[39  : 32] = input_data[71  : 64];
        output_data[7   : 0]  = input_data[39  : 32];
        return output_data;
        
    endfunction

    function bit[7:0] mutiple2(bit[7:0] input_data);
        bit [7:0] output_data;
        output_data = (input_data << 1) ^ (input_data[7] == 1'b1 ? 8'h1b : 8'h00);
        return output_data;
    endfunction

    function bit[7:0] mutiple3(bit[7:0] input_data);
        bit [7:0] output_data;
        output_data = (input_data << 1) ^ (input_data[7] == 1'b1 ? 8'h1b : 8'h00) ^ input_data;
        return output_data;
    endfunction

    function bit[31:0] mixColumn(bit[31:0] input_data);
        bit [31:0] output_data;
        bit [7:0] s0, s1, s2, s3;

        s0 = input_data[31:24];
        s1 = input_data[23:16];
        s2 = input_data[15:8];
        s3 = input_data[7:0];

        output_data[31:24] = mutiple2(s0) ^ mutiple3(s1) ^ s2           ^ s3;
        output_data[23:16] = s0           ^ mutiple2(s1) ^ mutiple3(s2) ^ s3;
        output_data[15:8]  = s0           ^ s1           ^ mutiple2(s2) ^ mutiple3(s3);
        output_data[7:0]   = mutiple3(s0) ^ s1           ^ s2           ^ mutiple2(s3);

        return output_data;
    endfunction

    function bit[127 :0] mixColumns(bit[127:0] input_data);
        bit[127:0] output_data;
        integer i;
        for (i = 0; i < 127; i = i + 32) begin
            output_data[i +: 32] = mixColumn(input_data[i +: 32]);
        end

        return output_data;
    endfunction

    function bit[31:0] rotWord(bit[31:0] input_data);
        bit[31:0] output_data;
        output_data[8 +: 24] = input_data[0 +: 24];
        output_data[0 +: 8] = input_data[24 +: 8];

        return output_data;
    endfunction

    function bit[31:0] subWord(bit[31:0] input_data);
        bit [31:0] output_data;
        output_data[0+:8]  = sbox(input_data[0+:8]);
        output_data[8+:8]  = sbox(input_data[8+:8]);
        output_data[16+:8] = sbox(input_data[16+:8]);
        output_data[24+:8] = sbox(input_data[24+:8]);

        return output_data;
    endfunction

    function bit[31:0] rcon(bit[31:0] input_data, bit[3:0] round);
        bit [31:0] output_data;
        case (round)
            4'h0 : output_data = input_data ^ 32'h01000000;
            4'h1 : output_data = input_data ^ 32'h02000000;
            4'h2 : output_data = input_data ^ 32'h04000000;
            4'h3 : output_data = input_data ^ 32'h08000000;
            4'h4 : output_data = input_data ^ 32'h10000000;
            4'h5 : output_data = input_data ^ 32'h20000000;
            4'h6 : output_data = input_data ^ 32'h40000000;
            4'h7 : output_data = input_data ^ 32'h80000000;
            4'h8 : output_data = input_data ^ 32'h1b000000;
            4'h9 : output_data = input_data ^ 32'h36000000;
            default: output_data = input_data ^ 32'h00000000;
        endcase

        return output_data;
    endfunction

    function bit[127:0] keyExpansion(bit[127:0] input_key, bit[3:0] round);
        bit [127:0] output_key;
        bit [31:0] w0,w1,w2,w3;

        w0 = input_key[127:96];
        w1 = input_key[95 :64];
        w2 = input_key[63 :32];
        w3 = input_key[31 :0];

        output_key[127:96] = w0 ^ rcon(subWord(rotWord(w3)), round);
        output_key[95 :64] = w1 ^ output_key[127:96];
        output_key[63 :32] = w2 ^ output_key[95 :64];
        output_key[31 :0]  = w3 ^ output_key[63 :32];

        return output_key;
    endfunction

    function bit[127:0] AES_128(bit[127:0] plain_text, bit[127:0] key);
        bit [127:0] ciphertext, new_key;
        ciphertext = plain_text ^ key; //addRoundKey
        for(int i = 0; i < 10; i = i + 1)begin
            key = keyExpansion(key, i);
            ciphertext = subBytes(ciphertext);
            ciphertext = shiftRows(ciphertext);
            if (i < 9) begin
                ciphertext = mixColumns(ciphertext);
            end
            ciphertext = ciphertext ^ key;
        end
        return ciphertext;
    endfunction
endclass

/*
module test;

    // Test the function
    bit [127 : 0] result;
    bit [127 : 0] plain_text = 128'h3243f6a8885a308d313198a2e0370734;
    bit [127 : 0] key        = 128'h2b7e151628aed2a6abf7158809cf4f3c;
    
    AES my_aes_class;

    initial begin
        my_aes_class = new();
        result =  my_aes_class.AES_128(plain_text, key);
        $display("result = %x", result);  
    end

endmodule
*/