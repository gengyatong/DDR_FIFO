// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
// Date        : Mon May 15 16:23:29 2023
// Host        : a-OptiPlex-7080 running 64-bit Ubuntu 20.04.4 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/a/FPGA_CODE/Learning/AXI_DDR/axi_ddr.srcs/sources_1/ip/vio_axiDDR/vio_axiDDR_stub.v
// Design      : vio_axiDDR
// Purpose     : Stub declaration of top-level module interface
// Device      : xcku035-ffva1156-2-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "vio,Vivado 2019.1" *)
module vio_axiDDR(clk, probe_in0, probe_out0, probe_out1, 
  probe_out2, probe_out3, probe_out4, probe_out5, probe_out6, probe_out7, probe_out8, probe_out9)
/* synthesis syn_black_box black_box_pad_pin="clk,probe_in0[0:0],probe_out0[0:0],probe_out1[0:0],probe_out2[127:0],probe_out3[0:0],probe_out4[0:0],probe_out5[29:0],probe_out6[0:0],probe_out7[0:0],probe_out8[29:0],probe_out9[0:0]" */;
  input clk;
  input [0:0]probe_in0;
  output [0:0]probe_out0;
  output [0:0]probe_out1;
  output [127:0]probe_out2;
  output [0:0]probe_out3;
  output [0:0]probe_out4;
  output [29:0]probe_out5;
  output [0:0]probe_out6;
  output [0:0]probe_out7;
  output [29:0]probe_out8;
  output [0:0]probe_out9;
endmodule
