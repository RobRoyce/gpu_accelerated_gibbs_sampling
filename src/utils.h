#pragma once

#include <math.h>

// add `u` and `v` of length `k` and store the result in `dst`
void vec_add_dd(double *dst, double *u, double *v, size_t k);
void vec_add_ud(double *dst, unsigned int *u, double *v, size_t k);

void normalize(double *v, size_t n);

inline double square(double x) { return x * x; }

double ligamma(double s, double x);

double uigamma(double s, double x) { return tgamma(s) - ligamma(s, x); }

double beta(double *x, size_t n);

// try to malloc/calloc and abort if unsuccessful
void *abort_calloc(size_t nmemb, size_t size);
void *abort_malloc(size_t size) { return abort_calloc(1, size); }
