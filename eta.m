function ETAstr = eta(n,N,starttime,output_type,console_text,skipframes)
% Calculate Estimated Time for Arrival with linear extrapolation.
% Made by Daniel Cox
% Version 1.0
%
% Can be used inside a long loop for estimation of computation time.
% 
% Usage:
%   ETAstr = eta(n,N,starttime,output_type,console_text,skipframes)
%
% n             = Current iteration/value
% N             = Final iteration/value
% starttime     = Timestamp of start moment
% output_type   = Either 'console' or 'string'
% console_text  = Text to display in console
% skipframes    = Skip console output every this many iterations
%
% starttime can be obtained beforehand with:
% starttime = now;
%
% The first iteration n is assumed to be 1. The eta function call
% should be placed at the end of an iteration.
%
% Only if output_type is set to 'console':
%  - the clc command will be used to clear the command window.
%  - console_text will be used to show text above the ETA in console
%  - skipframes will be used
%
% If output_type is set to 'string', console_text and skipframes
% arguments may be omitted.

if strcmp(output_type,'console')            % If output will be sent to console
    if n==N                                 % If at 100%, give output
        doit = 1;
    else
        doit = mod(n,skipframes+1) == 0;    % Give output every <skipframes+1> iteration
    end
elseif strcmp(output_type,'string')         % Always give output if a string is requested
    doit = true;
else
    error('Invalid output_type')
end

if doit
    % Show Estimated Time for Arrival in console
    perc = n/N*100;                         % Percentage done
    ETA = (now-starttime)*(N/n - 1);        % ETA in days [why Matlab? (-_-) ]
    ETA_min = floor(ETA*1440);              % minutes of ETA
    ETA_sec = mod(floor(ETA*86400),60);     % seconds of ETA

    ETAstr = sprintf('%.0f%% - ETA: %i min %.0f sec\n',perc,ETA_min,ETA_sec); % Format ETA string

    if strcmp(output_type,'console')        % If output form is console
        clc                                 % Clear console
        disp(console_text)                  % Show <console_text> in console
        disp(ETAstr)                        % Show the ETA string in console
    end
end

