function fig_resize(height,AR,axnum,fig)
% Figure Resize
% Made by Daniel Cox
% Version 1.0
%
% Resize figure by height and aspect ratio.
%
% Alternatively, instead of specifying the inner dimensions of the figure,
% the height and aspect ratio can be specified for a chosen axes. The inner
% dimensions of the figure will be scaled accordingly.
%
% Usages:
%   fig_resize
%   fig_resize(height)
%   fig_resize(height,AR)
%   fig_resize(height,AR,axnum)
%   fig_resize(height,AR,axnum,fig)
%
% height = Inner height in pixels of the figure. Default is 500 pixels.
% AR     = Aspect Ratio. Inner width/height ratio. Default is 1.
% ax     = Child axes number to set height and AR for. Default is 0.
% fig    = Figure handler or figure number. Default is current.
%
% Positions will be set such that figure center will remain the same.
%
% If child is 0 or omitted or figure contains no axes handlers,
% the height and AR apply to the figure itself. If the figure contains
% multiple axes or other objects, these will be scaled accordingly.
%
% Axes number supports polar axes as well as straight axes.

if nargin == 0              % Default height
    height = 500;
end

if nargin < 2               % Default aspect ratio
    AR = 1;
end

if nargin < 3               % Default child number
    axnum = 0;
end

if nargin < 4               % Default figure
    h = gcf;
else
    h = figure(fig);
end

% Determine if resize will be done on axes or figure (figmode)
if axnum
    % Find all axes in figure
    allaxes = findobj(h,'type','axes','-or','type','polaraxes');
    nax = length(allaxes);
    if axnum > nax                          % Check axes number
        error('Given axes number is %i, but figure contains %i axes.',axnum,nax)
    else
        figmode = false;                    % Will apply on axes
        ax = allaxes(axnum);                % Get axes handler
    end
else
    figmode = true;                         % Will apply on figure
end


% Fetch previous position
units = h.Units;                            % Save units for later
h.Units = 'pixels';                         % Use pixels
fip = h.InnerPosition;                      % Get inner figure position
fop = h.OuterPosition;                      % Get outer figure position

% Calculate center position
xc = fop(1) + fop(3)/2;
yc = fop(2) + fop(4)/2;

% Keep inner x, y the same
x = fip(1);
y = fip(2);

% Calculate and set inner width and height
if figmode
    % Use width and height directly for figure
    width = height * AR;                    
    h.InnerPosition = [x y width height];
else
    % Use width and height for chosen axes
    axunits = ax.Units;                     % Save units for later
    ax.Units = 'normalized';                % Use normalized units
    axp = ax.Position;                      % Fetch axes position
    hinn = height / axp(4);                 % Calculate figure height
    winn = height * AR / axp(3);            % Calculate figure width
    h.InnerPosition = [x y winn hinn];      % Set inner position figure
    ax.Units = axunits;                     % Revert units
end

% Figure center might have moved - Calculate center position shift
fops = h.OuterPosition;
dxc = xc - fops(1) - fops(3)/2;
dyc = yc - fops(2) - fops(4)/2;

% Set new outer position to correct center
h.OuterPosition = [fops(1)+dxc fops(2)+dyc fops(3) fops(4)];
h.Units = units;                            % Revert units
