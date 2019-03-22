%ENFEATSELECTIONCOMBINATIONS ## Step 2b) Create all possible combinations (linear discriminant) for given number of features.
% Jiri Spilka, Patrice Abry, ENS Lyon 2014

clear;
close all; clc

addpath(fullfile(pwd, 'data'));

%% data
load('entropy_RR_wavecoeff_140218');
cFeat = rmfield(cFeat,'UsedScales');

nFeatComb = 2; % how many features to combine

[aFeatMatx, aFeaturesNames] = uti_scaling2features(cFeat);
N = size(aFeatMatx,1);
y = pH <= 7.05;

%% removes features
[aFeatMatx, aFeaturesNames] = removeFeaturesNanInf(aFeatMatx, aFeaturesNames);

% include only .... Entropy
[aFeatMatx,aFeaturesNames] = uti_selectFeatureGroup(aFeatMatx, ...
    aFeaturesNames, 'StepEnAxDx');

%% AUC
% aAUC = colAUC(aFeatMatx, y,'algorithm','ROC','plot',1);
% 
% for i = 1:size(aFeatMatx,2)
%     analyseSingleFeature(aFeatMatx(:,i),y,aFeaturesNames{i});
% end

%% find combinations
nNrFeat = length(aFeaturesNames);

aAUC = zeros(nNrFeat,1);
aRHO = zeros(nNrFeat,1);
aaComb = nchoosek(1:nNrFeat,nFeatComb);

for i = 1:size(aaComb,2)
    fprintf('feat %d & ',i);
end
fprintf('corr(p,pH), AUC \n');

cnt = 0;
for i = 1:size(aaComb,1)
    xtrain = aFeatMatx(:,aaComb(i,:));
    [~, ~, posterior, ~, coeffs] = classify(xtrain,xtrain,y,'linear');
    %[~, err, posterior, ~, coeffs] = classify(xtrain,xtrain,ytrain,'quadratic');
    d = posterior(:,1);
    aAUC(i) = colAUC(d, y);
    r = corr(d, pH,'Type','Spearman');
    aRHO(i) = r(1,end);
end

%% results

%[vals,ind] = sort(aRHO,'descend');
[vals,ind] = sort(aAUC,'descend');
aaComb = aaComb(ind,:);
aOther = aRHO(ind);
%aOther = aAUC(ind);

for i = 1:min(50,length(aAUC))
    for j = 1:nFeatComb
        f1 = aFeaturesNames{aaComb(i,j)};
        fprintf('%s & ',f1);
    end
    fprintf('%2.4f %2.4f \\\\ \n',vals(i),aOther(i)); 
end
