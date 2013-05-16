#include "ruby.h"

long min_three(long a, long b, long c) {
	long min = a;
	if (b < min)
		min = b;
	if( c < min)
		min = c;
	return min;
}

long levenshtein_distance(VALUE str1, VALUE str2) {
	long i, j, s1_len, s2_len, *d;
	char * s = RSTRING_PTR(str1);
	char * t = RSTRING_PTR(str2);
	s1_len = RSTRING_LEN(str1);
	s2_len = RSTRING_LEN(str2);
	
	if (s1_len == 0) {
		return s2_len;
	} else if (s2_len == 0) {
		return s1_len;
	}
	
	// We need one extra col and row for the matrix for starting values
	s1_len++;
	s2_len++;
	
	d = xmalloc(sizeof(typeof(d)) * s1_len * s2_len);
	
	for (i = 0; i < s1_len; i++) {
		d[i] = i; // d[i, 0] = i
	}
	for (j = 0; j < s2_len; j++) {
		d[j*s1_len] = j; // d[0, j] = j
	}
	
	for (i = 1; i < s1_len; i++) {
		for (j = 1; j < s2_len; j++) {
			if (s[i-1] == t[j-1]) {
				d[j * s1_len + i] = d[(j-1) * s1_len + (i-1)];
			} else {
				d[j * s1_len + i] = 1 + min_three(
					d[j * s1_len + (i-1)],
					d[(j-1) * s1_len + i],
					d[(j-1) * s1_len + (i-1)]
				);
			}
		}
	}
	i = d[s1_len * s2_len -1];
	xfree(d);
	return i;
}

static VALUE lev_dist(VALUE self, VALUE str1, VALUE str2) {
	return LONG2FIX(levenshtein_distance( str1, str2 ));
}

static VALUE mAlgorithms;
static VALUE mString;

void Init_CString() {	
	mAlgorithms = rb_define_module("Algorithms");
	mString = rb_define_module_under(mAlgorithms, "String");
	rb_define_singleton_method(mString, "levenshtein_dist", lev_dist, 2);
}

