%=== Argument parser ===%
function results = complexcolorparser(varargin)
    % Input parser function for complex2rgb
    p = inputParser;
    
    % Parameters for complex2rgb
    p.addParameter('vscale', 'auto', @checkvscale)      % Value scale
    p.addParameter('vgamma', 1, @checkpositivescalar)   % Value gamma
    p.addParameter('vstep', 0, @checkvstep)             % Value step
    p.addParameter('vbright', 0, @checkscalar)          % Brightness corr.
    p.addParameter('sscale', 0, @checksscale)           % Saturation scale
    
    % Parameters for complexcolorwheel
    p.addParameter('position', 'bottomleft', @checkposition)
    p.addParameter('resolution', 256, @checkpositiveint)
    p.addParameter('textparams', struct(), @isstruct)
    p.addParameter('figure', get(0, 'CurrentFigure'))
    p.addParameter('axes', 'current')
    
    % Parse
    p.parse(varargin{:})
    results = p.Results;
end


%=== Argument check functions ===%
function checkscalar(x)
    validateattributes(x, {'numeric'}, {'scalar'});
end

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

function checkposition(x)
    if isnumeric(x)
        validateattributes(x, {'numeric'}, {'size', [1 4]})
        
    elseif ischar(x) || isstring(x)
        posoptions = {'topleft', 'topright', 'bottomleft', 'bottomright'};
        assert(any(ismember(posoptions, x)),...
            'Unexpected input ''%s''. Expected ''topleft'', ''topright'', ''bottomleft'' or ''bottomright''', x)
    
    else
        error('Unexpected input ''%s''. Expected a row vector of length 4, or a string or char array.', x)
    end
end



