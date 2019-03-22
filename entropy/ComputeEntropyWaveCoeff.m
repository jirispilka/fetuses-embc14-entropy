function [cFeat] = ComputeEntropyWaveCoeff(data,m,r)
% For given time series compute ApEn, SampEn, and KNN entropy on Dx, Ax, Lx
%
% Input:
%  data - [nx1] file name
%  m - [int] embedding dimension
%  r - [int] tolerance parameter
%
% Output:
%  cFeat - [struct] contains the computed entropies
%
% Jiri Spilka, Patrice Abry, 
% ENS Lyon 2014

Nwt=3;

if ~exist('data_bpm','var')
    data_bpm = data;
end

[mcol, mrow] = size(data);
if mcol > mrow
    data = data';
end

[coefB, leadersB, nj] =  DxLx1d_js(data, Nwt);
nscale=length(coefB);

nUsedScales = 8;
%nUsedScales = nscale;

for ia=1:nUsedScales % loop on the scales
    
    tmpDx = coefB(ia).value_noabs;
    tmpAx = coefB(ia).approW;
    tmpLx = leadersB(ia).value;
    
    % entropy of normalized DWT coefs
    temp=tmpDx./nanstd(tmpDx);
    [ApDxN(ia),SeDxN(ia),EnDxN(ia)] = ComputeEntropyAll(temp,m,r);

    temp=tmpAx./nanstd(tmpAx);
    [ApAxN(ia),SeAxN(ia),EnAxN(ia)] = ComputeEntropyAll(temp,m,r);    
    

end

cFeat.EnDxN = EnDxN;
cFeat.EnAxN = EnAxN;
