function fRes = round2Decimal(fIn,nDecimalPoints)
% ROUND2DECIMAL round to specified decimal points
%
% Synopsis:
%  fRes = round2Decimal(fIn,nDecimalPoints)
%
% Description:
%  Round to specified decimal points.
%
% Input:
%  fIn - [nxm float] vector of inputs
%  nDecimalPoints - [int] desired number of decimal points
% 
% Output:
%  fRes - [nxm int] result vector
%
% Examples:
%  round2Decimal(1.52,1)
%
% See also: 
%  
% About: 
%  Jirka Spilka
%  http://www.feld.cvut.cz
%  http://bio.felk.cvut.cz
%
% Modifications:
%

nMulti = 10^nDecimalPoints;

[m,n] = size(fIn);
fRes = zeros(m,n);

for i = 1:m
    for j = 1:n
        fIn(i,j) = fIn(i,j).*nMulti;
        fIn(i,j) = round(fIn(i,j));
        fRes(i,j) = fIn(i,j)./nMulti;
    end
end