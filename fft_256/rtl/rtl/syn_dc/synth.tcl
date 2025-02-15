# 设置库文件路径
set target_library "/usr/Synopsys/syn/T-2022.03-SP2/libraries/syn/gtech.db"  
set link_library "* $target_library"         

# 设置工作目录
set WORK_DIR "../syn_dc"  
# RTL代码目录
set RTL_DIR "../src"      
# Testbench目录
set TB_DIR "../tb"        

# 定义宏
set DEFINE "FSDB"

# 读取设计文件
analyze -format verilog [list \
    $RTL_DIR/butterfly.v \
    $RTL_DIR/counter.v \
    $RTL_DIR/fft256.v \
]

# 顶层模块
elaborate fft_256_2

# 设置顶层模块
current_design fft_256_2

# 链接设计
link

# 设置约束
# 例如：时钟约束
create_clock -name clk -period 10 [get_ports clk]

# 综合
compile

# 生成报告
report_timing > $WORK_DIR/timing.rpt
report_area > $WORK_DIR/area.rpt
report_power > $WORK_DIR/power.rpt

# 保存综合结果
write -format verilog -hierarchy -output $WORK_DIR/fft256_synth.v
write_sdc $WORK_DIR/fft256_synth.sdc

# 退出
exit