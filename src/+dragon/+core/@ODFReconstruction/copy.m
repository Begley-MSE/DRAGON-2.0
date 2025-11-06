function newObj = copy(obj)
    % COPY Create a deep copy of the ODFReconstruction object
    %
    % Syntax:
    %   newObj = obj.copy()
    %
    % Output:
    %   newObj - Independent copy of the ODFReconstruction object
    %
    % Example:
    %   odf2 = odf1.copy();
    
    % Create new object with same basic info
    newObj = dragon.core.ODFReconstruction(obj.info.name, ...
                                           obj.info.description, ...
                                           obj.info.author);
    
    % Copy timestamps (but use original created time)
    newObj.info.created = obj.info.created;
    newObj.info.modified = obj.info.modified;
    
    % Deep copy all pole figures
    newObj.pole_figures = cell(size(obj.pole_figures));
    for i = 1:length(obj.pole_figures)
        newObj.pole_figures{i} = obj.pole_figures{i}.copy();
    end
    
    % Copy ODF results and settings
    newObj.odf_results = copyStruct(obj.odf_results);
    newObj.settings = copyStruct(obj.settings);
    
    % Note: We generate a new ID for the copy
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