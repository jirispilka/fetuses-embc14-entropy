function [aFeatMatx, aFeaturesNames] = removeFeaturesNanInf(aFeatMatx, aFeaturesNames)

%% remove features NaN and INF
iNan = isnan(aFeatMatx) | isinf(aFeatMatx);
iNotNan = sum(iNan,1) == 0;

aFeatMatx = aFeatMatx(:,iNotNan);

fprintf('removed features:\n')
aFeaturesNames(iNotNan == 0)

aFeaturesNames = aFeaturesNames(iNotNan);

