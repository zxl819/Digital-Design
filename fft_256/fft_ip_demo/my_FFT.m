% DIT-FFT
% *********************************************************************************
% Author       : xinlei
% File         : my_FFT.m
% Description  : FFT ip top module
%==================================================================================
clear;
close all;
clc;
N = 256;
m = log2(N);

%% 产生旋转系数
for r=0:N/2-1
    Wnr(r+1)  = cos(2*pi/N*r) - 1i*sin(2*pi/N*r) ;
end

%% 产生输入x
for r = 1:N
    x(r) = r + r*i*1;
end

%% 反序操作
d = bin2dec(fliplr(dec2bin([0:N-1],m)))+1;
xm{1} = x(d);

%% my_fft
for mm = 1:m            % mm为层数
     for i = 1:2^(m-mm)        % i为组数 
         for j = 1:2^(mm-1)         % j为蝶形在组内的编号
             k = (i-1) * 2^mm + j;
             n = 2^(m-mm)*(j-1);
             [xm{mm+1}(k),xm{mm+1}(k+2^(mm-1))] = butterfly(xm{mm}(k),xm{mm}(k+2^(mm-1)),Wnr(n+1));
         end
     end
end

%% matlab_fft
fft2 = fft(x);

%% 画图比较
figure(1);
plot(1:N, abs(fft2), '-'); % 绘制 MATLAB fft 的结果，蓝色线条
hold on; % 保持当前图形窗口
plot(1:N, abs(xm{m+1}), '--'); % 绘制自定义 FFT 的结果，红色线条
hold off; % 关闭图形保持
title('Matlab FFT vs Custom FFT'); % 添加标题
xlabel('Frequency Bin'); % x 轴标签
ylabel('Magnitude'); % y 轴标签
legend('MATLAB FFT', 'Custom FFT'); % 添加图例
grid on; % 添加网格
 %% SQNR Evalute 
err_val = abs(xm{m+1})-abs(fft2);
% err_val = ones(1,64);
% 
pow_sig = sum(abs(xm{m+1}).^2);
pow_err = sum(abs(err_val).^2);
% 
sqnr = 10*log10(pow_sig/pow_err);
fprintf('SQNR = %.2f dB\n',sqnr);

figure;
plot(abs(err_val));
title('Error');

%% save data
save_cplxdata(xm{m+1}','fft_output')

