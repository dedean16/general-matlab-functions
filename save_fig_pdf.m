function save_fig_pdf(filename,h)
% Save figure to PDF and crop edges.
%
% Usages:
%   save_fig_pdf
%   save_fig_pdf(filename)
%   save_fig_pdf(filename,h)
%
% h can be either the figure number or handler
%
% Default filename:  'figure'
% Default figure:    current figure

if nargin < 1                   % Default filename
    filename = 'figure';        % Just call it 'figure'
end

if nargin < 2                   % Default figure
    h = gcf;                    % Use current figure
end

set(h,'Units','Inches');        % Set figure units to inches
pos = get(h,'Position');        % Get figure positions in inches
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h,filename,'-dpdf','-r0') % Write to PDF file
