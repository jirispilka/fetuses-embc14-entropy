%ENCOMPUTELDB ## Step 1) Compute ApEn, SampEN, and KNN entropy on LDB
% Synthetic data, RR data, and wavelets, etc.
% Jiri Spilka, Patrice Abry, ENS Lyon 2014

clear;
close all; clc;

path_v8 = '~/data/LyonDB_v8_201602_10Hz_long';
load(fullfile(path_v8, 'metainfo_currentDB.mat'));

%% Decide what to compute

bSynthetic = true; % entropy on synthetic data or RR

% !!! only one option can be chosen
bTimeSeriesRR = false;
bWaveCoeff = true; % entropy on wavelet coeff
bVarParam_r_knn = false; % vary tolerance and knn

% save to name
if bSynthetic
    sName = 'entropy_synthetic_140309';
    %sName = 'entropy_synthetic_wavecoeff_140310';
    %sName = 'entropy_synthetic_vary_r_knn_140310'
else
    sName = 'entropy_RR_140309';
    %sName = 'entropy_RR_wavecoeff_140310';
    %sName = 'entropy_RR_vary_r_knn_140310'    
end

%% example of analysis
sAnalyse = 'all';
%sAnalyse = 'pathol';

Tanalyse_min = 40;
knn = 10;
m = 3;
r = .2;

if strcmpi(sAnalyse,'all')
    % run all
    idx = find(metainfo.sig2End_min < Tanalyse_min);
    aFiles = metainfo.fileNameMat(idx);
    pH = metainfo.pH(idx);    
elseif strcmpi(sAnalyse, 'small_db')
    idx = find(metainfo.smallDbPresent);
    aFiles = metainfo.fileNameMat(idx);
    pH = metainfo.pH(idx);
elseif strcmpi(sAnalyse,'pathol')
    % run pathological
    idx= find(metainfo.pH <= 7.05);
    aFiles = metainfo.fileNameMat(idx);    
    pH = metainfo.pH(idx);
end

fs = metainfo.fs(1);
nNr = length(aFiles);
nWin_samp = Tanalyse_min*60*fs;

if bTimeSeriesRR
    aaApenRR = zeros(nNr,1);
    aaSampRR = zeros(nNr,1);
    aaEnRR = zeros(nNr,1);    
end

if bVarParam_r_knn
    aTolereance = 0.1:0.1:1;
    aKNN = 1:1:10;
    aaApenRR = zeros(nNr,length(aKNN));
    aaSampRR = zeros(nNr,length(aKNN));
    aaEnRR = zeros(nNr,length(aKNN));
end

%% process files
matlabClusterOpen;

for k = 1:nNr
    name = aFiles{k};
    fprintf('analysis of file: %s (%d/%d)\n',name,k,length(aFiles));
    
    %c = load(name);
    c = load(fullfile(path_v8, 'matfiles',strcat(name,'.mat')));
    
    data_rr = c.rr;
    data_bpm = c.bpm;
    time_ms = c.time_ms_rr;
    info = c.info;
    
    %nWin_samp = fs*60*nWin_min;
    %nOverlap_samp = fs*60*nWin_overlap_min;
    
    %% raw RRstage I,II, two segments for I stage
    [data_rr, time_ms, stageIIbegin_ms] = getDataWithoutIIstageRR(data_rr, time_ms, info);
    
    beginI = find(time_ms < (stageIIbegin_ms - Tanalyse_min*60*1000),1,'last');
    if isempty(beginI)
        beginI = 1;
    end
    
    timeI_ms = time_ms(beginI:end);
    dataI_rr = data_rr(beginI:end);
    dataI_rr = removeNaNsAtBeginAndEnd(dataI_rr);
    
    %% interpolated data
    [data_bpm, stageIIbegin_samp] = getDataWithoutIIstageBPM(data_bpm, fs, info);
    
    beginI = stageIIbegin_samp - nWin_samp;
    dataI = data_bpm(beginI+1:end);
    
    dataI = removeNaNsAtBeginAndEnd(dataI);
    
    %%
    dataI = dataI/std(dataI);
    dataI_rr = dataI_rr/std(dataI_rr);
    
    %% if SYNTHETIC
    if bSynthetic
        dataI_rr = randn(length(dataI_rr),1);
        dataI_rr = dataI_rr/std(dataI_rr);
    end
    
    %% entropy on RR
    if bTimeSeriesRR
        [apen,samp,entropyANN] = ComputeEntropyAll(dataI_rr',m,r);
        aaApenRR(k) = apen;
        aaSampRR(k) = samp;
        aaEnRR(k) = entropyANN;
    end

    %% entropy on wavelet coefficient
    if bWaveCoeff
        cFeat(k) = ComputeEntropyWaveCoeff(dataI_rr',m,r);    
    end
    
    %% RR vary K and Epsilon
    if bVarParam_r_knn
        for j=1:length(aTolereance)
            r = aTolereance(j);
            
            labels= ~isnan(dataI_rr);
            aaApenRR(k,j) = featureApEn_SR(0,dataI_rr,labels,r,1);
            
            samp = featureSampEnLake(dataI_rr',m,r,1);
            aaSampRR(k,j) = samp(end);
                       
            knn = aKNN(j);
            em3 = compute_entropy(dataI_rr,knn,m,1);
            em2 = compute_entropy(dataI_rr,knn,m-1,1);
            aaEnRR(k,j) =  em3 - em2;
        end
    end
   
    %aDataLength(k) = length(dataI_rr);
    %aDataMean(k) = median(dataI_rr);
    %aDataMedian(k) = mean(dataI_rr);
end

%% save
save(sName)
