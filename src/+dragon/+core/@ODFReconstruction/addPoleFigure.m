function obj = addPoleFigure(obj, pfData)
    % ADDPOLEFIGURE Add a pole figure to the reconstruction
    %
    % Syntax:
    %   obj = obj.addPoleFigure(pfData)
    %
    % Input:
    %   pfData - dragon.core.PoleFigureData object
    %
    % Example:
    %   odf = odf.addPoleFigure(pf);
    
    if ~isa(pfData, 'dragon.core.PoleFigureData')
        error('ODFReconstruction:InvalidInput', ...
              'Input must be a dragon.core.PoleFigureData object');
    end
    
    % Validate the pole figure
    pfData.validate();
    
    % Add to array
    obj.pole_figures{end+1} = pfData;
    obj.info.modified = datetime('now');
end