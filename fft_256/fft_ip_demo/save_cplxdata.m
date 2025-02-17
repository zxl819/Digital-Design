%% Save complex number array data to file
% save_cplxdata(cplx_arr,'twd.txt');
function save_cplxdata(din,filename)

fprintf('Saving complex data file %s\n', filename);
fid = fopen(filename,'w');

% fprintf(fid,'real, imag\n');

for ii = 1:length(din)
    fprintf(fid,'%.3f, %.3f\n',real(din(ii)),imag(din(ii)));
end

fclose(fid);

fprintf('Done to save complex data file %s\n', filename);

end