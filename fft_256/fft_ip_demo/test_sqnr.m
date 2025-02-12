% *********************************************************************************
% Author       : luzexiao
% E-mail       : zexiaooo@foxmail.com
% File         : test_sqnr.m
% Create       : 2025-01-15 15:57:28
% Description  : Test the SQNR performance
%==================================================================================
% Date         By              Revision        Change Description
%----------------------------------------------------------------------------------
% 2025-01-15   luzexiao        1.0             Original
%==================================================================================

clc;clear;close all;

%% Configuration
cfg.fft_ifft = 0; % 0-fft, 1-ifft
cfg.fft_len = 2^6; % fft length
cfg.twd_wid = 14; % fft twiddle factors fixed point data width
cfg.fl_fx = 0; % 0-float point, 1-fixed point


%% Generate Test Signal
fft_point = cfg.fft_len;
fs = 20e6;
freq1 = 7e6;
freq2 = 2e6;
t = (0:fft_point-1)/fs;
Sig1 = 0.5*sin(2*pi*freq1*t);
Sig2 = 0.5*sin(2*pi*freq2*t);
NOISE = 0*randn(1,fft_point);

Sig = floor(32767*(Sig1+Sig2+NOISE));
Sig = max(-32768,min(Sig,32767));

x_real = Sig;
x_imag = Sig;

x = complex(x_real,x_imag);

%% FFT IP TOP
dou_t = fft_ip_top(x, cfg);

% bit reverse opration
dou = bit_invert(dou_t);

%% Plot IQ
figure;plot(real(dou));hold on; plot(imag(dou));
title('FFT IP IQ');

%% FFT IP vs Matlab
dou_ref = fft(x,cfg.fft_len);
figure;plot(real(dou_ref));hold on; plot(imag(dou_ref));
title('Matlab FFT IQ');

%% FFT amplitude value
figure;
plot(abs(dou));hold on;plot(abs(dou_ref),'--');
title('FFT IP and Matlab');
legend('FFT IP','Matlab');

%% SQNR Evalute 
err_val = dou-dou_ref.';
% err_val = ones(1,64);

pow_sig = sum(abs(dou).^2);
pow_err = sum(abs(err_val).^2);

sqnr = 10*log10(pow_sig/pow_err);
fprintf('SQNR = %.2f dB\n',sqnr);

figure;
plot(abs(err_val));
title('Error');

