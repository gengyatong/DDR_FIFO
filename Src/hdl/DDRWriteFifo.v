`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/22/2023 05:14:49 PM
// Design Name: 
// Module Name: WriteFifo
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
// 
//////////////////////////////////////////////////////////////////////////////////


module DDRWriteFifo(   

    //写入时钟
    input WrClk,
    //复位信号
    input Rst,
    //模块使能信号,使能为高才开始写入数据
    input En,

    //输入数据，有效通常一直为1    
    input [31:0] DataIn,
    input        DataInValid,

    //读出时钟
    input RdClk,
    //FIfo的读信号由后级AXI接口控制
    input FifoRdEn,
    //Fifo空标志
    output       FifoEmpty,
//AXI总线一次burst的数据量（Wlen对应的参数转换例如 1，2，4，8等等）
    input  [7:0] BurstThread,
//Fifo超过一次burst域值的标志
    output reg   FifoOverBurstThread,
//FIfo数据输出
    output  [127:0]     DataOut,
    output              DataOutValid

);


wire [6:0]  RdDataCount;
wire        fifoWrEn;
reg [31:0]  DataInReg;
wire        fifofull;

always@(posedge WrClk)
begin
    DataInReg <= DataIn;
end

assign fifoWrEn = En && DataInValid && (~fifofull) ;


WriteFifo WriteFifoInst (
  .rst      (Rst    ),            // input wire rst
  .wr_clk   (WrClk  ),            // input wire wr_clk
  .rd_clk   (RdClk  ),            // input wire rd_clk
 
  .din      (DataInReg      ),              // input wire [31 : 0] din
  .wr_en    (fifoWrEn       ),              // input wire wr_en

  .rd_en    (FifoRdEn       ),              // input wire rd_en
  .dout     (DataOut        ),              // output wire [127 : 0] dout
  .valid    (DataOutValid   ),              // output wire valid
  
  .full     (fifofull       ),              // output wire full
  .wr_ack   (               ),              // output wire wr_ack
  .empty    (FifoEmpty      ),              // output wire empty
    
  .rd_data_count(RdDataCount),              // output wire [4 : 0] rd_data_count

  .wr_rst_busy(         ),                  // output wire wr_rst_busy
  .rd_rst_busy(         )                   // output wire rd_rst_busy
);

always@(posedge RdClk)
begin
    if(Rst)
        begin
            FifoOverBurstThread <= 1'b0;
        end
    else if( RdDataCount >= BurstThread)
        begin
            FifoOverBurstThread <= 1'b1;
        end
    else
        begin
            FifoOverBurstThread <= 1'b0;
        end
end



`ifdef ILA_DDRWriteFifo

ila_DDRWriteFifo0 ila_DDRWriteFifo0_inst (
	.clk(RdClk), // input wire clk

	.probe0(RdDataCount ), // input wire [4:0]  probe0  
	.probe1(fifoWrEn    ), // input wire [0:0]  probe1 
	.probe2(DataInReg   ), // input wire [31:0]  probe2 
	.probe3(fifofull    ), // input wire [0:0]  probe3 
	.probe4(FifoRdEn    ), // input wire [0:0]  probe4 
	.probe5(FifoEmpty   ), // input wire [0:0]  probe5 
	.probe6(BurstThread ), // input wire [4:0]  probe6
    .probe7(DataOutValid)
);
`endif 

endmodule
