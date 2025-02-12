% *********************************************************************************
% Author       : luzexiao
% E-mail       : zexiaooo@foxmail.com
% File         : gen_twd_lut.m
% Create       : 2025-01-15 15:57:28
% Description  : Generate the fft twiddle factors
%==================================================================================
% Date         By              Revision        Change Description
%----------------------------------------------------------------------------------
% 2025-01-15   luzexiao        1.0             Original
%==================================================================================

% cfg.lut_len: lut length, must be 2^n. cfg.fl_fx: 0-float point, 1-fixed point
% cfg.twd_wid: fix point data width

function twd_lut = gen_twd_lut(cfg)

lut_len = cfg.fft_len;

twd_lut = zeros(lut_len,1);


twd_lut(1:lut_len) = exp(-1i*2*pi*(0:lut_len-1)/lut_len);

if cfg.fl_fx == 1 % Fixed point
    twd_lut_t = round(twd_lut * 2^(cfg.twd_wid-1));
    twd_lut_real = min(2^(cfg.twd_wid-1)-1,real(twd_lut_t));
    twd_lut_imag = min(2^(cfg.twd_wid-1)-1,imag(twd_lut_t));
    twd_lut = complex(twd_lut_real, twd_lut_imag);
end

