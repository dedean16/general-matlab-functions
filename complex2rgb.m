function c = complex2rgb(z, varargin)
    % Complex 2D array to RGB values
    % Author: Daniel Cox
    % The output is intended for plotting with e.g. imagesc().
    %
    % Output:
    % c:       N*M*3 array, representing the RGB color channels, where N*M
    %          is the size of z.
    %
    % Input:
    % z:       Complex 1D or 2D array
    %
    % Further options can be passed by either a struct or Parameter Value
    % pairs. In the following description, |z| denotes the absolute value
    % of the input argument z.
    %
    % Options:
    % vscale:  Scalar > 0 or 'auto'. Default 'auto'. Controls how the value
    %          scales with |z|. Pass 'auto' to use the maximum of |z|.
    % vgamma:  Scalar > 0. Default 1. Gamma correction for value.
    % vbright: Scalar. Default 0. Brightness correction for value computa-
    %          tion. Final value will be multiplied by factor of 1+vbright.
    % vstep:   Scalar between (or equal to) 0 and 1. Default 0.
    %          If vstep == 0, the value clamps at 1. If vstep > 0, the mod
    %          of the value is taken, such that triangular steps from
    %          (1-vstep) to 1 are created. This is useful for showing
    %          amplitude contourlines along with phase.
    % sscale:  Scalar >= 0 or 'auto'. Default 0. Controls falloff of
    %          saturation as a function of |z|. 1/sscale equals the Half
    %          Width Half Maximum of the falloff curve.
    % cmap:    'hsv' or 'lab' (string or char array). Default 'hsv'. Choose
    %          colormap to represent the complex numbers. In both cases, black
    %          represents 0 and hues represent phase. The 'lab' colormap
    %          provides perceptually uniform color dimensions, while the 'hsv'
    %          colormap provides more contrast. More details below.
    %
    %
    % Note: For plotting 2D arrays as images with e.g. imagesc, by default
    % when using the high-level version, the Y-axis is reversed. Its
    % direction can be set to normal by:
    % set(gca, 'YDir', 'normal')
    %
    %
    % More on the colormaps (cmap):
    % 
    % With 'hsv', the phase of the complex numbers will correspond to the hue
    % (like using a 1D hsv colormap on the phase alone) and the amplitude will
    % be represented by value (and depending on the options, saturation).
    %
    % With the 'lab' option, the perceptually uniform Lab colorspace is used to
    % create the colormap. Note that though individual differences in phase and
    % in amplitude appear as perceptually uniform, the apparent color distance
    % with between any phase and amplitude is not perceptually uniform, as the
    % ranges for phase and amplitude differ. The amplitude is mapped linearly
    % to the lightness and chroma (84.21 total Lab-distance), while the phase
    % is mapped to the hue angle (at maximum amplitude, a radius of 40.2 and
    % circumference of 252.6 in Lab-space).
    %
    % More background info at: https://en.wikipedia.org/wiki/CIELAB_color_space 
    %
    %
    % % Example 1:
    % x = -2:0.1:2; y = x';             % Generate x- and y-values
    % z = x + 1i*y;                     % Generate complex plane values
    % options.vscale = 2;               % Set value-scale
    % options.sscale = 'auto';          % Set saturation-scale to 'auto'
    % c = complex2rgb(z, options);      % Generate colors from complex values
    % figure                            % Create new figure
    % imagesc(x,y,c)                    % Plot as image
    % set(gca, 'YDir', 'normal')        % Set Y-axis direction
    % xlabel('Re(z)'); ylabel('Im(z)')  % Label axes
    % complexcolorwheel(options)        % Add complex color wheel
    %
    % % Example 2:
    % x = linspace(-pi,pi,200); y = x'; % Generate x- and y-values
    % z = x + 1i*y;                     % Generate complex plane values
    % lnz = log(z);                     % Compute ln of z
    % options.cmap = 'lab';             % Use perceptually uniform Lab colormap
    % options.vscale = 0.5;             % Set value-scale
    % options.vstep = 0.8;              % Set saturation-scale to 'auto'
    % options.textparams.color = 'black';
    % options.textparams.backgroundcolor = 'white';
    % options.textparams.margin = 1;
    % c = complex2rgb(lnz, options);    % Generate colors from complex values
    % figure                            % Create new figure
    % surf(x, y, abs(lnz), c, 'edgecolor', 'none');
    % camproj perspective               % Perspective camera projection
    % xlabel('Re(z)');                  % Label x axis
    % ylabel('Im(z)');                  % Label y axis
    % zlabel('|ln(z)|');                % Label z axis
    % title('Complex Logarithm');       % Set title
    % complexcolorwheel(options)        % Add complex color wheel
    
    
    %=== Parse input and check for errors ===%
    validateattributes(z, {'numeric'}, {'2d'})    % Check input z
    in = complexcolorparser(varargin{:});         % Check other parameters
    
    %=== Compute auto values for vscale and/or sscale if requested ===%
    absz = abs(z);
    
    % Option to pass 'auto' instead of a value for vscale    
    if strcmp(in.vscale, 'auto')
        vscale = max(absz(:));
    else
        vscale = in.vscale;
    end
    
    % Option to pass 'auto' instead of a value for sscale
    if strcmp(in.sscale, 'auto')
        sscale = 1/max(absz(:));
    else
        sscale = in.sscale;
    end
    
    
    %=== Compute hue, saturation and value ===%
    hue = 0.5 + angle(z) / (2*pi);
    sat = 1 ./ ((sscale*absz).^2 + 1);
    val = absz / vscale;
    
    % Compute value
    if in.vstep == 0                % Value will be clamped
        val(val > 1) = 1;
        val = val .^ in.vgamma;
    else                            % Mod of value will be taken
        val = 1 - in.vstep*(1-mod(val,1)) .^ in.vgamma;
    end
    
    val = val .* (1 + in.vbright);  % Apply brightness correction
    
    % Compute RGB array
    if strcmp(in.cmap, 'hsv')       % Use HSV colorspace
        c = hsv2rgb(cat(3, hue, sat, val));
    elseif strcmp(in.cmap, 'lab')   % Use Lab colorspace
        L = val * 74;
        a = -40.2 * val .* cos(angle(z));
        b = -40.2 * val .* sin(angle(z));
        c = lab2rgb(cat(3, L, a, b));
    end
end



