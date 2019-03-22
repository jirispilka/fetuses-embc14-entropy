function err = CritFunLDA(xtrain,ytrain,xtest,ytest)
% Apply linear discriminant to trainning/test data. Called from sequentialfs.m
% Jiri Spilka, Patrice Abry, ENS Lyon 2014

if ~exist('xtest','var')
    xtest = xtrain;
    ytest = ytrain;
end

%% linear or quadratic
[y_pred, err, posterior, ~, coeffs] = classify(xtest,xtrain,ytrain,'linear');
% %[y_pred, err, posterior, ~, coeffs] = classify(xtest,xtrain,ytrain,'quadratic');
d = posterior(:,1);

%% log reg
% [betaHatNom,dev,stats] = mnrfit(xtrain,ytrain+1,'model','nominal','interactions','on');
% p = mnrval(betaHatNom,xtrain,'model','nominal','interactions','on');
% d = p(:,2);

%%
% yt = convertLabels(ytrain,[0,1],[-1,1]);
% cSvm = svmtrain(xtrain,double(yt),...
%     'kernel_function','linear','showplot',false,...
%     'kktviolationlevel',0.05,...
%     'Method','LS');
% 
% shift = cSvm.ScaleData.shift;
% scale = cSvm.ScaleData.scaleFactor;
% 
% Xnew = xtest;
% Xnew = bsxfun(@plus,Xnew,shift);
% Xnew = bsxfun(@times,Xnew,scale);
% 
% sv = cSvm.SupportVectors;
% alphaHat = cSvm.Alpha;
% bias = cSvm.Bias;
% kfun = cSvm.KernelFunction;
% kfunargs = cSvm.KernelFunctionArgs;
% 
% d = kfun(sv,Xnew,kfunargs{:})'*alphaHat(:) + bias;
% d = -d; % flip the sign to get the score for the +1 class

%% AUC
if length(unique(ytest)) == 1
    auc = 0;
else
    auc = colAUC(d, ytest);
end

% auc
err = 1-auc;

%% correlation
% r = corr(d,ytest,'type','Spearman');
% %r = corr(p,ytest,'type','Pearson');
% err = 1-abs(r);

%% visualization

% if size(xtrain,2) == 2
%     figure
%     hold on
%     gscatter(xtest(:,1),xtest(:,2),ytest);
%     grid on;
%     
%     K = coeffs(1,2).const;
%     L = coeffs(1,2).linear;
%     %f = @(x,y) K + L(1)*x + L(2)*y;    
%     
%     Q = coeffs(1,2).quadratic;
%     f = @(x,y) K + L(1)*x + L(2)*y ...
%         + Q(1,1)*x.^2 + (Q(1,2)+Q(2,1))*x.*y + Q(2,2)*y.^2;
%     h = ezplot(f);
%     set(h, 'Color', 'k','Linewidth',2);   % Make the line magenta
%     hold off
%     
%     % C = confusionmat(y,pre_quad)
%     % yt1 = convertLabels(X(:,2) < -0.8,[0,1],[1,2]);
%     % C = confusionmat(y,yt1)
%     
%     %figure
%     aAUC = colAUC(d, ytest,'algorithm','ROC','plot',0);
%     
%     aAUC
%     pause
%     close all
% end
