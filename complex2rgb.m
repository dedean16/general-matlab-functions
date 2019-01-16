function c = complex2rgb(z, varargin)
    % Complex 2D array to RGB values
    % The output is intended for plotting with e.g. imagesc().
    %
    % Output:
    % c:      N*M*3 array, representing the RGB color channels, where N*M
    %         is the size of z.
    %
    % Input:
    % z:      Complex 1D or 2D array
    %
    % Further options can be passed by either a struct or Parameter Value
    % pairs. In the following description, |z| denotes the absolute value
    % of the input argument z.
    %
    % Options:
    % vscale: Scalar > 0 or 'auto'. Default 'auto'. Controls how the value
    %         scales with |z|. Pass 'auto' to use the maximum of |z|.
    % vgamma: Scalar > 0. Default 1. Gamma correction for value.
    % vstep:  Scalar between (or equal to) 0 and 1. Default 0.
    %         If vstep == 0, the value clamps at 1. If vstep > 0, the mod
    %         of the value is taken, such that triangular steps from
    %         (1-vstep) to 1 are created. This is useful for showing
    %         amplitude contourlines along with phase.
    % sscale: Scalar >= 0 or 'auto'. Default 0. Controls falloff of
    %         saturation as a function of |z|. 1/sscale equals the Half
    %         Width Half Maximum of the falloff curve.
    %
    % Example usage:
    % x = -2:0.1:2; y = x';
    % z = x + 1i*y;
    % options.vscale = 2;
    % options.sscale = 'auto';
    % c = complex2rgb(z, options);
    % imagesc(x,y,c)
    % xlabel('Re(z)'); ylabel('Im(z)')
    
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
    c = hsv2rgb(cat(3, hue, sat, val));
end



