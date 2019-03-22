function [apen,samp,entropyANN] = ComputeEntropyAll(data,m,r,k_nn,fs)
%COMPUTEENTROPYALL For given time series compute ApEn, SampEn, and KNN
%
% Inputs:
%  data [nx1]
%  m [int] - embedding dimension
%  r [float] - tolerance parameter
%  knn [int] - number of nearest neighbour
% 
%
% Jiri Spilka, Patrice Abry, 
% ENS Lyon 2014

if ~exist('knn','var')
    k_nn = 10;
end

if ~exist('fs','var')
    fs = 10;
end

data = double(data);

labels= ~isnan(data);
apen = featureApEn_SR(0,data,labels,r,1);

[ncol,nrow] = size(data);
if ncol > nrow
    data = data';
end

%samp = 0;
temp = data;
if sum(isnan(data)) ~= 0    
    if sum(isnan(data) + isinf(data)) == length(data)
        temp = zeros(size(temp'));
    else
        temp = interpolateAllGaps(temp, fs, 0);
    end
    temp = temp';
end

samp = featureSampEnLake(double(temp),m,r,1);
samp = samp(end);

labels = ones(size(data));
labels(isnan(data) | isinf(data)) = 0;
data(labels == 0) = 0;
em3 = compute_entropy(data,k_nn,m,1,labels);
em2 = compute_entropy(data,k_nn,m-1,1,labels);
entropyANN =  em3 - em2;
