% *********************************************************************************
% Author       : luzexiao
% E-mail       : zexiaooo@foxmail.com
% File         : btf_rdx2.m
% Create       : 2025-01-15 15:57:28
% Description  : Radix2 buterfly
%                din: 2x1 array twd: 2x1 array
%==================================================================================
% Date         By              Revision        Change Description
%----------------------------------------------------------------------------------
% 2025-01-15   luzexiao        1.0             Original
%==================================================================================

function res = btf_rdx2(din, twd, cfg)

% cfg.fl_fx
% cfg.twd_wid

res = zeros(1,2);

res(1) = (din(1) + din(2)) * twd(1);
res(2) = (din(1) - din(2)) * twd(2);


if cfg.fl_fx == 1
	res = floor(res/2^(cfg.twd_wid-1));
end