`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/25/2023 02:51:27 PM
// Design Name: 
// Module Name: AXIReadChannel
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
`include "Config.vh"

module AXIReadChannel(

        input       M_AXI_ACLK      ,
        input       M_AXI_ARESETN   ,
        
        input       read_fifo_full  ,
        output reg  axi_rready      ,

        input [`C_M_AXI_DATA_WIDTH - 1 : 0] M_AXI_RDATA,
        input                               M_AXI_RVALID,
        input                               M_AXI_RLAST ,
    
        output  [`C_M_AXI_DATA_WIDTH - 1 : 0] axi_data_out,
        output                                axi_data_outValid   
    );


//--------------------------------
//Read Data (and Response) Channel
//--------------------------------
always@(posedge M_AXI_ACLK)
begin
if(M_AXI_ARESETN == 0)
    begin
        axi_rready <= 1'b0;
    end
else if(~read_fifo_full)
    begin
        axi_rready <= 1'b1;
    end
else
    begin
        axi_rready <= 1'b0;
    end
end

assign axi_data_out      = M_AXI_RDATA;
assign axi_data_outValid = M_AXI_RVALID;

endmodule
