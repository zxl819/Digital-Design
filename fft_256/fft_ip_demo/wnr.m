clear all; close all; clc;
%=======================================================
% Wnr calcuting
%=======================================================
N = 256;
Wnr_Re = cell(N/2, 1);  % 使用 cell 数组存储字符串
Wnr_Im = cell(N/2, 1);  % 使用 cell 数组存储字符串

for r = 0:N/2-1
    Wnr_factor  = cos(2*pi/N*r) - 1i*sin(2*pi/N*r);
    Wnr_integer = floor(Wnr_factor * 2^13);
   
    if (real(Wnr_integer) < 0)
        Wnr_real = real(Wnr_integer) + 2^16;  % 负数的补码
    else
        Wnr_real = real(Wnr_integer);
    end
    if (imag(Wnr_integer) < 0)
        Wnr_imag = imag(Wnr_integer) + 2^16;
    else
        Wnr_imag = imag(Wnr_integer);
    end
   
    Wnr{2*r+1}  = dec2hex(Wnr_real);  % 实部
    Wnr{2*r+2}  = dec2hex(Wnr_imag);  % 虚部

    Wnr_Re{r+1} = dec2hex(Wnr_real);  % 存储实部
    Wnr_Im{r+1} = dec2hex(Wnr_imag);  % 存储虚部
end