.PHONY:vcs_com vcs_sim verdi

OUTPUT = simv
TIMESCALE = 1ns/1ns

#start vcs compile
vcs_com:
	cd ../vcs && vcs -full64 +v2k -debug_pp -timescale=${TIMESCALE} -o ${OUTPUT} -l compile.log

#start vcs sim
vcs_sim:
	cd ../vcs && ./${OUTPUT} -l sim.log

#start verdi
verdi:
	cd ../verdi && verdi -f ../vcs/file_list.f -ssf fft_waveform.fsdb
