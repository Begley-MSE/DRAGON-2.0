function n = numPoleFigures(obj)
    % NUMPOLEFIGURES Get number of pole figures
    %
    % Syntax:
    %   n = obj.numPoleFigures()
    %
    % Output:
    %   n - Integer, number of pole figures in reconstruction
    
    n = length(obj.pole_figures);
end