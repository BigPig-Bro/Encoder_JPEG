`timescale 1ns / 1ns
module top_tb();

reg         sys_clk,rst_n,start;
wire        uart_tx;

top top_m0(
    .sys_clk                (sys_clk                    ),
    .rst_n                  (rst_n                      ),
    .start                  (start                      )
    // .uart_tx                (uart_tx                    ) // 串口输出(暂未测试到该阶段)
);

initial begin
    sys_clk = 0;    
    forever #10 sys_clk = ~sys_clk;
end

initial begin
    rst_n = 0;
    start = 0;
    #100 rst_n = 1;
    #100 start = 1;
    #100 start = 0;
end

endmodule