function redo(obj)
    % REDO Redo the most recently undone command
    %
    % Syntax:
    %   obj.redo()
    
    if isempty(obj.redo_stack)
        warning('CommandManager:NothingToRedo', 'Nothing to redo');
        return;
    end
    
    % Get the most recently undone command
    command = obj.redo_stack{end};
    
    % Execute it again
    command.execute();
    
    % Move from redo to undo stack
    obj.redo_stack(end) = [];
    obj.undo_stack{end+1} = command;
end