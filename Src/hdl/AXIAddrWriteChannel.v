`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/23/2023 09:02:17 AM
// Design Name: 
// Module Name: AXIAddrWriteChannel
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

module AXIAddrWriteChannel(
    
    input                                       M_AXI_ACLK                  ,
    input                                       M_AXI_ARESETN               ,
    input                                       fifo_over_burst_thread      ,

    output reg                                  start_single_burst_write    ,

//Write Response (B) Channel
    input                                       M_AXI_BVALID                ,
    output reg                                  axi_bready                  ,
    input  [1:0]                                M_AXI_BRESP                 ,

//Write Address Channel
    input                                       M_AXI_AWREADY               ,     
    output reg                                  axi_awvalid                 ,
    output reg [`C_M_AXI_ADDR_WIDTH-1:0]        axi_awaddr

);

function integer clogb2 (input integer bit_depth);              
begin                                                           
  for(clogb2=0; bit_depth>0; clogb2=clogb2+1)                   
    bit_depth = bit_depth >> 1;                                 
  end                                                           
endfunction   
	
localparam integer C_TRANSACTIONS_NUM = clogb2(`C_M_AXI_BURST_LEN-1);

wire [C_TRANSACTIONS_NUM + 5 : 0] 	burst_size_bytes;
assign burst_size_bytes	= `C_M_AXI_BURST_LEN * `C_M_AXI_DATA_WIDTH/8;

//--------------------
//Write Address Channel
//--------------------

reg burst_write_active;

always @(posedge M_AXI_ACLK)                                   
begin                                                                
	                                                                       
	if (M_AXI_ARESETN == 0  )                                           
	  begin                                                            
	    axi_awvalid <= 1'b0;                                           
	  end                                                              
	// If previously not valid , start next transaction                
	else if (~axi_awvalid && start_single_burst_write)                 
	  begin                                                            
	    axi_awvalid <= 1'b1;                                           
	  end                                                              
	/* Once asserted, VALIDs cannot be deasserted, so axi_awvalid      
	must wait until transaction is accepted */                         
	else if (M_AXI_AWREADY && axi_awvalid)                             
	  begin                                                            
	    axi_awvalid <= 1'b0;                                           
	  end                                                              
	else                                                               
	  axi_awvalid <= axi_awvalid;                                      
end                                                                
	                                                                       
	                                                                       
// Next address after AWREADY indicates previous address acceptance    
always @(posedge M_AXI_ACLK)                                         
begin                                                                
  if (M_AXI_ARESETN == 0 )                                            
    begin                                                            
      axi_awaddr <= 'b0;                                             
    end                                                              
  else if (M_AXI_AWREADY && axi_awvalid)                             
    begin                                                            
      axi_awaddr <= axi_awaddr + burst_size_bytes;                   
    end                                                              
  else                                                               
    axi_awaddr <= axi_awaddr;                                        
end     

always@(posedge M_AXI_ACLK)
begin
  if(M_AXI_ARESETN == 0)
      begin
        start_single_burst_write <= 1'b0;
      end
  else if (~axi_awvalid && ~start_single_burst_write && ~burst_write_active && fifo_over_burst_thread)                       
      begin                                                                                     
        start_single_burst_write <= 1'b1;                                                       
      end                                                                                       
    else                                                                                        
      begin                                                                                     
        start_single_burst_write <= 1'b0; //Negate to generate a pulse                          
      end                                                                                       
end
                                
always @(posedge M_AXI_ACLK)                                                                              
begin                                                                                                     
  if (M_AXI_ARESETN == 0 )                                                                                 
    burst_write_active <= 1'b0;                                                                           
                                                                                                          
  //The burst_write_active is asserted when a write burst transaction is initiated                        
  else if (start_single_burst_write)                                                                      
    burst_write_active <= 1'b1;                                                                           
  else if (M_AXI_BVALID && axi_bready)                                                                    
    burst_write_active <= 0;                                                                              
end     

//----------------------------
//Write Response (B) Channel
//----------------------------

always @(posedge M_AXI_ACLK)                                     
begin                                                                 
  if (M_AXI_ARESETN == 0  )                                            
    begin                                                             
      axi_bready <= 1'b0;                                             
    end                                                               
  // accept/acknowledge bresp with axi_bready by the master           
  // when M_AXI_BVALID is asserted by slave                           
  else if (M_AXI_BVALID && ~axi_bready)                               
    begin                                                             
      axi_bready <= 1'b1;                                             
    end                                                               
  // deassert after one clock cycle                                   
  else if (axi_bready)                                                
    begin                                                             
      axi_bready <= 1'b0;                                             
    end                                                               
  // retain the previous value                                        
  else                                                                
    axi_bready <= axi_bready;                                         
end                                                                   


reg write_resp_error;                                                                           

always@(posedge M_AXI_ACLK)
begin                                                                       
    //Flag any write response errors                                        
    write_resp_error <= axi_bready & M_AXI_BVALID & M_AXI_BRESP[1]; 
end

`ifdef ila_AXIWriteChannel

ila_AXIWriteChannel ila_AXIWriteChannel_inst (
	.clk(M_AXI_ACLK ), // input wire clk

	.probe0(axi_awvalid         ), // input wire [0:0]  probe0  
	.probe1(start_single_burst_write), // input wire [0:0]  probe1 
	.probe2(M_AXI_AWREADY       ), // input wire [0:0]  probe2 
	.probe3(axi_awaddr          ), // input wire [29:0]  probe3 
	.probe4(burst_size_bytes    ), // input wire [11:0]  probe4 
	.probe5(burst_write_active  ), // input wire [0:0]  probe5 
	.probe6(axi_bready          ), // input wire [0:0]  probe6 
	.probe7(M_AXI_BVALID        ), // input wire [0:0]  probe7 
	.probe8(write_resp_error    ), // input wire [0:0]  probe8
  .probe9(fifo_over_burst_thread)
);

`endif 

endmodule
