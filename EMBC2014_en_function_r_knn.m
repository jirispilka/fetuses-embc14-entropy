% Plot entropy as function of k and epsilon
% Jiri Spilka, Patrice Abry, ENS Lyon 2014

clear;
close all; clc

bRR = false;
rstdtot = 0.1:0.1:1;

addpath(fullfile(pwd, 'data'));

%% RR data
if bRR
    load('entropy_RR_vary_r_knn_140310')
    sName = 'entropy_RR_param_r_knn';
    apen = aaApenRR;
    sampen = aaSampRR;
    en = aaEnRR;
else
    %% Gaussian WN
    sName = 'entropy_WN_param_r_knn';
    load entropy_synthetic_vary_r_knn_140310.mat
    apen = Ae';
    sampen = sAE';
    en = myAe';
end

%% figure properties
nFontSize = 11;
sFontName = 'Times';  % [Times | Courier | ]              TODO complete the list
sInterpreter = 'latex';  % [{tex} | latex]
ms = 4;
lw = 1;

for i = 1:size(apen,1)
    apen(i,:) = apen(i,:) + log(2*rstdtot);
    sampen(i,:) = sampen(i,:) + log(2*rstdtot);
end

figure
hold on
errorbar(rstdtot,mean(apen),std(apen),'--xb','MarkerSize',ms)
errorbar(rstdtot,mean(sampen),std(sampen),'--ok','MarkerSize',ms)
errorbar(rstdtot,mean(en),std(en),'--sr','MarkerSize',ms)
grid on;
a = axis;
axis([0 1.1 a(3) 1.6])
%axis([a(1) 1 0 3])

%setFigureSizeProp([1 1 8 7.5]); % [pos_x pos_y width_x width_y]
set(gca,'FontName',sFontName,'FontSize',nFontSize)

ylabel('$h_{32}$','FontName',sFontName,'FontSize', nFontSize, ...
    'Interpreter', sInterpreter);

xlabel('$\epsilon, k/10$','FontName',sFontName,'FontSize', nFontSize, ...
    'Interpreter', sInterpreter);

% asLabels = [{'AE'};{'SE'};{'kNN'}];
% [hleg1, hobj1] = legend( asLabels,'Location','best','Box','on','Interpreter',sInterpreter);
% textobj = findobj(hobj1, 'type', 'text');
% set(textobj,'fontsize', nFontSize-2);

%% print 
% print(1, '-depsc', sName);
% unix(['epstopdf ' sName, '.eps']);
% unix(['cp ' sName, '.pdf /home/jirka/svn_working_copy/iga_brno/doc/papers/2014_EMBC_stephane_entropy/images/' sName '.pdf']);
