/*=================================================================
 * featureSampEnLake.c Matlab wrapper of code http://www.physionet.org/physiotools/sampen/.
 * Jiri Spilka Lyon 2015
 *=================================================================*/

#include "mex.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

/* #define DEBUG */

void sampen(double *y, int m, double r, int n, double *res);
void normalize(double *data, int n);

/* 
 * Code from http://www.physionet.org/physiotools/sampen/
 * Authors: DK Lake (dlake at virginia dot edu), JR Moorman and Cao Hanqing
 * 
 * References
 *  Lake, D. E., J. S. Richman, M. P. Griffin, and J. R. Moorman.
 *    Sample entropy analysis of neonatal heart rate variability. Am J Physiol 2002; 283(3):R789-R797;
 *  Richman, J. S. and J. R. Moorman.
 *   Physiological time series analysis using approximate entropy and sample entropy. Am J Physiol 2000; 278(6):H2039-H2049; 
 *
 * Call from matlab:
 *   featureSampEnLake(x,m,r,bNorm) 
 * 
 *  see featureSampEnLake.m for detailes
 */

void mexFunction(int nlhs, mxArray *plhs[],
        int nrhs, const mxArray *prhs[]) {
          
    if (nrhs < 1) {
      mexErrMsgTxt("There is at least 1 input arguments required.\n");
      return;
    }  
    if ( (nrhs != 4) ) {
      mexErrMsgTxt("Wrong number of input parameters, this function requires 4 parameters. "
				  "See help for more information.\n");
      return;
    }    
    
    /* first input the data */
    if(mxIsEmpty(prhs[0])) {
      mexErrMsgTxt("Input signal is empty!!\n");
      return;
    }
    if (!(mxIsDouble(prhs[0]))){ /* refuse complex data*/
      mexErrMsgTxt("Input argument must be of type double.");
    }	    
     
    int N; /* length of input vector */
    int i;
    int m;
    double r;      
    short nflag;
    
    double *paData; /*pointer to array data*/
    double *paResults; /*pointer to results */
    
    /* input arguments */ 
    paData = mxGetPr(prhs[0]);
    N = mxGetN(prhs[0]);
    
    if (N < 2){ 
      mexErrMsgTxt("Input data are shorter than 2. (Transpose the data?)");
    }	    
    
    m = mxGetScalar(prhs[1]);
    r = mxGetScalar(prhs[2]);
    nflag = mxGetScalar(prhs[3]);
    
    /* output arguments */ 
    plhs[0] = mxCreateDoubleMatrix(m+1,1,mxREAL);    
    paResults = mxGetPr(plhs[0]);   
    
    /* init output arguments */
    for (i = 0; i < m+1; i++)
      paResults[i] = 0;    
    
#ifdef DEBUG    
    mexPrintf("length of input vector = %d\n", N);
    mexPrintf("m = %d\n", m);
    mexPrintf("r = %1.1f\n", r);
    mexPrintf("normalize = %d\n", nflag);
    mexPrintf("size of results matrix = %d\n",  mxGetN(plhs[0]));
#endif       
    
    if (nflag == 1)
    {              
      normalize(paData, N);       
#ifdef DEBUG    
      /* mexPrintf("normalizing data to standard deviation\n");      */
      /*for (i = 0; i < N; i++)
	mexPrintf("%2.2f\n", paData[i]); */
#endif       
    }

    sampen(paData, m, r, N, paResults); /* compute */
    return;
}

/* This function subtracts the mean from data, then divides the data by their
   standard deviation. */
void normalize(double *data, int n)
{
    int i;
    double mean = 0;
    double var = 0;
    for (i = 0; i < n; i++)
	mean += data[i];
    mean = mean / n;
    for (i = 0; i < n; i++)
	data[i] = data[i] - mean;
    for (i = 0; i < n; i++)
	var += data[i] * data[i];
    var = sqrt(var / (n-1));
    for (i = 0; i < n; i++)
	data[i] = data[i] / var;
}

/* sampen() calculates an estimate of sample entropy but does NOT calculate
   the variance of the estimate */
void sampen(double *y, int M, double r, int n, double *res)
{
    double *p = NULL;
    double *e = NULL;
    long *run = NULL, *lastrun = NULL, N;
    double *A = NULL, *B = NULL;
    int M1, j, nj, jj, m;
    int i;
    double y1;

    M++;
    if ((run = (long *) calloc(n, sizeof(long))) == NULL)
	exit(1);
    if ((lastrun = (long *) calloc(n, sizeof(long))) == NULL)
	exit(1);
    if ((A = (double *) calloc(M, sizeof(double))) == NULL)
	exit(1);
    if ((B = (double *) calloc(M, sizeof(double))) == NULL)
	exit(1);
    if ((p = (double *) calloc(M, sizeof(double))) == NULL)
	exit(1);

    /* start running */
    for (i = 0; i < n - 1; i++) {
	nj = n - i - 1;
	y1 = y[i];
	for (jj = 0; jj < nj; jj++) {
	    j = jj + i + 1;
	    if (((y[j] - y1) < r) && ((y1 - y[j]) < r)) {
		run[jj] = lastrun[jj] + 1;
		M1 = M < run[jj] ? M : run[jj];
		for (m = 0; m < M1; m++) {
		    A[m]++;
		    if (j < n - 1)
			B[m]++;
		}
	    }
	    else
		run[jj] = 0;
	}			/* for jj */
	for (j = 0; j < nj; j++)
	    lastrun[j] = run[j];
    }				/* for i */

    N = (long) (n * (n - 1) / 2);
    p[0] = A[0] / N;
    res[0] = -log(p[0]);
    /* printf("SampEn(0,%g,%d) = %lf\n", r, n, -log(p[0])); */

    for (m = 1; m < M; m++) {
	p[m] = A[m] / B[m - 1];
	if (p[m] == 0)
	{
	}
	    /* printf("No matches! SampEn((%d,%g,%d) = Inf!\n", m, r, n); */
	else
	{
	    /* printf("SampEn(%d,%g,%d) = %lf\n", m, r, n, -log(p[m])); */
	    res[m] = -log(p[m]);
	}
    }

    free(A);
    free(B);
    free(p);
    free(run);
    free(lastrun);
}
