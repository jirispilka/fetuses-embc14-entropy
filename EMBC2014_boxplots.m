% Boxplot for normal and pathological records 
% (uncomment entropy you want to plot)
% Jiri Spilka, Patrice Abry, ENS Lyon 2014

close all; clc

addpath(fullfile(pwd, 'data'));
load('entropy_RR_wavecoeff_140218'); 
y = pH <= 7.05;

%% uncomment one of the following
sName1 ='figBoxplotAE';x =[cFeat.apen];
%sName1 ='figBoxplotSE';x =[cFeat.sampen];
%sName1 ='figBoxplotKNN'; x =[cFeat.entropy_ann];

% general properties
nFontSize = 10;
sFontName = 'Times';  % [Times | Courier | ]
sInterpreter = 'latex';  % [{tex} | latex]
ms = 10;
lw = 1;

% figure 1
figure(804)
hold on;
H = boxplot(x,y,'notch','on');
set(H,'Color','k','linewidth',lw);
outlier = findobj(gca,'Tag','Outliers');
set(outlier,'MarkerSize',2,'Marker','o','MarkerEdgeColor','k')
grid on

%setFigureSizeProp([1 1 4 6]); % [pos_x pos_y width_x width_y]
set(gca,'FontName',sFontName,'FontSize',nFontSize)

% ylabel('$H_{AE}$','FontName',sFontName, ...
%     'FontSize', nFontSize, ...
%     'Interpreter', sInterpreter);
xlabel('','FontName',sFontName,'FontSize', nFontSize, ...
    'Interpreter', sInterpreter);

%% print 
% print(804, '-depsc', sName1);
% unix(['epstopdf ' sName1, '.eps']);
% unix(['cp ' sName1, '.pdf /home/jirka/svn_working_copy/iga_brno/doc/papers/2014_EMBC_stephane_entropy/images/' sName1 '.pdf']);