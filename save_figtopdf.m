function save_figtopdf(filename, h, bgcolor)
% Save figure to PDF and crop edges.
% Made by Daniel Cox
% Version 1.0
%
% Usages:
%   save_fig_pdf
%   save_fig_pdf(filename)
%   save_fig_pdf(filename, h)
%   save_fig_pdf(filename, h, bgcolor)
%
% Input:
%   filename: Name or path of the output file. Default: 'figure'.
%   h:        The figure number or handler. Default: current figure.
%   bgcolor:  Backgroundcolor of the figure. Default: 'white';
%
% Note for Linux users:
% At the time of writing, using subscripts and superscripts in figure
% titles seems to yield incorrect spacings when exporting to PDF.

if nargin < 1                   % Default filename
    filename = 'figure';        % Just call it 'figure'
end

if nargin < 2                   % Default figure
    h = gcf;                    % Use current figure
end

if nargin < 3                   % Default background color
    bgcolor = 'white';          % White
end

tempcolor = get(h, 'Color');    % Current background color of figure
set(h, 'Color', bgcolor);       % Set background color
set(h, 'InvertHardcopy', 'off');% Required for colored text and background

set(h, 'Units', 'Inches');      % Set figure units to inches
pos = get(h, 'Position');       % Get figure positions in inches
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h, filename, '-dpdf');    % Write to PDF file

set(h, 'Color', tempcolor);     % Restore background color
