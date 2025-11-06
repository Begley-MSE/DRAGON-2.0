function obj = removePoleFigure(obj, index)
    % REMOVEPOLEFIGURE Remove a pole figure by index
    %
    % Syntax:
    %   obj = obj.removePoleFigure(index)
    %
    % Input:
    %   index - Integer index of pole figure to remove
    
    if index < 1 || index > length(obj.pole_figures)
        error('ODFReconstruction:InvalidIndex', ...
              'Index out of bounds: %d (valid range: 1-%d)', ...
              index, length(obj.pole_figures));
    end
    
    obj.pole_figures(index) = [];
    obj.info.modified = datetime('now');
end