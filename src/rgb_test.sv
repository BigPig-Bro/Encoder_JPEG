module rgb_test(
    input                       clk,
    input                       rst_n,

    input                       start,

    output                      rgb_clk,
    output                      rgb_de,
    output reg [23:0]           rgb_data
);

// 输出时钟 = 输入时钟
assign rgb_clk = clk;

// 生成行列计数器 
parameter  H_ACTIVE = 640;
parameter  V_ACTIVE = 480;
reg                     state = 0;
reg [10:0]              h_cnt, v_cnt;

always@(posedge rgb_clk)
    if(!rst_n)begin
        h_cnt <= 0;
        v_cnt <= 0;
        state <= 0;
    end else if(state) begin
        h_cnt <= h_cnt == H_ACTIVE + 10 ? 0 : h_cnt + 1;
        v_cnt <= h_cnt == H_ACTIVE + 10 ? v_cnt == V_ACTIVE ? 0 :  v_cnt + 1 : v_cnt;
        state <= h_cnt == H_ACTIVE + 10 & v_cnt == V_ACTIVE ? 0 : state;
    end
    else begin
        h_cnt <= 0;
        v_cnt <= 0;
        state <= start;
    end

always@(posedge rgb_clk)
    if(!rst_n)begin
        rgb_de <= 0;
    end else begin
        rgb_de <= h_cnt >= 1 && h_cnt <= H_ACTIVE  && v_cnt < V_ACTIVE;
        //生成横向彩条
        if (h_cnt >= 1 && h_cnt <= H_ACTIVE / 24 * 1 & v_cnt < V_ACTIVE ) 
            rgb_data <= 24'h000001;
        else if (h_cnt >= 1 && h_cnt <= H_ACTIVE / 24 * 2 & v_cnt < V_ACTIVE )
            rgb_data <= 24'h000002;
        else if (h_cnt >= 1 && h_cnt <= H_ACTIVE / 24 * 3 & v_cnt < V_ACTIVE )
            rgb_data <= 24'h000004;
        else if (h_cnt >= 1 && h_cnt <= H_ACTIVE / 24 * 4 & v_cnt < V_ACTIVE )
            rgb_data <= 24'h000008;
        else if (h_cnt >= 1 && h_cnt <= H_ACTIVE / 24 * 5 & v_cnt < V_ACTIVE )
            rgb_data <= 24'h000010;
        else if (h_cnt >= 1 && h_cnt <= H_ACTIVE / 24 * 6 & v_cnt < V_ACTIVE )
            rgb_data <= 24'h000020;
        else if (h_cnt >= 1 && h_cnt <= H_ACTIVE / 24 * 7 & v_cnt < V_ACTIVE )
            rgb_data <= 24'h000040;
        else if (h_cnt >= 1 && h_cnt <= H_ACTIVE / 24 * 8 & v_cnt < V_ACTIVE )
            rgb_data <= 24'h000080;
        else if (h_cnt >= 1 && h_cnt <= H_ACTIVE / 24 * 9 & v_cnt < V_ACTIVE )
            rgb_data <= 24'h000100;
        else if (h_cnt >= 1 && h_cnt <= H_ACTIVE / 24 * 10 & v_cnt < V_ACTIVE )
            rgb_data <= 24'h000200;
        else if (h_cnt >= 1 && h_cnt <= H_ACTIVE / 24 * 11 & v_cnt < V_ACTIVE )
            rgb_data <= 24'h000400;
        else if (h_cnt >= 1 && h_cnt <= H_ACTIVE / 24 * 12 & v_cnt < V_ACTIVE )
            rgb_data <= 24'h000800;
        else if (h_cnt >= 1 && h_cnt <= H_ACTIVE / 24 * 13 & v_cnt < V_ACTIVE )
            rgb_data <= 24'h001000;
        else if (h_cnt >= 1 && h_cnt <= H_ACTIVE / 24 * 14 & v_cnt < V_ACTIVE )
            rgb_data <= 24'h002000;
        else if (h_cnt >= 1 && h_cnt <= H_ACTIVE / 24 * 15 & v_cnt < V_ACTIVE )
            rgb_data <= 24'h004000;
        else if (h_cnt >= 1 && h_cnt <= H_ACTIVE / 24 * 16 & v_cnt < V_ACTIVE )
            rgb_data <= 24'h008000;
        else if (h_cnt >= 1 && h_cnt <= H_ACTIVE / 24 * 17 & v_cnt < V_ACTIVE )
            rgb_data <= 24'h010000;
        else if (h_cnt >= 1 && h_cnt <= H_ACTIVE / 24 * 18 & v_cnt < V_ACTIVE )
            rgb_data <= 24'h020000;
        else if (h_cnt >= 1 && h_cnt <= H_ACTIVE / 24 * 19 & v_cnt < V_ACTIVE )
            rgb_data <= 24'h040000;
        else if (h_cnt >= 1 && h_cnt <= H_ACTIVE / 24 * 20 & v_cnt < V_ACTIVE )
            rgb_data <= 24'h080000;
        else if (h_cnt >= 1 && h_cnt <= H_ACTIVE / 24 * 21 & v_cnt < V_ACTIVE )
            rgb_data <= 24'h100000;
        else if (h_cnt >= 1 && h_cnt <= H_ACTIVE / 24 * 22 & v_cnt < V_ACTIVE )
            rgb_data <= 24'h200000;
        else if (h_cnt >= 1 && h_cnt <= H_ACTIVE / 24 * 23 & v_cnt < V_ACTIVE )
            rgb_data <= 24'h400000;
        else if (h_cnt >= 1 && h_cnt <= H_ACTIVE / 24 * 24 & v_cnt < V_ACTIVE )
            rgb_data <= 24'h800000;
        else 
            rgb_data <= 24'h000000;
        
    end

endmodule