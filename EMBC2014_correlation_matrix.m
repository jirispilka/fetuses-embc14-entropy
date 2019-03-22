%EMBC2014_CORRELATION_MATRIX ## Step 4) Plot correlation matrix for features
% Jiri Spilka, Patrice Abry, ENS Lyon 2014

clear
close all; clc

%% figure properties
lx=5;  % in cm
ly=5;   % in cm
margex=[1.4 1.2 1.0];
margey=[1.2 .3 1.6];
marge=0;
orientat='portrait';% ou landscape

mkrsize=4;
fntsize=12;
labsize=10;
txtsize=10;
interpret='none';
plotlinewidth=.6;
lw = 1;

ncol=1; nrows=1;
[hh1, AX,lxtot] = figaxes(ncol, nrows, lx, ly, margex, margey, marge, orientat);

figure(hh1);
set(hh1,'units','centimeters'); 
set(hh1,'PaperType','A4');

%% compute correlations

addpath(fullfile(pwd, 'data'));
load('entropy_RR_wavecoeff_140218');

cFeat = rmfield(cFeat,'UsedScales');
[aFeatMatx, aFeaturesNames] = uti_scaling2features(cFeat);

% include only Stephane Entropy
[aFeatMatx,aFeaturesNames] = uti_selectFeatureGroup( ...
    aFeatMatx, aFeaturesNames, 'StepEnAxDx');

% reorder
aFeaturesNames{13} = 'EnAxN0';
id = [13,7:12,1:6];
aFeatMatx = aFeatMatx(:,id);
aFeaturesNames = aFeaturesNames(id);

% rename
for i = 1:length(aFeaturesNames)
    sname = aFeaturesNames{i};
    s = sname(3);
    j = sname(end);
    aFeaturesNames{i} = sprintf('$h_{%s(%s)}$',s,j);
end
    
N = size(aFeatMatx,1);
y = pH <= 7.05;

aLabels = aFeaturesNames;
[~,n] = size(aFeatMatx);
order = 1:n;

[~,nl] = size(aLabels);
if iscell(aLabels)
    aLabels = char(aLabels);
end

[mrow,ncols] = size(aFeatMatx);
sim = ones(ncols,ncols);
aP = zeros(ncols,ncols);

for i = 1:n
    for j = 1:n
        [h1]=lillietest(aFeatMatx(:,i));
        [h2]=lillietest(aFeatMatx(:,j));
        if h1 || h2
            sType = 'Spearman';
        else
            sType = 'Pearson';
        end
        [sim(i,j), aP(i,j)] = corr(aFeatMatx(:,i),aFeatMatx(:,j),'type',sType);
    end
end

%% plot figure 

col=1; lin=1; H=AX{(col)}{lin};
axes(H); 
set(H, 'fontsize', labsize); 
set(H,'LineWidth',plotlinewidth)

sim = [sim zeros(n,1); [zeros(1,n) 1]]; % last row and column are not used
pcolor(0.5:1:n+0.5,0.5:1:n+0.5,sim), colormap('jet')

set(gca,'Ydir','reverse')
set(gca,'YTickLabel',[],'YTick',[])
set(gca,'XTickLabel',[],'XTick',[])
% set(gca, 'XTick', 1:n);
% set(gca, 'YTick', 1:n);

axis('square')

os = 0.90*nl/50;

text(-n*os*ones(n,1)+0.5*ones(n,1)+0.6,(1:n)-0.2,aLabels(order,:))
z = get(gca,'Children');
set(z(1:n),'FontSize',fntsize)

text((1:n)-.15,zeros(1,n)+0.4,aLabels(order,:))
z = get(gca,'Children');
set(z(1:n),'Rotation',90);
set(z(1:n),'FontSize',fntsize)

hold on
%plot([-n*os n+0.5],[-n*os -n*os],'-k');
%plot([-n*os n+0.5],[n+.5 n+.5],'-k');
%plot([-n*os -n*os],[-n*os n+.5],'-k');
%plot([n+0.5 n+0.5],[-n*os n+.5],'-k');
hold off
axis image
axis tight
hc = colorbar;
set(hc,'FontSize',fntsize)
z=get(hc,'position');
set(hc,'position', [z(1)+0.12 z(2) z(3) z(4)]);

%% LAPRINT
% set(0,'defaulttextinterpreter','none')
% laprint(1,'fig3CorrMatx','factor',1,'width',lxtot,'asonscreen','off','keepfontprops','on','mathticklabels','on','figcopy','on');
