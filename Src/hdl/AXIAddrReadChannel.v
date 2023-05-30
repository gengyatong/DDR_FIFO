`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/25/2023 02:15:26 PM
// Design Name: 
// Module Name: AXIAddrReadChannel
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

module AXIAddrReadChannel(
        
        input M_AXI_ACLK,
        input M_AXI_ARESETN,


        input  rd_en,

        input                                  M_AXI_RVALID     ,
        input                                  M_AXI_RLAST      ,
        input                                  M_AXI_ARREADY    ,
        output reg [`C_M_AXI_ADDR_WIDTH - 1:0] axi_araddr       ,
        output reg                             axi_arvalid      

    );

function integer clogb2 (input integer bit_depth);              
begin                                                           
  for(clogb2=0; bit_depth>0; clogb2=clogb2+1)                   
    bit_depth = bit_depth >> 1;                                 
  end                                                           
endfunction   
	
localparam integer C_TRANSACTIONS_NUM = clogb2(`C_M_AXI_BURST_LEN-1);

wire [C_TRANSACTIONS_NUM+5 : 0] 	burst_size_bytes;
assign burst_size_bytes	= `C_M_AXI_BURST_LEN * `C_M_AXI_DATA_WIDTH/8;

//----------------------------
//Read Address Channel
//----------------------------

reg start_single_burst_read;
reg burst_read_active ;

always @(posedge M_AXI_ACLK)                                 
begin                                                                                                                                 
  if (M_AXI_ARESETN == 0  )                                         
    begin                                                          
      axi_arvalid <= 1'b0;                                         
    end                                                            
  // If previously not valid , start next transaction              
  else if ((start_single_burst_read ) && (~axi_arvalid))               
    begin                                                          
      axi_arvalid <= 1'b1;                                         
    end                                                            
  else if ( M_AXI_ARREADY && axi_arvalid)                           
    begin                                                          
      axi_arvalid <= 1'b0;                                         
    end                                                            
  else                                                             
    axi_arvalid <= axi_arvalid;                                    
end       

// Next address after ARREADY indicates previous address acceptance  
always @(posedge M_AXI_ACLK)                                       
begin                                                              
  if (M_AXI_ARESETN == 0 )                                          
    begin                                                          
      axi_araddr <= 'b0;                                           
    end                                                                                                                      
  else if (M_AXI_ARREADY && axi_arvalid)                           
    begin                                                          
      axi_araddr <= axi_araddr + burst_size_bytes;                 
    end                                                            
  else                                                             
    axi_araddr <= axi_araddr;                                         
end


always@(posedge M_AXI_ACLK)
begin
  if(M_AXI_ARESETN == 0)
      begin
        start_single_burst_read <= 1'b0;
      end
  else if (~axi_arvalid && ~start_single_burst_read && ~burst_read_active && rd_en )                       
      begin                                                                                     
        start_single_burst_read <= 1'b1;                                                       
      end                                                                                       
    else                                                                                        
      begin                                                                                     
        start_single_burst_read <= 1'b0; //Negate to generate a pulse                          
      end                                                                                       
end

always @(posedge M_AXI_ACLK)                                                                              
begin                                                                                                     
  if (M_AXI_ARESETN == 0 )                                                                                 
    burst_read_active <= 1'b0;                                                                           
                                                                                                          
  //The burst_read_active is asserted when a write burst transaction is initiated                        
  else if (start_single_burst_read)                                                                      
    burst_read_active <= 1'b1; 
  //收到本次burst 的最后一个last信号后，完成本次burst
  else if ( M_AXI_RLAST && M_AXI_RVALID )                                                                    
    burst_read_active <= 0;                                                                              
end     

`ifdef ila_axi_read_addr_channel

ila_axi_read_addr_channel ila_axi_read_addr_channel_inst (
	.clk(M_AXI_ACLK), // input wire clk


	.probe0(axi_arvalid             ), // input wire [0:0]  probe0  
	.probe1(start_single_burst_read ), // input wire [0:0]  probe1 
	.probe2(M_AXI_ARREADY           ), // input wire [0:0]  probe2 
	.probe3(axi_araddr              ), // input wire [29:0]  probe3 
	.probe4(burst_read_active       ), // input wire [0:0]  probe4 
	.probe5(rd_en                   ) // input wire [0:0]  probe5
);

`endif


endmodule
