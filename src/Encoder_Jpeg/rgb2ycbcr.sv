
module  rgb2ycbcr(
	input                       clk,rst_n,
	input[7:0]                  rgb_r,
	input[7:0]                  rgb_g,
	input[7:0]                  rgb_b,
	input                       rgb_de,
	output[7:0]                 ycbcr_y,
	output[7:0]                 ycbcr_cb,
	output[7:0]                 ycbcr_cr,
	output reg                  ycbcr_de
);

//multiply 256
parameter para_0257_10b = 10'd65;
parameter para_0564_10b = 10'd144;
parameter para_0098_10b = 10'd25; 
parameter para_0148_10b = 10'd38; 
parameter para_0291_10b = 10'd74; 
parameter para_0439_10b = 10'd112; 
parameter para_0368_10b = 10'd94; 
parameter para_0071_10b = 10'd18; 
parameter para_16_18b   = 18'd4096;
parameter para_128_18b  = 18'd32768;

wire                           sign_cb;
wire                           sign_cr;
reg[17:0]                      mult_r_for_y_18b;
reg[17:0]                      mult_r_for_cb_18b;
reg[17:0]                      mult_r_for_cr_18b;
reg[17:0]                      mult_g_for_y_18b;
reg[17:0]                      mult_g_for_cb_18b;
reg[17:0]                      mult_g_for_cr_18b;
reg[17:0]                      mult_b_for_y_18b;
reg[17:0]                      mult_b_for_cb_18b;
reg[17:0]                      mult_b_for_cr_18b;
reg[17:0]                      add_y_0_18b;
reg[17:0]                      add_cb_0_18b;
reg[17:0]                      add_cr_0_18b;
reg[17:0]                      add_y_1_18b;
reg[17:0]                      add_cb_1_18b;
reg[17:0]                      add_cr_1_18b;
reg[17:0]                      result_y_18b;
reg[17:0]                      result_cb_18b;
reg[17:0]                      result_cr_18b;
reg[9:0]                       y_tmp;
reg[9:0]                       cb_tmp;
reg[9:0]                       cr_tmp;
reg                            i_h_sync_delay_1;
reg                            i_v_sync_delay_1;
reg                            i_data_en_delay_1;
reg                            i_h_sync_delay_2;
reg                            i_v_sync_delay_2;
reg                            i_data_en_delay_2;
reg                            i_h_sync_delay_3;
reg                            i_v_sync_delay_3;
reg                            i_data_en_delay_3;
reg                            i_h_sync_delay_4;
reg                            i_v_sync_delay_4;
reg                            i_data_en_delay_4;
//LV1 pipeline : mult
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		mult_r_for_y_18b <= 18'd0;
		mult_r_for_cb_18b <= 18'd0;
		mult_r_for_cr_18b <= 18'd0;
	end
	else
	begin
		mult_r_for_y_18b <= rgb_r * para_0257_10b;
		mult_r_for_cb_18b <= rgb_r * para_0148_10b;
		mult_r_for_cr_18b <= rgb_r * para_0439_10b;
	end
end

always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		mult_g_for_y_18b <= 18'd0;
		mult_g_for_cb_18b <= 18'd0;
		mult_g_for_cr_18b <= 18'd0;
	end
	else
	begin
		mult_g_for_y_18b <= rgb_g * para_0564_10b;
		mult_g_for_cb_18b <= rgb_g * para_0291_10b;
		mult_g_for_cr_18b <= rgb_g * para_0368_10b;
	end
end

always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		mult_b_for_y_18b <= 18'd0;
		mult_b_for_cb_18b <= 18'd0;
		mult_b_for_cr_18b <= 18'd0;
	end
	else
	begin
		mult_b_for_y_18b <= rgb_b * para_0098_10b;
		mult_b_for_cb_18b <= rgb_b * para_0439_10b;
		mult_b_for_cr_18b <= rgb_b * para_0071_10b;
	end
end
//LV2 pipeline : add
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		add_y_0_18b <= 18'd0;
		add_cb_0_18b <= 18'd0;
		add_cr_0_18b <= 18'd0;
		add_y_1_18b <= 18'd0;
		add_cb_1_18b <= 18'd0;
		add_cr_1_18b <= 18'd0;
	end
	else
	begin
		add_y_0_18b <= mult_r_for_y_18b + mult_g_for_y_18b;
		add_y_1_18b <= mult_b_for_y_18b + para_16_18b;
		add_cb_0_18b <= mult_b_for_cb_18b + para_128_18b;
		add_cb_1_18b <= mult_r_for_cb_18b + mult_g_for_cb_18b;
		add_cr_0_18b <= mult_r_for_cr_18b + para_128_18b;
		add_cr_1_18b <= mult_g_for_cr_18b + mult_b_for_cr_18b;
	end
end
//LV3 pipeline : y + cb + cr

assign  sign_cb = (add_cb_0_18b >= add_cb_1_18b);
assign  sign_cr = (add_cr_0_18b >= add_cr_1_18b);
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		result_y_18b <= 18'd0;
		result_cb_18b <= 18'd0;
		result_cr_18b <= 18'd0;
	end
	else
	begin
		result_y_18b <= add_y_0_18b + add_y_1_18b;
		result_cb_18b <= sign_cb ? (add_cb_0_18b - add_cb_1_18b) : 18'd0;
		result_cr_18b <= sign_cr ? (add_cr_0_18b - add_cr_1_18b) : 18'd0;
	end
end

always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		y_tmp <= 10'd0;
		cb_tmp <= 10'd0;
		cr_tmp <= 10'd0;
	end
	else
	begin
		y_tmp <= result_y_18b[17:8] + {9'd0,result_y_18b[7]};
		cb_tmp <= result_cb_18b[17:8] + {9'd0,result_cb_18b[7]};
		cr_tmp <= result_cr_18b[17:8] + {9'd0,result_cr_18b[7]};
	end
end

//output
assign  ycbcr_y      = ( y_tmp[9:8] == 2'b00) ?  y_tmp[7 : 0] : 8'hFF;
assign  ycbcr_cb     = (cb_tmp[9:8] == 2'b00) ? cb_tmp[7 : 0] : 8'hFF;
assign  ycbcr_cr     = (cr_tmp[9:8] == 2'b00) ? cr_tmp[7 : 0] : 8'hFF;

always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	begin
		i_data_en_delay_1 <= 1'b0;
		i_data_en_delay_2 <= 1'b0;
		i_data_en_delay_3 <= 1'b0;
		i_data_en_delay_4 <= 1'b0;
		ycbcr_de <= 1'b0;
	end
	else
	begin
		i_data_en_delay_1 <= rgb_de;
		i_data_en_delay_2 <= i_data_en_delay_1;
		i_data_en_delay_3 <= i_data_en_delay_2;
		i_data_en_delay_4 <= i_data_en_delay_2;
		ycbcr_de <= i_data_en_delay_4;
	end
	
end
/********************************************************************************************/
endmodule