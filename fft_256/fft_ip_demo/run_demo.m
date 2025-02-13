
% Define the input signal din (256-point random complex signal as an example)
% din = randn(256, 1) + 1i*randn(256, 1);  % Random complex numbers
din = (1:256)';  % Column vector of numbers from 1 to 256
% Define the configuration structure
cfg = struct();
cfg.fft_ifft = 0;        % 0 for FFT, 1 for IFFT
cfg.fft_len = 256;       % FFT length
cfg.twd_wid = 16;        % Twiddle factor width (fixed point width)
cfg.fl_fx = 0;           % 0 for floating point, 1 for fixed point

% Call the FFT function
dou = fft_ip_top(din, cfg);

% Display the output
disp(dou);
