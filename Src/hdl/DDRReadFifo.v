`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/25/2023 11:28:37 AM
// Design Name: 
// Module Name: DDRReadFifo
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 在这个文件里 FIFO的写入方是DDR，所以写入时钟 wr_clk就是 AXI时钟域 
// FIFO的读出方是DAC相关模块，    所以读出时钟 rd_clk就是主控时钟域。
// 所有的给AXI 时钟域的控制信号都经过了时钟域同步
//////////////////////////////////////////////////////////////////////////////////
`include "Config.vh"

module DDRReadFifo(

        input                           rst,
        input                           wr_clk,         //DDR时钟域

        input [`C_M_AXI_DATA_WIDTH-1:0] wr_dataIn,
        input                           wr_dataIn_valid,

        
        input                           rd_clk,         //ADC及DAC时钟域
        output[47:0]                    rd_dataout,
        output                          rd_dataout_valid,

        //发送给DDR 的数据读取信号，一旦AXI的读取相关通道收到这个信号，就会向MIG核请求读出数据
        //读出的数据量为一次AXI突发长度
        output  reg                     DDR_rd_en,     //给DDR模块的，在DDR的AXI时钟域
        
        output                          fifo_full,

        //当写入数据量达到一定程度，保证DDR中有足够数据存入后，才会打开这个控制信号；
        //在这个控制信号打开后，一旦读出fifo中的数据量小于一定值，就会向MIG核发出读数据信号
        input                           ctrl_rd_en                            
    );

//数据量小于DDR_READFIFO_DATANUM（只要保证不会断流即可）的时候，就准备向DDR读出数据
wire [9:0] prog_empty_thresh = `DDR_READFIFO_DATANUM        ;
//读时钟域下的Fifo可编程空
wire                            read_fifo_prog_empty_rd_clk ;

wire                            fifo_empty                  ;
reg                             rd_en                       ;          
wire [9:0]                      rd_data_count               ;

Read_fifo Read_fifo_inst (
  .rst              (rst                        ),                              // input wire rst
  .wr_clk           (wr_clk                     ),                              // input wire wr_clk
  .rd_clk           (rd_clk                     ),                              // input wire rd_clk
  
  .din              (wr_dataIn[191:0]           ),                               // input wire [127 : 0] din
  .wr_en            (wr_dataIn_valid            ),                               // input wire wr_en
  .rd_en            (rd_en                      ),                               // input wire rd_en
  .prog_empty_thresh(prog_empty_thresh          ),                               // input wire [7 : 0] prog_empty_thresh

  .full             (fifo_full                  ),                                                               // output wire full
  .empty            (fifo_empty                 ),                               // output wire empty
  
  .dout             (rd_dataout                 ),                               // output wire [31 : 0] dout
  .valid            (rd_dataout_valid           ),                               // output wire valid
  .prog_empty       (read_fifo_prog_empty       ),                               // output wire prog_empty
  .rd_data_count    (rd_data_count),                                             // output wire [9 : 0] rd_data_count
  .wr_rst_busy(),                                                        // output wire wr_rst_busy
  .rd_rst_busy()                                                         // output wire rd_rst_busy
);

//一旦开启工作使能之后，非空即读，保持数据不能断流
always@(posedge rd_clk)
begin
    if(rst)
        begin
            rd_en <= 1'b0;
        end

    else if((ctrl_rd_en) &&(~fifo_empty))   
        begin
            rd_en <= 1'b1;
        end
    else
        begin
            rd_en <= rd_en;
        end
end
/*
//写时钟域下的Fifo可编程空（读时钟域下的可编程空需要跨时钟域到写时钟域下面，然后写时钟域根据是编程空状态决定 是否要从DDR中读取数据 ）
(*ASYNC_REG = "TRUE" *)reg read_fifo_prog_empty_wr_clk , read_fifo_prog_empty_wr_clk_async ;
always@(posedge wr_clk)
begin
    read_fifo_prog_empty_wr_clk_async   <= read_fifo_prog_empty_rd_clk;
    read_fifo_prog_empty_wr_clk         <= read_fifo_prog_empty_wr_clk_async;
end

(*ASYNC_REG = "TRUE" *)reg rst_wr_clk , rst_wr_async ;
always@(posedge wr_clk)
begin
    rst_wr_async    <= rst;
    rst_wr_clk      <= rst_wr_async;
end

(*ASYNC_REG = "TRUE" *)reg ctrl_rd_en_wr_clk , ctrl_rd_en_async ;
always@(posedge wr_clk)
begin
    ctrl_rd_en_async <= ctrl_rd_en;
    ctrl_rd_en_wr_clk<= ctrl_rd_en_async;
end
*/
reg DDR_rd_en_rd_clk;
(*ASYNC_REG = "TRUE" *)reg DDR_rd_en_async,DDR_rd_en_wr_clk ;

always@(posedge rd_clk)
begin
    if(rst)
        begin
            DDR_rd_en_rd_clk <= 1'b0;
        end
    //同步后的读控制信号有效，且fifo读空到了prog_empty之下，就开始向DDR请求    
    else if((read_fifo_prog_empty)&&(ctrl_rd_en))
        begin
            DDR_rd_en_rd_clk <= 1'b1;
        end
    else
        begin
            DDR_rd_en_rd_clk <= 1'b0;
        end
end

always@(posedge wr_clk)
begin
    DDR_rd_en_async  <=  DDR_rd_en_rd_clk;
    DDR_rd_en_wr_clk <=  DDR_rd_en_async;
    DDR_rd_en        <=  DDR_rd_en_wr_clk;
end 



`ifdef ila_DDR_read_fifo

ila_DDR_read_fifo ila_DDR_read_fifo_inst (
	.clk(wr_clk), // input wire clk

	.probe0(rst         ), // input wire [0:0]  probe0  
	.probe1(fifo_empty  ), // input wire [0:0]  probe1 
	.probe2(rd_en       ), // input wire [0:0]  probe2 
	.probe3(prog_empty_thresh), // input wire [8:0]  probe3 
	.probe4(ctrl_rd_en  ), // input wire [0:0]  probe4 
	.probe5(DDR_rd_en   ), // input wire [0:0]  probe5 
	.probe6(rd_data_count), // input wire [8:0]  probe6
    .probe7(fifo_full   )
);
`endif 

endmodule
