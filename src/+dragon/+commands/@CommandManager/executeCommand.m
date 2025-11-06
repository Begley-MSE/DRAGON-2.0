function executeCommand(obj, command)
    % EXECUTECOMMAND Execute a command and add it to undo stack
    %
    % Syntax:
    %   obj.executeCommand(command)
    %
    % Input:
    %   command - dragon.commands.Command object to execute
    
    if ~isa(command, 'dragon.commands.Command')
        error('CommandManager:InvalidCommand', ...
              'Command must inherit from dragon.commands.Command');
    end
    
    % Execute the command
    command.execute();
    
    % Add to undo stack
    obj.undo_stack{end+1} = command;
    
    % Clear redo stack (can't redo after new command)
    obj.redo_stack = {};
    
    % Enforce max history limit
    if length(obj.undo_stack) > obj.max_history
        obj.undo_stack(1) = [];
    end
end