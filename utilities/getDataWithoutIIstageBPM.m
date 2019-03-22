function [dataI, stageIIbegin_samp] = getDataWithoutIIstageBPM(data_bpm, fs, info,bPlot)
% Removes second stage from BPM data
% Jiri Spilka, ENS Lyon, 2014

% warning: info.fs might contain different sampling frequency than argument fs

if ~exist('bPlot','var')
    bPlot = false;
end

stageII_min = info.stageII_min;
sig2end_min = info.sig2End_min;

if isnan(stageII_min)
    stageII_min=0;
end

if stageII_min <= sig2end_min
    stageIIbegin_samp = length(data_bpm);
else
    stageIIbegin_samp = length(data_bpm)  - round(60*fs*(stageII_min - sig2end_min));
end

dataI = data_bpm(1:stageIIbegin_samp);

if bPlot
    figure
    hold on;
    plot(data_bpm,'k')
    grid on;
    plot(1:stageIIbegin_samp,dataI,'r')
    legend('stage II','stage I')
end