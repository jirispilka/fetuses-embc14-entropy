function [out,uu] = featureApEn_SR(times,vals,labels,rstd,lag)
% Computes the approximate entropy of the data
% [t,v,lab] = apenhr(times,vals,labels,params)
% <params> consists of [ ]
% <rstd> gives the "filter factor" which is the length
% scale to apply in computing apen.  If rstd > 0,
% this is in terms of the standard deviation of the data.
% If rstd < 0, it's absolute value will be used as an
% absolute length scale.
% <lag> is the embedding lag.  
% Outputs:
% t   -- min and max times of the segment
% v   -- fraction of beat pairs differing by more than alpha
% lab -- fraction of beat pairs where one or both beats are invalid.
%
% When no arguments are given, the program documents itself
% [t,v,lab] = apenhr()
% <t> tells how many values in the returned t when there are arguments
% <v> tells the approximate entropy
% <lab> is a character string documenting t,v, and lab

if rstd > 0 
  r = rstd*std(vals(find(labels == 1)));
else
  r = abs(rstd);
end

m = 3;
% embed the data in p=2 and find the pre and post values
[pre,post] = getimage(lagembed(vals,m-1,lag),1); % pre(:,1)=data(2:end-1);
                                               % pre(:,2)=data(1:end-2);
                                               % post=data(3:end);

% pull out only those rows that have good labels throughout
ldata = lagembed(labels,m-1,lag);  
[lpre,lpost]= getimage(ldata,1);

% actually do the calculation
[out, uu] = apen(pre,post,r);
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y = lagembed(x_temp,M,lag)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% lagEmbed(x,dim,lag) constructs an embedding of a time series on a vector
% lagEmbed(x,dim) makes an m-dimensional embedding with lag 1
% lagEmbed(x,dim,lag) uses the specified lag
% Copyright (c) 1996 by D. Kaplan, All Rights Reserved

if nargin < 3
	lag = 1;
end
%convert x to a column
[xr,xc] = size(x_temp);
if xr == 1	
    x = x_temp';
else
    x = x_temp;
end

lx = length(x);
newsize = lx - lag*(M-1);
y = zeros(newsize,M);
i=1;
for j = 0:-lag:lag*(-(M-1))
	first=1+lag*(M-1)+j;
	last=first+newsize-1;
	if last > lx
		last = lx;
	end
	y(:,i) = x(first:last, 1);
	i = i+1;
end


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [data2, images] = getimage(data, pred)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [data2, images] = GETIMAGE(data,pred) finds the scalar images of
% the points in a time series <pred> time sets in the future
% data --- matrix of embedded data (from lagembed)
% pred --- look ahead time, default value 1
% Returns
% data2 --- a new embedded data matrix appropriately trimmed
% images --- the images (at time <pred>) of the points in data2
% This is a convenience program to trim an embedding appropriately.
% Copyright (c) 1996 by D. Kaplan, All Rights Reserved
if nargin < 2
  pred = 1;
end
images = data((1+pred):length(data),1);
data2 = data(1:(length(data)-pred),:);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [entropy ,uu]= apen(pre, post, r) % Computes approximate entropy a la Steve Pincus
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[N,p] = size(pre);
% how many pairs of points are closer than r in the pre space
phiM = 0;
% how many are closer in the post values
phiMplus1 = 0; 

phiMbis = zeros(1,N);
% how many are closer in the post values
phiMplus1bis = zeros(1,N); 

% will be used in distance calculation
foo = zeros(N,p);
% Loop over all the points
for k=1:N
   % fill in matrix foo to contain many replications of the point in question
   for j=1:p
	foo(:,j) = pre(k,j);
   end
   
   % calculate the distance 
   goo = (abs( foo - pre ) <= r );
   % which ones of them are closer than r using the max norm
   if p == 1
      closerpre = goo;
   else
      closerpre = all(goo');
   end
   lesindex=find(closerpre>.5);
 
   precount = sum(closerpre); % combien plus pres de r (pour chaque dir)
   phiM = phiM + log(precount);
   phiMbis(k) = precount;
   % of the ones that were closer in the pre space, how many are closer
   % in post also
   temp=abs( post(closerpre) - post(k) ) ;
   postcount = sum( temp < r ); 
   %postcount = sum( abs( post(closerpre) - post(k) ) < r ); 
   phiMplus1 = phiMplus1 + log(postcount);
   phiMplus1bis(k) = postcount;
 
   %lesindexM{k}=lesindex;
   ii= find( temp < r );
   %lesindexMplus1{k}=lesindex(ii);
end
%phiM/N
%phiMplus1/N
entropy = (phiM - phiMplus1)/N;
uu.phiM=phiM/N;
uu.phiMbis=phiMbis;
uu.phiMplus1=phiMplus1/N;
uu.phiMplus1bis=phiMplus1bis;
%uu.lM=lesindexM;
%uu.lMp1=lesindexMplus1;