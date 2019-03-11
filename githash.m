function [shorthash, hash, status] = githash
    % Retrieve git commit hash of HEAD
    % Performs a system command to retrieve the git hash of HEAD.
    %
    % Usage:    [shorthash, hash, status] = githash
    %
    % Output:
    % shorthash Abbreviated commit hash.
    % hash      Full commit hash.
    % status    Output status of command. (0 = no errors.)

    [~, hash] = system('git log -1 --pretty=format:%H|printf $(tee)');
    [status, shorthash] = system('git log -1 --pretty=format:%h|printf $(tee)');

    if status ~= 0
        warning('Error while attempting to retrieve git commit hash.')
    end

end

