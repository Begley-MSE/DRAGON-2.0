function obj = load(filepath)
    % LOAD Load reconstruction from file (static method)
    %
    % Syntax:
    %   odf = dragon.core.ODFReconstruction.load(filepath)
    %
    % Input:
    %   filepath - String, path to .mat file
    %
    % Output:
    %   obj - dragon.core.ODFReconstruction object
    %
    % Example:
    %   odf = dragon.core.ODFReconstruction.load('my_texture.mat');
    
    if ~exist(filepath, 'file')
        error('ODFReconstruction:FileNotFound', ...
              'File not found: %s', filepath);
    end
    
    data = load(filepath);
    
    if ~isfield(data, 'odfRecon')
        error('ODFReconstruction:InvalidFile', ...
              'File does not contain an ODFReconstruction object');
    end
    
    obj = data.odfRecon;
    
    % Validate after loading
    obj.validate();
    
    fprintf('ODFReconstruction loaded from: %s\n', filepath);
end