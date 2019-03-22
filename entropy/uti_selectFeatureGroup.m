function [aFeatMatx aFeaturesNames] = uti_selectFeatureGroup(aFeatMatx, aFeaturesNames, sSelectGroup)
% Select group of features based on a string 
%
% Inputs:
%  aFeatMatx [mxn]
%  aFeaturesNames [cell 1xn]
%  sSelectGroup [string]
%
% Outputs: 
%  only selected features
%
% Jiri Spilka, Patrice Abry, ENS Lyon 2014

switch sSelectGroup
    case 'StepEn'
        acSelect{1} = 'En';
    case 'StepEnLogAbs'
        acSelect{1} = 'EnLogAbs';
        acSelect{2} = 'Entropy';
    case 'StepEnAxDxLx'
        acSelect{1} = 'EnAx';
        acSelect{2} = 'EnDx';
        acSelect{3} = 'EnLx';
        acSelect{4} = 'Entropy';
    case 'StepEnAxDx'
        acSelect{1} = 'EnAx';
        acSelect{2} = 'EnDx';
        acSelect{3} = 'Entropy';
    case 'ApSeEnEnAxDx'
        c = 1;
        acSelect{c} = 'ApAx';c = c+1;
        acSelect{c} = 'ApDx';c = c+1;
        acSelect{c} = 'SeAx';c = c+1;
        acSelect{c} = 'SeDx';c = c+1;        
        acSelect{c} = 'EnAx';c = c+1;
        acSelect{c} = 'EnDx';c = c+1;                
        acSelect{c} = 'apen';c = c+1;
        acSelect{c} = 'sampen';c = c+1;        
        acSelect{c} = 'Entropy';c = c+1;        
    case 'Opt1'
        acSelect{1} = 'H3';
        acSelect{2} = 'MF_c1';        
        acSelect{3} = 'MF_hmin';        
        acSelect{4} = 'MF_H';
        acSelect{5} = 'decDtrdMD';
    case 'SeAxDx'
        acSelect{1} = 'SeAx';
        acSelect{2} = 'SeDx';
        acSelect{3} = 'sampen';        
    case 'ApAxDx'
        acSelect{1} = 'ApAx';
        acSelect{2} = 'ApDx';
        acSelect{3} = 'apen';         
end
%aFeaturesNames
aIdx = [];
for i = 1:length(aFeaturesNames)
    name = aFeaturesNames{i};
    
    for j = 1:length(acSelect)
        s = acSelect{j};
        stemp = name(1:min(length(name),length(s)));
        if strcmpi(stemp,s)
            aIdx = [aIdx i];
        end
    end
end

aFeatMatx = aFeatMatx(:,aIdx);
aFeaturesNames = aFeaturesNames(aIdx);