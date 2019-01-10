%=== Argument parser ===%
function results = complexcolorparser(varargin)
    % Input parser function for complex2rgb
    p = inputParser;
    
    % Parameters for complex2rgb
    p.addParameter('vscale', 'auto', @checkvscale)      % Value scale
    p.addParameter('vgamma', 1, @checkpositivescalar)   % Value gamma
    p.addParameter('vstep', 0, @checkvstep)             % Value step
    p.addParameter('sscale', 0, @checksscale)           % Saturation scale
    
    % Parameters for complexcolorwheel
    p.addParameter('position', [0.14 0.12 0.16 0.16])
    p.addParameter('resolution', 128, @checkpositiveint)
    p.addParameter('textparams', struct(), @isstruct)
    p.addParameter('figure', gcf)
    
    % Parse
    p.parse(varargin{:})
    results = p.Results;
end


%=== Argument check functions ===%
function checkpositivescalar(x)
    validateattributes(x, {'numeric'}, {'scalar', 'positive'})
end

function checkpositiveint(x)
    validateattributes(x, {'numeric'}, {'scalar', 'positive', 'integer'})
end

function checkvscale(x)
    if ~strcmp(x, 'auto')
        checkpositivescalar(x)
    end
end

function checkvstep(x)
    validateattributes(x,  {'numeric'}, {'scalar', 'nonnegative', '<=', 1})
end

function checksscale(x)
    if ~strcmp(x, 'auto')
        validateattributes(x, {'numeric'}, {'scalar', 'nonnegative'})
    end
end
