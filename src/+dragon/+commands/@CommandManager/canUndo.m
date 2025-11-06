function result = canUndo(obj)
    % CANUNDO Check if undo is available
    %
    % Syntax:
    %   result = obj.canUndo()
    %
    % Output:
    %   result - Boolean, true if undo is available
    
    result = ~isempty(obj.undo_stack);
end