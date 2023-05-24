`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/22/2023 04:09:01 PM
// Design Name: 
// Module Name: SimDataGenSim
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


module SimDataGenSim(

    );

reg clk = 0;
reg En = 0; 

always #5 clk = ~clk;

initial
begin

    #50 En = 1'b1;
    #10 En = 1'b0;

    #5000 En =  1'b1;
    #10  En =  1'b0;

end

 SimulateDataGen SimulateDataGen_inst(
   .clk(clk),
   .En(En),
   .DataOut(), 
   .DataOutValid()
);

endmodule
