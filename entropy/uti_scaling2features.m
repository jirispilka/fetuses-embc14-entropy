function [aFeatMatx, aFeatNameNew] = uti_scaling2features(cFeatures)
% Transform selected scales into single features
%
% Jiri Spilka, Patrice Abry, 
% ENS Lyon 2014

aFeaturesNames = fieldnames(cFeatures)';
nNrFeatures = length(aFeaturesNames);
nNrRecords = length(cFeatures);

aFeatMatx = zeros(nNrRecords, 1000);
cnt = 0;

nNr = length(cFeatures);

for k = 1:nNrFeatures

    
    sName = aFeaturesNames{k};
    x = [cFeatures.(sName)];
    
    scales = length(x)/nNr;
    xx = vec2mat(x, scales);    
    
    [~,n] = size(xx);
    
    if n > 1
        for rr = 1:n 
            cnt = cnt + 1;
            aFeatNameNew{cnt} = strcat(sName,num2str(rr));
            aFeatMatx(:,cnt) = xx(:,rr);
        end
    else
        cnt = cnt + 1;
        aFeatNameNew{cnt} = sName;
        aFeatMatx(:,cnt) = xx;   
    end
end

aFeatMatx = aFeatMatx(:,1:cnt);