function c = complex2rgb(z, options)
    % Complex 2D array to RGB values
    % The output is intended for plotting with e.g. imagesc()
    %
    % Input:
    % z:        
    % satscale: controls falloff of saturation as a function of abs(z)

    % Error checking
    narginchk(1,2)
    validateattributes(z, {'numeric'}, {'2d'})
    
    absz = abs(z);
    valscale, valgamma, valstep, satscale
    if nargin == 1
    
    if length(options) < 1
        valscale = 'auto';          % Default valscale = max of |z|
    end
    if length(options) < 2
        valgamma = 1;               % Default valgamma = 1 (no change)
    end
    if length(options) < 3
        valstep = 0;                % Default is 'clamp' mode
    end
    if length(options) < 4
        satscale = 0;               % Default saturation 1 everywhere
    end
    
    % Option to pass 'max' instead of a value for valscale
    if ischar(valscale) || isstring(valscale)
        if strcmp(valscale, 'auto')
            valscale = max(absz(:));
        else
            error(sprintf('Unknown option ''%s'' for valscale', valscale))
        end
    end
    
    % Option to pass 'max' instead of a value for satscale
    if ischar(satscale) || isstring(satscale)
        if strcmp(satscale, 'auto')
            satscale = 1/max(absz(:));
        else
            error(sprintf('Unknown option ''%s'' for satscale', satscale))
        end
    end
    
    
    validateattributes(valscale, {'numeric'}, {'scalar', 'positive'})
    validateattributes(valgamma, {'numeric'}, {'scalar', 'positive'})
    validateattributes(valstep,  {'numeric'}, {'scalar', 'nonnegative', '<=', 1})
    validateattributes(satscale, {'numeric'}, {'scalar', 'nonnegative'})
    
    
    % Compute hue, saturation and value
    hue = 0.5 + angle(z) / (2*pi);
    sat = 1 ./ ((satscale*absz).^2 + 1);
    val = absz / valscale;
    
    if valstep == 0                 % Value will be clamped
        val(val > 1) = 1;
        val = val .^ valgamma;
    else                            % Mod of value will be taken
        val = 1 - valstep*(1-mod(val,1)) .^ valgamma;
    end
    
    % Compute RGB array
    c = hsv2rgb(cat(3, hue, sat, val));
end
