function obj = setMetadata(obj, field, value)
    % SETMETADATA Set metadata field
    %
    % Syntax:
    %   obj = obj.setMetadata(field, value)
    %
    % Inputs:
    %   field - String, name of metadata field
    %   value - Value to set
    %
    % Example:
    %   pf = pf.setMetadata('specimen_info', 'Cold rolled steel');
    
    obj.metadata.(field) = value;
    obj.metadata.timestamp = datetime('now');
end