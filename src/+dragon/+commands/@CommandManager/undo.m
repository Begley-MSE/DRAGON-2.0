function undo(obj)
    % UNDO Undo the most recent command
    %
    % Syntax:
    %   obj.undo()
    
    if isempty(obj.undo_stack)
        warning('CommandManager:NothingToUndo', 'Nothing to undo');
        return;
    end
    
    % Get the most recent command
    command = obj.undo_stack{end};
    
    % Undo it
    command.undo();
    
    % Move from undo to redo stack
    obj.undo_stack(end) = [];
    obj.redo_stack{end+1} = command;
end