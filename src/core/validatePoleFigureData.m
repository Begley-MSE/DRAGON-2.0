function [isValid, errorMsg] = validatePoleFigureData(pfData)
% VALIDATEPOLEFIGUREDATA Validates a PoleFigureData structure
%
% Syntax:
%   [isValid, errorMsg] = validatePoleFigureData(pfData)
%
% Inputs:
%   pfData - PoleFigureData structure to validate
%
% Outputs:
%   isValid - Boolean, true if valid
%   errorMsg - String, error message if invalid

    isValid = true;
    errorMsg = '';
    
    % Check if it's a struct
    if ~isstruct(pfData)
        isValid = false;
        errorMsg = 'Input must be a structure';
        return;
    end
    
    % Check required fields
    requiredFields = {'id', 'miller_indices', 'crystal_symmetry', ...
                      'metadata'};
    for i = 1:length(requiredFields)
        if ~isfield(pfData, requiredFields{i})
            isValid = false;
            errorMsg = sprintf('Missing required field: %s', requiredFields{i});
            return;
        end
    end
    
    % Validate miller_indices
    if ~isnumeric(pfData.miller_indices) || ...
       (length(pfData.miller_indices) ~= 3 && length(pfData.miller_indices) ~= 4)
        isValid = false;
        errorMsg = 'miller_indices must be a 3 or 4 element numeric vector';
        return;
    end
    
    % Validate crystal_symmetry
    validSymmetries = {'cubic', 'hexagonal', 'trigonal', 'tetragonal', ...
                       'orthorhombic', 'monoclinic', 'triclinic'};
    if ~ischar(pfData.crystal_symmetry) && ~isstring(pfData.crystal_symmetry)
        isValid = false;
        errorMsg = 'crystal_symmetry must be a string';
        return;
    end
    if ~ismember(lower(pfData.crystal_symmetry), validSymmetries)
        isValid = false;
        errorMsg = sprintf('Invalid crystal_symmetry. Must be one of: %s', ...
                          strjoin(validSymmetries, ', '));
        return;
    end
    
    % Check metadata structure
    if ~isfield(pfData.metadata, 'source') || ~isfield(pfData.metadata, 'timestamp')
        isValid = false;
        errorMsg = 'metadata must contain source and timestamp fields';
        return;
    end
    
end