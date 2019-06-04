function complexcolorwheel(varargin)
    % Complex Color Wheel
    % Author: Daniel Cox
    % Draw a color wheel to represent the complex plane, drawn with
    % the function complex2rgb, as a qualitative equivalent of a colorbar
    % for real scalar color plots.
    %
    % The color wheel itself is also drawn with complex2rgb. All options
    % will be passed to complex2rgb. See documentation of complex2rgb for
    % options related to colors. When using a struct to pass options, it
    % is recommended to use the same struct, to match the colorwheel with
    % the plot.
    % 
    %
    % Options can be passed by either a struct or Parameter Value pairs.
    % Options:
    % position:     Any of the following char arrays or strings:
    %               'topleft', 'topright', 'bottomleft', 'bottomright', or
    %               a 4-element scalar array of normalized units:
    %               [x, y, width, height]. Default: 'bottomleft'.
    % resolution:   Positive integer. Number of pixels per dimension for
    %               drawing the color wheel. Default: 256.
    % textparams:   Struct. Parameters to be passed to the label text of
    %               the colorwheel. See Text Properties for more info.
    % figure:       Figure handle or index. Set target figure. Is ignored
    %               when an axes handle is passed. Default: Current figure.
    % axes:         Axes handle or index. Set target axes. Default: Current
    %               axes.
    %
    % Note: All objects corresponding to the color wheel (the color wheel
    % itself and the text labels) are tagged with 'ComplexColorWheel'.
    % This allows easy access after the color wheel has been added.
    % For instance, the color wheel and labels can be hidden with the
    % following code:
    % wheel = findobj(gcf, 'Tag', 'ComplexColorWheel')
    % for h = 1:length(wheel)
    %   wheel(h).Visible='off';
    % end
    
    % Check and parse input parameters
    in = complexcolorparser(varargin{:});
    res = in.resolution;
    
    % Get target figure and current axes
    fig = figure(in.figure);                    % Get target figure
    currentaxes = get(fig, 'CurrentAxes');      % Remember current axes
    
    % Get target parentaxes
    if isnumeric(in.axes)                       % By axes index
        allaxes = findobj(fig,'type','axes','-or','type','polaraxes');
        parentaxes = allaxes(in.axes);
    elseif strcmp('current', in.axes)           % By CurrentAxes property
        parentaxes = get(fig, 'CurrentAxes');
    else
        parentaxes = in.axes;                   % By axes handle
    end
    
    % Determine color wheel preset position or assign normalized position
    if ischar(in.position) || isstring(in.position)
        switch in.position                      % Check for presets
            case 'topleft'
                wheelpos = [0.02 0.79 0.15 0.15];
            case 'topright'
                wheelpos = [0.81 0.79 0.15 0.15];
            case 'bottomleft'
                wheelpos = [0.02 0.02 0.15 0.15];
            case 'bottomright'
                wheelpos = [0.81 0.02 0.15 0.15];
            otherwise
                error('Invalid preset for color wheel position.')
        end
    else
        wheelpos = in.position;
    end
    
    % Compute color wheel position with respect to parent axes
    paxpos = parentaxes.Position;                   % Parent axes position
    xwheel = paxpos(1) + wheelpos(1) * paxpos(3);   % Wheel axes x
    ywheel = paxpos(2) + wheelpos(2) * paxpos(4);   % Wheel axes y
    wwheel = wheelpos(3) * paxpos(3);               % Wheel axes width
    hwheel = wheelpos(4) * paxpos(4);               % Wheel axes height
    
    
    % Option to pass 'auto' instead of a value for vscale    
    if strcmp(in.vscale, 'auto')
        vscale = 1;
    else
        vscale = in.vscale;
    end
    
    
    % Construct color image of complex unit circle
    X = linspace(-vscale, vscale, res);
    Y = X';
    R = sqrt(X.^2 + Y.^2);                          % Radius from origin
    circle = (R <= 1);                              % Circle filled with 1
    alpha = 1 - linstep(R, vscale*0.97, vscale);    % Transparency
    C = complex2rgb((X + 1i*Y) .* circle, varargin{:});
    
    % Display color image of complex unit circle
    image(axes(fig, 'Position', [xwheel ywheel wwheel hwheel]),...
        C, 'AlphaData', alpha, 'Tag', 'ComplexColorWheel');
    % Set Y-axis in normal direction, keep strictly to 1:1 aspect ratio
    set(gca, 'YDir', 'normal',...
        'DataAspectRatioMode', 'manual', 'DataAspectRatio', [1 1 1])
    
    % Insert phase labels
    text(res, res/2, '0',...
        'FontSize', 14, 'Color', 'white',...
        'Tag', 'ComplexColorWheel', in.textparams)
    text(res/2, res, '\pi/2',...
        'FontSize', 14, 'Color', 'white',...
        'HorizontalAlignment', 'center','VerticalAlignment', 'bottom',...
        'Tag', 'ComplexColorWheel', in.textparams)
    axis off
    
    % Return to original current axes
    set(fig, 'CurrentAxes', currentaxes);
end


% Linear step function
function xs = linstep(x, smin, smax)
    % Linear step function from (smin, 0) to (smax, 1)
    xs = (x - smin)./(smax - smin);
    xs(xs < 0) = 0;
    xs(xs > 1) = 1;
end

