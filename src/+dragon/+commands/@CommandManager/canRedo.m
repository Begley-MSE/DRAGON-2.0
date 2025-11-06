function result = canRedo(obj)
    % CANREDO Check if redo is available
    %
    % Syntax:
    %   result = obj.canRedo()
    %
    % Output:
    %   result - Boolean, true if redo is available
    
    result = ~isempty(obj.redo_stack);
end