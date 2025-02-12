# 1) 编译
vcs -full64 -sverilog -debug_access+all \
    -f filelist.f -l compile.log -o simv

# 2) 运行仿真
./simv +fsdbfile+wave.fsdb +fsdb+autoflush +fsdb+all -l sim.log

# 3) 查看波形 (若使用 Verdi)
verdi -sv -f filelist.f -ssf wave.fsdb &
