function [yp,yq] = butterfly(xp,xq,wnr)
%BUTTERFLY 此处显示有关此函数的摘要
%   此处显示详细说明
yp = xp + xq * wnr;
yq = xp - xq * wnr;
end
