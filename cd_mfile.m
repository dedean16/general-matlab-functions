function cd_mfile
% CD M-file
% Made by Daniel Cox
% Version 1.0
%
% Switch current directory to path
% of m-file that calls this function.

[ST,~] = dbstack('-completenames');     % Get structure of calls

if length(ST) > 1
    cd(fileparts(ST(2).file));          % cd to previous call path
else
    % When called from command window
    disp('This function will cd to the path of the m-file that calls it.')
end
