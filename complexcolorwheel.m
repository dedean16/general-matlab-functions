function complexcolorwheel(varargin)
    
    in = complexcolorparser(varargin{:});
    res = in.resolution;
    
    
    % Option to pass 'auto' instead of a value for vscale    
    if strcmp(in.vscale, 'auto')
        vscale = 1;
    else
        vscale = in.vscale;
    end
    
    % Construct color image of complex unit circle
    X = linspace(-vscale, vscale, res);
    Y = X';
    R = sqrt(X.^2 + Y.^2);
    alpha = 1 - linstep(R, vscale*(res*0.99)/res, vscale);
    C = complex2rgb((X + 1i*Y) .* alpha, varargin{:});
    
    % Display color image of complex unit circle
    image(axes(figure(in.figure), 'Position', in.position),...
        C, 'AlphaData', alpha);
    
    text(res, res/2, '0',...
        'FontSize', 16, 'Color', 'white',...
        in.textparams)
    text(res/2, 0, '\pi/2',...
        'FontSize', 16, 'Color', 'white',...
        'HorizontalAlignment', 'center','VerticalAlignment', 'bottom',...
        in.textparams)
    drawnow
    axis off
end


% Linear step function
function xs = linstep(x, smin, smax)
    % Linear step function from (smin, 0) to (smax, 1)
    xs = (x - smin)./(smax - smin);
    xs(xs < 0) = 0;
    xs(xs > 1) = 1;
end

