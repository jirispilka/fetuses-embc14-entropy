function [cFeat] = ComputeEntropyWaveCoeff(data,m,r)
% For given time series compute ApEn, SampEn, and KNN entropy on Dx, Ax, Lx
%
% Input:
%  data - [nx1] file name
%  m - [int] embedding dimension
%  r - [int] tolerance parameter
%
% Output:
%  cFeat - [struct] contains the computed entropies
%
% Jiri Spilka, Patrice Abry, 
% ENS Lyon 2014

Nwt=3;

if ~exist('data_bpm','var')
    data_bpm = data;
end

[mcol, mrow] = size(data);
if mcol > mrow
    data = data';
end

[coefB, leadersB, nj] =  DxLx1d_js(data, Nwt);
nscale=length(coefB);

nUsedScales = 8;
%nUsedScales = nscale;

for ia=1:nUsedScales % loop on the scales
    
    tmpDx = coefB(ia).value_noabs;
    tmpAx = coefB(ia).approW;
    tmpLx = leadersB(ia).value;
        
    % % entropy of raw DWT coefs
    %[ApTDB(ia),SeTDB(ia),EnTDB(ia)] = ComputeEntropyAll(tmpB,m,r);
    
    % % Entropy of absolute value of DWT coefs
    %[ApTDB_Abs(ia), SeTDB_Abs(ia), EnTDB_Abs(ia)] = ComputeEntropyAll(abs(tmpB),m,r);
    
    % entropy of normalized DWT coefs
    temp=tmpDx./nanstd(tmpDx);
    [ApDxN(ia),SeDxN(ia),EnDxN(ia)] = ComputeEntropyAll(temp,m,r);

    temp=tmpAx./nanstd(tmpAx);
    [ApAxN(ia),SeAxN(ia),EnAxN(ia)] = ComputeEntropyAll(temp,m,r);    
    
    %temp=tmpLx/std(tmpLx);
    %[ApLxN(ia),SeLxN(ia),EnLxN(ia)] = ComputeEntropyAll(temp,m,r);        
    
%     % entropy of the log absolute value of DWT coefs
%     temp=log(abs(tmpDx));
%     temp=temp/std(temp);
%     [ApLogAbsDx(ia),SeLogAbsDx(ia),EnLogAbsDx(ia)] = ComputeEntropyAll(temp,m,r);    
%     
%     temp=log(abs(tmpAx));
%     temp=temp/std(temp);
%     [ApLogAbsAx(ia),SeLogAbsAx(ia),EnLogAbsAx(ia)] = ComputeEntropyAll(temp,m,r);        
%     
%     temp=log(abs(tmpLx));
%     temp=temp/std(temp);
%     [ApLogAbsLx(ia),SeLogAbsLx(ia),EnLogAbsLx(ia)] = ComputeEntropyAll(temp,m,r);        
%    
% %     % Entropy of normalized absolute value of DWT coefs
% %     temp=abs(tmpB)/std(abs(tmpB));
% %     [ApTDBN_Abs(ia),SeTDBN_Abs(ia),EnTDBN_Abs(ia)]= ComputeEntropyAll(temp,m,r);
% %     
% %     % entropy of the log of  DWT coefs
% %     temp=log(abs(tmpB));
% %     [ApTDB_logAbs(ia),SeTDB_logAbs(ia),EnTDB_logAbs(ia)]= ComputeEntropyAll(temp,m,r);
% %         
% %     % entropy of the normalized log of  DWT coefs
% %     temp=temp/std(temp);
% %     [ApTDB_logAbsN(ia),SeTDB_logAbsN(ia),EnTDB_logAbsN(ia)]= ComputeEntropyAll(temp,m,r);
end

%% Costa's multiscale entropy on RR
% data = data/std(data);
% data = data';
% tmp1 = tempname;
% tmp2 = tempname;
% 
% save(tmp1,'data','-ascii')
% s = sprintf('mse -m 3 -M 3 -r 0.2 -R 0.2 -n 32 < %s > %s',tmp1,tmp2);
% unix(s);
% 
% res = importdata(tmp2);
% afMse = res.data(:,2)';
% 
% delete(tmp1,tmp2);
%
% figure
% plot(afMse)

%% Entropy on RR

% data = data/std(data);
% [apen,samp,entropyANN] = ComputeEntropyAll(data,m,r);

%% save all
% cFeat.ApTDB = ApTDB;
% cFeat.SeTDB = SeTDB;
% cFeat.EnTDB = EnTDB;
% 
% cFeat.ApTDB_Abs = ApTDB_Abs;
% cFeat.SeTDB_Abs = SeTDB_Abs;
% cFeat.EnTDB_Abs = EnTDB_Abs;
% 
% cFeat.ApDwtN = ApDxN;
% cFeat.SeDwtN = SeDwtN;
% cFeat.EnDwtN = EnDwtN;
% 
% cFeat.ApTDBN_Abs = ApTDBN_Abs;
% cFeat.SeTDBN_Abs = SeTDBN_Abs;
% cFeat.EnTDBN_Abs = EnTDBN_Abs;
% 
% cFeat.ApTDB_logAbs = ApTDB_logAbs;
% cFeat.SeTDB_logAbs = SeTDB_logAbs;
% cFeat.EnTDB_logAbs = EnTDB_logAbs;
% 
% cFeat.ApTDB_logAbsN = ApTDB_logAbsN;
% cFeat.SeTDB_logAbsN = SeTDB_logAbsN;
% cFeat.EnTDB_logAbsN = EnTDB_logAbsN;

%cFeat.ApDxN = ApDxN;
%cFeat.SeDxN = SeDxN;
cFeat.EnDxN = EnDxN;

%cFeat.ApAxN = ApAxN;
%cFeat.SeAxN = SeAxN;
cFeat.EnAxN = EnAxN;

%cFeat.ApLxN = ApLxN;
%cFeat.SeLxN = SeLxN;
%cFeat.EnLxN = EnLxN;

% cFeat.ApLogAbsDx = ApLogAbsDx;
% cFeat.SeLogAbsDx = SeLogAbsDx;
% cFeat.EnLogAbsDx = EnLogAbsDx;
% 
% cFeat.ApLogAbsAx = ApLogAbsAx;
% cFeat.SeLogAbsAx = SeLogAbsAx;
% cFeat.EnLogAbsAx = EnLogAbsAx;
% 
% cFeat.ApLogAbsLx = ApLogAbsLx;
% cFeat.SeLogAbsLx = SeLogAbsLx;
% cFeat.EnLogAbsLx = EnLogAbsLx;
% cFeat.afMse = afMse;

%cFeat.UsedScales = nUsedScales;
% cFeat.apen = apen;
% cFeat.sampen = samp;
% cFeat.entropy_ann = entropyANN;