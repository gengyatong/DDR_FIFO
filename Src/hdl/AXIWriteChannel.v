`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/22/2023 06:55:07 PM
// Design Name: 
// Module Name: AXIWriteChannel
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

//--------------------
//Write Data Channel
//--------------------

module AXIWriteChannel
(

    input                               M_AXI_ACLK,
    input                               M_AXI_ARESETN,
    
    input                               M_AXI_WREADY,

    input                               start_single_burst_write,

    input   [`C_M_AXI_DATA_WIDTH-1:0]   WriteData,
    input                               WriteDataValid,

    output                              write_Fifo_RdEn,

    output reg                                  axi_wlast,
    output reg                                  axi_wvalid,
    output wire [`C_M_AXI_DATA_WIDTH-1 : 0]     axi_wdata


);


function integer clogb2 (input integer bit_depth);              
begin                                                           
  for(clogb2=0; bit_depth>0; clogb2=clogb2+1)                   
    bit_depth = bit_depth >> 1;                                 
  end                                                           
endfunction                                                     

localparam integer C_TRANSACTIONS_NUM = clogb2(`C_M_AXI_BURST_LEN-1);

wire wnext;
//如果为1表示下一个时钟周期仍要将新的数据输出到总线上面
assign wnext = M_AXI_WREADY & axi_wvalid;                                   

reg [C_TRANSACTIONS_NUM : 0] 	write_index;

// WVALID logic, similar to the axi_awvalid always block above                      
always @(posedge M_AXI_ACLK)                                                      
begin                                                                             
  if (M_AXI_ARESETN == 0)                                                        
    begin                                                                         
      axi_wvalid <= 1'b0;                                                         
    end                                                                           

  else if (~axi_wvalid && start_single_burst_write)                               
    begin                                                                         
      axi_wvalid <= 1'b1;                                                         
    end

//最后一次写入之后，将valid清除
  else if ((WriteDataValid && axi_wlast)&&(M_AXI_WREADY))                                                    
    axi_wvalid <= 1'b0;                                                           
  else                                                                            
    axi_wvalid <= axi_wvalid;                                                     

end  

assign axi_wdata = WriteData;

//前级FIFO读取
assign write_Fifo_RdEn = wnext ;

//写入数据量计数                                                 
always @(posedge M_AXI_ACLK)                                                      
begin                                                                             
  if (M_AXI_ARESETN == 0 || start_single_burst_write == 1'b1)    
    begin                                                                         
      write_index <= 0;                                                           
    end                                                                           
  else if (wnext && (write_index != `C_M_AXI_BURST_LEN-1))                         
    begin                                                                         
      write_index <= write_index + 1;                                             
    end                                                                           
  else                                                                            
    write_index <= write_index;                                                   
end                                                                               
	                                                                                    
	                                                                            
//WLAST generation on the MSB of a counter underflow                                
// WVALID logic, similar to the axi_awvalid always block above                      
always @(posedge M_AXI_ACLK)                                                      
begin                                                                             
  if (M_AXI_ARESETN == 0  )                                                        
    begin                                                                         
      axi_wlast <= 1'b0;                                                          
    end                                                                           
  // axi_wlast is asserted when the write index                                   
  // count reaches the penultimate count to synchronize                           
  // with the last write data when write_index is b1111                           
  // else if (&(write_index[C_TRANSACTIONS_NUM-1:1])&& ~write_index[0] && wnext)  
  else if (((write_index == `C_M_AXI_BURST_LEN-2 && `C_M_AXI_BURST_LEN >= 2) && wnext) || (`C_M_AXI_BURST_LEN == 1 ))
    begin                                                                         
      axi_wlast <= 1'b1;                                                          
    end                                                                           
  // Deassrt axi_wlast when the last write data has been                          
  // accepted by the slave with a valid response                                  
  else if (wnext)                                                                 
    axi_wlast <= 1'b0;                                                            
  else if (axi_wlast && `C_M_AXI_BURST_LEN == 1)                                   
    axi_wlast <= 1'b0;                                                            
  else                                                                            
    axi_wlast <= axi_wlast;                                                       
end     


`ifdef ila_WriteDataChannel

ila_WriteDataChannel ila_WriteDataChannel (
	.clk(M_AXI_ACLK),       // input wire clk

	.probe0(M_AXI_WREADY),              // input wire [0:0]  probe0  
	.probe1(axi_wvalid),                // input wire [0:0]  probe1 
	.probe2(write_index),               // input wire [7:0]  probe2 
	.probe3(start_single_burst_write),  // input wire [0:0]  probe3 
	.probe4(WriteDataValid),            // input wire [0:0]  probe4 
	.probe5(axi_wlast),                 // input wire [0:0]  probe5 
	.probe6({WriteData[103:96],WriteData[71:64],WriteData[39:32],WriteData[7:0]}), // input wire [31:0]  probe6 
	.probe7(wnext)                      // input wire [0:0]  probe7
);
`endif

endmodule
