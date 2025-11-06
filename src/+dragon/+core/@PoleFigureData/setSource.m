function obj = setSource(obj, title, figure)
    % SETSOURCE Set source publication information
    %
    % Syntax:
    %   obj = obj.setSource(title, figure)
    %
    % Inputs:
    %   title - String, publication title/reference
    %   figure - String, figure number/letter (e.g., '3a', '5B')
    %
    % Example:
    %   pf = pf.setSource('Smith et al. 1985', 'Figure 3a');
    
    obj.metadata.source.title = title;
    obj.metadata.source.figure = figure;
    obj.metadata.timestamp = datetime('now');
end