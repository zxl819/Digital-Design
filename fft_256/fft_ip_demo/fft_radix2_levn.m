% *********************************************************************************
% Author       : luzexiao
% E-mail       : zexiaooo@foxmail.com
% File         : fft_radix2_levn.m
% Create       : 2025-01-15 15:57:28
% Description  : FFT radix-2 level
%                din: nx1 array twd_lut: nx1 array
%==================================================================================
% Date         By              Revision        Change Description
%----------------------------------------------------------------------------------
% 2025-01-15   luzexiao        1.0             Original
%==================================================================================
function dou = fft_radix2_levn(din, twd_lut, cfg)
    % cfg.group_num : Number of group of the butterfly
    % cfg.fft_len : Length of the FFT
    % cfg.last_lev : Indicate this is the last level

    grp_dnum = cfg.fft_len/cfg.group_num; % Data number of a group
    grp_intv = grp_dnum/2; % Interval of butterfly unit data
    btf_num = grp_dnum/2; % Number of butterfly per group

    dou = zeros(cfg.fft_len,1);

    for cnt_group = 0:cfg.group_num-1
        for cnt_btf = 0:btf_num-1
            data_pos = cnt_group*grp_dnum + cnt_btf + (0:1)*grp_intv+1;
            % ---- 1-Obtain data
            din_btf = din(data_pos);
            % ---- 2-Obtain twiddle factors
            if(cfg.last_lev == 1)
                if cfg.fl_fx == 1
                    twd_btf = [1, 1] * 2^(cfg.twd_wid-1)-1;
                else
                    twd_btf = [1, 1];
                end
            else
                twd_btf = twd_lut((0:1)*cnt_btf+1);
            end

            % ---- 3-Butterfly calculation
            res_btf = btf_rdx2(din_btf, twd_btf, cfg);
            dou(data_pos) = res_btf;
        end
    end