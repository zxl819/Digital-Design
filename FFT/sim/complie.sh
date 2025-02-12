#!/bin/bash

# ------------------------------------------------
# 使用 VCS 进行编译，开启 debug 以支持 Verdi 波形和可视化
# ------------------------------------------------

# 需要的主要选项说明：
#   -full64               : 64位编译
#   -sverilog             : 启用 SystemVerilog 前端
#   -debug_access+all     : 生成全部调试信息 (也可用 -debug_acc 等)
#   -kdb                  : 新版 Verdi 建议开启 kdb 格式
#   -timescale=1ns/1ps    : 指定默认时间单位(如需要)
#   -f filelist.f         : 包含需要编译的文件列表
#   -l compile.log        : 日志文件
#   -o simv               : 指定生成的可执行文件名

vcs -full64 -sverilog \
    -debug_access+all \
    -kdb \
    -timescale=1ns/1ps \
    -f filelist.f \
    -l compile.log \
    -o simv
