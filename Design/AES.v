// 
// Designer: <N26115011> 
//
module AES(
    input clk,
    input rst,
    input [127:0] P,
    input [127:0] K,
    output reg [127:0] C,
    output reg valid
    );

// write your design here //
parameter N = 10;
// Declare FSM
reg state;
reg next_state;
localparam WAIT = 0;
localparam RECEIVE_DATA = 1;

// Declare reg
reg [3:0] current, count;
reg [3:0] round [0:N];
reg [127:0] P_mem [0:N];
reg [127:0] K_mem [0:N];

// Declare wire
wire [3:0] output_round[0:N];
wire [127:0] output_key[0:N];
wire [127:0] out[0:N];

Round round0(.after_addroundkey(P_mem[0]), .input_key(K_mem[0]), .input_round(round[0]), .output_round(output_round[0]), .output_key(output_key[0]), .out(out[0]));
Round round1(.after_addroundkey(P_mem[1]), .input_key(K_mem[1]), .input_round(round[1]), .output_round(output_round[1]), .output_key(output_key[1]), .out(out[1]));
Round round2(.after_addroundkey(P_mem[2]), .input_key(K_mem[2]), .input_round(round[2]), .output_round(output_round[2]), .output_key(output_key[2]), .out(out[2]));
Round round3(.after_addroundkey(P_mem[3]), .input_key(K_mem[3]), .input_round(round[3]), .output_round(output_round[3]), .output_key(output_key[3]), .out(out[3]));
Round round4(.after_addroundkey(P_mem[4]), .input_key(K_mem[4]), .input_round(round[4]), .output_round(output_round[4]), .output_key(output_key[4]), .out(out[4]));
Round round5(.after_addroundkey(P_mem[5]), .input_key(K_mem[5]), .input_round(round[5]), .output_round(output_round[5]), .output_key(output_key[5]), .out(out[5]));
Round round6(.after_addroundkey(P_mem[6]), .input_key(K_mem[6]), .input_round(round[6]), .output_round(output_round[6]), .output_key(output_key[6]), .out(out[6]));
Round round7(.after_addroundkey(P_mem[7]), .input_key(K_mem[7]), .input_round(round[7]), .output_round(output_round[7]), .output_key(output_key[7]), .out(out[7]));
Round round8(.after_addroundkey(P_mem[8]), .input_key(K_mem[8]), .input_round(round[8]), .output_round(output_round[8]), .output_key(output_key[8]), .out(out[8]));
Round round9(.after_addroundkey(P_mem[9]), .input_key(K_mem[9]), .input_round(round[9]), .output_round(output_round[9]), .output_key(output_key[9]), .out(out[9]));
Round roundA(.after_addroundkey(P_mem[10]), .input_key(K_mem[10]), .input_round(round[10]), .output_round(output_round[10]), .output_key(output_key[10]), .out(out[10]));

integer i;
always @(posedge clk or posedge rst) begin
    if (rst) begin
        valid   <= 0;
        current <= 0;
        count   <= 0;
        for (i = 0; i < N+1; i = i + 1)begin
            round[i] <= 0;
            P_mem[i] <= 0;
            K_mem[i] <= 0;
        end
    end
    else begin
    case (state)
        WAIT:begin
            
        end

        RECEIVE_DATA:begin

            count <= (count < N) ? count + 1 : 0;
            for(i = 0; i < N + 1; i = i + 1)begin

                if (count != i)begin
                    K_mem[i] <= output_key[i];
                    P_mem[i] <= out[i];
                    round[i] <= output_round[i];
                end
                else begin
                    K_mem[count] <= K;
                    P_mem[count] <= P ^ K; //add_roundkey
                    round[count] <= 0;
                end
            end

            if (round[current] == N) begin
                valid <= 1;
                C <= P_mem[current];
                current <= (current < N) ? current + 1 : 0;
            end
            else begin
                valid <= 0;
            end
        end 
    endcase
    end
end

always @(posedge clk or posedge rst) begin
    if(rst)
        state <= WAIT;
    else
        state <= next_state;
end

always @(*) begin
    case(state)
        WAIT:begin
            next_state = RECEIVE_DATA;
        end
        RECEIVE_DATA:begin
            next_state = RECEIVE_DATA;
        end
    endcase
end

endmodule

module Round(after_addroundkey, input_key, input_round, output_round, output_key, out); 
input [127:0] after_addroundkey, input_key;
input [3:0] input_round;

output [3:0] output_round;
output [127:0] output_key, out;

wire [127:0] after_subbytes;
wire [127:0] after_shiftrows;
wire [127:0] after_mixcolumns;
wire [127:0] temp;

assign output_round = (input_round < 10) ? input_round + 1 : 0;
assign temp = (input_round == 9) ? after_shiftrows : after_mixcolumns; 

KeyExpansion my_keyexpansion(input_key, input_round, output_key);

SubBytes my_subbytes(after_addroundkey, after_subbytes);
ShiftRows my_shiftrows(after_subbytes, after_shiftrows);
MixColumns my_mixcolumns(after_shiftrows, after_mixcolumns);
AddRoundKey my_addroundkey(temp, output_key, out);

endmodule

module AddRoundKey(plain_text, key, out);
input [127:0] plain_text, key;
output [127:0] out;

assign out = plain_text ^ key;

endmodule

module SubBytes(in, out);
input [127:0] in;
output [127:0] out;

sbox my_sbox1(.in(in[7:0]), .out(out[7:0]));
sbox my_sbox2 (.in(in[15:8]), .out(out[15:8]));
sbox my_sbox3 (.in(in[23:16]), .out(out[23:16]));
sbox my_sbox4 (.in(in[31:24]), .out(out[31:24]));
sbox my_sbox5 (.in(in[39:32]), .out(out[39:32]));
sbox my_sbox6 (.in(in[47:40]), .out(out[47:40]));
sbox my_sbox7 (.in(in[55:48]), .out(out[55:48]));
sbox my_sbox8 (.in(in[63:56]), .out(out[63:56]));
sbox my_sbox9 (.in(in[71:64]), .out(out[71:64]));
sbox my_sbox10 (.in(in[79:72]), .out(out[79:72]));
sbox my_sbox11 (.in(in[87:80]), .out(out[87:80]));
sbox my_sbox12 (.in(in[95:88]), .out(out[95:88]));
sbox my_sbox13 (.in(in[103:96]), .out(out[103:96]));
sbox my_sbox14 (.in(in[111:104]), .out(out[111:104]));
sbox my_sbox15 (.in(in[119:112]), .out(out[119:112]));
sbox my_sbox16 (.in(in[127:120]), .out(out[127:120]));
    
endmodule

module ShiftRows(in, out);
input [127:0] in;
output [127:0] out;
    
// Shift first row
assign out[127:120] = in[127:120];
assign out[95:88]   = in[95:88];
assign out[63:56]   = in[63:56];
assign out[31:24]   = in[31:24];

// Shift second row 
assign out[119:112] = in[87:80];
assign out[87:80]   = in[55:48];
assign out[55:48]   = in[23:16];
assign out[23:16]   = in[119:112];

// Shift third row
assign out[111:104] = in[47:40];
assign out[79:72]   = in[15:8];
assign out[47:40]   = in[111:104];
assign out[15:8]    = in[79:72];

// Shift fourth row
assign out[103:96] = in[7:0];
assign out[71:64]  = in[103:96];
assign out[39:32]  = in[71:64];
assign out[7:0]    = in[39:32];
    
endmodule

module MutipleTwo(in, out);
input [7:0] in;
output [7:0] out;

assign out = (in << 1) ^ (in[7] == 1'b1 ? 8'h1b : 8'h00);

endmodule

module MutipleThree(in, out);
input [7:0] in;
output [7:0] out;

assign out = (in << 1) ^ (in[7] == 1'b1 ? 8'h1b : 8'h00) ^ in;

endmodule


/*
2   3   1   1
1   2   3   1
1   1   2   3
3   1   1   2
*/
module MixOneColumn(in, out);
input [31:0] in;
output [31:0] out;

wire [7:0] mut00_2, mut01_3, mut11_2, mut12_3, mut22_2, mut23_3, mut30_3, mut33_2;
MutipleTwo my_mutipletwo1(in[31:24], mut00_2);
MutipleTwo my_mutipletwo2(in[23:16], mut11_2);
MutipleTwo my_mutipletwo3(in[15:8],  mut22_2);
MutipleTwo my_mutipletwo4(in[7:0],   mut33_2);

MutipleThree my_mutiplethree1(in[23:16], mut01_3);
MutipleThree my_mutiplethree2(in[15:8],  mut12_3);
MutipleThree my_mutiplethree3(in[7:0],   mut23_3);
MutipleThree my_mutiplethree4(in[31:24], mut30_3);

assign out[31:24] = mut00_2   ^ mut01_3   ^ in[15:8] ^ in[7:0];
assign out[23:16] = in[31:24] ^ mut11_2   ^ mut12_3  ^ in[7:0];
assign out[15:8]  = in[31:24] ^ in[23:16] ^ mut22_2  ^ mut23_3;
assign out[7:0]   = mut30_3   ^ in[23:16] ^ in[15:8] ^ mut33_2;
    
endmodule

module MixColumns(in, out);
input [127:0] in;
output [127:0] out;

MixOneColumn my_mixonecolumn1(.in(in[31:0]),   .out(out[31:0]));
MixOneColumn my_mixonecolumn2(.in(in[63:32]),  .out(out[63:32]));
MixOneColumn my_mixonecolumn3(.in(in[95:64]),  .out(out[95:64]));
MixOneColumn my_mixonecolumn4(.in(in[127:96]), .out(out[127:96]));    

endmodule


module sbox(in, out);

input  [7:0] in; 
output reg [7:0] out;

always @(in)
    case (in)
        8'h00: out = 8'h63;
        8'h01: out = 8'h7c;
        8'h02: out = 8'h77;
        8'h03: out = 8'h7b;
        8'h04: out = 8'hf2;
        8'h05: out = 8'h6b;
        8'h06: out = 8'h6f;
        8'h07: out = 8'hc5;
        8'h08: out = 8'h30;
        8'h09: out = 8'h01;
        8'h0a: out = 8'h67;
        8'h0b: out = 8'h2b;
        8'h0c: out = 8'hfe;
        8'h0d: out = 8'hd7;
        8'h0e: out = 8'hab;
        8'h0f: out = 8'h76;
        8'h10: out = 8'hca;
        8'h11: out = 8'h82;
        8'h12: out = 8'hc9;
        8'h13: out = 8'h7d;
        8'h14: out = 8'hfa;
        8'h15: out = 8'h59;
        8'h16: out = 8'h47;
        8'h17: out = 8'hf0;
        8'h18: out = 8'had;
        8'h19: out = 8'hd4;
        8'h1a: out = 8'ha2;
        8'h1b: out = 8'haf;
        8'h1c: out = 8'h9c;
        8'h1d: out = 8'ha4;
        8'h1e: out = 8'h72;
        8'h1f: out = 8'hc0;
        8'h20: out = 8'hb7;
        8'h21: out = 8'hfd;
        8'h22: out = 8'h93;
        8'h23: out = 8'h26;
        8'h24: out = 8'h36;
        8'h25: out = 8'h3f;
        8'h26: out = 8'hf7;
        8'h27: out = 8'hcc;
        8'h28: out = 8'h34;
        8'h29: out = 8'ha5;
        8'h2a: out = 8'he5;
        8'h2b: out = 8'hf1;
        8'h2c: out = 8'h71;
        8'h2d: out = 8'hd8;
        8'h2e: out = 8'h31;
        8'h2f: out = 8'h15;
        8'h30: out = 8'h04;
        8'h31: out = 8'hc7;
        8'h32: out = 8'h23;
        8'h33: out = 8'hc3;
        8'h34: out = 8'h18;
        8'h35: out = 8'h96;
        8'h36: out = 8'h05;
        8'h37: out = 8'h9a;
        8'h38: out = 8'h07;
        8'h39: out = 8'h12;
        8'h3a: out = 8'h80;
        8'h3b: out = 8'he2;
        8'h3c: out = 8'heb;
        8'h3d: out = 8'h27;
        8'h3e: out = 8'hb2;
        8'h3f: out = 8'h75;
        8'h40: out = 8'h09;
        8'h41: out = 8'h83;
        8'h42: out = 8'h2c;
        8'h43: out = 8'h1a;
        8'h44: out = 8'h1b;
        8'h45: out = 8'h6e;
        8'h46: out = 8'h5a;
        8'h47: out = 8'ha0;
        8'h48: out = 8'h52;
        8'h49: out = 8'h3b;
        8'h4a: out = 8'hd6;
        8'h4b: out = 8'hb3;
        8'h4c: out = 8'h29;
        8'h4d: out = 8'he3;
        8'h4e: out = 8'h2f;
        8'h4f: out = 8'h84;
        8'h50: out = 8'h53;
        8'h51: out = 8'hd1;
        8'h52: out = 8'h00;
        8'h53: out = 8'hed;
        8'h54: out = 8'h20;
        8'h55: out = 8'hfc;
        8'h56: out = 8'hb1;
        8'h57: out = 8'h5b;
        8'h58: out = 8'h6a;
        8'h59: out = 8'hcb;
        8'h5a: out = 8'hbe;
        8'h5b: out = 8'h39;
        8'h5c: out = 8'h4a;
        8'h5d: out = 8'h4c;
        8'h5e: out = 8'h58;
        8'h5f: out = 8'hcf;
        8'h60: out = 8'hd0;
        8'h61: out = 8'hef;
        8'h62: out = 8'haa;
        8'h63: out = 8'hfb;
        8'h64: out = 8'h43;
        8'h65: out = 8'h4d;
        8'h66: out = 8'h33;
        8'h67: out = 8'h85;
        8'h68: out = 8'h45;
        8'h69: out = 8'hf9;
        8'h6a: out = 8'h02;
        8'h6b: out = 8'h7f;
        8'h6c: out = 8'h50;
        8'h6d: out = 8'h3c;
        8'h6e: out = 8'h9f;
        8'h6f: out = 8'ha8;
        8'h70: out = 8'h51;
        8'h71: out = 8'ha3;
        8'h72: out = 8'h40;
        8'h73: out = 8'h8f;
        8'h74: out = 8'h92;
        8'h75: out = 8'h9d;
        8'h76: out = 8'h38;
        8'h77: out = 8'hf5;
        8'h78: out = 8'hbc;
        8'h79: out = 8'hb6;
        8'h7a: out = 8'hda;
        8'h7b: out = 8'h21;
        8'h7c: out = 8'h10;
        8'h7d: out = 8'hff;
        8'h7e: out = 8'hf3;
        8'h7f: out = 8'hd2;
        8'h80: out = 8'hcd;
        8'h81: out = 8'h0c;
        8'h82: out = 8'h13;
        8'h83: out = 8'hec;
        8'h84: out = 8'h5f;
        8'h85: out = 8'h97;
        8'h86: out = 8'h44;
        8'h87: out = 8'h17;
        8'h88: out = 8'hc4;
        8'h89: out = 8'ha7;
        8'h8a: out = 8'h7e;
        8'h8b: out = 8'h3d;
        8'h8c: out = 8'h64;
        8'h8d: out = 8'h5d;
        8'h8e: out = 8'h19;
        8'h8f: out = 8'h73;
        8'h90: out = 8'h60;
        8'h91: out = 8'h81;
        8'h92: out = 8'h4f;
        8'h93: out = 8'hdc;
        8'h94: out = 8'h22;
        8'h95: out = 8'h2a;
        8'h96: out = 8'h90;
        8'h97: out = 8'h88;
        8'h98: out = 8'h46;
        8'h99: out = 8'hee;
        8'h9a: out = 8'hb8;
        8'h9b: out = 8'h14;
        8'h9c: out = 8'hde;
        8'h9d: out = 8'h5e;
        8'h9e: out = 8'h0b;
        8'h9f: out = 8'hdb;
        8'ha0: out = 8'he0;
        8'ha1: out = 8'h32;
        8'ha2: out = 8'h3a;
        8'ha3: out = 8'h0a;
        8'ha4: out = 8'h49;
        8'ha5: out = 8'h06;
        8'ha6: out = 8'h24;
        8'ha7: out = 8'h5c;
        8'ha8: out = 8'hc2;
        8'ha9: out = 8'hd3;
        8'haa: out = 8'hac;
        8'hab: out = 8'h62;
        8'hac: out = 8'h91;
        8'had: out = 8'h95;
        8'hae: out = 8'he4;
        8'haf: out = 8'h79;
        8'hb0: out = 8'he7;
        8'hb1: out = 8'hc8;
        8'hb2: out = 8'h37;
        8'hb3: out = 8'h6d;
        8'hb4: out = 8'h8d;
        8'hb5: out = 8'hd5;
        8'hb6: out = 8'h4e;
        8'hb7: out = 8'ha9;
        8'hb8: out = 8'h6c;
        8'hb9: out = 8'h56;
        8'hba: out = 8'hf4;
        8'hbb: out = 8'hea;
        8'hbc: out = 8'h65;
        8'hbd: out = 8'h7a;
        8'hbe: out = 8'hae;
        8'hbf: out = 8'h08;
        8'hc0: out = 8'hba;
        8'hc1: out = 8'h78;
        8'hc2: out = 8'h25;
        8'hc3: out = 8'h2e;
        8'hc4: out = 8'h1c;
        8'hc5: out = 8'ha6;
        8'hc6: out = 8'hb4;
        8'hc7: out = 8'hc6;
        8'hc8: out = 8'he8;
        8'hc9: out = 8'hdd;
        8'hca: out = 8'h74;
        8'hcb: out = 8'h1f;
        8'hcc: out = 8'h4b;
        8'hcd: out = 8'hbd;
        8'hce: out = 8'h8b;
        8'hcf: out = 8'h8a;
        8'hd0: out = 8'h70;
        8'hd1: out = 8'h3e;
        8'hd2: out = 8'hb5;
        8'hd3: out = 8'h66;
        8'hd4: out = 8'h48;
        8'hd5: out = 8'h03;
        8'hd6: out = 8'hf6;
        8'hd7: out = 8'h0e;
        8'hd8: out = 8'h61;
        8'hd9: out = 8'h35;
        8'hda: out = 8'h57;
        8'hdb: out = 8'hb9;
        8'hdc: out = 8'h86;
        8'hdd: out = 8'hc1;
        8'hde: out = 8'h1d;
        8'hdf: out = 8'h9e;
        8'he0: out = 8'he1;
        8'he1: out = 8'hf8;
        8'he2: out = 8'h98;
        8'he3: out = 8'h11;
        8'he4: out = 8'h69;
        8'he5: out = 8'hd9;
        8'he6: out = 8'h8e;
        8'he7: out = 8'h94;
        8'he8: out = 8'h9b;
        8'he9: out = 8'h1e;
        8'hea: out = 8'h87;
        8'heb: out = 8'he9;
        8'hec: out = 8'hce;
        8'hed: out = 8'h55;
        8'hee: out = 8'h28;
        8'hef: out = 8'hdf;
        8'hf0: out = 8'h8c;
        8'hf1: out = 8'ha1;
        8'hf2: out = 8'h89;
        8'hf3: out = 8'h0d;
        8'hf4: out = 8'hbf;
        8'hf5: out = 8'he6;
        8'hf6: out = 8'h42;
        8'hf7: out = 8'h68;
        8'hf8: out = 8'h41;
        8'hf9: out = 8'h99;
        8'hfa: out = 8'h2d;
        8'hfb: out = 8'h0f;
        8'hfc: out = 8'hb0;
        8'hfd: out = 8'h54;
        8'hfe: out = 8'hbb;
        8'hff: out = 8'h16;
endcase

endmodule

module RotWord(in, out);
input [31:0]in;
output [31:0]out;

assign out[7:0]   = in[31:24];
assign out[15:8]  = in[7:0];
assign out[23:16] = in[15:8];
assign out[31:24] = in[23:16];

endmodule

module SubWord(in, out);
input [31:0] in;
output [31:0] out;

sbox my_sbox1 (.in(in[7:0]), .out(out[7:0]));
sbox my_sbox2 (.in(in[15:8]), .out(out[15:8]));
sbox my_sbox3 (.in(in[23:16]), .out(out[23:16]));
sbox my_sbox4 (.in(in[31:24]), .out(out[31:24]));
    
endmodule

module Rcon(in, round, out);
input [31:0] in;
input [3:0] round;
output reg [31:0] out;

always @(in, round) begin    
    case (round)
        0: out = in ^ 32'h01000000;
        1: out = in ^ 32'h02000000;
        2: out = in ^ 32'h04000000;
        3: out = in ^ 32'h08000000;
        4: out = in ^ 32'h10000000;
        5: out = in ^ 32'h20000000;
        6: out = in ^ 32'h40000000;
        7: out = in ^ 32'h80000000;
        8: out = in ^ 32'h1b000000;
        9: out = in ^ 32'h36000000;
        default: out = in ^ 32'h00000000;
    endcase
end
endmodule

module KeyExpansion(in, round, out);
input [127:0] in;
input [3:0] round;
output [127:0] out;

wire [31:0] after_rotword;
wire [31:0] after_subword;
wire [31:0] after_rcon;

RotWord my_rotword(.in(in[31:0]), .out(after_rotword));
SubWord my_subword(.in(after_rotword), .out(after_subword));
Rcon my_rcon(.in(after_subword), .round(round), .out(after_rcon));

assign out[127:96] = in[127:96] ^ after_rcon; 
assign out[95:64]  = in[95:64]  ^ out[127:96];
assign out[63:32]  = in[63:32]  ^ out[95:64]; 
assign out[31:0]   = in[31:0]   ^ out[63:32]; 

endmodule
