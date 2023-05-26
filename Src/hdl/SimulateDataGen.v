`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/22/2023 02:55:20 PM
// Design Name: 
// Module Name: SimulateDataGen
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


module SimulateDataGen(
  input wire clk,
  
  input wire En,

  output reg    [31:0]  DataOut,
  
  output reg            DataOutValid
);

always@(posedge clk)
begin
    if(En)
        begin
            DataOut      <= DataOut +1'b1;
            DataOutValid <= 1'b1; 
        end
    else
        begin
            DataOut <= 'd0;
            DataOutValid <= 1'b0; 
        end
end
endmodule



