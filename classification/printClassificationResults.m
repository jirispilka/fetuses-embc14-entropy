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
        
end

TPm = sum(TP)/nRepCV;
FPm = sum(FP)/nRepCV;
TNm = sum(TN)/nRepCV;
FNm = sum(FN)/nRepCV;

se_m = mean(se);
sp_m = mean(sp);

se_std = std(se);
sp_std = std(sp);

fprintf('SE: %1.2f (%1.2f)\n',se_m,se_std);
fprintf('SP: %1.2f (%1.2f)\n',sp_m,sp_std);

fprintf('Confussion matrix - cumulative\n');
fprintf(' %6s %6s <- classified as \n','a','b');
fprintf(' %6d %6d  | a = 0 \n',round(TPm),round(FNm));
fprintf(' %6d %6d  | b = 1 \n',round(FPm),round(TNm));
