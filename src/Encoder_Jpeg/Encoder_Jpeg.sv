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
wire ycbcr_de;
wire [2:0][7:0] ycbcr_data;
rgb2ycbcr rgb2ycbcr_m0(
    .clk                    (rgb_clk                    ),
    .rst_n                  (rst_n                      ),

    .rgb_de                 (rgb_de                     ),
    .rgb_r                  (rgb_data[23:16]            ),
    .rgb_g                  (rgb_data[15: 8]            ),
    .rgb_b                  (rgb_data[ 7: 0]            ),
    .ycbcr_de               (ycbcr_de                   ),
	.ycbcr_y                (ycbcr_data[0]              ),
	.ycbcr_cb               (ycbcr_data[1]              ),
	.ycbcr_cr               (ycbcr_data[2]              )
);
    
/******************************     Y CB CR三通道并行处理     **********************************/
// //////////////////// 			 乒乓RAM 行缓存(YCBCR)	      /////////////////////////////
logic	[63:0][7:0] 	img_data; //8X8算子输出
logic 					img_data_vaild;
line_ycbcr_buffer line_ycbcr_buffer_m0(
    .clk                    (rgb_clk                    ),
    .rst_n                  (rst_n                      ),
 
    .ycbcr_de               (ycbcr_de                   ),
	.ycbcr_data             (ycbcr_data[0]              ),
 	
	.o_img_data 			(img_data					),
	.o_img_data_vaild 		(img_data_vaild 			)
);
 
// //////////////////// 			8x8 DCT变换	             /////////////////////////////
logic	[63:0][7:0] 	dct_data; //8X8算子输出
logic 					dct_data_vaild;
	dct8x8 dct8x8_m0(
    .clk                    (rgb_clk                    ),
    .rst_n                  (rst_n                      ),
 
	.i_img_data 			(img_data 					),
    .i_img_data_vaild 		(img_data_vaild 			)  

	.o_dct_data 			(dct_data					),
	.o_ dct _data_vaild 	(dct_data_vaild 			)
);

// //////////////////// 			 量化	              /////////////////////////////
// quant quant_m0(
//     .clk                    (rgb_clk                    ),
//     .rst_n                  (rst_n                      ),

// );


// //////////////////// 			 ZigZag	              /////////////////////////////
// scan_z scan_z_m0(
//     .clk                    (rgb_clk                    ),
//     .rst_n                  (rst_n                      ),

// );

// //////////////////// 			 熵编码（霍夫曼	       /////////////////////////////
// entropy_huffman entropy_huffman_m0(
//     .clk                    (rgb_clk                    ),
//     .rst_n                  (rst_n                      ),

// );

/******************************     Y CB CR三通道合并输出     **********************************/
    
endmodule
