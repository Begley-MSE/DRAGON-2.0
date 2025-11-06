function isValid = validate(obj)
    % VALIDATE Validate the PoleFigureData object
    %
    % Syntax:
    %   isValid = obj.validate()
    %
    % Returns:
    %   isValid - Boolean, true if valid
    
    % Validate miller_indices
    if isempty(obj.miller_indices) || ...
       (~isequal(length(obj.miller_indices), 3) && ...
        ~isequal(length(obj.miller_indices), 4))
        error('PoleFigureData:InvalidIndices', ...
              'miller_indices must be 3 or 4 element vector');
    end
    
    % Validate crystal_symmetry
    validSymmetries = {'cubic', 'hexagonal', 'trigonal', 'tetragonal', ...
                       'orthorhombic', 'monoclinic', 'triclinic'};
    if ~ismember(lower(obj.crystal_symmetry), validSymmetries)
        error('PoleFigureData:InvalidSymmetry', ...
              'Invalid crystal_symmetry: %s', obj.crystal_symmetry);
    end
    
    isValid = true;
end