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
%   filename: Name or path of the output file. Note: may
%             not end on a graphics file extension, like '.pdf' or '.fig'.
%             If the FileName property of the figure is non-empty, it will
%             be used as filename. If it is empty, 'figure' will be used as
%             default filename.
%   h:        The figure number or handle. Default: current figure.
%   bgcolor:  Background color of the figure. Default: 'white';

% Set defaults
if nargin < 3                       % Default background color
    bgcolor = 'white';              % White
end

if nargin < 2                       % Default figure
    h = gcf;                        % Use current figure
end

if nargin < 1                       % Default filename
    filename = get(h, 'FileName');  % Filename from figure
    if isempty(filename)            % If it is not set (empty)
        filename = 'figure';        % Just call it 'figure'
    end
end

% Save figure to PDF and fig
save_figtopdf(filename, h, bgcolor) % Save to PDF

tempcolor = get(h, 'Color');        % Current background color of figure
set(h, 'Color', bgcolor);           % Set background color
savefig(h, filename)                % Save to fig
set(h, 'Color', tempcolor);         % Restore background color
end

