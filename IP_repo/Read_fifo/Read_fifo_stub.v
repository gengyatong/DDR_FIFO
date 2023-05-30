// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
// Date        : Tue May 30 14:01:09 2023
// Host        : a-OptiPlex-7080 running 64-bit Ubuntu 20.04.4 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/a/FPGA_CODE/Learning/AXI_DDR/IP_repo/Read_fifo/Read_fifo_stub.v
// Design      : Read_fifo
// Purpose     : Stub declaration of top-level module interface
// Device      : xcku035-ffva1156-2-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_2_4,Vivado 2019.1" *)
module Read_fifo(rst, wr_clk, rd_clk, din, wr_en, rd_en, 
  prog_empty_thresh, dout, full, empty, valid, rd_data_count, prog_empty, wr_rst_busy, rd_rst_busy)
/* synthesis syn_black_box black_box_pad_pin="rst,wr_clk,rd_clk,din[191:0],wr_en,rd_en,prog_empty_thresh[9:0],dout[47:0],full,empty,valid,rd_data_count[9:0],prog_empty,wr_rst_busy,rd_rst_busy" */;
  input rst;
  input wr_clk;
  input rd_clk;
  input [191:0]din;
  input wr_en;
  input rd_en;
  input [9:0]prog_empty_thresh;
  output [47:0]dout;
  output full;
  output empty;
  output valid;
  output [9:0]rd_data_count;
  output prog_empty;
  output wr_rst_busy;
  output rd_rst_busy;
endmodule
