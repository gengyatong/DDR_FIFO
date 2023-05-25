`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/08/2023 05:29:58 PM
// Design Name: 
// Module Name: AXI_USER_CODE
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

// 该文件用于计算地址，并向DDR对应地址内写入数据

// 代码中的用户逻辑复位和AXI总线复位是分开的

//////////////////////////////////////////////////////////////////////////////////
`include "Config.vh"

module AXI_USER_CODE #(

  	// Base address of targeted slave
		parameter  C_M_TARGET_SLAVE_BASE_ADDR	= 30'h00000000,
		// Burst Length. Supports 1, 2, 4, 8, 16, 32, 64, 128, 256 burst lengths
		parameter integer C_M_AXI_BURST_LEN		= `C_M_AXI_BURST_LEN,
		// Thread ID Width
		parameter integer C_M_AXI_ID_WIDTH		= `C_M_AXI_ID_WIDTH,
		// Width of Address Bus
		parameter integer C_M_AXI_ADDR_WIDTH	= `C_M_AXI_ADDR_WIDTH,
		// Width of Data Bus
		parameter integer C_M_AXI_DATA_WIDTH	= `C_M_AXI_DATA_WIDTH,
		// Width of User Write Address Bus
		parameter integer C_M_AXI_AWUSER_WIDTH	= `C_M_AXI_AWUSER_WIDTH,
		// Width of User Read Address Bus
		parameter integer C_M_AXI_ARUSER_WIDTH	= `C_M_AXI_ARUSER_WIDTH,
		// Width of User Write Data Bus
		parameter integer C_M_AXI_WUSER_WIDTH	= `C_M_AXI_WUSER_WIDTH,
		// Width of User Read Data Bus
		parameter integer C_M_AXI_RUSER_WIDTH	= `C_M_AXI_RUSER_WIDTH,
		// Width of User Response Bus
		parameter integer C_M_AXI_BUSER_WIDTH	= `C_M_AXI_BUSER_WIDTH
)

(

// 写fifo 超过一次AXIburst突发长度“标志”
	input 								fifo_over_burst_thread	,

	output 								write_Fifo_RdEn 		, 
	input [`C_M_AXI_DATA_WIDTH-1 : 0]	dataIn					,           
	input 								dataInValid      		,

//读状态相关信号
    input                           rd_en			,
	input 							read_fifo_full	,

    output [C_M_AXI_DATA_WIDTH:0]   dataOut			,
    output                          dataOutValid	,

//AXI interface

  // Global Clock Signal.
		input wire  M_AXI_ACLK,
		// Global Reset Singal. This Signal is Active Low
		input wire  M_AXI_ARESETN,
		// Master Interface Write Address ID
		output wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_AWID,
		// Master Interface Write Address
		output wire [C_M_AXI_ADDR_WIDTH-1 : 0] M_AXI_AWADDR,
		// Burst length. The burst length gives the exact number of transfers in a burst
		output wire [7 : 0] M_AXI_AWLEN,
		// Burst size. This signal indicates the size of each transfer in the burst
		output wire [2 : 0] M_AXI_AWSIZE,
		// Burst type. The burst type and the size information, 
    // determine how the address for each transfer within the burst is calculated.
		output wire [1 : 0] M_AXI_AWBURST,
		// Lock type. Provides additional information about the
    // atomic characteristics of the transfer.
		output wire  M_AXI_AWLOCK,
		// Memory type. This signal indicates how transactions
    // are required to progress through a system.
		output wire [3 : 0] M_AXI_AWCACHE,
		// Protection type. This signal indicates the privilege
    // and security level of the transaction, and whether
    // the transaction is a data access or an instruction access.
		output wire [2 : 0] M_AXI_AWPROT,
		// Quality of Service, QoS identifier sent for each write transaction.
		output wire [3 : 0] M_AXI_AWQOS,
		// Optional User-defined signal in the write address channel.
		output wire [C_M_AXI_AWUSER_WIDTH-1 : 0] M_AXI_AWUSER,
		// Write address valid. This signal indicates that
    // the channel is signaling valid write address and control information.
		output wire  M_AXI_AWVALID,
		// Write address ready. This signal indicates that
    // the slave is ready to accept an address and associated control signals
		input wire  M_AXI_AWREADY,
		// Master Interface Write Data.
		output wire [C_M_AXI_DATA_WIDTH-1 : 0] M_AXI_WDATA,
		// Write strobes. This signal indicates which byte
    // lanes hold valid data. There is one write strobe
    // bit for each eight bits of the write data bus.
		output wire [C_M_AXI_DATA_WIDTH/8-1 : 0] M_AXI_WSTRB,
		// Write last. This signal indicates the last transfer in a write burst.
		output wire  M_AXI_WLAST,
		// Optional User-defined signal in the write data channel.
		output wire [C_M_AXI_WUSER_WIDTH-1 : 0] M_AXI_WUSER,
		// Write valid. This signal indicates that valid write
    // data and strobes are available
		output wire  M_AXI_WVALID,
		// Write ready. This signal indicates that the slave
    // can accept the write data.
		input wire  M_AXI_WREADY,
		// Master Interface Write Response.
		input wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_BID,
		// Write response. This signal indicates the status of the write transaction.
		input wire [1 : 0] M_AXI_BRESP,
		// Optional User-defined signal in the write response channel
		input wire [C_M_AXI_BUSER_WIDTH-1 : 0] M_AXI_BUSER,
		// Write response valid. This signal indicates that the
    // channel is signaling a valid write response.
		input wire  M_AXI_BVALID,
		// Response ready. This signal indicates that the master
    // can accept a write response.
		output wire  M_AXI_BREADY,
		// Master Interface Read Address.
		output wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_ARID,
		// Read address. This signal indicates the initial
    // address of a read burst transaction.
		output wire [C_M_AXI_ADDR_WIDTH-1 : 0] M_AXI_ARADDR,
		// Burst length. The burst length gives the exact number of transfers in a burst
		output wire [7 : 0] M_AXI_ARLEN,
		// Burst size. This signal indicates the size of each transfer in the burst
		output wire [2 : 0] M_AXI_ARSIZE,
		// Burst type. The burst type and the size information, 
    // determine how the address for each transfer within the burst is calculated.
		output wire [1 : 0] M_AXI_ARBURST,
		// Lock type. Provides additional information about the
    // atomic characteristics of the transfer.
		output wire  M_AXI_ARLOCK,
		// Memory type. This signal indicates how transactions
    // are required to progress through a system.
		output wire [3 : 0] M_AXI_ARCACHE,
		// Protection type. This signal indicates the privilege
    // and security level of the transaction, and whether
    // the transaction is a data access or an instruction access.
		output wire [2 : 0] M_AXI_ARPROT,
		// Quality of Service, QoS identifier sent for each read transaction
		output wire [3 : 0] M_AXI_ARQOS,
		// Optional User-defined signal in the read address channel.
		output wire [C_M_AXI_ARUSER_WIDTH-1 : 0] M_AXI_ARUSER,
		// Write address valid. This signal indicates that
    // the channel is signaling valid read address and control information
		output wire  M_AXI_ARVALID,
		// Read address ready. This signal indicates that
    // the slave is ready to accept an address and associated control signals
		input wire  M_AXI_ARREADY,
		// Read ID tag. This signal is the identification tag
    // for the read data group of signals generated by the slave.
		input wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_RID,
		// Master Read Data
		input wire [C_M_AXI_DATA_WIDTH-1 : 0] M_AXI_RDATA,
		// Read response. This signal indicates the status of the read transfer
		input wire [1 : 0] M_AXI_RRESP,
		// Read last. This signal indicates the last transfer in a read burst
		input wire  M_AXI_RLAST,
		// Optional User-defined signal in the read address channel.
		input wire [C_M_AXI_RUSER_WIDTH-1 : 0] M_AXI_RUSER,
		// Read valid. This signal indicates that the channel
    // is signaling the required read data.
		input wire  M_AXI_RVALID,
		// Read ready. This signal indicates that the master can
    // accept the read data and response information.
		output wire  M_AXI_RREADY
);

wire [C_M_AXI_ADDR_WIDTH-1 :0 ]  axi_awaddr;
wire                             axi_awvalid;

wire [C_M_AXI_DATA_WIDTH-1 : 0]  axi_wdata;
wire                             axi_wlast;
wire                             axi_wvalid;
wire                             axi_bready;

wire [C_M_AXI_ADDR_WIDTH-1 : 0]  axi_araddr;

wire                             axi_arvalid;
wire                             axi_rready;

	  // function called clogb2 that returns an integer which has the 
	  // value of the ceiling of the log base 2.                      
	  function integer clogb2 (input integer bit_depth);              
	  begin                                                           
	    for(clogb2=0; bit_depth>0; clogb2=clogb2+1)                   
	      bit_depth = bit_depth >> 1;                                 
	    end                                                           
	  endfunction  


//I/O Connections. Write Address (AW)
	assign M_AXI_AWID	= 'b0;
	//The AXI address is a concatenation of the target base address + active offset range
	assign M_AXI_AWADDR	= C_M_TARGET_SLAVE_BASE_ADDR + axi_awaddr;
	//Burst LENgth is number of transaction beats, minus 1
	assign M_AXI_AWLEN	= C_M_AXI_BURST_LEN - 1;
	//Size should be C_M_AXI_DATA_WIDTH, in 2^SIZE bytes, otherwise narrow bursts are used
	assign M_AXI_AWSIZE	= clogb2((C_M_AXI_DATA_WIDTH/8)-1);
	//INCR burst type is usually used, except for keyhole bursts
	assign M_AXI_AWBURST	= 2'b01;
	assign M_AXI_AWLOCK	= 1'b0;
	//Update value to 4'b0011 if coherent accesses to be used via the Zynq ACP port. Not Allocated, Modifiable, not Bufferable. Not Bufferable since this example is meant to test memory, not intermediate cache. 
	assign M_AXI_AWCACHE	= 4'b0010;
	assign M_AXI_AWPROT	= 3'h0;
	assign M_AXI_AWQOS	= 4'h0;
	assign M_AXI_AWUSER	= 'b1;
	assign M_AXI_AWVALID	= axi_awvalid;
	//Write Data(W)
	assign M_AXI_WDATA	= axi_wdata;
	//All bursts are complete and aligned in this example
	assign M_AXI_WSTRB	= {(C_M_AXI_DATA_WIDTH/8){1'b1}};
	assign M_AXI_WLAST	= axi_wlast;
	assign M_AXI_WUSER	= 'b0;
	assign M_AXI_WVALID	= axi_wvalid;
	//Write Response (B)
	assign M_AXI_BREADY	= axi_bready;
	//Read Address (AR)
	assign M_AXI_ARID	= 'b0;
	assign M_AXI_ARADDR	= C_M_TARGET_SLAVE_BASE_ADDR + axi_araddr;
	//Burst LENgth is number of transaction beats, minus 1
	assign M_AXI_ARLEN	= C_M_AXI_BURST_LEN - 1;
	//Size should be C_M_AXI_DATA_WIDTH, in 2^n bytes, otherwise narrow bursts are used
	assign M_AXI_ARSIZE	= clogb2((C_M_AXI_DATA_WIDTH/8)-1);
	//INCR burst type is usually used, except for keyhole bursts
	assign M_AXI_ARBURST	= 2'b01;
	assign M_AXI_ARLOCK	= 1'b0;
	//Update value to 4'b0011 if coherent accesses to be used via the Zynq ACP port. Not Allocated, Modifiable, not Bufferable. Not Bufferable since this example is meant to test memory, not intermediate cache. 
	assign M_AXI_ARCACHE	= 4'b0010;
	assign M_AXI_ARPROT	= 3'h0;
	assign M_AXI_ARQOS	= 4'h0;
	assign M_AXI_ARUSER	= 'b1;
	assign M_AXI_ARVALID	= axi_arvalid;
	//Read and Read Response (R)
	assign M_AXI_RREADY	= axi_rready;



reg [ C_M_AXI_ADDR_WIDTH - 1 : 0 ] dataInAddrReg;
reg [ C_M_AXI_DATA_WIDTH -1  : 0 ] dataInReg;
reg          WrEnReg = 0;


//------------------------------------------------------------
//	Write Address Channel && Write Response (B) Channel
//------------------------------------------------------------

wire  start_single_burst_write;

 AXIAddrWriteChannel AXIAddrWriteChannel_Inst(
    
    . M_AXI_ACLK                  (M_AXI_ACLK),
    . M_AXI_ARESETN               (M_AXI_ARESETN),
    . fifo_over_burst_thread      (fifo_over_burst_thread  ),

    .start_single_burst_write     (start_single_burst_write),

//Write Response (B) Channel
    .M_AXI_BVALID                (M_AXI_BVALID	),
    .axi_bready                  (axi_bready	),
    .M_AXI_BRESP                 (M_AXI_BRESP	),

//Write Address Channel
    .M_AXI_AWREADY               (M_AXI_AWREADY),     
    .axi_awvalid                 (axi_awvalid),
    .axi_awaddr					 (axi_awaddr)
);


//--------------------
//Write Data Channel
//--------------------
AXIWriteChannel AXIWriteChannel_inst
(

    .M_AXI_ACLK			(M_AXI_ACLK),
    .M_AXI_ARESETN		(M_AXI_ARESETN),

    .M_AXI_WREADY		(M_AXI_WREADY),

    .start_single_burst_write(start_single_burst_write),

    .WriteData			(dataIn				),
    .WriteDataValid		(dataInValid		),

    .write_Fifo_RdEn	(write_Fifo_RdEn	),

    .axi_wlast			(axi_wlast			),
    .axi_wvalid			(axi_wvalid			),
    .axi_wdata			(axi_wdata			)
);
 

 AXIReadChannel AXIReadChannel_inst(

        .M_AXI_ACLK		(M_AXI_ACLK		) ,
        .M_AXI_ARESETN  (M_AXI_ARESETN	) ,
		
        .read_fifo_full (read_fifo_full	) ,
        .axi_rready     (axi_rready		) ,

        .M_AXI_RDATA	(M_AXI_RDATA	),
        .M_AXI_RVALID	(M_AXI_RVALID	),
        .M_AXI_RLAST 	(M_AXI_RLAST	),
    
        .axi_data_out	(dataOut		),
        .axi_data_outValid(dataOutValid	)   
    );

 AXIAddrReadChannel AXIAddrReadChannel_inst(
        
        .M_AXI_ACLK		(M_AXI_ACLK		),
        .M_AXI_ARESETN	(M_AXI_ARESETN	),

        .rd_en			(rd_en			),

        .M_AXI_RVALID   (M_AXI_RVALID	),
        .M_AXI_RLAST    (M_AXI_RLAST	),
        .M_AXI_ARREADY  (M_AXI_ARREADY	),
        .axi_araddr     (axi_araddr		),
        .axi_arvalid  	(axi_arvalid	)    
    );



endmodule
