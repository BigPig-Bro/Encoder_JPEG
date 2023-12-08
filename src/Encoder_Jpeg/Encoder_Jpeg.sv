module Encoder_Jpeg#(
    parameter   H_ACTIVE        = 720, //编码图像宽度
    parameter   V_ACTIVE        = 480 //编码图像高度
)(
    input           rst_n,
    input           start,

    input           rgb_clk,
    input           rgb_de,
    input [23:0]    rgb_data,

    output          send_data_vaild,send_data_last,
    output [7:0]    send_data
);

//////////////////// 			 RGB 转 YCBCR	            /////////////////////////////
rgb2ycbcr rgb2ycbcr_m0(
    .clk                    (rgb_clk                    ),
    .rst_n                  (rst_n                      ),

    .rgb_de                 (rgb_de                     ),
    .rgb_data               (rgb_data                   ),
    .ycbcr_de               (ycbcr_de                   ),
    .ycbcr_y                (ycbcr_y                    ),
    .ycbcr_cb               (ycbcr_cb                   ),
    .ycbcr_cr               (ycbcr_cr                   )
);

//////////////////// 			 乒乓RAM 行缓存(YCBCR)	      /////////////////////////////
line_ycbcr_buffer line_ycbcr_buffer_m0(
    .clk                    (rgb_clk                    ),
    .rst_n                  (rst_n                      ),

    .ycbcr_de               (ycbcr_de                   ),
    .ycbcr_y                (ycbcr_y                    ),
    .ycbcr_cb               (ycbcr_cb                   ),
    .ycbcr_cr               (ycbcr_cr                   ),

);

//////////////////// 			8x8 DCT变换	             /////////////////////////////
dct8x8 dct8x8_m0(
    .clk                    (rgb_clk                    ),
    .rst_n                  (rst_n                      ),

);

//////////////////// 			 量化	              /////////////////////////////
quant quant_m0(
    .clk                    (rgb_clk                    ),
    .rst_n                  (rst_n                      ),

);


//////////////////// 			 ZigZag	              /////////////////////////////
scan_z scan_z_m0(
    .clk                    (rgb_clk                    ),
    .rst_n                  (rst_n                      ),

);

//////////////////// 			 熵编码（霍夫曼	       /////////////////////////////
entropy_huffman entropy_huffman_m0(
    .clk                    (rgb_clk                    ),
    .rst_n                  (rst_n                      ),

);


endmodule