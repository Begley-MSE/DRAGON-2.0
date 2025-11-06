function clear(obj)
    % CLEAR Clear both undo and redo stacks
    %
    % Syntax:
    %   obj.clear()
    
    obj.undo_stack = {};
    obj.redo_stack = {};
end