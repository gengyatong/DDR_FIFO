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

reg EnReg = 0;
reg EnMutex = 0;

reg [7:0] counter = 0;
reg       valid = 0;

always@(posedge clk)
begin
    EnReg <= En;
end

always@(posedge clk)
begin
    if((EnReg == 1'b0 )&&(En == 1'b1))
    begin
        EnMutex <= 1'b1;
    end
    else if( counter == 8'd255) 
    begin
        EnMutex <= 1'b0;
    end
    else
    begin
        EnMutex <= EnMutex;
    end
end
 
always@(posedge clk)
begin
    if(EnMutex)
        begin
            counter <= counter + 1'b1;
            valid <=  1'b1;
        end

    else if(counter == 8'd255 )
        begin
            counter <= 'd0;
            valid   <= 'd0;
        end
    else
        begin
            counter <= 'd0;
            valid <= 'd0;
        end
end

always@(posedge clk)
begin
    DataOut         <= {4{counter}};
    DataOutValid    <= valid;
end

endmodule



