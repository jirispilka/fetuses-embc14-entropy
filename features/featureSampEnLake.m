% Function to compute Sample entropy
%  
%  Code from http://www.physionet.org/physiotools/sampen/
%  Authors: DK Lake (dlake at virginia dot edu), JR Moorman and Cao Hanqing
%
%  Matlab interface Jiri Spilka, ENS in Lyon, 2014
%   
%  References:
%   Lake, D. E., J. S. Richman, M. P. Griffin, and J. R. Moorman.
%     Sample entropy analysis of neonatal heart rate variability. Am J Physiol 2002; 283(3):R789-R797;
%   Richman, J. S. and J. R. Moorman.
%    Physiological time series analysis using approximate entropy and sample entropy. Am J Physiol 2000; 278(6):H2039-H2049; 
%  
%  Synopsis:
%    res = featureSampEnLake(x,m,r,bNorm) 
% 
%  Inputs:
%   x - [nx1] input vector
%   m - [int] embeding 
%   r - [double] tolerance 
%   bNorm - [bool] normalization flag (1 = normalize)
%
%  Outputs:
%   res - [(m+1)x1] - output sample entropy for m=0,m=1,m=2, etc
%  
%  Installation
%   run: mex featureSampEnLake.c