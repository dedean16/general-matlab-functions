function mw = weighted_median(v,w)
% Weighted Median
% Version 1.0
% by Daniel Cox
%
% Computes the weighted median of a 1D array
% with 1D weight array. Usage:
%   mw = weighted_median(v,w)
%
% v = value array
% w = weight array
%
% The returned value is chosen from the given
% array, not interpolated.

% Sort values and weights by value
[vs, is] = sort(v);
ws = w(is);

% Compute Total Weight and Cumulative Sum array
wsum = sum(w);
wcsum = cumsum(ws);

% Find index for first occurence of cumsum > totsum/2
im = find(wcsum>wsum/2,1);
mw = vs(im);
