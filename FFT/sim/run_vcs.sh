#!/bin/bash

# 清理旧文件
rm -rf simv* csrc *.log *.fsdb

# 编译设计
vcs -full64 -sverilog -debug_all \
    ../rtl/fft_256.v \
    ../tb/tb_fft_256.v \
    -l compile.log

# 运行仿真
./simv -l sim.log