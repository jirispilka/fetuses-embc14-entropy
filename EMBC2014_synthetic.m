%EMBC2014_SYNTHETIC ## Step 4) All plots related to synthetic data (density, entropy on wavelets, dependence on r and knn)
% Jiri Spilka, Patrice Abry, ENS Lyon 2014

clear
close all; clc

addpath(fullfile(pwd, 'data'));
%addpath '/home/jirka/svn_working_copy/iga_brno/matlab/ENSL/utilities/figures';

lx=3;  % in cm
ly=3;   % in cm
margex=[1.4 1.2 1.0];
margey=[1.2 .3 1.6];
marge=0;
orientat='portrait';% ou landscape

mkrsize=4;
fntsize=10;
labsize=10;
txtsize=10;
interpret='none';
plotlinewidth=.6;
lw = 1;

ncol=3; nrows=1;
[hh1, AX,lxtot] = figaxes(ncol, nrows, lx, ly, margex, margey, marge, orientat);

figure(hh1);
set(hh1,'units','centimeters'); 
set(hh1,'PaperType','A4');

%% FIRST PLOT - Probability density for gaussian white noise 
load('entropy_synthetic_140309');
r = 0.2;
APGtheo= 1/2*(log(2*pi)+1)-log(2*r);
SampGtheo=1/2*log(4*pi)-log(2*r);
KNNGtheo = log(2*pi*exp(1))/2;

en = aaEnRR;

% bias
% [mean(apen)-APGtheo; std(apen); sqrt(mean((apen-APGtheo).^2)); skewness(apen)]
% [mean(sampen)-SampGtheo; std(sampen); sqrt(mean((sampen-SampGtheo).^2)); skewness(sampen)]
% [mean(en)-KNNGtheo; std(en); sqrt(mean((en-KNNGtheo).^2)); skewness(en)]

apen = aaApenRR + log(2*r);
sampen = aaSampRR + log(2*r);

[f1,x1] = ksdensity([apen]);
[f2,x2] = ksdensity([sampen]);
[f3,x3] = ksdensity([en]);

%%%%%%%  figure 

col=1; lin=1; H=AX{(col)}{lin};
axes(H); 
set(H, 'fontsize', labsize); 
set(H,'LineWidth',plotlinewidth)

hold on;
plot(x1,f1,'--b','LineWidth',lw)
plot(x2,f2,'k','LineWidth',lw)
plot(x3,f3,'Color','r','LineWidth',lw)
grid on
a = axis;
axis([1.1 1.5 a(3) a(4)])
%axis([a(1) a(2) 0 70])

hx = xlabel('$\hat{h}_{3}$');
set(hx,'fontsize',txtsize);
ux=get(hx,'position');
set(hx,'position', [ux(1) ux(2)+5]);

hy = ylabel('probability density');
set(hy,'fontsize',txtsize);
uy=get(hy,'position');
set(hy,'position', [uy(1)+0.03 uy(2)]);

h = text(1.11,5,'a)') ;
set(h,'fontsize',txtsize) ;

%% SECOND PLOT - sample and KNN entropy as a function of r and KNN

load entropy_synthetic_vary_r_knn_140310.mat
apen = Ae';
sampen = sAE';
en = myAe';
rstdtot = 0.1:0.1:1;
sName = 'entropy_WN_param_r_knn';

for i = 1:size(apen,1)
    apen(i,:) = apen(i,:) + log(2*rstdtot);
    sampen(i,:) = sampen(i,:) + log(2*rstdtot);
end

%%%%%%%  figure 

col=2; lin=1; H=AX{(col)}{lin};
axes(H); 
set(H, 'fontsize', labsize); 
set(H,'LineWidth',plotlinewidth)

hold on;
errorbar(rstdtot,mean(apen),std(apen),'--xb','MarkerSize',mkrsize,'LineWidth',lw)
errorbar(rstdtot,mean(sampen),std(sampen),'--ok','MarkerSize',mkrsize,'LineWidth',lw)
errorbar(rstdtot,mean(en),std(en),'--sr','MarkerSize',mkrsize,'LineWidth',lw)
grid on;
a = axis;
axis([0 1.1 a(3) 1.6])

hx = xlabel('$\epsilon, k/10$');
set(hx,'fontsize',txtsize);
ux=get(hx,'position');
set(hx,'position', [ux(1) ux(2)+0.1]);

hy = ylabel('$\hat{h}_{3}$');
uy=get(hy,'position');
set(hy,'fontsize',txtsize);
set(hy,'position', [uy(1)+0.11 uy(2)]);

h = text(0.032,0.11,'b)') ;
set(h,'fontsize',txtsize) ;

%% THIRD PLOT - entropy as a function of scales

load('entropy_synthetic_wavecoeff_140310');
y = pH <= 7.05;

scales = cFeat(1).UsedScales;

% Ax
% apen = vec2mat([cFeat.ApAxN],scales);
% sampen = vec2mat([cFeat.SeAxN],scales);
% en = vec2mat([cFeat.EnAxN],scales);
% sName1 ='figSyntheticWavCoeff_Ax';

% Dx
apen = vec2mat([cFeat.ApDxN],scales);
sampen = vec2mat([cFeat.SeDxN],scales);
en = vec2mat([cFeat.EnDxN],scales);

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

ax = 1:scales;

%%%%%%%  figure 
col=3; lin=1; H=AX{(col)}{lin};
axes(H); 
set(H, 'fontsize', labsize); 
set(H,'LineWidth',plotlinewidth)

hold on;
errorbar(ax-0.08,eAE,eAEci,'--xb','MarkerSize',mkrsize,'LineWidth',lw);
errorbar(ax,eSE,eSEci,'-ok','MarkerSize',mkrsize,'LineWidth',lw);
errorbar(ax+0.08,eKNN,eKNNci,'-sr','MarkerSize',mkrsize,'LineWidth',lw);
grid on;
a = axis;
axis([1-0.5 6+0.5 a(3) a(4)])

hx = xlabel('scale ($j$)');
set(hx,'fontsize',txtsize);
ux=get(hx,'position');
set(hx,'position', [ux(1) ux(2)+0.2]);

hy = ylabel('$\hat{h}_{3}$');
uy=get(hy,'position');
set(hy,'fontsize',txtsize);
set(hy,'position', [uy(1)+0.4 uy(2)]);

h = text(0.7,-.78,'c)') ;
set(h,'fontsize',txtsize) ;

%% LAPRINT
%set(0,'defaulttextinterpreter','none')
%laprint(1,'fig1SynthData','factor',1,'width',lxtot,'asonscreen','off','keepfontprops','on','mathticklabels','on','figcopy','on');
