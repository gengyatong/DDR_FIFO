`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/11/2023 04:55:43 PM
// Design Name: 
// Module Name: MIG_WrRd_AXI
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

module MIG_WrRd_AXI(
    input                                    c0_sys_clk_p               ,   //DDR200M 时钟输入
    input                                    c0_sys_clk_n               ,
    output [`DDR4_ADR_WIDTH      - 1 : 0]     c0_ddr4_adr                ,
    output [`DDR4_BA_WIDTH       - 1 : 0]     c0_ddr4_ba                 ,
    output [`DDR4_CKE_WIDTH      - 1 : 0]     c0_ddr4_cke                ,
    output [`DDR4_CS_N_WIDTH     - 1 : 0]     c0_ddr4_cs_n               ,
    inout  [`DDR4_DM_DBI_N_WIDTH - 1 : 0]     c0_ddr4_dm_dbi_n           ,
    inout  [`DDR4_DQ_WIDTH       - 1 : 0]     c0_ddr4_dq                 ,
    inout  [`DDR4_DQS_C_WIDTH    - 1 : 0]     c0_ddr4_dqs_c              ,
    inout  [`DDR4_DQS_T_WIDTH    - 1 : 0]     c0_ddr4_dqs_t              ,
    output [`DDR4_ODT_WIDTH      - 1 : 0]     c0_ddr4_odt                ,
    output [`DDR4_BG_WIDTH       - 1 : 0]     c0_ddr4_bg                 ,
    output                                   c0_ddr4_reset_n            ,
    output                                   c0_ddr4_act_n              ,
    output [`DDR4_CK_C_WIDTH     - 1 : 0]     c0_ddr4_ck_c               ,
    output [`DDR4_CK_T_WIDTH     - 1 : 0]     c0_ddr4_ck_t               
    );




wire [`C_M_AXI_ID_WIDTH-1   :0]  c0_ddr4_s_axi_awid      ; 
wire [`C_M_AXI_ADDR_WIDTH-1 :0]  c0_ddr4_s_axi_awaddr    ;
wire [7                     :0]  c0_ddr4_s_axi_awlen     ;
wire [2                     :0]  c0_ddr4_s_axi_awsize    ;
wire [1                     :0]  c0_ddr4_s_axi_awburst   ;
wire                             c0_ddr4_s_axi_awlock    ;
wire [3                     :0]  c0_ddr4_s_axi_awcache   ;
wire [2                     :0]  c0_ddr4_s_axi_awprot    ;
wire [3                     :0]  c0_ddr4_s_axi_awqos     ;
wire                             c0_ddr4_s_axi_awvalid   ;
wire                             c0_ddr4_s_axi_awready   ;

wire [`C_M_AXI_DATA_WIDTH-1   : 0]  c0_ddr4_s_axi_wdata     ;
wire [`C_M_AXI_DATA_WIDTH/8-1 : 0]  c0_ddr4_s_axi_wstrb     ;
wire                                c0_ddr4_s_axi_wlast     ;
wire                                c0_ddr4_s_axi_wvalid    ;
wire                                c0_ddr4_s_axi_wready    ;

wire                                c0_ddr4_s_axi_bready    ;
wire [`C_M_AXI_ID_WIDTH-1     :0]   c0_ddr4_s_axi_bid       ;
wire [1                       :0]   c0_ddr4_s_axi_bresp     ;
wire                                c0_ddr4_s_axi_bvalid    ;

wire [`C_M_AXI_ID_WIDTH-1     :0]   c0_ddr4_s_axi_arid      ;
wire [`C_M_AXI_ADDR_WIDTH-1   :0]   c0_ddr4_s_axi_araddr    ;
wire [7                       :0]   c0_ddr4_s_axi_arlen     ;
wire [2                       :0]   c0_ddr4_s_axi_arsize    ;
wire [1                       :0]   c0_ddr4_s_axi_arburst   ;
wire                                c0_ddr4_s_axi_arlock    ;
wire [3                       :0]   c0_ddr4_s_axi_arcache   ;
wire [2                       :0]   c0_ddr4_s_axi_arprot    ;
wire [3                       :0]   c0_ddr4_s_axi_arqos     ;
wire                                c0_ddr4_s_axi_arvalid   ;
wire                                c0_ddr4_s_axi_arready   ;

wire                                c0_ddr4_s_axi_rready    ;
wire                                c0_ddr4_s_axi_rlast     ;
wire                                c0_ddr4_s_axi_rvalid    ;
wire [1                       :0]   c0_ddr4_s_axi_rresp     ;
wire [`C_M_AXI_ID_WIDTH-1     :0]   c0_ddr4_s_axi_rid       ;
wire [`C_M_AXI_DATA_WIDTH-1   :0]   c0_ddr4_s_axi_rdata     ;

wire                                c0_ddr4_ui_clk_sync_rst;  //MIG核输出的同步复位信号，取反后用于给AXI 接口复位


wire          MIGRst;
wire          usrRst;

wire [127:0]  dataIn;
wire          dataInValid;
wire          WrEn;
wire [29:0]   dataInAddr;  
wire          dataInAddrValid;

wire          RdEn;
wire [29:0]   dataOutAddr;
wire          dataOutAddrValid ;

wire [127:0]  dataOut;
wire          dataOutValid;

vio_axiDDR vio_axiDDRInst (
  .clk      (c0_ddr4_ui_clk     ),  // input wire clk
  
  .probe_in0(0),    // input wire [0 : 0] probe_in0 

  .probe_out0(MIGRst            ),  // output wire [0 : 0] probe_out0     //MIGRst         1   bit
  .probe_out1(                  ),  // output wire [0 : 0] probe_out1     //user reset        1   bit
  .probe_out2(                  ),  // output wire [127 : 0] probe_out2   //dataIn            128 bit
  .probe_out3(                  ),  // output wire [0 : 0] probe_out3     //dataIn valid      1   bit
  .probe_out4(WrEn              ),  // output wire [0 : 0] probe_out4     //wr en             1   bit
  .probe_out5(                  ),  // output wire [16 : 0] probe_out5    //dataInaddr        17  bit 
  .probe_out6(                  ),  // output wire [0 : 0] probe_out6     //dataInaddrValid   1   bit
  .probe_out7(RdEn              ),  // output wire [0 : 0] probe_out7     //RdEn              1   bit
  .probe_out8(dataOutAddr       ),  // output wire [16 : 0] probe_out8    //dataOutAddr       17  bit
  .probe_out9(dataOutAddrValid  )  // output wire [0 : 0] probe_out9      //dataOutaddrValid  1   bit
);

wire [31:0] SimDataOut      ;
wire        SimDataOutValid ;

 SimulateDataGen SimulateDataGenInst(
  .clk          (c0_ddr4_ui_clk ),      //现在用的还是AXI时钟，后期需要换成ADC时钟-----------------------------------
  .En           (WrEn           ),
  .DataOut      (SimDataOut     ),
  .DataOutValid (SimDataOutValid)
);

wire [127:0] WriteFifoDataOut;
wire         WriteFifoDataOutValid;
wire         WriteFifoRdEn  ;      
wire         WriteFifoEmpty ;
wire [4:0]   RdDataCount    ;

wire [4:0]   BurstThread;
wire         FifoOverBurstThread;
  
assign BurstThread = 'd4;

DDRWriteFifo DDRWriteFifoInst(  

    .WrClk         (c0_ddr4_ui_clk          ),    //现在用的还是AXI时钟，后期需要换成ADC时钟-------------------------------------
    .Rst           (c0_ddr4_ui_clk_sync_rst ),    //复位信号
    .En            (WrEn                    ),    //模块使能信号,使能为高才开始写入数据
    .DataIn        (SimDataOut              ),    //输入数据，有效通常一直为1  
    .DataInValid   (SimDataOutValid         ),

    .RdClk         (c0_ddr4_ui_clk       ), //读出时钟
    .FifoRdEn      (WriteFifoRdEn        ), //FIfo的读信号由后级AXI接口控制 
    .FifoEmpty     (WriteFifoEmpty       ), //Fifo空标志

    .BurstThread   (BurstThread          ),
    .FifoOverBurstThread(FifoOverBurstThread),//Fifo数据量达到一次AXI突发长度

    .DataOut       (WriteFifoDataOut        ),//FIfo数据输出
    .DataOutValid  (WriteFifoDataOutValid   ) //Fifo数据输出有效
);



AXI_USER_CODE AXI_USER_CODE_inst
(

//写入Fifo相关信号
    .fifo_over_burst_thread (FifoOverBurstThread      ),
    .write_Fifo_RdEn        (WriteFifoRdEn            ),
    .dataIn                 (WriteFifoDataOut         ),
    .dataInValid            (WriteFifoDataOutValid    ),


//读状态相关信号
    .RdEn           (RdEn          ),
    .dataOutAddr    (dataOutAddr   ),
    .dataOutAddrValid(dataOutAddrValid),
    .dataOut        (dataOut      ),
    .dataOutValid   (dataOutValid ),

  .M_AXI_ACLK   (c0_ddr4_ui_clk),
  .M_AXI_ARESETN(~c0_ddr4_ui_clk_sync_rst),
  
  .M_AXI_AWID   (c0_ddr4_s_axi_awid   ),
  .M_AXI_AWADDR (c0_ddr4_s_axi_awaddr ),
  .M_AXI_AWLEN  (c0_ddr4_s_axi_awlen  ),
  .M_AXI_AWSIZE (c0_ddr4_s_axi_awsize ),
  .M_AXI_AWBURST(c0_ddr4_s_axi_awburst),
  .M_AXI_AWLOCK (c0_ddr4_s_axi_awlock ),
  .M_AXI_AWCACHE(c0_ddr4_s_axi_awcache),
  .M_AXI_AWPROT (c0_ddr4_s_axi_awprot ),
  .M_AXI_AWQOS  (c0_ddr4_s_axi_awqos  ),
  .M_AXI_AWVALID(c0_ddr4_s_axi_awvalid),
  .M_AXI_AWREADY(c0_ddr4_s_axi_awready),
  
  .M_AXI_WDATA  (c0_ddr4_s_axi_wdata ),
  .M_AXI_WSTRB  (c0_ddr4_s_axi_wstrb ),
  .M_AXI_WLAST  (c0_ddr4_s_axi_wlast ), 
  .M_AXI_WVALID (c0_ddr4_s_axi_wvalid),
  .M_AXI_WREADY (c0_ddr4_s_axi_wready),
  
  .M_AXI_BID    (c0_ddr4_s_axi_bid    ),
  .M_AXI_BRESP  (c0_ddr4_s_axi_bresp  ),
  .M_AXI_BVALID (c0_ddr4_s_axi_bvalid ),
  .M_AXI_BREADY ( c0_ddr4_s_axi_bready),
  
  .M_AXI_ARID     (c0_ddr4_s_axi_arid    ),
  .M_AXI_ARADDR   (c0_ddr4_s_axi_araddr  ),
  .M_AXI_ARLEN    (c0_ddr4_s_axi_arlen   ),
  .M_AXI_ARSIZE   (c0_ddr4_s_axi_arsize  ),
  .M_AXI_ARBURST  (c0_ddr4_s_axi_arburst ),
  .M_AXI_ARLOCK   (c0_ddr4_s_axi_arlock  ),
  .M_AXI_ARCACHE  (c0_ddr4_s_axi_arcache ),
  .M_AXI_ARPROT   (c0_ddr4_s_axi_arprot  ),
  .M_AXI_ARQOS    (c0_ddr4_s_axi_arqos   ),
  .M_AXI_ARVALID  (c0_ddr4_s_axi_arvalid ),
  .M_AXI_ARREADY  (c0_ddr4_s_axi_arready ),
  
  .M_AXI_RID      (c0_ddr4_s_axi_rid     ),
  .M_AXI_RDATA    (c0_ddr4_s_axi_rdata   ),
  .M_AXI_RRESP    (c0_ddr4_s_axi_rresp   ),
  .M_AXI_RLAST    (c0_ddr4_s_axi_rlast   ),
  .M_AXI_RVALID   (c0_ddr4_s_axi_rvalid  ),
  .M_AXI_RREADY   (c0_ddr4_s_axi_rready  )
);


ddr4_0 ddr4_0_inst (
  .c0_init_calib_complete   (         ),    // output wire c0_init_calib_complete
  .dbg_clk                  (         ),                                  // output wire dbg_clk
  .c0_sys_clk_p(c0_sys_clk_p),                        // input wire c0_sys_clk_p
  .c0_sys_clk_n(c0_sys_clk_n),                        // input wire c0_sys_clk_n
  .dbg_bus     (            ),                                  // output wire [511 : 0] dbg_bus
  .c0_ddr4_adr(c0_ddr4_adr),                          // output wire [16 : 0] c0_ddr4_adr
  .c0_ddr4_ba(c0_ddr4_ba),                            // output wire [1 : 0] c0_ddr4_ba
  .c0_ddr4_cke(c0_ddr4_cke),                          // output wire [0 : 0] c0_ddr4_cke
  .c0_ddr4_cs_n(c0_ddr4_cs_n),                        // output wire [0 : 0] c0_ddr4_cs_n
  .c0_ddr4_dm_dbi_n(c0_ddr4_dm_dbi_n),                // inout wire [1 : 0] c0_ddr4_dm_dbi_n
  .c0_ddr4_dq(c0_ddr4_dq),                            // inout wire [15 : 0] c0_ddr4_dq
  .c0_ddr4_dqs_c(c0_ddr4_dqs_c),                      // inout wire [1 : 0] c0_ddr4_dqs_c
  .c0_ddr4_dqs_t(c0_ddr4_dqs_t),                      // inout wire [1 : 0] c0_ddr4_dqs_t
  .c0_ddr4_odt(c0_ddr4_odt),                          // output wire [0 : 0] c0_ddr4_odt
  .c0_ddr4_bg(c0_ddr4_bg),                            // output wire [0 : 0] c0_ddr4_bg
  .c0_ddr4_reset_n(c0_ddr4_reset_n),                  // output wire c0_ddr4_reset_n
  .c0_ddr4_act_n(c0_ddr4_act_n),                      // output wire c0_ddr4_act_n
  .c0_ddr4_ck_c(c0_ddr4_ck_c),                        // output wire [0 : 0] c0_ddr4_ck_c
  .c0_ddr4_ck_t(c0_ddr4_ck_t),                        // output wire [0 : 0] c0_ddr4_ck_t
  
  .c0_ddr4_ui_clk(c0_ddr4_ui_clk),                    // output wire c0_ddr4_ui_clk
  .c0_ddr4_ui_clk_sync_rst(c0_ddr4_ui_clk_sync_rst),  // output wire c0_ddr4_ui_clk_sync_rst

  .c0_ddr4_aresetn(~c0_ddr4_ui_clk_sync_rst),                  // input wire c0_ddr4_aresetn

  .c0_ddr4_s_axi_awid     (c0_ddr4_s_axi_awid   ),            // input wire [3 : 0] c0_ddr4_s_axi_awid
  .c0_ddr4_s_axi_awaddr   (c0_ddr4_s_axi_awaddr ),        // input wire [29 : 0] c0_ddr4_s_axi_awaddr
  .c0_ddr4_s_axi_awlen    (c0_ddr4_s_axi_awlen  ),          // input wire [7 : 0] c0_ddr4_s_axi_awlen
  .c0_ddr4_s_axi_awsize   (c0_ddr4_s_axi_awsize ),        // input wire [2 : 0] c0_ddr4_s_axi_awsize
  .c0_ddr4_s_axi_awburst  (c0_ddr4_s_axi_awburst),      // input wire [1 : 0] c0_ddr4_s_axi_awburst
  .c0_ddr4_s_axi_awlock   (c0_ddr4_s_axi_awlock ),        // input wire [0 : 0] c0_ddr4_s_axi_awlock
  .c0_ddr4_s_axi_awcache  (c0_ddr4_s_axi_awcache),      // input wire [3 : 0] c0_ddr4_s_axi_awcache
  .c0_ddr4_s_axi_awprot   (c0_ddr4_s_axi_awprot ),        // input wire [2 : 0] c0_ddr4_s_axi_awprot
  .c0_ddr4_s_axi_awqos    (c0_ddr4_s_axi_awqos  ),          // input wire [3 : 0] c0_ddr4_s_axi_awqos
  .c0_ddr4_s_axi_awvalid  (c0_ddr4_s_axi_awvalid),      // input wire c0_ddr4_s_axi_awvalid
  .c0_ddr4_s_axi_awready  (c0_ddr4_s_axi_awready),      // output wire c0_ddr4_s_axi_awready

  .c0_ddr4_s_axi_wdata    (c0_ddr4_s_axi_wdata  ),          // input wire [127 : 0] c0_ddr4_s_axi_wdata
  .c0_ddr4_s_axi_wstrb    (c0_ddr4_s_axi_wstrb  ),          // input wire [15 : 0] c0_ddr4_s_axi_wstrb
  .c0_ddr4_s_axi_wlast    (c0_ddr4_s_axi_wlast  ),          // input wire c0_ddr4_s_axi_wlast
  .c0_ddr4_s_axi_wvalid   (c0_ddr4_s_axi_wvalid ),        // input wire c0_ddr4_s_axi_wvalid
  .c0_ddr4_s_axi_wready   (c0_ddr4_s_axi_wready ),        // output wire c0_ddr4_s_axi_wready
  
  .c0_ddr4_s_axi_bready   (c0_ddr4_s_axi_bready ),        // input wire c0_ddr4_s_axi_bready
  .c0_ddr4_s_axi_bid      (c0_ddr4_s_axi_bid    ),              // output wire [3 : 0] c0_ddr4_s_axi_bid
  .c0_ddr4_s_axi_bresp    (c0_ddr4_s_axi_bresp  ),          // output wire [1 : 0] c0_ddr4_s_axi_bresp
  .c0_ddr4_s_axi_bvalid   (c0_ddr4_s_axi_bvalid ),        // output wire c0_ddr4_s_axi_bvalid
  
  .c0_ddr4_s_axi_arid     (c0_ddr4_s_axi_arid   ),            // input wire [3 : 0] c0_ddr4_s_axi_arid
  .c0_ddr4_s_axi_araddr   (c0_ddr4_s_axi_araddr ),        // input wire [29 : 0] c0_ddr4_s_axi_araddr
  .c0_ddr4_s_axi_arlen    (c0_ddr4_s_axi_arlen  ),          // input wire [7 : 0] c0_ddr4_s_axi_arlen
  .c0_ddr4_s_axi_arsize   (c0_ddr4_s_axi_arsize ),        // input wire [2 : 0] c0_ddr4_s_axi_arsize
  .c0_ddr4_s_axi_arburst  (c0_ddr4_s_axi_arburst),      // input wire [1 : 0] c0_ddr4_s_axi_arburst
  .c0_ddr4_s_axi_arlock   (c0_ddr4_s_axi_arlock ),        // input wire [0 : 0] c0_ddr4_s_axi_arlock
  .c0_ddr4_s_axi_arcache  (c0_ddr4_s_axi_arcache),      // input wire [3 : 0] c0_ddr4_s_axi_arcache
  .c0_ddr4_s_axi_arprot   (c0_ddr4_s_axi_arprot ),        // input wire [2 : 0] c0_ddr4_s_axi_arprot
  .c0_ddr4_s_axi_arqos    (c0_ddr4_s_axi_arqos  ),          // input wire [3 : 0] c0_ddr4_s_axi_arqos
  .c0_ddr4_s_axi_arvalid  (c0_ddr4_s_axi_arvalid),      // input wire c0_ddr4_s_axi_arvalid
  .c0_ddr4_s_axi_arready  (c0_ddr4_s_axi_arready),      // output wire c0_ddr4_s_axi_arready
  
  .c0_ddr4_s_axi_rready   (c0_ddr4_s_axi_rready ),        // input wire c0_ddr4_s_axi_rready
  .c0_ddr4_s_axi_rlast    (c0_ddr4_s_axi_rlast  ) ,          // output wire c0_ddr4_s_axi_rlast
  .c0_ddr4_s_axi_rvalid   (c0_ddr4_s_axi_rvalid ),        // output wire c0_ddr4_s_axi_rvalid
  .c0_ddr4_s_axi_rresp    (c0_ddr4_s_axi_rresp  ),          // output wire [1 : 0] c0_ddr4_s_axi_rresp
  .c0_ddr4_s_axi_rid      (c0_ddr4_s_axi_rid    ),              // output wire [3 : 0] c0_ddr4_s_axi_rid
  .c0_ddr4_s_axi_rdata    (c0_ddr4_s_axi_rdata  ),          // output wire [127 : 0] c0_ddr4_s_axi_rdata

  .addn_ui_clkout1        (addn_ui_clkout1),                  // output wire addn_ui_clkout1
  .addn_ui_clkout2        (addn_ui_clkout2),                  // output wire addn_ui_clkout2
  
  .sys_rst( MIGRst )                                  // input wire sys_rst
);


ila_AXI ila_AXI (
	.clk(c0_ddr4_ui_clk), // input wire clk


	.probe0 (c0_ddr4_s_axi_awid   ), // input wire [3:0]  probe0  
	.probe1 (c0_ddr4_s_axi_awaddr ), // input wire [29:0]  probe1 
	.probe2 (c0_ddr4_s_axi_awlen  ), // input wire [7:0]  probe2 
	.probe3 (c0_ddr4_s_axi_awsize ), // input wire [2:0]  probe3 
	.probe4 (c0_ddr4_s_axi_awburst), // input wire [1:0]  probe4 
	.probe5 (c0_ddr4_s_axi_awlock ), // input wire [0:0]  probe5 
	.probe6 (c0_ddr4_s_axi_awcache), // input wire [3:0]  probe6 
	.probe7 (c0_ddr4_s_axi_awprot ), // input wire [2:0]  probe7 
	.probe8 (c0_ddr4_s_axi_awqos  ), // input wire [3:0]  probe8 
	.probe9 (c0_ddr4_s_axi_awvalid), // input wire [0:0]  probe9 
	.probe10(c0_ddr4_s_axi_awready), // input wire [0:0]  probe10 

	.probe11(c0_ddr4_s_axi_wdata  ), // input wire [127:0]  probe11 
	.probe12(c0_ddr4_s_axi_wstrb  ), // input wire [15:0]  probe12 
	.probe13(c0_ddr4_s_axi_wlast  ), // input wire [0:0]  probe13 
	.probe14(c0_ddr4_s_axi_wvalid ), // input wire [0:0]  probe14 
	.probe15(c0_ddr4_s_axi_wready ), // input wire [0:0]  probe15 

	.probe16(c0_ddr4_s_axi_bready ), // input wire [0:0]  probe16 
	.probe17(c0_ddr4_s_axi_bid    ), // input wire [3:0]  probe17 
	.probe18(c0_ddr4_s_axi_bresp  ), // input wire [1:0]  probe18 
	.probe19(c0_ddr4_s_axi_bvalid ), // input wire [0:0]  probe19 

	.probe20(c0_ddr4_s_axi_arid   ), // input wire [3:0]  probe20 
	.probe21(c0_ddr4_s_axi_araddr ), // input wire [29:0]  probe21 
	.probe22(c0_ddr4_s_axi_arlen  ), // input wire [7:0]  probe22 
	.probe23(c0_ddr4_s_axi_arsize ), // input wire [2:0]  probe23 
	.probe24(c0_ddr4_s_axi_arburst), // input wire [1:0]  probe24 
	.probe25(c0_ddr4_s_axi_arlock ), // input wire [0:0]  probe25 
	.probe26(c0_ddr4_s_axi_arcache), // input wire [3:0]  probe26 
	.probe27(c0_ddr4_s_axi_arprot ), // input wire [2:0]  probe27 
	.probe28(c0_ddr4_s_axi_arqos  ), // input wire [3:0]  probe28 
	.probe29(c0_ddr4_s_axi_arvalid), // input wire [0:0]  probe29 
	.probe30(c0_ddr4_s_axi_arready), // input wire [0:0]  probe30 

	.probe31(c0_ddr4_s_axi_rready), // input wire [0:0]  probe31 
	.probe32(c0_ddr4_s_axi_rlast ), // input wire [0:0]  probe32 
	.probe33(c0_ddr4_s_axi_rvalid), // input wire [0:0]  probe33 
	.probe34(c0_ddr4_s_axi_rresp ), // input wire [1:0]  probe34 
	.probe35(c0_ddr4_s_axi_rid   ), // input wire [3:0]  probe35 
	.probe36(c0_ddr4_s_axi_rdata ), // input wire [127:0]  probe36 
	.probe37(dataOutValid        ), // input wire [0:0]  probe37 
	.probe38(dataOut       ) // input wire [127:0]  probe38
);




endmodule
