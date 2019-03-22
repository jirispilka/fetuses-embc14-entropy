%ENCLASSIFYLDA ## Step 3) Select features and classify using LDA (cross validation)
% (sequential feat selection, AUC criterium)
% Jiri Spilka, Patrice Abry, ENS Lyon 2014

clear;
close all; clc

%% data
addpath(fullfile(pwd, 'data'));
load('entropy_RR_wavecoeff_140218');

cFeat = rmfield(cFeat,'UsedScales');
[aFeatMatx, aFeaturesNames] = uti_scaling2features(cFeat);

% include only Stephane Entropy
[aFeatMatx,aFeaturesNames] = uti_selectFeatureGroup( ...
    aFeatMatx, aFeaturesNames, 'StepEnAxDx');

%%
N = size(aFeatMatx,1);
y = pH <= 7.05;

%% settings
nFoldCV = 4; % number of cross validation folds (error estimation)
nFoldFeatSel = 2;  % number of folds for feature selection
nRepetition = 10; % repeat to remove sampling bias
nFeatChoose = 2; % features to select

%% init 
nNrFeat = size(aFeatMatx,2);
nCnt = nRepetition*nFoldCV;

aNrSelFeat = zeros(nRepetition,nFoldCV);
aCritVal = zeros(nRepetition,nFoldCV);

aALLAuc = zeros(nRepetition,nFoldCV);
aFmeasure = zeros(nRepetition,nFoldCV);
aRho = zeros(nRepetition,nFoldCV);

cP_all = cell(nRepetition,1);
aAllRankFeat = [];
aAllSelFeat = [];
aAllProb = [];

bCluster = true;
matlabClusterOpen;

for irep = 1:nRepetition
    
    cCV = cvpartition(y,'kfold',nFoldCV);  % K-FOLD- stratified
    cCP = cell(nFoldCV,1);
    aRankFeat = nan(nFoldCV,nNrFeat);
    aProb = nan(length(y),1);
    aSelFeat = zeros(1,nNrFeat);
    
    for ifold = 1:cCV.NumTestSets
                
        fprintf('## rep: %2d, %2d-fold CVm\n',irep,ifold);
        
        YTRAIN = y(cCV.training(ifold));
        XTRAIN = aFeatMatx(cCV.training(ifold),:);
        
        XTEST = aFeatMatx(cCV.test(ifold),:);
        YTEST = y(cCV.test(ifold));
                
        % reshuffle data
        idx = randperm(length(YTRAIN));
        XTRAIN = XTRAIN(idx,:);
        YTRAIN = YTRAIN(idx);
        
        idxs = 1:nNrFeat; % NO FS
        
        %% feature selection using Wrapper
        cvnb = cvpartition(YTRAIN,'kfold',nFoldFeatSel);
        
        fun = @(x_train,y_train,x_test,y_test)CritFunLDA(x_train,y_train,x_test,y_test);
        opt = statset('display','off');
        [inmodel,history] = sequentialfs(fun,XTRAIN,YTRAIN,...   
            'nfeatures',nFeatChoose,...
            'cv',cvnb,...
            'options',opt,...
            'direction','forward');       

        aSelFeat = aSelFeat + inmodel;
        aNrSelFeat(irep,ifold) = sum(inmodel);
        aCritVal(irep,ifold) = history.Crit(end);
        idxs = find(inmodel);
        
        % evaluate rank of features
        rank_inverted = sum(history.In,1);
        nr = length(idxs); % number of selected feat
        
        rank = nr-rank_inverted+1; % rank features, first features have rank 1 etc
        rank(rank == nr + 1) = NaN; % make not selected features to NaN
        aRankFeat(ifold,:) = rank; 
        
        %% apply feature selection
        XTRAIN = XTRAIN(:,idxs);
        XTEST = XTEST(:,idxs);        
        
        %% linear class
        [Y_hatTest, err, posterior, ~, coeffs] = classify(XTEST,XTRAIN,YTRAIN,'linear');
        %[Y_hatTest, err, posterior, ~, coeffs] = classify(XTEST,XTRAIN,YTRAIN,'quadratic');
        p = posterior(:,1);

% % plotting (only for 2 features)        
%         figure
%         hold on
%         gscatter(XTEST(:,1),XTEST(:,2),YTEST);
%         grid on;
%         
%         K = coeffs(1,2).const;
%         L = coeffs(1,2).linear;
%         f = @(x,y) K + L(1)*x + L(2)*y;
%         
%         %Q = coeffs(1,2).quadratic;
%         %f = @(x,y) K + L(1)*x + L(2)*y ...
%         %    + Q(1,1)*x.^2 + (Q(1,2)+Q(2,1))*x.*y + Q(2,2)*y.^2;
%         h = ezplot(f);
%         set(h, 'Color', 'k','Linewidth',2);   % Make the line magenta
%         hold off
%         
%         aAUC = colAUC(p, YTEST,'algorithm','ROC','plot',0)
%         r = corr([XTEST,p,pH(cCV.test(ifold))])
%         pause 
%         close all        


        %% SVM
% %         figure
%         yt = convertLabels(YTRAIN,[0,1],[-1,1]);
%         cSvm = svmtrain(XTRAIN,double(yt),...
%             'kernel_function','linear','showplot',false,...
%             'kktviolationlevel',0.05);
%             %'Method','LS');
%         
%         Y_hatTest = svmclassify(cSvm,XTEST,'showplot',false);
%         Y_hatTest = convertLabels(Y_hatTest,[-1,1],[0,1]);
%         
%         shift = cSvm.ScaleData.shift;
%         scale = cSvm.ScaleData.scaleFactor;
%         
%         Xnew = XTEST;
%         Xnew = bsxfun(@plus,Xnew,shift);
%         Xnew = bsxfun(@times,Xnew,scale);
%         
%         sv = cSvm.SupportVectors;
%         alphaHat = cSvm.Alpha;
%         bias = cSvm.Bias;
%         kfun = cSvm.KernelFunction;
%         kfunargs = cSvm.KernelFunctionArgs;
%         
%         p = kfun(sv,Xnew,kfunargs{:})'*alphaHat(:) + bias;
%         p = -p; % flip the sign to get the score for the +1 class
%                 
% %         %figure
% %         aAUC = colAUC(p, YTEST,'algorithm','ROC','plot',0)
% %         pause 
% %         close all

        %% eval
        [cP,sM] = classificationPerformance(Y_hatTest,YTEST,1);
        cCP{ifold} = cP;
        %aProb(cCV.test(ifold),1) = p;
        
        aALLAuc(irep,ifold) = colAUC(p, YTEST);
        aFmeasure(irep,ifold) = cP.Fmeasure;
        r = corr(p,pH(cCV.test(ifold)),'type','Pearson');
        %r = corr(p,pH(cCV.test(ifold)),'type','Spearman');
        aRho(irep,ifold) = r(1,end);
               
    end
    aAllSelFeat = [aAllSelFeat; aSelFeat];
    aAllRankFeat = [aAllRankFeat; aRankFeat];
    aAllProb = [aAllProb , aProb];
    cP_all{irep} = cCP;
end

%% analyse results
nanmean(aAllRankFeat);
rank = round(100*sum(aAllSelFeat)/(nRepetition*nFoldCV));


meanAuc = median(aALLAuc(:));
[h,p,ci,stats] = ttest(aALLAuc(:));
%meanRho = median(aRho(:))

fprintf('\n ## Resulting AUC \n')
fprintf('auc: %2.2f (%2.2f-%2.2f)\n',meanAuc,ci(1),ci(2));

% evaluation
c = [];
for i = 1:length(cP_all)
    c = [c; cP_all{i}];
end
cP_iter = c;

fprintf('\n ## Details \n')
printClassificationResults(cP_iter,nCnt);

%% selected features
fprintf('\n ## Selected features \n')

rank = round(100*sum(aAllSelFeat)/(nRepetition*nFoldCV));

[vals, idx] = sort(rank,'descend');
aAUC = colAUC(aFeatMatx, y,'algorithm','ROC','plot',0);

for i = 1:length(vals)
   fprintf('%25s & %3d & %2.2f & %2.2f \\\\ \n', aFeaturesNames{idx(i)},rank(idx(i)),nanmean(aAllRankFeat(:,idx(i))),aAUC(idx(i)));
end
