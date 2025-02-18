% 读取文件
Verilog_FFT = zeros(256,2);
Matlab_FFT = load('ifft_output');
Verilog_FFT = load('../rtl/vcs/ifft_output.txt');

Verilog_FFT_data = Verilog_FFT(:,1) + Verilog_FFT(:,2)*1i;


% %Err_val = zeros(226,2);
% Err_val(:,1) = abs(Matlab_FFT(:,1))-abs(Verilog_FFT(:,1));
% Err_val(:,2) = abs(Matlab_FFT(:,2))-abs(Verilog_FFT(:,2));
% 
figure(1);
plot(1:256, abs(Verilog_FFT_data), '-'); % 绘制 MATLAB fft 的结果，蓝色线条
hold on; % 保持当前图形窗口
plot(1:N, abs(xm{m+1}), '--'); % 绘制自定义 FFT 的结果，红色线条
plot(1:N,abs(ifft2),'-.')
hold off; % 关闭图形保持
title('VCS sim IFFT vs Custom IFFT vs Matlab'); % 添加标题
xlabel('Frequency Bin'); % x 轴标签
ylabel('Magnitude'); % y 轴标签
legend('Vcs sim IFFT', 'Custom IFFT'," Matlab IFFT"); % 添加图例
grid on; % 添加网格


 %% SQNR Evalute 
err_val2 = abs(xm{m+1})-abs(Verilog_FFT_data');
% err_val = ones(1,64);
% 
pow_sig = sum(abs(xm{m+1}).^2);
pow_err2 = sum(abs(Verilog_FFT_data).^2);
% 
sqnr2 = 10*log10(pow_sig/pow_err2);
fprintf('SQNR2 = %.2f dB\n',sqnr2);

figure;
plot(abs(err_val2));
title('Error');

