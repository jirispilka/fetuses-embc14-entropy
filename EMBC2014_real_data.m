%EMBC2014_REAL_DATA ## Step 4) All plots related to RR data
% density normal vs abnormal, entropy on wavelets
% Jiri Spilka, Patrice Abry, ENS Lyon 2014

clear
close all; clc

addpath(fullfile(pwd, 'data'));

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

%% FIRST PLOT - Probability density

load('entropy_RR_140310');

y = pH <= 7.05;
x = aaSampRR + log(2*r); 
sAUC = '0.68 (0.60-0.74)';

[f1,x1] = ksdensity(x(y));
[f2,x2] = ksdensity(x(~y));

%%%%%%%  figure 

col=1; lin=1; H=AX{(col)}{lin};
axes(H); 
set(H, 'fontsize', labsize); 
set(H,'LineWidth',plotlinewidth)

hold on;
plot(x1,f1,'--r','LineWidth',lw)
plot(x2,f2,'k','LineWidth',lw)
grid on
hold on;
a = axis;
axis([-4 0 0 6])

hx = xlabel('SE');
set(hx,'fontsize',txtsize);
ux=get(hx,'position');
set(hx,'position', [ux(1) ux(2)+0.4]);

hy = ylabel('probability density');
set(hy,'fontsize',txtsize);
uy=get(hy,'position');
set(hy,'position', [uy(1)+0.2 uy(2)]);

m1 = mean(x);
std1 = std(x);
g1 = skewness(x);

[~,p,ks2stat] = kstest2(x(y),x(~y));

x = -3.9;
h(5) = text(x,5.5,sprintf('AUC = %s',sAUC)) ;
h(4) = text(x+0.1,4.75,sprintf('~~KS = %1.1e',p)) ;
h(1) = text(x+0.05,3,sprintf('mean = %1.2f',m1)) ;
h(2) = text(x+0.025,2.25,sprintf('~~~~SD =~ %1.2f',std1)) ;
h(3) = text(x+0.05,1.5,sprintf('skew. =~ %1.2f',g1)) ;
set(h,'fontsize',txtsize-3) ;

h = text(-3.9,0.4,'a)') ;
set(h,'fontsize',txtsize) ;

%% SECOND PLOT - Probability density KNN

x = aaEnRR; 
sXlab = 'SE'; 
sAUC = '0.64 (0.57-0.71)';

[f1,x1] = ksdensity(x(y));
[f2,x2] = ksdensity(x(~y));

%%%%%%%  figure 

col=2; lin=1; H=AX{(col)}{lin};
axes(H); 
set(H, 'fontsize', labsize); 
set(H,'LineWidth',plotlinewidth)

hold on;
plot(x1,f1,'--r','LineWidth',lw)
plot(x2,f2,'k','LineWidth',lw)
grid on
hold on;
a = axis;
axis([-4 0 0 6])

hx = xlabel('kNN');
set(hx,'fontsize',txtsize);
ux=get(hx,'position');
set(hx,'position', [ux(1) ux(2)+0.4]);

m1 = mean(x);
std1 = std(x);
g1 = skewness(x);

[~,p,ks2stat] = kstest2(x(y),x(~y));

x = -3.9;
h(5) = text(x+0.1,5.5,sprintf('AUC = %s',sAUC)) ;
h(4) = text(x+0.1,4.75,sprintf('~~KS = %1.1e',p)) ;
h(1) = text(x+0.05,3,sprintf('mean = %1.2f',m1)) ;
h(2) = text(x+0.025,2.25,sprintf('~~~~SD =~ %1.2f',std1)) ;
h(3) = text(x+0.05,1.5,sprintf('skew. =~ %1.2f',g1)) ;
set(h,'fontsize',txtsize-3) ;

h = text(-3.9,0.4,'b)') ;
set(h,'fontsize',txtsize) ;

%% THIRD PLOT - entropy as a function of scales

load('entropy_RR_vary_r_knn_140310')
apen = aaApenRR;
sampen = aaSampRR;
en = aaEnRR;
rstdtot = 0.1:0.1:1;

for i = 1:size(apen,1)
    apen(i,:) = apen(i,:) + log(2*rstdtot);
    sampen(i,:) = sampen(i,:) + log(2*rstdtot);
end

%%%%%%%  figure 
col=3; lin=1; H=AX{(col)}{lin};
axes(H); 
set(H, 'fontsize', labsize); 
set(H,'LineWidth',plotlinewidth)

hold on
errorbar(rstdtot,mean(apen),std(apen),'--xb','MarkerSize',mkrsize)
errorbar(rstdtot,mean(sampen),std(sampen),'--ok','MarkerSize',mkrsize)
errorbar(rstdtot,mean(en),std(en),'--sr','MarkerSize',mkrsize)
grid on;
a = axis;
axis([0 1.1 a(3) 1.6])
%axis([a(1) 1 0 3])

hx = xlabel('$\epsilon, k/10$');
set(hx,'fontsize',txtsize);
ux=get(hx,'position');
set(hx,'position', [ux(1) ux(2)+0.2]);

hy = ylabel('$\hat{h}_{3}$');
uy=get(hy,'position');
set(hy,'fontsize',txtsize);
set(hy,'position', [uy(1)+0.05 uy(2)]);

h = text(0.03,-2.7,'c)') ;
set(h,'fontsize',txtsize) ;

%% LAPRINT
%set(0,'defaulttextinterpreter','none')
%laprint(1,'fig1RealData','factor',1,'width',lxtot,'asonscreen','off','keepfontprops','on','mathticklabels','on','figcopy','on');
