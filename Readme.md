# Encoder_JPEG

**描述**：该工程在EP4CE6上实现了JPEG编码，并通过串口输出到电脑上，在电脑上保存为.jpeg文件即可打开图像。



## 工程接口

输入：（内置测试彩条图片）RGB888

输出：Jpeg码流，通过串口上传PC



## 复现过程

+ 



## 版本更新





 ### 进度更新

20231208：完成top.sv 接口设计

​					 完成rgb_test.sv 测试彩条画面输出

​					 完成top_tb.sv测试环境生成

​					测试彩条生成信号符合预期

![rgb_out1](modelsim/rgb_out1.png)

+ 上图为一个start信号，触发生成一帧RGB彩条时序

![rgb_out2](modelsim/rgb_out2.png)

+ 上图为一行内像素赋值000001 ~ 800000H



