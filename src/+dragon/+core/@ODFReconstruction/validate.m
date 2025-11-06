function isValid = validate(obj)
    % VALIDATE Validate the ODFReconstruction object
    %
    % Syntax:
    %   isValid = obj.validate()
    %
    % Returns:
    %   isValid - Boolean, true if valid
    
    % Check that we have required info fields
    requiredFields = {'id', 'name', 'created', 'modified'};
    for i = 1:length(requiredFields)
        if ~isfield(obj.info, requiredFields{i})
            error('ODFReconstruction:MissingField', ...
                  'Missing required info field: %s', requiredFields{i});
        end
    end
    
    % Validate each pole figure
    for i = 1:length(obj.pole_figures)
        if ~isa(obj.pole_figures{i}, 'dragon.core.PoleFigureData')
            error('ODFReconstruction:InvalidPoleFigure', ...
                  'Pole figure %d is not a PoleFigureData object', i);
        end
        obj.pole_figures{i}.validate();
    end
    
    isValid = true;
end