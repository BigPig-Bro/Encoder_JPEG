`timescale 1ns / 1ns
module jpeg_package_tb();

reg         sys_clk,rst_n;
wire 		jpeg_data_vaild,jpeg_data_last;
wire [ 7:0] jpeg_data;

jpeg_package #(
    .YUV_MODE               (2                      ),
    .IMG_WIDTH              (16'd128                ),
    .IMG_HEIGHT             (16'd128                )
)jpeg_package_m0(       
    .clk                    (sys_clk                ),
    .rst_n                  (rst_n                  ),

    .Compress_data_rdy      (1'b1                    ),
    .Compress_data_last     (                       ),
    .Compress_data          (                       ),
    .Compress_data_rden     (                       ),

    .jpeg_data              (jpeg_data              ),
    .jpeg_data_vaild        (jpeg_data_vaild        ),
    .jpeg_data_last         (jpeg_data_last         )
);

initial begin
    sys_clk = 0;    
    forever #10 sys_clk = ~sys_clk;
end

initial begin
    rst_n = 0;
    #100 rst_n = 1;
end

//将jpeg_data输出到文件
integer test;
initial begin 
	test  = $fopen("jpeg_data.jpeg","wb");
	if(test) $display("open file success");
	else	 $display("open file fail");
end

always@(posedge sys_clk)begin
    if(jpeg_data_vaild)
        $fwrite(test,"%c",jpeg_data); 

    if(jpeg_data_last)begin
        $fclose(test);
    	$display("close success");

    	$stop;
    end
end
endmodule