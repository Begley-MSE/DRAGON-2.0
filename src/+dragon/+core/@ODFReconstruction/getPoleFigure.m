function pf = getPoleFigure(obj, index)
    % GETPOLEFIGURE Get a pole figure by index
    %
    % Syntax:
    %   pf = obj.getPoleFigure(index)
    %
    % Input:
    %   index - Integer index of pole figure
    %
    % Output:
    %   pf - dragon.core.PoleFigureData object
    
    if index < 1 || index > length(obj.pole_figures)
        error('ODFReconstruction:InvalidIndex', ...
              'Index out of bounds: %d (valid range: 1-%d)', ...
              index, length(obj.pole_figures));
    end
    
    pf = obj.pole_figures{index};
end