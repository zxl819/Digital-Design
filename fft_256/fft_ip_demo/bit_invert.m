% *********************************************************************************
% Author       : luzexiao
% E-mail       : zexiaooo@foxmail.com
% File         : bit_invert.m
% Create       : 2025-01-15 15:57:28
% Description  : FFT bit reverse opration
%                din: nx1 array
%==================================================================================
% Date         By              Revision        Change Description
%----------------------------------------------------------------------------------
% 2025-01-15   luzexiao        1.0             Original
%==================================================================================
function dou = bit_invert(din)

din_len = length(din);
dou = din;
bit_num = floor(log2(din_len));

%% Radix2 bit reverse opration
for ii = 1:din_len
    bin_in = de2bi(ii-1, bit_num, 'left-msb');
    ord_o = bi2de(bin_in,'right-msb');
    % fprintf('%3d ----> %3d\n',ord_o, ii-1);
    dou(ord_o+1) = din(ii);
end
