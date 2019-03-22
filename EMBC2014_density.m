% Plot probability density fnction
% Jiri Spilka, Patrice Abry, ENS Lyon 2014

clear;
close all; clc

addpath(fullfile(pwd, 'data'));
bRR = true;

%% RR time series

if bRR
    load('entropy_RR_140310');
    sName1='figEntropyDensityRR';
    
    y = pH <= 7.05;
    r = 0.2;
    
    % correction
    apen = aaApenRR + log(2*r);
    sampen = aaSampRR + log(2*r);
    en = aaEnRR;
    
    % apen = [[cFeat.apen],0] + log(2*r);
    % sampen = [[cFeat.sampen],-1] + log(2*r);
    % % apen = [[cFeat.apen],0] ;
    % % sampen = [[cFeat.sampen],-1];
    % en = [cFeat.entropy_ann];
    
    [mean(apen); std(apen); skewness(apen)]
    [mean(sampen); std(sampen); skewness(sampen)]
    [mean(en); std(en); skewness(en)]
    
    % f2 = [0,f2];
    % x2 = [0,x2];
    
    % [f1,x1] = hist(apen,100);
    % [f2,x2] = hist(sampen,100);
    % [f3,x3] = hist([cFeat.entropy_ann],100);
    %
    % f1 = slidingAvg(f1,7);
    % f2 = slidingAvg(f2,7);
    % f3 = slidingAvg(f3,7);
    
    [f1,x1] = ksdensity(apen);
    [f2,x2] = ksdensity(sampen);
    [f3,x3] = ksdensity(en);
else
    %% Gaussian white noise
    
    load('entropy_synthetic_140309');
    sName1='figEntropyDensityWN';
    r = 0.2;
    
    APGtheo= 1/2*(log(2*pi)+1)-log(2*r);
    SampGtheo=1/2*log(4*pi)-log(2*r);
    KNNGtheo = log(2*pi*exp(1))/2;
    
    apen = aaApenRR;
    sampen = aaSampRR;
    en = aaEnRR;
    
    % bias
    [mean(apen)-APGtheo; std(apen); sqrt(mean((apen-APGtheo).^2)); skewness(apen)]
    [mean(sampen)-SampGtheo; std(sampen); sqrt(mean((sampen-SampGtheo).^2)); skewness(sampen)]
    [mean(en)-KNNGtheo; std(en); sqrt(mean((en-KNNGtheo).^2)); skewness(en)]
    
    apen = aaApenRR + log(2*r);
    sampen = aaSampRR + log(2*r);
    
    % [mean(apen); std(apen); ]
    % [mean(sampen); std(sampen); skewness(sampen)]
    % [mean(en); std(en); skewness(en)]
    
    [f1,x1] = ksdensity([apen]);
    [f2,x2] = ksdensity([sampen]);
    [f3,x3] = ksdensity([en]);
    
    %saveRtable('EntropyDensityWN.tab',[en,sampen,apen], {'kNN','SE','AE',});
    %saveRtable('EntropyDensityWN.tab',[apen], {'AE'});
    
    % [f1,x1]=hist([apen;2.18],100);
    % [f2,x2]=hist([sampen;2.28],100);
    % [f3,x3]=hist([1.36;en;1.44],100);
    
    % f1 = slidingAvg(f1,7);
    % f2 = slidingAvg(f2,7);
    % f3 = slidingAvg(f3,7);
    
end

%%
% general properties
nFontSize = 11;
sFontName = 'Times';  % [Times | Courier | ]              TODO complete the list
sInterpreter = 'latex';  % [{tex} | latex]
lw = 1;

%% figure density KNN, SE
gray = [170,170,170]/255;

figure
hold on;
plot(x1,f1,'--b','LineWidth',lw)
plot(x2,f2,'k','LineWidth',lw)
plot(x3,f3,'Color','r','LineWidth',lw)
grid on
a = axis;
% axis([-4 a(2) a(3) a(4)])
%axis([a(1) a(2) 0 70])

%% figure density data length
% [f1,x1] = ksdensity(aDataLength);
% figure
% hold on;
% %plot(x1,f1,'--b','LineWidth',lw)
% plot(x1,f1,'k','LineWidth',lw)
% grid on
% a = axis;
% %axis([-3 1 a(3) a(4)])

%%
%setFigureSizeProp([1 1 8 6]); % [pos_x pos_y width_x width_y]
set(gca,'FontName',sFontName,'FontSize',nFontSize)

ylabel('probability density','FontName',sFontName,'FontSize', nFontSize, ...
    'Interpreter', sInterpreter);

xlabel('$h_{32}$','FontName',sFontName,'FontSize', nFontSize, ...
    'Interpreter', sInterpreter);

% asLabels = [{'AE'};{'SE'};{'k-NN'}];
% [hleg1, hobj1] = legend( asLabels,'Location','NorthWest','Box','on','Interpreter',sInterpreter); 
% textobj = findobj(hobj1, 'type', 'text');
% set(textobj,'fontsize', nFontSize-2);

%% print
% print(1, '-depsc', sName1);
% unix(['epstopdf ' sName1, '.eps']);
% unix(['cp ' sName1, '.* /home/jirka/svn_working_copy/iga_brno/doc/papers/2014_EMBC_stephane_entropy/images/']);