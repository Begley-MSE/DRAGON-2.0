function newObj = copy(obj)
    % COPY Create a deep copy of the PoleFigureData object
    %
    % Syntax:
    %   newObj = obj.copy()
    %
    % Output:
    %   newObj - Independent copy of the PoleFigureData object
    %
    % Example:
    %   pf2 = pf1.copy();
    
    % Create new object with same Miller indices and symmetry
    newObj = dragon.core.PoleFigureData(obj.miller_indices, obj.crystal_symmetry);
    
    % Copy simple properties
    newObj.raw_image = obj.raw_image;
    newObj.corrected_image = obj.corrected_image;
    newObj.extracted_data = obj.extracted_data;
    
    % Deep copy structs
    newObj.correction_params = copyStruct(obj.correction_params);
    newObj.circle_geometry = copyStruct(obj.circle_geometry);
    newObj.annotations = copyStruct(obj.annotations);
    newObj.metadata = copyStruct(obj.metadata);
    
    % Note: We generate a new ID for the copy, but keep all other data
end

function newStruct = copyStruct(oldStruct)
    % Helper function to deep copy a struct
    if isempty(oldStruct)
        newStruct = oldStruct;
        return;
    end
    
    fields = fieldnames(oldStruct);
    newStruct = struct();
    
    for i = 1:length(fields)
        value = oldStruct.(fields{i});
        if isstruct(value)
            newStruct.(fields{i}) = copyStruct(value);
        else
            newStruct.(fields{i}) = value;
        end
    end
end