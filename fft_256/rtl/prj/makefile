.PHONY:vcs_com vcs_sim verdi

OUTPUT = simv
TIMESCALE = 1ns/1ns

#start vcs compile
vcs_com:
	cd ../vcs && ${VCS_HOME}/bin/vcs -full64 -sverilog -debug_acc+all -f file_list.f -o ${OUTPUT} -l compile.log

#start vcs sim
vcs_sim:
	cd ../vcs && ./${OUTPUT} -l sim.log

# #start verdi
# verdi:
# 	cd ../verdi && verdi -f ../vcs/file_list.f -ssf fft_waveform.fsdb

#ifft start verdi
verdi:
	cd ../verdi && verdi -f ../vcs/file_list.f -ssf ifft_waveform.fsdb

#syn
DC:
	cd ../syn_dc && dc_shell -f synth.tcl

