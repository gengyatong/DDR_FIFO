`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2023 02:11:12 PM
// Design Name: 
// Module Name: CheckDataCorrectness
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


module CheckDataCorrectness(

    input               clk,
    input               rst,
    input [31:0]        wr_data,
    input               wr_data_valid,   
    input [31:0]        rd_data,
    input               rd_data_valid,

    output reg [31 :0]      finish_cycle_num,
    output reg [4 : 0]      error      ,     
    output reg [31 : 0]      data_differ

);
//输入与输出数据之差
reg[31:0]  data_differ_reg;

always@(posedge clk)
begin
    if((rd_data_valid)&&(wr_data_valid))
        data_differ <= wr_data - rd_data  ;
    else
        data_differ <= data_differ;
end

always@(posedge clk)
begin
    data_differ_reg <= data_differ;
end

reg [31:0] wr_data_reg;
always@(posedge clk)
begin
    wr_data_reg <= wr_data;
end

reg[31:0] rd_data_reg;
always@(posedge clk)
begin
    rd_data_reg <= rd_data;
end


always@(posedge clk)
begin
    if(rst)
        begin
            finish_cycle_num <= 'd0;
        end
    else if(rd_data == 32'hffffffff)
        begin
            finish_cycle_num <= finish_cycle_num + 1'b1;
        end
    else
        begin
            finish_cycle_num <= finish_cycle_num;
        end
end

always@(posedge clk)
begin
    if(rst)
        error[0] <= 1'b0;
    else if (data_differ_reg!=data_differ) 
        error[0] <= 1'b1;
    else
        error[0] <=  error[0];
end

always@(posedge clk)
begin
    if(rst)
        error[1] <= 1'b0;
    else if (rd_data_valid != 1'b1) 
        error[1] <= 1'b1;
    else
        error[1] <=  error[1];
end

always@(posedge clk)
begin
    if(rst)
         error[2] <= 1'b0;            
    else if  (wr_data_valid != 1'b1)
        error[2] <= 1'b1;
    else
        error[2] <=  error[2];
end


always@(posedge clk)
begin
    if(rst)
        error[3] <= 1'b0;
    else if  ((rd_data - rd_data_reg) != 'd1)
        error[3] <= 1'b1;
    else
        error[3] <= error[3];

end

always@(posedge clk)
begin
    if(rst)
        error[4] <= 1'b0;
    else if  ((wr_data - wr_data_reg) != 'd1)
        error[4] <= 1'b1;
    else
        error[4] <= error[4];
        
end
    








endmodule