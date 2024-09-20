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
  localparam TABLE_Y [64] = 
  {};
  localparam TABLE_CBCR [64] = 
  {};
  localparam TABLE_NOW[64] = CBCR_Y ? TABLE_CBCR : TABLE_Y;

  integer   i;
  always@(posedge i_clk)begin
    if(!i_rst_n)begin
      o_quant_data_vaild     <= 'd0;
    end else begin
      for(i = 0 ; i <= 63 ; 
      o_quant_data_vaild   <= i_dct_data_vaild;
    end

  end
endmodule
