#!/bin/bash

# # 设置环境变量
# export VCS_HOME=/path/to/synopsys/vcs  # 确保指定了正确的 VCS 安装路径
# export VERDI_HOME=/path/to/synopsys/verdi # 确保指定了正确的 Verdi 安装路径

# 1. 编译 Verilog 源代码和 Testbench
echo "编译设计文件和 Testbench ..."
# $VCS_HOME/bin/vcs -full64 -sverilog -debug_all \
#     -f filelist.f # 如果有外部依赖库，使用 filelist 文件来包含

# 如果没有外部依赖库，则可以直接指定文件：
$VCS_HOME/bin/vcs -full64 -sverilog -debug_all \
   fft_256.v tb_fft.v counter.v butterfly.v -o fft_256_simv

# 2. 启动仿真
echo "启动仿真 ..."
./fft_256_simv +vcs+lic+wait -l simulation.log

# 3. 在 Verdi 中启动仿真并加载波形
echo "启动 Verdi ..."

# 假设使用 Verdi 来查看仿真波形
$VERDI_HOME/bin/verdi -sv -f -ssf verdi_waveform.ssf -l verdi.log

# 4. 仿真完成后，检查输出文件
echo "仿真完成，输出文件："
cat fft_output.txt
