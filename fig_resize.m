function fig_resize(height, AR, ax, fig, iterations)
    % Figure Resize - Resize figure by height and aspect ratio.
    % Author: Daniel Cox
    %
    % Usages:
    %   fig_resize
    %   fig_resize(height)
    %   fig_resize(height, AR)
    %   fig_resize(height, AR, ax)
    %   fig_resize(height, AR, ax, fig)
    %   fig_resize(height, AR, ax, fig, iterations)
    %
    % height     = Inner height in pixels of the figure. Default: 500 pixels.
    % AR         = Aspect Ratio. Inner width/height ratio. Default: 1.
    % ax         = Child axes number or handle to set height and AR for.
    %              Default: 0.
    % fig        = Figure handler or figure number. Default: current.
    % iterations = Maximum number of recursion iterations, when ax ~= 0.
    %              Default 3. When setting the size of axes, the figure is
    %              resized, and the axes are assumed to scale linearly.
    %              However, the scaling is actually slightly nonlinear. The
    %              requested axes-size can still be achieved by recursive
    %              rescaling. The recursive rescaling is stopped when the
    %              maximum number of iterations is reached, or when
    %              |change in width| + |change in height| <= 2 pixels.
    %
    %
    % Positions will be set such that figure center will remain the same.
    %
    % Alternatively, instead of specifying the inner dimensions of the figure,
    % the height and aspect ratio can be specified for a chosen axes by setting
    % ax to the axes number. The inner dimensions of the figure will be scaled
    % accordingly. Since in the latter case, the scaling of axes with figure
    % size can be slightly nonlinear, the function will by default recursively
    % rescale up to 3 iterations. This maximum can be changed with the argument
    % 'iterations'.
    %
    % If ax is 0 or omitted or figure contains no axes handlers, the height and
    % AR apply to the figure itself. If the figure contains multiple axes or
    % other objects, these will automatically be scaled accordingly.
    %
    % Axes number supports polar axes as well as straight axes.

    
    % Defaults
    if nargin == 0              % Default height
        height = 500;
    end

    if nargin < 2               % Default aspect ratio
        AR = 1;
    end

    if nargin < 3               % Default child number or handle
        ax = 0;
    end

    if nargin < 4               % Default figure
        h = gcf;
    else
        h = figure(fig);
    end

    if nargin < 5               % Default number of recursion iterations
        iterations = 2;
    end


    % Determine if resize will be done on axes or figure (figmode)
    if isnumeric(ax)                            % Axes passed as number
        if ax
            % Find all axes in figure
            allaxes = findobj(h,'type','axes','-or','type','polaraxes');
            nax = length(allaxes);
            if ax > nax                         % Check axes number
                error('Given axes number is %i, but figure contains %i axes.',ax,nax)
            else
                figmode = false;                % Will apply on axes
                axh = allaxes(ax);              % Get axes handler
            end
        else
            figmode = true;                     % Will apply on figure
        end
    else                                        % Axes passed as handle
        figmode = false;                        % Will apply on axes
        axh = ax;
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

    width = height * AR;
    
    % Calculate and set inner width and height
    if figmode
        % Use width and height directly for figure
        h.InnerPosition = [x y width height];
    else
        % Use width and height for chosen axes
        axunits = axh.Units;                    % Save units for later
        axh.Units = 'normalized';               % Use normalized units
        axp = axh.Position;                     % Fetch axes position
        hinn = height / axp(4);                 % Calculate figure height
        winn = width / axp(3);                  % Calculate figure width
        h.InnerPosition = [x y winn hinn];      % Set inner position figure
        axh.Units = axunits;                    % Revert units
    end

    % Figure center might have moved - Calculate center position shift
    fops = h.OuterPosition;
    dxc = xc - fops(1) - fops(3)/2;
    dyc = yc - fops(2) - fops(4)/2;

    % Set new outer position to correct center
    h.OuterPosition = [fops(1)+dxc fops(2)+dyc fops(3) fops(4)];
    h.Units = units;                                           % Revert units

    % Recursive rescaling to overcome nonlinear scaling
    figsizechange = sum(abs(h.InnerPosition(3:4) - fip(3:4))); % Change in size
    if ax ~= 0 && iterations > 1 && figsizechange > 2
        fig_resize(height, AR, ax, h, iterations-1)            % Scale again
    end
    
end
