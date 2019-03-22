function printClassificationResults(cClassifPerf,nFolds, nRepCV)
%
% Print results of cross-validation
%
% Inputs:
%   cClassifPerf  structure contains resualts of each fold of crossvalidation
%   nFolds        number of crossvalidation fold
%
% Outputs:
%   printed results
%
%  Jiri Spilka
%  Czech Technical University in Prague, 2010

if ~exist('nRepCV','var')
    nRepCV  = 1;
end

Ntot = nFolds*nRepCV;

se=0; sp=0;
pr=0;re=0;Fm=0;
TP=0;TN=0;FP=0;FN=0;

% nFolds == 0, the whole database was used for training
if nFolds == 0
    se = cClassifPerf.sensitivity;
    sp = cClassifPerf.specificity;
    pr = cClassifPerf.precision;
    re = cClassifPerf.recall;
    Fm = cClassifPerf.Fmeasure;
    TP = cClassifPerf.TP;
    FP = cClassifPerf.FP;
    TN = cClassifPerf.TN;
    FN = cClassifPerf.FN;
else
    N = length(cClassifPerf);
    se = zeros(N,1);
    sp = zeros(N,1);
    pr = zeros(N,1);
    Fm = zeros(N,1);
    re = zeros(N,1);
    TP = zeros(N,1);
    FP = zeros(N,1);
    TN = zeros(N,1);
    FN = zeros(N,1);
    
    for i = 1:Ntot
        
        if iscell(cClassifPerf(i))
            cP = cClassifPerf{i};
        else
            cP = cClassifPerf(i);
        end
        
        se(i) = cP.sensitivity;
        sp(i) = cP.specificity;
        pr(i) = cP.precision;
        re(i) = cP.recall;
        Fm(i) = cP.Fmeasure;
        TP(i) = cP.TP;
        FP(i) = cP.FP;
        TN(i) = cP.TN;
        FN(i) = cP.FN;
    end
    
    %figure
    %hist(sensitivity,10)
    
end

TPm = sum(TP)/nRepCV;
FPm = sum(FP)/nRepCV;
TNm = sum(TN)/nRepCV;
FNm = sum(FN)/nRepCV;

% prc = [25 75];

% fprintf('sensitivity: %1.3f [%1.3f - %1.3f]\n',median(sensitivity),prctile(sensitivity,prc));
% fprintf('specificity: %1.3f [%1.3f - %1.3f]\n',median(specificity),prctile(specificity,prc));
% fprintf('precision: %1.3f [%1.3f - %1.3f]\n',median(precision),prctile(precision,prc));
% fprintf('recall: %1.3f [%1.3f - %1.3f]\n',median(recall),prctile(recall,prc));
% fprintf('F-measure: %1.3f [%1.3f - %1.3f]\n',median(Fmeasure),prctile(Fmeasure,prc));

% [se_m, se_ci] = binofit(TPm,TPm+FNm);
% [sp_m, sp_ci] = binofit(TNm,TNm+FPm);
%[pr_m, pr_ci] = binofit(TPm,round(TPm+FPm));

se_m = mean(se);
sp_m = mean(sp);

se_std = std(se);
sp_std = std(sp);

fprintf('SE: %1.2f (%1.2f)\n',se_m,se_std);
fprintf('SP: %1.2f (%1.2f)\n',sp_m,sp_std);
%fprintf('PR: %1.2f (%1.2f - %1.3f)\n',pr_m,pr_ci);
%fprintf('F-measure: %1.3f [%1.3f - %1.3f]\n',median(Fm),prctile(Fm,prc));

% fprintf('Confussion matrix - average of cross-validation folds\n');
% fprintf(' %6s %6s <- classified as \n','a','b');
% fprintf(' %6.2f %6.2f  | a = 0 \n',TP,FN);
% fprintf(' %6.2f %6.2f  | b = 1 \n',FP,TN);

fprintf('Confussion matrix - cumulative\n');
fprintf(' %6s %6s <- classified as \n','a','b');
fprintf(' %6d %6d  | a = 0 \n',round(TPm),round(FNm));
fprintf(' %6d %6d  | b = 1 \n',round(FPm),round(TNm));

% print = [sensitivity, specificity , precision , Fmeasure];

% for i = 1:4
%     data = print(:,i);
%     fprintf('\\boxPercentConf{%d}{%d}{%d}\n',round(100*median(data)), ...
%         round(100*prctile(data,prc(1))), ...
%         round(100*prctile(data,prc(2))))
% end

% for i = 1:4
%     data = print(:,i);
%     fprintf('\\boxPercentConfS{%d}{%d}{%d}',round(100*median(data)), ...
%         round(100*prctile(data,prc(1))), ...
%         round(100*prctile(data,prc(2))))
%     
%     if i ~= 4
%         fprintf(' & ');
%     end
% end
% fprintf('\n');

