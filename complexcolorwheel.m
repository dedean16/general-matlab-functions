function complexcolorwheel(varargin)
    
    % Check and parse input parameters
    in = complexcolorparser(varargin{:});
    res = in.resolution;
    
    % Get figure, current axes and parent axes
    fig = figure(in.figure);
    currentaxes = get(fig, 'CurrentAxes');      % Remember current axes
    
    if isnumeric(in.axes)
        allaxes = findobj(fig,'type','axes','-or','type','polaraxes');
        parentaxes = allaxes(in.axes);
    else
        parentaxes = in.axes;
    end
    
    % Determine color wheel preset position or assign normalized position
    if ischar(in.position) || isstring(in.position)
        switch in.position
            case 'topleft'
                wheelpos = [0.02 0.81 0.15 0.15];
            case 'topright'
                wheelpos = [0.83 0.83 0.15 0.15];
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
    
    % Compute color wheel position
    paxpos = parentaxes.Position;
    xwheel = paxpos(1) + wheelpos(1) * paxpos(3);
    ywheel = paxpos(2) + wheelpos(2) * paxpos(4);
    wwheel = wheelpos(3) * paxpos(3);
    hwheel = wheelpos(4) * paxpos(4);
    
    
    % Option to pass 'auto' instead of a value for vscale    
    if strcmp(in.vscale, 'auto')
        vscale = 1;
    else
        vscale = in.vscale;
    end
    
    
    % Construct color image of complex unit circle
    X = linspace(-vscale, vscale, res);
    Y = X';
    R = sqrt(X.^2 + Y.^2);                           % Radius from origin
    alpha = 1 - linstep(R, vscale*(res*0.99)/res, vscale); % Transparency
    C = complex2rgb((X + 1i*Y) .* alpha, varargin{:});
    
    % Display color image of complex unit circle
    image(axes(fig, 'Position', [xwheel ywheel wwheel hwheel]),...
        C, 'AlphaData', alpha);
    
    text(res, res/2, '0',...
        'FontSize', 14, 'Color', 'white',...
        in.textparams)
    text(res/2, 0, '\pi/2',...
        'FontSize', 14, 'Color', 'white',...
        'HorizontalAlignment', 'center','VerticalAlignment', 'bottom',...
        in.textparams)
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

