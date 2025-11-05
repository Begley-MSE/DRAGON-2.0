function [isValid, errorMsg] = validateODFReconstruction(odfRecon)
% VALIDATEODFRECONSTRUCTION Validates an ODFReconstruction structure
%
% Syntax:
%   [isValid, errorMsg] = validateODFReconstruction(odfRecon)
%
% Inputs:
%   odfRecon - ODFReconstruction structure to validate
%
% Outputs:
%   isValid - Boolean, true if valid
%   errorMsg - String, error message if invalid

    isValid = true;
    errorMsg = '';
    
    % Check if it's a struct
    if ~isstruct(odfRecon)
        isValid = false;
        errorMsg = 'Input must be a structure';
        return;
    end
    
    % Check required top-level fields
    requiredFields = {'info', 'pole_figures', 'odf_results', 'settings'};
    for i = 1:length(requiredFields)
        if ~isfield(odfRecon, requiredFields{i})
            isValid = false;
            errorMsg = sprintf('Missing required field: %s', requiredFields{i});
            return;
        end
    end
    
    % Check info fields
    requiredInfoFields = {'id', 'name', 'created', 'modified'};
    for i = 1:length(requiredInfoFields)
        if ~isfield(odfRecon.info, requiredInfoFields{i})
            isValid = false;
            errorMsg = sprintf('Missing required info field: %s', requiredInfoFields{i});
            return;
        end
    end
    
    % Check that pole_figures is a cell array
    if ~iscell(odfRecon.pole_figures)
        isValid = false;
        errorMsg = 'pole_figures must be a cell array';
        return;
    end
    
    % Validate each pole figure
    for i = 1:length(odfRecon.pole_figures)
        [pfValid, pfError] = validatePoleFigureData(odfRecon.pole_figures{i});
        if ~pfValid
            isValid = false;
            errorMsg = sprintf('Invalid pole figure %d: %s', i, pfError);
            return;
        end
    end
    
end