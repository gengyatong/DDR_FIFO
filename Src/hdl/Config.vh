`ifndef __CONFIG_VH__
`define __CONFIG_VH__

// DDR4存储数据和控制位宽定义?
`define         DDR4_ADR_WIDTH              17 
`define         DDR4_BA_WIDTH               2  
`define         DDR4_CKE_WIDTH              1  
`define         DDR4_CS_N_WIDTH             1  
`define         DDR4_DM_DBI_N_WIDTH         2  
`define         DDR4_DQ_WIDTH               16 
`define         DDR4_DQS_C_WIDTH            2  
`define         DDR4_DQS_T_WIDTH            2  
`define         DDR4_ODT_WIDTH              1  
`define         DDR4_BG_WIDTH               1  
`define         DDR4_CK_C_WIDTH             1  
`define         DDR4_CK_T_WIDTH             1  

`define C_M_AXI_BURST_LEN	 128
// Thread ID Width
`define C_M_AXI_ID_WIDTH	 4
// Width of Address Bus
`define C_M_AXI_ADDR_WIDTH	 30
// Width of Data Bus
`define C_M_AXI_DATA_WIDTH	 128
// Width of User Write Address Bus
`define C_M_AXI_AWUSER_WIDTH  0
// Width of User Read Address Bus
`define C_M_AXI_ARUSER_WIDTH  0
// Width of User Write Data Bus
`define C_M_AXI_WUSER_WIDTH	  0
// Width of User Read Data Bus
`define C_M_AXI_RUSER_WIDTH	  0
// Width of User Response Bus
`define C_M_AXI_BUSER_WIDTH	  0

//从DDR读出FIFO的缓存数据量
`define DDR_READFIFO_DATANUM 400


`define ILA_DDRWriteFifo
`define ila_AXIWriteChannel
`define ila_WriteDataChannel
`define ila_DDR_read_fifo
`define ila_axi_read_addr_channel
`define ila_InOut_Data_Compare

`endif 