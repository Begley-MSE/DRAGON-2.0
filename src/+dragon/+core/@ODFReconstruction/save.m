function save(obj, filepath)
    % SAVE Save reconstruction to file
    %
    % Syntax:
    %   obj.save(filepath)
    %
    % Input:
    %   filepath - String, path to .mat file (with or without extension)
    %
    % Example:
    %   odf.save('data/projects/my_texture.mat');
    
    % Add .mat extension if not present
    [pathStr, name, ext] = fileparts(filepath);
    if isempty(ext)
        filepath = fullfile(pathStr, [name '.mat']);
    end
    
    % Create directory if it doesn't exist
    if ~isempty(pathStr) && ~exist(pathStr, 'dir')
        mkdir(pathStr);
    end
    
    % Validate before saving
    obj.validate();
    
    % Update modified timestamp
    obj.info.modified = datetime('now');
    
    % Save
    odfRecon = obj; %#ok<NASGU>
    save(filepath, 'odfRecon', '-v7.3');
    fprintf('ODFReconstruction saved to: %s\n', filepath);
end