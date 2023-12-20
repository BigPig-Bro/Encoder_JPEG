module jpeg_package#(
    parameter YUV_MODE      = 2, // 0: YUV 4:2:0, 1: YUV 4:2:2, 2: YUV 4:4:4
    parameter IMG_WIDTH     = 16'd128, //图像宽度
    parameter IMG_HEIGHT    = 16'd128 //图像高度
)(
    input                   clk,
    input                   rst_n,

    input                   Compress_data_rdy,Compress_data_last,
    input [ 7:0]            Compress_data,
    output reg              Compress_data_rden,

    output reg [ 7:0]       jpeg_data,
    output reg              jpeg_data_vaild,
    output reg              jpeg_data_last
);

parameter JPEG_SOI = 16'hFFD8;  // 段标识符

parameter JPEG_APP0 = {
                    16'hFFE0,   // 段标识符
                    16'h0010,   // 段长度
                    40'h4A46494600,   // JFIF标识符
                    16'h0101,   // 版本号
                    8'h01,   // 密度单位
                    IMG_WIDTH,   // X方向像素数量
                    IMG_HEIGHT,   // Y方向像素数量
                    8'h00,   // 缩略图 x 方向像素数量
                    8'h00  };  // 缩略图 y 方向像素数量

parameter JPEG_DQT_Y = {
                    16'hFFDB,   // 段标识符
                    16'h0043,   // 段长度
                    8'h00,   // 量化表信息 00 表示 8 位精度 亮度表
                    512'h100B0C0E0C0A100E0D0E1211101318281A181616183123251D283A333D3933383740485C4E404457453738506D51575F626768673E4D71797064785C656763}   // 量化表（默认）

parameter JPEG_DQT_UV = {
                    16'hFFDB,   // 段标识符
                    16'h0043,   // 段长度
                    8'h01,   // 量化表信息 01 表 8 位精度 色度表
                    521'h1112121815182F1A1A2F6342384263636363636363636363636363636363636363636363636363636363636363636363636363636363636363636363636363}   // 量化表（默认）

parameter JPEG_SOF = {
                    16'hFFC0,   // 段标识符
                    16'h0011,   // 段长度
                    8'h08,   // 精度
                    IMG_HEIGHT,   // 图像高度
                    IMG_WIDTH,   // 图像宽度
                    8'h03,   // 图像分量数量
                    24'h012200,   // 分量1 + 采样方式 + 量化表 ID
                    24'h022201,   // 分量2 + 采样方式 + 量化表 ID
                    24'h032201 };  // 分量3 + 采样方式 + 量化表 ID

parameter JPEG_DHT_Y_DC = {
                    16'hFFC4,   // 段标识符
                    16'h001F,   // 段长度
                    8'h00,   // 类型 + ID
                    128'h00010501010101010100000000000000,   // 计数表
                     96'h000102030405060708090A0B};   // 值表

parameter JPEG_DHT_Y_AC = {
                    16'hFFC4,   // 段标识符
                    16'h00B5,   // 段长度
                    8'h10,   // 类型 + ID
                    128'h0002010303020403050504040000017D,   // 计数表 ,
                    1296'h02030400041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636
                    465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FA};

parameter JPEG_DHT_UV_DC = {
                    16'hFFC4,   // 段标识符
                    16'h001F,   // 段长度
                    8'h01,   // 类型 + ID
                    128'h00030101010101010101010000000000,   // 计数表
                     96'h000102030405060708090A0B};   // 值表

parameter JPEG_DHT_UV_AC = {
                    16'hFFC4,   // 段标识符
                    16'h00B5,   // 段长度
                    8'h11,   // 类型 + ID
                    128'h0002010204040304070504040001027700,   // 计数表 
                    1296'h000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636
                    465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FA};

parameter JPEG_SOS = {
                    16'hFFDA,   // 段标识符
                    16'h000C,   // 段长度
                    8'h03,   // 图像分量数量
                    16'h0100,   // 分量1 + 表
                    16'h0211,   // 分量2 + 表
                    16'h0311,   // 分量3 + 表
                    8'h00,   // 起始谱选择
                    8'h3F,   // 结束谱选择
                    8'h00 };  // 交流谱选择

parameter JPEG_EOI = 16'hFFD9; // 段标识符

parameter JPEG_SOI_NUM = 8'D2 - 1; // SOI需要发送的字节数
parameter JPEG_APP0_NUM = 8'D18 - 1; // APP0需要发送的字节数
parameter JPEG_DQT_Y_NUM = 8'D69 - 1; // DQT_Y需要发送的字节数
parameter JPEG_DQT_UV_NUM = 8'D69 - 1; // DQT_UV需要发送的字节数
parameter JPEG_SOF_NUM = 8'D19 - 1; // SOF需要发送的字节数
parameter JPEG_DHT_Y_DC_NUM = 8'D33 - 1; // DHT_Y_DC需要发送的字节数
parameter JPEG_DHT_Y_AC_NUM = 8'D183 - 1; // DHT_Y_AC需要发送的字节数
parameter JPEG_DHT_UV_DC_NUM = 8'D33 - 1; // DHT_UV_DC需要发送的字节数
parameter JPEG_DHT_UV_AC_NUM = 8'D183 - 1; // DHT_UV_AC需要发送的字节数
parameter JPEG_SOS_NUM = 8'D14 - 1; // SOS需要发送的字节数
parameter JPEG_EOI_NUM = 8'D2 - 1; // EOI需要发送的字节数


enum {IDLE,SOI,APP0,DQT_Y, DQT_UV,SOF,DHT_Y_DC,DHT_Y_AC,DHT_UV_DC,DHT_UV_AC,SOS,DATA,EOI} JPEG_ENCODE_STATE;

reg [3:0] state = IDLE;
reg [7:0] encode_cnt = 8'd0;

always@(posedge clk)
    if(!rst_n)begin
        encode_cnt  <= 8'd0;

        state       <= IDLE;
    end else 
        case(state)
            IDLE:begin
                encode_cnt  <= 8'd0;
                
                if(Compress_data_rdy)begin
                    Compress_data_rden  <= 1'b1;
                    
                    state               <= SOI;
                end else begin
                    Compress_data_rden  <= 1'b0;
                    jpeg_data           <= 8'd0;
                    jpeg_data_vaild     <= 1'b0;
                    jpeg_data_last      <= 1'b0;

                    state               <= IDLE;
                end
            end

            SOI:begin
                encode_cnt  <= encode_cnt == JPEG_SOI_NUM ? 'd0 : encode_cnt + 1'b1;

                jpeg_data_vaild <= 1'b1;
                jpeg_data       <= JPEG_SOI[(JPEG_SOI_NUM - encode_cnt) * 8 +: 8];

                state           <= encode_cnt == JPEG_SOI_NUM ? APP0 : SOI;
            end

            APP0:begin
                encode_cnt  <= encode_cnt == JPEG_APP0_NUM ? 'd0 : encode_cnt + 1'b1;

                jpeg_data       <= JPEG_APP0[(JPEG_APP0_NUM - encode_cnt) * 8 +: 8];

                state           <= encode_cnt == JPEG_APP0_NUM ? DQT : APP0;
            end

            DQT_Y:begin
                encode_cnt  <= encode_cnt == JPEG_DQT_Y_NUM ? 'd0 : encode_cnt + 1'b1;

                jpeg_data       <= JPEG_DQT_Y[(JPEG_DQT_Y_NUM - encode_cnt) * 8 +: 8];

                state           <= encode_cnt == JPEG_DQT_Y_NUM ? DQT_UV : DQT_Y;
            end

            DQT_UV:begin
                encode_cnt  <= encode_cnt == JPEG_DQT_UV_NUM ? 'd0 : encode_cnt + 1'b1;

                jpeg_data       <= JPEG_DQT_UV[(JPEG_DQT_UV_NUM - encode_cnt) * 8 +: 8];

                state           <= encode_cnt == JPEG_DQT_UV_NUM ? SOF : DQT_UV;
            end

            SOF:begin
                encode_cnt  <= encode_cnt == JPEG_SOF_NUM ? 'd0 : encode_cnt + 1'b1;

                jpeg_data       <= JPEG_SOF[(JPEG_SOF_NUM - encode_cnt) * 8 +: 8];

                state           <= encode_cnt == JPEG_SOF_NUM ? DHT_Y_DC : SOF;
            end

            DHT_Y_DC:begin
                encode_cnt  <= encode_cnt == JPEG_DHT_Y_DC_NUM ? 'd0 : encode_cnt + 1'b1;

                jpeg_data       <= JPEG_DHT_Y_DC[(JPEG_DHT_Y_DC_NUM - encode_cnt) * 8 +: 8];

                state           <= encode_cnt == JPEG_DHT_Y_DC_NUM ? DHT_Y_AC : DHT_Y_DC;
            end

            DHT_Y_AC:begin
                encode_cnt  <= encode_cnt == JPEG_DHT_Y_AC_NUM ? 'd0 : encode_cnt + 1'b1;

                jpeg_data       <= JPEG_DHT_Y_AC[(JPEG_DHT_Y_AC_NUM - encode_cnt) * 8 +: 8];

                state           <= encode_cnt == JPEG_DHT_Y_AC_NUM ? DHT_UV_DC : DHT_Y_AC;
            end

            DHT_UV_DC:begin
                encode_cnt  <= encode_cnt == JPEG_DHT_UV_DC_NUM ? 'd0 : encode_cnt + 1'b1;

                jpeg_data       <= JPEG_DHT_UV_DC[(JPEG_DHT_UV_DC_NUM - encode_cnt) * 8 +: 8];

                state           <= encode_cnt == JPEG_DHT_UV_DC_NUM ? DHT_UV_AC : DHT_UV_DC;
            end

            DHT_UV_AC:begin
                encode_cnt  <= encode_cnt == JPEG_DHT_UV_AC_NUM ? 'd0 : encode_cnt + 1'b1;

                jpeg_data       <= JPEG_DHT_UV_AC[(JPEG_DHT_UV_AC_NUM - encode_cnt) * 8 +: 8];

                state           <= encode_cnt == JPEG_DHT_UV_AC_NUM ? SOS : DHT_UV_AC;
            end

            SOS:begin
                encode_cnt  <= encode_cnt == JPEG_SOS_NUM ? 'd0 : encode_cnt + 1'b1;

                jpeg_data       <= JPEG_SOS[(JPEG_SOS_NUM - encode_cnt) * 8 +: 8];

                // state           <= encode_cnt == JPEG_SOS_NUM ? DATA : SOS;
                state           <= encode_cnt == JPEG_SOS_NUM ? EOI : SOS;
            end

            // DATA:begin

            // end

            EOI:begin
                encode_cnt  <= encode_cnt == JPEG_EOI_NUM ? 'd0 : encode_cnt + 1'b1;

                jpeg_data       <= JPEG_EOI[(JPEG_EOI_NUM - encode_cnt) * 8 +: 8];
                jpeg_data_vaild     <= encode_cnt == JPEG_EOI_NUM ? 1'b0 : 1'b1;
                jpeg_data_last      <= encode_cnt == JPEG_EOI_NUM - 1 ? 1'b1 : 1'b0;

                state           <= encode_cnt == JPEG_EOI_NUM ? IDLE : EOI;
            end
            
        endcase

endmodule 

