% *********************************************************************************
% Author       : luzexiao
% E-mail       : zexiaooo@foxmail.com
% File         : fft_ip_top.m
% Create       : 2025-01-15 15:57:28
% Description  : FFT ip top module
%                din: nx1 array
%==================================================================================
% Date         By              Revision        Change Description
%----------------------------------------------------------------------------------
% 2025-01-15   luzexiao        1.0             Original
%==================================================================================

function dou = fft_ip_top(din, cfg)

% cfg.fft_ifft % 0-fft, 1-ifft
% cfg.fft_len % fft length
% cfg.twd_wid % fft twiddle factors fixed point data width
% cfg.fl_fx % 0-float point, 1-fixed point

%% ----------- Generate the twiddle factors

twdcfg = cfg;
twd_lut = gen_twd_lut(twdcfg);


%% ----------- Data preprocessing
if cfg.fft_ifft == 1 % ifft
    din = conj(din);
end

%% ----------- FFT Calculation - Radix2

len_log2 = log2(cfg.fft_len);
levnum = len_log2;
fprintf('Number of level = %d\n',levnum);

lev_data = zeros(cfg.fft_len,levnum+1);
lev_din = din;

lev_cfg = cfg;
lev_cfg.last_lev = 0;

%% ----------- Radix2 Levels (Last level is not included)
for cnt_lev = 0:1:levnum-2
    % Level input
    lev_cfg.group_num = 2^cnt_lev;
    lev_twd_lut = twd_lut(1:2^cnt_lev:cfg.fft_len);
    % Level calculation
    lev_dou = fft_radix2_levn(lev_din, lev_twd_lut, lev_cfg);
    % Level output
    lev_data(:,cnt_lev+1) = lev_dou;
    lev_din = lev_dou;
end


%% ----------- Last Level of Radix2
lev_cfg.last_lev = 1;
lev_cfg.group_num = 2^(levnum-1);

lev_dou = fft_radix2_levn(lev_din, 0, lev_cfg);


%% ----------- Data postprocessing
if cfg.fft_ifft == 1 % ifft
	lev_dou = conj(lev_dou);
end

%% ----------- Output
dou = lev_dou;

% % bit reverse opration
% dou = bit_invert(lev_dou);




