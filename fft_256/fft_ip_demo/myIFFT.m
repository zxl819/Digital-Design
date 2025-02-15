% DIF-IFFT
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
    x(r) = r + 1i*r;
end

%% 反序操作
d = bin2dec(fliplr(dec2bin([0:N-1],m)))+1;
xm{1} = x(d);

%% my_ifft
for mm = 1:m            % mm为层数
     for i = 1:2^(m-mm)        % i为组数 
         for j = 1:2^(mm-1)         % j为蝶形在组内的编号
             k = (i-1) * 2^mm + j;
             n = 2^(m-mm)*(j-1);
             [xm{mm+1}(k),xm{mm+1}(k+2^(mm-1))] = butterfly(xm{mm}(k),xm{mm}(k+2^(mm-1)),Wnr(n+1));
         end
     end
end

for i = 1:N
    re = real(xm{m+1}(i));
    im = imag(xm{m+1}(i));
    xm{m+1}(i) = im + re*1i;
end
xm{m+1} = xm{m+1}/N;

%% matlab_ifft
ifft2 = ifft(x);

%% 画图比较
plot(1:N, abs(ifft2));
hold on
plot(1:N, abs(xm{m+1}), 'r');
