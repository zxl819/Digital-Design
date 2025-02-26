echo "开始编译"
iverilog -o res ./test_tb.v
echo "编译完成"

echo "生成波形文件"
vvp -n res
# cp tb_inst.vcd wave.lxt

echo "打开波形文件"
open tb_instru.vcd
