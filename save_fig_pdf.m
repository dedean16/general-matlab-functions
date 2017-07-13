function save_fig_pdf(filename,h)
% Save current figure to PDF
% and crop edges.
%
% Usages:
%   save_fig_pdf
%   save_fig_pdf(filename)
%   save_fig_pdf(filename,fig)
%
% fig can be either the figure number or handler
%
% Default filename:  'figure'
% Default figure:    current figure

if nargin < 1
    filename = 'figure';        % Just call it 'figure'
end

if nargin < 2
    h = gcf;                    % Use current figure
end

set(h,'Units','Inches');
pos = get(h,'Position');        % Get figure positions in inches
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h,filename,'-dpdf','-r0') % Write to PDF file
