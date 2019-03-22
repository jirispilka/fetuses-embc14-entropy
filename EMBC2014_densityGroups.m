% Plot probability density for normal and abnormal 
% (uncomment line for different entropies)
% Jiri Spilka, Patrice Abry, ENS Lyon 2014

clear;
close all; clc

addpath(fullfile(pwd, 'data'));
load('entropy_RR_140310');

y = pH <= 7.05;
r = 0.2;

%% each in separate figure
sName1 ='figDensityAE_groups';
%sName1 ='figDensitySE_groups';
%sName1 ='figDensityKNN_groups';

x = aaApenRR + log(2*r); sXlab = 'AE'; sAUC = '0.65';
%x = aaSampRR + log(2*r); sXlab = 'SE'; sAUC = '0.68';
%x = aaEnRR; sXlab = 'k-NN'; sAUC = '0.64';

% general properties
nFontSize = 12;
sFontName = 'Times';  % [Times | Courier | ]              TODO complete the list
sInterpreter = 'latex';  % [{tex} | latex]
ms = 4;
lw = 1;

[f1,x1] = ksdensity(x(y));
[f2,x2] = ksdensity(x(~y));

%% figure
figure(420)
hold on;
plot(x1,f1,'--r','LineWidth',lw)
plot(x2,f2,'k','LineWidth',lw)
grid on
hold on;
a = axis;
axis([-4 0 0 6])

m1 = mean(x);
std1 = std(x);
g1 = skewness(x);

[~,p,ks2stat] = kstest2(x(y),x(~y));

h(4) = text(-3.8,5.5,sprintf('~~KS = %1.1e',p)) ;
h(5) = text(-3.8,4.75,sprintf('AUC = %s',sAUC)) ;

h(1) = text(-3.8,3,sprintf('mean = %1.2f',m1)) ;
h(2) = text(-3.8,2.25,sprintf('~~~~SD =~ %1.2f',std1)) ;
h(3) = text(-3.8,1.5,sprintf('skew. =~ %1.2f',g1)) ;
set(h,'FontName',sFontName,'FontSize',nFontSize,'Interpreter', sInterpreter) ;

%% sample entropy and KNN in one figure

% sName1 ='figDensitySEandKNN_groups';
%  
% x1 = aaSampRR + log(2*r);
% x2 = aaEnRR;
%  
% % general properties
% nFontSize = 11;
% sFontName = 'Times';  % [Times | Courier | ]              TODO complete the list
% sInterpreter = 'latex';  % [{tex} | latex]
% ms = 4;
% lw = 1;
% 
% [f1a,x1a] = ksdensity(x1(y));
% [f1n,x1n] = ksdensity(x1(~y));
% 
% [f2a,x2a] = ksdensity(x2(y));
% [f2n,x2n] = ksdensity(x2(~y));
% 
% figure(420)
% hold on;
% plot(x1a,f1a,'--r','LineWidth',lw)
% plot(x1n,f1n,'k','LineWidth',lw)
% plot(x2a,f2a,'--r','LineWidth',lw)
% plot(x2n,f2n,'k','LineWidth',lw)
% grid on
% a = axis;
% %axis([-4 0 0 6])

%%

%setFigureSizeProp([1 1 7 6]); % [pos_x pos_y width_x width_y]
set(gca,'FontName',sFontName,'FontSize',nFontSize)

% ylabel('probability density','FontName',sFontName, ...
%     'FontSize', nFontSize, ...
%     'Interpreter', sInterpreter);

xlabel(sXlab,'FontName',sFontName,'FontSize', nFontSize, ...
     'Interpreter', sInterpreter);
 
%% print
% print(420, '-depsc', sName1);
% unix(['epstopdf ' sName1, '.eps']);
% unix(['cp ' sName1, '.* /home/jirka/svn_working_copy/iga_brno/doc/papers/2014_EMBC_stephane_entropy/images/']);