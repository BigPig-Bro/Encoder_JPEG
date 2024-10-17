module zigzag_scan(
  input     i_clk ,
  input     i_rst_n,

  input [63:0][15:0]  i_quant_data,
  input               i_quant_data_vaild,

  output reg [63:0][15:0]  o_zig_data,
  output reg               o_zig_vaild,
);

  integer i;
  always@(posedge i_clk)
    if(!i_rst_n)begin
      o_zig_vaild <= 'd0;
      for(i=0;i<64;i++)begin
        o_zig_data[i] <= 'd0;
      end
    end else begin
      o_zig_vaild <= i_quant_data_vaild;

      o_zig_data[0] <= i_quant_data[0];
      o_zig_data[1] <= i_quant_data[1];
      o_zig_data[2] <= i_quant_data[8];
      o_zig_data[3] <= i_quant_data[16];
      o_zig_data[4] <= i_quant_data[9];
      o_zig_data[5] <= i_quant_data[2];
      o_zig_data[6] <= i_quant_data[3];
      o_zig_data[7] <= i_quant_data[10];
      o_zig_data[8] <= i_quant_data[17];
      o_zig_data[9] <= i_quant_data[24];
      o_zig_data[10] <= i_quant_data[32];
      o_zig_data[11] <= i_quant_data[25];
      o_zig_data[12] <= i_quant_data[18];
      o_zig_data[13] <= i_quant_data[11];
      o_zig_data[14] <= i_quant_data[4];
      o_zig_data[15] <= i_quant_data[5];
      o_zig_data[16] <= i_quant_data[12];
      o_zig_data[17] <= i_quant_data[19];
      o_zig_data[18] <= i_quant_data[26];
      o_zig_data[19] <= i_quant_data[33];
      o_zig_data[20] <= i_quant_data[40];
      o_zig_data[21] <= i_quant_data[48];
      o_zig_data[22] <= i_quant_data[41];
      o_zig_data[23] <= i_quant_data[34];
      o_zig_data[24] <= i_quant_data[27];
      o_zig_data[25] <= i_quant_data[20];
      o_zig_data[26] <= i_quant_data[13];
      o_zig_data[27] <= i_quant_data[6];
      o_zig_data[28] <= i_quant_data[7];
      o_zig_data[29] <= i_quant_data[14];
      o_zig_data[30] <= i_quant_data[21];
      o_zig_data[31] <= i_quant_data[28];
      o_zig_data[32] <= i_quant_data[35];
      o_zig_data[33] <= i_quant_data[42];
      o_zig_data[34] <= i_quant_data[49];
      o_zig_data[35] <= i_quant_data[56];
      o_zig_data[36] <= i_quant_data[57];
      o_zig_data[37] <= i_quant_data[50];
      o_zig_data[38] <= i_quant_data[43];
      o_zig_data[39] <= i_quant_data[36];
      o_zig_data[40] <= i_quant_data[29];
      o_zig_data[41] <= i_quant_data[22];
      o_zig_data[42] <= i_quant_data[15];
      o_zig_data[43] <= i_quant_data[23];
      o_zig_data[44] <= i_quant_data[30];
      o_zig_data[45] <= i_quant_data[37];
      o_zig_data[46] <= i_quant_data[44];
      o_zig_data[47] <= i_quant_data[51];
      o_zig_data[48] <= i_quant_data[58];
      o_zig_data[49] <= i_quant_data[59];
      o_zig_data[50] <= i_quant_data[52];
      o_zig_data[51] <= i_quant_data[45];
      o_zig_data[52] <= i_quant_data[38];
      o_zig_data[53] <= i_quant_data[31];
      o_zig_data[54] <= i_quant_data[39];
      o_zig_data[55] <= i_quant_data[46];
      o_zig_data[56] <= i_quant_data[53];
      o_zig_data[57] <= i_quant_data[60];
      o_zig_data[58] <= i_quant_data[61];
      o_zig_data[59] <= i_quant_data[54];
      o_zig_data[60] <= i_quant_data[47];
      o_zig_data[61] <= i_quant_data[55];
      o_zig_data[62] <= i_quant_data[62];
      o_zig_data[63] <= i_quant_data[63];
    end

endmodule
