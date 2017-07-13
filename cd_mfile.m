function cd_mfile
% Switch current directory to path
% of m-file that calls this function.

[ST,~] = dbstack('-completenames');

if length(ST) > 1
    cd(fileparts(ST(2).file));
else
    disp('This function will cd to the path of the m-file that calls it.')
end
