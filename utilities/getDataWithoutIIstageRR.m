function [dataI_rr, timeI_ms, stageIIbegin_ms] = getDataWithoutIIstageRR(data_rr, time_ms, info)
% removes second stage from data
% Jiri Spilka, ENS Lyon, 2014

bPlot = false;

stageII_min = info.stageII_min;
sig2end_min = info.sig2End_min;

if isnan(stageII_min)
    stageII_min=0;
end

if stageII_min <= sig2end_min
    stageIIbegin_ms = time_ms(end);
else
    stageIIbegin_ms = time_ms(end)  - 1000*60*(stageII_min - sig2end_min);
end

endI = find(time_ms < stageIIbegin_ms,1,'last');

timeI_ms = time_ms(1:endI);
dataI_rr = data_rr(1:endI);

if bPlot
    figure
    hold on;
    plot(time_ms,data_rr,'k')
    plot(timeI_ms,dataI_rr,'r')
    grid on;
end