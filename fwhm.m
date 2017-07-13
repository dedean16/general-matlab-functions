function [width,xl,xr,yhm] = fwhm(x,y,ipeak,v)
% Full Width Half Maximum
% Made by Daniel Cox
% Version 1.0
%
% Usage: 
%   [width,xl,xr,yhm] = fwhm(x,y)
%   [width,xl,xr,yhm] = fwhm(x,y,ipeak)
%   [width,xl,xr,yhm] = fwhm(x,y,ipeak,v)
%   [width,xl,xr,yhm] = fwhm(x,y,[],v)
%
% width:        Full Width Half Maximum
% xl and xr:    Interpolated x-values at half maximum
% yhm:          Half Maximum
%
% Returns the Full Width Half Maximum
% of a peak y(x) in units of x. Uses linear
% interpolation to find x of half maximum.
% Assumes a signal 'smooth' enough around
% the half maximum, such that the peak contains
% only two half maximum crossings. (Crossings
% closest to peak maximum will be used.)
%
% If an empty array [], is passed as ipeak, it will
% be ignored and the function simply uses max() to
% find the peak.
%
% If the boolean v is true, the result will be plotted.

if nargin < 2
    error('Not enough input arguments. At least 2 required.')
elseif nargin == 2
    [ymax,ipeak] = max(y);                      % Find maximum
    v = 0;
elseif nargin > 2
    if isempty(ipeak)
        [ymax,ipeak] = max(y);                  % Find maximum
    else
        ymax = y(ipeak);                        % Use given index as max
    end
end

if nargin < 4
    v = 0;
end

% Find outer boundary indices

yhm = ymax/2;                                   % Find half maximum
il1  = find(y(1:ipeak) <= yhm, 1,'last');       % FWHM outer left index
ir2 = find(y(ipeak:end) <= yhm, 1) + ipeak-1;   % FWHM outer right index

% Find local slopes for linear interpolation
al = (y(il1+1) - y(il1)) / (x(il1+1) - x(il1));
ar = (y(ir2) - y(ir2-1)) / (x(ir2) - x(ir2-1));

% Interpolate FWHM x-values and find FWHM
xl = x(il1) + (yhm-y(il1)) / al;
xr = x(ir2) + (yhm-y(ir2)) / ar;
width = abs(xr - xl);

% Visualise
if v
    figure
    plot(x,y,'.-'); hold on
    plot([xl xr],[yhm yhm],'o-r'); % FWHM line
    hold off
    title(sprintf('FWHM = %e',width))
    xlabel('x'); ylabel('y')
end


