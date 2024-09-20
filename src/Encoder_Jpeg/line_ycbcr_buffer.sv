module line_ycbcr_buffer#(
	input 					i_clk,
	input 					i_rst_n,

	input 					i_ycbcr_de,
	input [7:0] 			i_ycbcr_data,

	output reg [63:0][ 7:0] o_img_data,
	output reg 				o_img_data_vaild
);

	logic [ 7:0] img_ram[4096 * 8]; //8行RAM
	logic [11:0] line_data_cnt,line_data_cnt_d; //单行最大4095个像素(_d读取延时缓冲）
	logic [ 2:0] line_cnt; //算子需要统计8行
	
/******************************     行结束判定     **********************************/
	logic		 de_r;
	logic 		 i_ycbcr_de_done = de_r & ~i_ycbcr_de;
	always@(posedge i_clk) de_r <= !i_rst_n ? 'd0 : i_ycbcr_de;
	
/******************************     RAM读写逻辑判定     **********************************/	
	always@(posedge i_clk)begin
		if(!i_rst_n)begin
			line_data_cnt 		<= 'd0;
			line_cnt			<= 'd0;
			o_img_data_vaild	<= 'd0;
		end else begin
			//写入数据
			img_ram[{line_cnt,line_data_cnt}]	<= i_ycbcr_de ? i_ycbcr_data : img_ram[ram_index];
			
			//计算行列读写数据
			line_data_cnt 		<= i_ycbcr_de ? line_data_cnt + 1 : 'd0;  // 0~H_ACTIVE(4095 max)
			line_cnt 			<= i_ycbcr_de_done ? line_cnt + 1 : line_cnt;  // 8行 自动循环
			line_data_cnt_d 	<= line_data_cnt;
			line_cnt_d 			<= line_cnt;
			
			o_img_data[0 * 8 + line_data_cnt_d] <= img_ram[{3'd0,line_data_cnt_d}];//第一行 左上0，向右+1，向下+8
			o_img_data[1 * 8 + line_data_cnt_d] <= img_ram[{3'd1,line_data_cnt_d}];
			o_img_data[2 * 8 + line_data_cnt_d] <= img_ram[{3'd2,line_data_cnt_d}];
			o_img_data[3 * 8 + line_data_cnt_d] <= img_ram[{3'd3,line_data_cnt_d}];
			o_img_data[4 * 8 + line_data_cnt_d] <= img_ram[{3'd4,line_data_cnt_d}];
			o_img_data[5 * 8 + line_data_cnt_d] <= img_ram[{3'd5,line_data_cnt_d}];
			o_img_data[6 * 8 + line_data_cnt_d] <= img_ram[{3'd6,line_data_cnt_d}];
			o_img_data[7 * 8 + line_data_cnt_d] <= img_ram[{3'd7,line_data_cnt_d}];
			o_img_data_vaild 					<= line_cnt_d == 3'd7 && line_data_cnt_d[2:0] == 3'd7;
		end
	end
endmodule
