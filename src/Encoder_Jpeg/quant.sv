module quant#(
  parameter     CBCR_Y_SEL     = 2'd0 // 0: Y 1: CB 2:CR
)(
  input                         i_clk,
  input                         i_rst_n,

  input signed [63:0][15:0]     i_dct_data,
  input                         i_dct_data_vaild,

  output reg signed [63:0][15:0] o_quant_data,
  output reg                     o_quant_data_vaild
);

  //亮度 色度量化表选择
  localparam logic[15:0] TABLE_Y [64] = 
  {16,11,10,16,24,40,51,61,12,12,14,19,26,58,60,55,
   14,13,16,24,40,57,69,56,14,17,22,29,51,87,80,62,
   18,22,37,56,68,109,103,77,24,35,55,64,81,104,113,92,
  49,64,78,87,103,121,120,101,72,92,95,98,112,100,103,99};
  
  localparam logic[15:0] TABLE_CBCR [64] = 
  {17,18,24,47,99,99,99,99,18,21,26,66,99,99,99,99,
  24,26,56,99,99,99,99,99,47,66,99,99,99,99,99,99,
  99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,
  99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,};
  
  localparam logic[15:0] TABLE_NOW[64] = CBCR_Y ? TABLE_CBCR : TABLE_Y;

  integer   i;
  always@(posedge i_clk)begin
    if(!i_rst_n)begin
      o_quant_data_vaild     <= 'd0;
    end else begin
      for(i = 0 ; i <= 63 ; i++)
        o_quant_data[i] <= i_dct_data[i] / TABLE_CBCR[i];
      o_quant_data_vaild   <= i_dct_data_vaild;
    end
  end
endmodule
