function save_fig_and_pdf(filename, h, bgcolor)
% Save figure both as PDF and as Matlab FIG file.
% Made by Daniel Cox
%
% This function will simply call save_figtopdf and the Matlab built-in
% function savefig.
%
% Usages:
%   save_fig_pdf
%   save_fig_pdf(filename)
%   save_fig_pdf(filename, h)
%   save_fig_pdf(filename, h, bgcolor)
%
% Input:
%   filename: Name or path of the output file. Default: 'figure'. Note: may
%             not end on a graphics file extension, like '.pdf' or '.fig'.
%   h:        The figure number or handler. Default: current figure.
%   bgcolor:  Backgroundcolor of the figure. Default: 'white';

if nargin < 1                   % Default filename
    filename = 'figure';        % Just call it 'figure'
end

if nargin < 2                   % Default figure
    h = gcf;                    % Use current figure
end

if nargin < 3                   % Default background color
    bgcolor = 'white';          % White
end

save_figtopdf(filename, h, bgcolor)
savefig(h, filename)

end

