% Figure of entropy on different scales (Ax, Dx)
% Jiri Spilka, Patrice Abry, ENS Lyon 2014

clear;
close all; clc

addpath(fullfile(pwd, 'data'));
load('entropy_RR_wavecoeff_140218');
%load('entropy_synthetic_wavecoeff_140310');

y = pH <= 7.05;

% general properties
nFontSize = 11;
sFontName = 'Times';  % [Times | Courier | ]              TODO complete the list
sInterpreter = 'latex';  % [{tex} | latex]
ms = 5;
lw = 1;

scales = cFeat(1).UsedScales;

%% Ax
% apen = vec2mat([cFeat.ApAxN],scales);
% sampen = vec2mat([cFeat.SeAxN],scales);
% en = vec2mat([cFeat.EnAxN],scales);
% sName1 ='figSyntheticWavCoeff_Ax';

%% Dx
apen = vec2mat([cFeat.ApDxN],scales);
sampen = vec2mat([cFeat.SeDxN],scales);
en = vec2mat([cFeat.EnDxN],scales);
sName1 ='figSyntheticWavCoeff_Dx';

%%
sampen(sampen==0) = NaN;

apen = apen + log(2*0.2);
sampen = sampen + log(2*0.2);

fK = 1.349; % standard dev. = fK*iqr
eAE = median(apen);
eAEci = iqr(apen)/fK;
eSE = nanmedian(sampen);
eSEci = iqr(sampen)/fK;
eKNN = median(en);
eKNNci = iqr(en)/fK;

% eP = median(en(y,:));
% ePci = iqr(en(y,:))/fK;
% eN = median(en(~y,:));
% eNci = iqr(en(~y,:))/fK;

ax = 1:scales;

figure(325)
hold on;
errorbar(ax-0.08,eAE,eAEci,'--xb','MarkerSize',ms,'LineWidth',lw);
errorbar(ax,eSE,eSEci,'-ok','MarkerSize',ms,'LineWidth',lw);
errorbar(ax+0.08,eKNN,eKNNci,'-sr','MarkerSize',ms,'LineWidth',lw);
grid on;
a = axis;
axis([1-0.5 6+0.5 a(3) a(4)])

%setFigureSizeProp([1 1 8 7.5]); % [pos_x pos_y width_x width_y]
set(gca,'FontName',sFontName,'FontSize',nFontSize)

ylabel('$h_{32}$','FontName',sFontName, ...
    'FontSize', nFontSize, ...
    'Interpreter', sInterpreter);
xlabel('scale ($j$)','FontName',sFontName,'FontSize', nFontSize, ...
     'Interpreter', sInterpreter);
 
% asLabels = [{'AE'}; {'SE'}; {'k-NN'}];
% [hleg1, hobj1] = legend( asLabels,'Location','SouthWest','Box','on','Interpreter',sInterpreter); 
% textobj = findobj(hobj1, 'type', 'text');
% set(textobj,'fontsize', nFontSize-2);
 
%% print
% print(325, '-depsc', sName1);
% unix(['epstopdf ' sName1, '.eps']);
% unix(['cp ' sName1, '.* /home/jirka/svn_working_copy/iga_brno/doc/papers/2014_EMBC_stephane_entropy/images/']);