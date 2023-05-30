proc FindExcept { } {

    #mig复位
    set_property OUTPUT_VALUE 1 [get_hw_probes user_rst -of_objects [get_hw_vios -of_objects [get_hw_devices xcku035_0] -filter {CELL_NAME=~"vio_axiDDRInst"}]]
    commit_hw_vio [get_hw_probes {user_rst} -of_objects [get_hw_vios -of_objects [get_hw_devices xcku035_0] -filter {CELL_NAME=~"vio_axiDDRInst"}]]
    #关闭工作使能
    set_property OUTPUT_VALUE 0 [get_hw_probes start_work -of_objects [get_hw_vios -of_objects [get_hw_devices xcku035_0] -filter {CELL_NAME=~"vio_axiDDRInst"}]]
    commit_hw_vio [get_hw_probes {start_work} -of_objects [get_hw_vios -of_objects [get_hw_devices xcku035_0] -filter {CELL_NAME=~"vio_axiDDRInst"}]]
    after 1000
    #错误检测复位
    set_property OUTPUT_VALUE 1 [get_hw_probes data_check_rst -of_objects [get_hw_vios -of_objects [get_hw_devices xcku035_0] -filter {CELL_NAME=~"vio_axiDDRInst"}]]
    commit_hw_vio [get_hw_probes {data_check_rst} -of_objects [get_hw_vios -of_objects [get_hw_devices xcku035_0] -filter {CELL_NAME=~"vio_axiDDRInst"}]]

    #开启ILA
    run_hw_ila [get_hw_ilas -of_objects [get_hw_devices xcku035_0] -filter {CELL_NAME=~"MIG_WrRd_AXI_inst/ila_AXI"}]
    
    #mig复位解除
    set_property OUTPUT_VALUE 0 [get_hw_probes user_rst -of_objects [get_hw_vios -of_objects [get_hw_devices xcku035_0] -filter {CELL_NAME=~"vio_axiDDRInst"}]]
    commit_hw_vio [get_hw_probes {user_rst} -of_objects [get_hw_vios -of_objects [get_hw_devices xcku035_0] -filter {CELL_NAME=~"vio_axiDDRInst"}]]
    after 1000

    #开始工作
    set_property OUTPUT_VALUE 1 [get_hw_probes start_work -of_objects [get_hw_vios -of_objects [get_hw_devices xcku035_0] -filter {CELL_NAME=~"vio_axiDDRInst"}]]
    commit_hw_vio [get_hw_probes {start_work} -of_objects [get_hw_vios -of_objects [get_hw_devices xcku035_0] -filter {CELL_NAME=~"vio_axiDDRInst"}]]

    #错误检查复位解除
    set_property OUTPUT_VALUE 0 [get_hw_probes data_check_rst -of_objects [get_hw_vios -of_objects [get_hw_devices xcku035_0] -filter {CELL_NAME=~"vio_axiDDRInst"}]]
    commit_hw_vio [get_hw_probes {data_check_rst} -of_objects [get_hw_vios -of_objects [get_hw_devices xcku035_0] -filter {CELL_NAME=~"vio_axiDDRInst"}]]

    #刷新波形
    wait_on_hw_ila [get_hw_ilas -of_objects [get_hw_devices xcku035_0] -filter {CELL_NAME=~"MIG_WrRd_AXI_inst/ila_AXI"}]    
    display_hw_ila_data [upload_hw_ila_data [get_hw_ilas -of_objects [get_hw_devices xcku035_0] -filter {CELL_NAME=~"MIG_WrRd_AXI_inst/ila_AXI"}]]

    run_hw_ila [get_hw_ilas -of_objects [get_hw_devices xcku035_0] -filter {CELL_NAME=~"ila_InOut_Data_Compare_inst"}] -trigger_now
    wait_on_hw_ila [get_hw_ilas -of_objects [get_hw_devices xcku035_0] -filter {CELL_NAME=~"ila_InOut_Data_Compare_inst"}]
    display_hw_ila_data [upload_hw_ila_data [get_hw_ilas -of_objects [get_hw_devices xcku035_0] -filter {CELL_NAME=~"ila_InOut_Data_Compare_inst"}]]

}