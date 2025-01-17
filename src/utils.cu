#include <float.h>
#include <math.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include "utils.h"

void vecAddDd(DTYPE *dst, DTYPE *u, DTYPE *v, size_t k)
{
    for(int i=0; i < k; i++)
        dst[i] = u[i] + v[i];
}

__host__ __device__ void vecAddUd(DTYPE *dst, unsigned int *u, DTYPE *v, size_t k)
{
#ifdef __CUDA_ARCH__

    int i = threadIdx.x + blockIdx.x * blockDim.x;
    dst[i] = u[i] + v[i];

#else

    for(int i=0; i < k; i++)
        dst[i] = u[i] + v[i];

#endif
}

__host__ __device__ void normalize(DTYPE *v, size_t n)
{
    DTYPE sum = 0;
    for(int i=0; i < n; i++)
        sum += v[i];
    for(int i=0; i < n; i++)
        v[i] /= sum;
}

DTYPE square(DTYPE x) { return x*x; }

DTYPE ligamma(DTYPE s, DTYPE x)
{
    DTYPE sum=0, term=1/s;
    for(int k=1; term >= DBL_EPSILON; sum += term, term *= x/(s + k), k++);
    return pow(x, s) * exp(-x) * sum; 
}

DTYPE uigamma(DTYPE s, DTYPE x) { return tgamma(s) - ligamma(s, x); }

DTYPE beta(DTYPE *x, size_t n)
{
    DTYPE gamma_prod=1, sum=0;
    for(int i=0; i < n; gamma_prod *= tgamma(x[i]), sum += x[i], i++);
    return gamma_prod / tgamma(sum);
}

void *abortCalloc(size_t nmemb, size_t size)
{
    void *mem = calloc(nmemb, size);
    if(mem == NULL)
        fputs("insufficient memory", stderr), abort();
    return mem;
}

void *abortMalloc(size_t size) { return abortCalloc(1, size); }
