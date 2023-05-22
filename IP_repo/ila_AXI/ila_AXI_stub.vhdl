-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
-- Date        : Mon May 15 11:48:19 2023
-- Host        : a-OptiPlex-7080 running 64-bit Ubuntu 20.04.4 LTS
-- Command     : write_vhdl -force -mode synth_stub
--               /home/a/FPGA_CODE/Learning/AXI_DDR/axi_ddr.srcs/sources_1/ip/ila_AXI/ila_AXI_stub.vhdl
-- Design      : ila_AXI
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xcku035-ffva1156-2-e
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ila_AXI is
  Port ( 
    clk : in STD_LOGIC;
    probe0 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe1 : in STD_LOGIC_VECTOR ( 29 downto 0 );
    probe2 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe3 : in STD_LOGIC_VECTOR ( 2 downto 0 );
    probe4 : in STD_LOGIC_VECTOR ( 1 downto 0 );
    probe5 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe6 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe7 : in STD_LOGIC_VECTOR ( 2 downto 0 );
    probe8 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe9 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe10 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe11 : in STD_LOGIC_VECTOR ( 127 downto 0 );
    probe12 : in STD_LOGIC_VECTOR ( 15 downto 0 );
    probe13 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe14 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe15 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe16 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe17 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe18 : in STD_LOGIC_VECTOR ( 1 downto 0 );
    probe19 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe20 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe21 : in STD_LOGIC_VECTOR ( 29 downto 0 );
    probe22 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    probe23 : in STD_LOGIC_VECTOR ( 2 downto 0 );
    probe24 : in STD_LOGIC_VECTOR ( 1 downto 0 );
    probe25 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe26 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe27 : in STD_LOGIC_VECTOR ( 2 downto 0 );
    probe28 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe29 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe30 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe31 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe32 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe33 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe34 : in STD_LOGIC_VECTOR ( 1 downto 0 );
    probe35 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe36 : in STD_LOGIC_VECTOR ( 127 downto 0 );
    probe37 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe38 : in STD_LOGIC_VECTOR ( 127 downto 0 )
  );

end ila_AXI;

architecture stub of ila_AXI is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,probe0[3:0],probe1[29:0],probe2[7:0],probe3[2:0],probe4[1:0],probe5[0:0],probe6[3:0],probe7[2:0],probe8[3:0],probe9[0:0],probe10[0:0],probe11[127:0],probe12[15:0],probe13[0:0],probe14[0:0],probe15[0:0],probe16[0:0],probe17[3:0],probe18[1:0],probe19[0:0],probe20[3:0],probe21[29:0],probe22[7:0],probe23[2:0],probe24[1:0],probe25[0:0],probe26[3:0],probe27[2:0],probe28[3:0],probe29[0:0],probe30[0:0],probe31[0:0],probe32[0:0],probe33[0:0],probe34[1:0],probe35[3:0],probe36[127:0],probe37[0:0],probe38[127:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "ila,Vivado 2019.1";
begin
end;
