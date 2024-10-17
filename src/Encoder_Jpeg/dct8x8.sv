module dct8x8 (
  input                           i_clk,
  input                           i_rst_n,

  input    [63:0][7:0]            i_img_data, 
  input                           i_img_data_vaild,

  output signed reg [63:0][15:0]  o_dct_data,
  output reg                      o_dct_data_vaild
);
  
/******************************     将输入0-255偏置为-128~127     **********************************/
  logic signed [63:0][7:0]       img_data_d;
  logic img_data_vaild_r;
  integer i;
  always@(posedge i_clk)begin
    img_data_vaild_r <= i_img_data_vaild;
    for(i=0;i<=63;i=i+1)begin
      img_data_d <= img_data - 128;
    end
  end
  
  /******************************     DCT     **********************************/

  
  
endmodule
