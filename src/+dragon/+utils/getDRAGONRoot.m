function rootPath = getDRAGONRoot()
    % GETDRAGONROOT Returns the root directory of the DRAGON project
    %
    % Syntax:
    %   rootPath = dragon.utils.getDRAGONRoot()
    %
    % Output:
    %   rootPath - String, absolute path to DRAGON project root
    %
    % Description:
    %   Searches upward from the current file location to find the
    %   DRAGON project root, identified by the presence of startup.m
    
    % Start from this file's location
    currentPath = fileparts(mfilename('fullpath'));
    
    % Search upward for startup.m
    maxLevels = 10; % Prevent infinite loop
    for i = 1:maxLevels
        if exist(fullfile(currentPath, 'startup.m'), 'file')
            rootPath = currentPath;
            return;
        end
        
        % Move up one directory
        parentPath = fileparts(currentPath);
        
        % Check if we've reached the root of the filesystem
        if strcmp(currentPath, parentPath)
            error('dragon:utils:getDRAGONRoot:NotFound', ...
                  'Could not find DRAGON project root (startup.m not found)');
        end
        
        currentPath = parentPath;
    end
    
    error('dragon:utils:getDRAGONRoot:NotFound', ...
          'Could not find DRAGON project root after searching %d levels', maxLevels);
end