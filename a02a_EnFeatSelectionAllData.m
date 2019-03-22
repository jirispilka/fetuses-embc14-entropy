%ENFEATSELECTIONALLDATA ## Step 2a) Feature selection of all data using Sequential feat. sel.
% Crit function: linear discriminant, metric: AUC
% Jiri Spilka, Patrice Abry, ENS Lyon 2014

clear;
close all; clc

addpath(fullfile(pwd, 'data'));

%% data
load('entropy_RR_wavecoeff_140218');
cFeat = rmfield(cFeat, 'UsedScales');
[aFeatMatx, aFeatNames] = uti_scaling2features(cFeat);

N = size(aFeatMatx,1);
y = pH <= 7.05;

%% removes features
% remove features NaN and INF
[aFeatMatx, aFeatNames] = removeFeaturesNanInf(aFeatMatx, aFeatNames);

% include only .... Entropy
[aFeatMatx,aFeatNames] = uti_selectFeatureGroup(...
    aFeatMatx, aFeatNames, 'StepEnAxDx');

%% AUC
figure(10); clf
aAUC = colAUC(aFeatMatx, y,'algorithm','ROC','plot',1);
figure(11); clf
stem(aAUC);
grid on;
set(gca,'XTick',1:length(aFeatNames))
set(gca,'XTickLabel',aFeatNames)
%rotateXLabels(gca,90);
grid on;

%% feature selection
opt = statset('display','iter');
fun = @(x_train,y_train)CritFunLDA(x_train,y_train);
[inmodel,history] = sequentialfs(fun,aFeatMatx,double(y),...
    'nfeature',5,...
    'cv','none',...
    'options',opt,...
    'direction','forward');

inmodel

history.Crit

%% figure
figure
stem(1-history.Crit)
xlabel('number of features')
ylabel('AUC')
a = axis;
axis([a(1) a(2) 0.65 1])
grid on;

%% table of features
rank_inverted = sum(history.In,1);
id = find(inmodel); % find selected features
nr = length(id); % number of selected feat

rank = nr-rank_inverted+1; % rank features, first features have rank 1 etc
rank(rank == nr + 1) = NaN; % make not selected features to NaN

[vals, idx] = sort(rank,'ascend');
aAUC = colAUC(aFeatMatx, y,'algorithm','ROC','plot',0);

notNan = sum(~isnan(vals));

for i = 1:notNan
    fprintf('%25s & %3d & %2.2f & %2.2f \\\\ \n', aFeatNames{idx(i)},rank(idx(i)),aAUC(idx(i)),1-history.Crit(i));
end
