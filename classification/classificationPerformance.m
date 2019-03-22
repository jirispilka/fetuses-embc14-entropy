function [cP, sConfMatx, accuracy, gMean, avgFmeas, MAE, aMatx] = classificationPerformance(y_hat,y,nPosClass,nBeta,bDebug)
% Compute various metrics
%
%  Jiri Spilka
%  Czech Technical University in Prague, 2019

if ~exist('nPosClass','var'), nPosClass = 1;end
if ~exist('nBeta','var'), nBeta = 1;end
if ~exist('bDebug','var'), bDebug = 0;end

global gBeta; gBeta = nBeta;
global gbDebug; gbDebug = bDebug;
global bConfMatLatex; bConfMatLatex = false;

y_hat = makeColumnVectror(y_hat);
y = makeColumnVectror(y);

% get type and number of classes
aClt = unique(y_hat);
aClassTypes = unique(y);
aClassTypes = unique([aClt; aClassTypes]);
nNrClasses = length(unique(aClassTypes));

if nNrClasses == 2 || nNrClasses == 1
    
    nNegClass = aClassTypes(aClassTypes ~= nPosClass);
    
    if nNrClasses == 1 && isempty(nNegClass)
        nNegClass = NaN;
    end
    
    cP = computePerformance(y_hat,y,nPosClass,nNegClass);
    cP.sDesc = strcat(num2str(nPosClass),'vs',num2str(nNegClass));
    cP.sPerf = makeStringPerf(cP);
    
    accuracy = sum(y_hat == y)/length(y_hat);   
    
    gMean =  sqrt(cP.sensitivity * cP.specificity);
    cP.gMean = gMean;
    %cP.BER = 1-(cP.sensitivity + cP.specificity)/2;
    cP.BER = (cP.sensitivity + cP.specificity)/2;
    avgFmeas = cP.Fmeasure;  
    
    % MAE
    MAE = computeMAE(nNrClasses, aClassTypes, y_hat, y);
    cP.MAE = MAE;
   
else
    
    accuracy = sum(y_hat == y)/length(y_hat);
    
    for iClass = 1:nNrClasses
        nClassSingle = aClassTypes(aClassTypes == aClassTypes(iClass));
        aClassOther = aClassTypes(aClassTypes ~= aClassTypes(iClass));
        
        aClassTemp = y;
        aPredictLabTemp = y_hat;
        sDesc = strcat(num2str(nClassSingle),'vs');
        % group the other classes into single class
        for j = 1:length(aClassOther)
            aClassTemp(aClassTemp == aClassOther(j)) = 99;
            aPredictLabTemp(aPredictLabTemp == aClassOther(j)) = 99;
            sDesc = [sDesc num2str(aClassOther(j))];
        end

        cTemp = computePerformance(aPredictLabTemp,aClassTemp,nClassSingle,99);
        cTemp.sDesc = sDesc;
        cTemp.sPerf = makeStringPerf(cTemp);
        cP(iClass) = cTemp;
    end
    
    % gMean, avgFmeas
    g = 1;
    fmeas = 0;
    for i = 1:nNrClasses
        g = g * cP(i).sensitivity*cP(i).specificity;
        fmeas = fmeas + cP(i).Fmeasure;
    end
    gMean = g^(1/nNrClasses);
    avgFmeas = fmeas/nNrClasses;
    
    % MAE
    MAE = computeMAE(nNrClasses, aClassTypes, y_hat, y);
    %cP.MAE = mae;
end

if nargout > 1
    if nNrClasses == 2
        if ~bConfMatLatex
            t = sprintf('------------- \n');
            t1 = sprintf(' %4s %4s <- classified as \n','a','b');
            t2 = sprintf(' %4d %4d | a = %2d \n',cP.TP,cP.FN,nPosClass);
            t3 = sprintf(' %4d %4d | b = %2d \n',cP.FP,cP.TN,nNegClass);
            sConfMatx = sprintf('%s%s%s%s',t,t1,t2,t3);
        else
            t1 = sprintf(' %4d & %4d \\\\\n',cP.TP,cP.FN);
            t2 = sprintf(' %4d & %4d \\\\\n',cP.FP,cP.TN);
            sConfMatx = sprintf('%s%s',t1,t2);
        end
    else
        [sConfMatx, aMatx] = makeStringConfMatxMultipleClass(y_hat,y,aClassTypes);
    end
end


%%
function cP = computePerformance(aPredictLabels,aClass,nPosClass,nNegClass)

global gBeta;

aPredictN = aPredictLabels == nNegClass;
aPredictP = aPredictLabels == nPosClass;
aClassN = aClass == nNegClass;
aClassP = aClass == nPosClass;

TP = sum(aPredictP & aClassP);
TN = sum(aPredictN & aClassN);
FP = sum(aPredictP & aClassN);
FN = sum(aPredictN & aClassP);

if sum(TP+TN+FP+FN) ~= length(aPredictLabels)
    error('These numbers has to match');
end

% warning('Zmenil jsem vypocet!!!!!!')
% t = FP;
% FP = FN;
% FN = t;

% if divide by zero - precision
if TP+FP ~= 0
    cP.precision = TP/(TP+FP);
else
    cP.precision = 0; 
end

% if divide by zero - recall, sensitivity
if TP+FN ~= 0
    cP.recall = TP/(TP+FN);
    cP.sensitivity = TP/(TP+FN);
else
    cP.recall = 0;
    cP.sensitivity = 0;
end

% specificity
if TN+FP ~= 0
    cP.specificity = TN/(TN+FP);
else
    cP.specificity = 0;
end

if cP.precision ~= 0 || cP.recall ~= 0
    cP.Fmeasure = (1+gBeta^2)*(cP.precision * cP.recall)/((gBeta^2)*cP.precision + cP.recall);
else
    cP.Fmeasure = 0;
end

cP.TP = TP;
cP.FP = FP;
cP.FN = FN;
cP.TN = TN;

%cP.ber = ((1-cP.sensitivity) + (1-cP.specificity))/2;
cP.ber = (cP.sensitivity + cP.specificity)/2;

cP.gMean =  sqrt(cP.sensitivity * cP.specificity);

% round, multiply by 100 -> round -> divide by 100
cP.sensitivity = round2Decimal(cP.sensitivity,3);
cP.specificity = round2Decimal(cP.specificity,3);
cP.precision = round2Decimal(cP.precision,3);
cP.recall = round2Decimal(cP.recall,3);
cP.Fmeasure = round2Decimal(cP.Fmeasure,3);
cP.gMean = round2Decimal(cP.gMean,3);

cP.mcc = (TP*TN-FP*FN)/(sqrt((TP+FP)*(TP+FN)*(TN+FP)*(TN+FN))+eps);

%%
function d = makeColumnVectror(d)

[m,n] = size(d);

if m < n
    d = d';
end

function MAE = computeMAE(nNrClasses, aClassTypes, aPredictLabels, aClass)

tMae = zeros(nNrClasses,1);
for i = 1:nNrClasses
    idx = aClass == aClassTypes(i);
    tMae(i) = mean(abs(aPredictLabels(idx) - aClass(idx)));
end

MAE = mean(tMae); % macro-averaging
%MAE = mean(abs(aPredictLabels - aClass)); % micro-averaging

%%
function sP = makeStringPerf(cP)

global bConfMatLatex;

if ~bConfMatLatex
 sP = sprintf('SE:  %1.3f\n SP:  %1.3f\n BER : %1.3f\n',cP.sensitivity,cP.specificity,...
     cP.ber);
else
% sP = sprintf('se:  %1.3f\n sp:  %1.3f\n pr:  %1.3f\n F:   %1.3f\n MCC: %1.3f\n',cP.sensitivity,cP.specificity,...
%     cP.precision,cP.Fmeasure,cP.mcc);    
sP = sprintf('SE:  %1.3f\n SP:  %1.3f\n G  : %1.3f\n',cP.sensitivity,cP.specificity,...
    cP.gMean);
end

%%
function [sConfMatx, aMatx] = makeStringConfMatxMultipleClass(aPredictLabels,aClass,aClassTypes)

aMatx = getConfussionMatrix(aPredictLabels,aClass);

n = length(aClassTypes);

% make header
s = '';
for i = 1:n
    s = strcat(s,sprintf(' %4d ',aClassTypes(i)));
end
t2 = sprintf('%s | <- classified as',s);
t1 = sprintf('-------------------');

% make matrix
t3 = '';
for i = 1:n
    s = '';
    for j = 1:n
        s = strcat(s,sprintf(' %4d ',aMatx(i,j)));
    end
    s = strcat(s,sprintf(' | %4d ',aClassTypes(i)));
    t3 = sprintf('%s%s\n',t3,s);
end

sConfMatx = sprintf('%s\n%s\n%s',t2,t1,t3);

