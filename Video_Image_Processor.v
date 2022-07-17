module Video_Image_Processor
    #(
    parameter  SOBEL_THRESHOLD = 128//sobel阈值
    )
    (
    input   clk,    //cmos 像素时钟
    input   rst_n,  
    
    //预处理图像数据
    input        in_frame_vsync, //预图像数据列有效信号  
    input        in_frame_href,  //预图像数据行有效信号  
    input        in_frame_clken, //预图像数据输入使能效信号
    input [15:0] in_img_Y, //输入RGB565数据
        
    //处理后的图像数据
    output       out_frame_vsync, //处理后的图像数据列有效信号  
    output       out_frame_href,  //处理后的图像数据行有效信号  
    output       out_frame_clken, //处理后的图像数据输出使能效信号
    output       out_img_Bit        //处理后的灰度数据

);

//wire define 
wire [7:0] img_y ;
wire       frame_vsync;
wire       frame_hsync;
wire       post_frame_de;

//*****************************************************
//**                    main code
//*****************************************************

rgb2ycbcr u_rgb2ycbcr(
    .clk             (clk),
    .rst_n           (rst_n),
    
    .pre_frame_vsync (in_frame_vsync),
    .pre_frame_hsync (in_frame_href),
    .pre_frame_de    (in_frame_clken),
    .img_red         (in_img_Y[15:11]),
    .img_green       (in_img_Y[10:5]),
    .img_blue        (in_img_Y[4:0]),
    
    .frame_vsync     (frame_vsync),
    .frame_hsync     (frame_hsync),
    .post_frame_de   (post_frame_de),
    .img_y           (img_y),
    .img_cb          (),
    .img_cr          ()
);

VIP_Sobel_Edge_Detector 
    #(
    .SOBEL_THRESHOLD  (SOBEL_THRESHOLD)//sobel阈值
    )
u_VIP_Sobel_Edge_Detector(
    .clk (clk),   
    .rst_n (rst_n),  
    
    //预处理数据
    .per_frame_vsync (frame_vsync),   //预处理帧有效信号
    .per_frame_href  (frame_hsync),   //预处理行有效信号
    .per_frame_clken (post_frame_de), //预处理图像使能信号
    .per_img_Y       (img_y),         //输入灰度数据
    
    //处理后的数据
    .post_frame_vsync (out_frame_vsync), //处理后帧有效信号
    .post_frame_href  (out_frame_href),  //处理后行有效信号
    .post_frame_clken (out_frame_clken), //输出使能信号
    .post_img_Bit     (out_img_Bit),     //输出像素有效标志(1: Value, 0:inValid)
    
    //用户接口
//    .Sobel_Threshold  (Sobel_Threshold) //Sobel 阈值
);

endmodule 