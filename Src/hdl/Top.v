`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2023 01:40:52 PM
// Design Name: 
// Module Name: Top
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

module Top(

    input                                     c0_sys_clk_p                ,   
    input                                     c0_sys_clk_n                ,
    output [`DDR4_ADR_WIDTH      - 1 : 0]     c0_ddr4_adr                 ,
    output [`DDR4_BA_WIDTH       - 1 : 0]     c0_ddr4_ba                  ,
    output [`DDR4_CKE_WIDTH      - 1 : 0]     c0_ddr4_cke                 ,
    output [`DDR4_CS_N_WIDTH     - 1 : 0]     c0_ddr4_cs_n                ,
    inout  [`DDR4_DM_DBI_N_WIDTH - 1 : 0]     c0_ddr4_dm_dbi_n            ,
    inout  [`DDR4_DQ_WIDTH       - 1 : 0]     c0_ddr4_dq                  ,
    inout  [`DDR4_DQS_C_WIDTH    - 1 : 0]     c0_ddr4_dqs_c               ,
    inout  [`DDR4_DQS_T_WIDTH    - 1 : 0]     c0_ddr4_dqs_t               ,
    output [`DDR4_ODT_WIDTH      - 1 : 0]     c0_ddr4_odt                 ,
    output [`DDR4_BG_WIDTH       - 1 : 0]     c0_ddr4_bg                  ,
    output                                    c0_ddr4_reset_n             ,
    output                                    c0_ddr4_act_n               ,
    output [`DDR4_CK_C_WIDTH     - 1 : 0]     c0_ddr4_ck_c                ,
    output [`DDR4_CK_T_WIDTH     - 1 : 0]     c0_ddr4_ck_t               
   
);


wire          MIGRst        ;
wire          mig_ui_clk;
wire          start_work    ;
wire [31:0]   delay_thread  ;        
wire          data_check_rst;

vio_axiDDR vio_axiDDRInst (
  .clk      (mig_ui_clk     ),  // input wire clk
  
  .probe_in0(0),    // input wire [0 : 0] probe_in0 

  .probe_out0(MIGRst            ),  // output wire [0 : 0] probe_out0     //MIGRst         1   bit
  .probe_out1(data_check_rst    ),  // output wire [0 : 0] probe_out1     //user reset        1   bit
  .probe_out2(delay_thread      ),  // output wire [127 : 0] probe_out2   //dataIn            128 bit
  .probe_out3(                  ),  // output wire [0 : 0] probe_out3     //dataIn valid      1   bit
  .probe_out4(start_work        ),  // output wire [0 : 0] probe_out4     //wr en             1   bit
  .probe_out5(                  ),  // output wire [16 : 0] probe_out5    //dataInaddr        17  bit 
  .probe_out6(                  ),  // output wire [0 : 0] probe_out6     //dataInaddrValid   1   bit
  .probe_out7(                  ),  // output wire [0 : 0] probe_out7     //RdEn              1   bit
  .probe_out8(                  ),  // output wire [16 : 0] probe_out8    //dataOutAddr       17  bit
  .probe_out9(                  )  // output wire [0 : 0] probe_out9      //dataOutaddrValid  1   bit
);

//==============================================================

//                        仿真数据产生

//==============================================================


wire [31:0] SimDataOut      ;
wire        SimDataOutValid ;

 SimulateDataGen SimulateDataGenInst(
  .clk          (mig_ui_clk ),      //现在用的还是AXI时钟，后期需要换成ADC时钟-----------------------------------
  .En           (start_work     ),
  .DataOut      (SimDataOut     ),
  .DataOutValid (SimDataOutValid)
);

//==============================================================

//                        主要模块例化

//==============================================================

wire [31:0] rd_dataOut;
wire        rd_dataOut_valid;

MIG_WrRd_AXI MIG_WrRd_AXI_inst(
   
    .mig_rst            (MIGRst         ), 

    .wr_clk             (mig_ui_clk     ),          //后续替换为ADC采样时钟
    .wr_dataIn          (SimDataOut     ),
    .wr_dataIn_valid    (SimDataOutValid),

    .start_work         (start_work     ),
    .delay_thread       (delay_thread   ),      

    .rd_clk             (mig_ui_clk     ),          //后续替换为DAC读取时钟
    .rd_dataOut         (rd_dataOut     ),
    .rd_dataOut_valid   (rd_dataOut_valid),

    .mig_ui_clk         (mig_ui_clk ),        

//mig核相关接口   
    .c0_sys_clk_p                (c0_sys_clk_p     ),   //DDR200M 时钟输入
    .c0_sys_clk_n                (c0_sys_clk_n     ),
    .c0_ddr4_adr                 (c0_ddr4_adr      ),
    .c0_ddr4_ba                  (c0_ddr4_ba       ),
    .c0_ddr4_cke                 (c0_ddr4_cke      ),
    .c0_ddr4_cs_n                (c0_ddr4_cs_n     ),
    .c0_ddr4_dm_dbi_n            (c0_ddr4_dm_dbi_n ),
    .c0_ddr4_dq                  (c0_ddr4_dq       ),
    .c0_ddr4_dqs_c               (c0_ddr4_dqs_c    ),
    .c0_ddr4_dqs_t               (c0_ddr4_dqs_t    ),
    .c0_ddr4_odt                 (c0_ddr4_odt      ),
    .c0_ddr4_bg                  (c0_ddr4_bg       ),
    .c0_ddr4_reset_n             (c0_ddr4_reset_n  ),
    .c0_ddr4_act_n               (c0_ddr4_act_n    ),
    .c0_ddr4_ck_c                (c0_ddr4_ck_c     ),
    .c0_ddr4_ck_t                (c0_ddr4_ck_t     )
    );

//==============================================================

//                        运行状态检测

//==============================================================

wire [31:0] finish_cycle_num;
wire [4:0]  error;
wire [31:0] data_differ;

CheckDataCorrectness CheckDataCorrectness_inst(

    .clk            (mig_ui_clk         ),
    .rst            (data_check_rst     ),
    .wr_data        (SimDataOut         ),
    .wr_data_valid  (SimDataOutValid    ),   
    .rd_data        (rd_dataOut         ),
    .rd_data_valid  (rd_dataOut_valid   ),

    .finish_cycle_num(finish_cycle_num  ),
    .error          (error              ),     
    .data_differ    (data_differ        )

);



`ifdef ila_InOut_Data_Compare
ila_InOut_Data_Compare ila_InOut_Data_Compare_inst
(
  .clk(mig_ui_clk),

  .probe0(rd_dataOut      ),
  .probe1(rd_dataOut_valid),
  .probe2(SimDataOut      ),
  .probe3(SimDataOutValid ),
  .probe4(finish_cycle_num),  //32bit
  .probe5(error           ),   //5bit  
  .probe6(data_differ     )
);

`endif 

endmodule
