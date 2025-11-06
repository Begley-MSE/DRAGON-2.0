classdef CommandManager < handle
    % COMMANDMANAGER Manages undo/redo stacks for commands
    %
    % Properties:
    %   undo_stack - Stack of commands that can be undone
    %   redo_stack - Stack of commands that can be redone
    %   max_history - Maximum number of commands to keep in history
    
    properties (Access = private)
        undo_stack cell
        redo_stack cell
        max_history double
    end
    
    methods
        function obj = CommandManager(maxHistory)
            % Constructor for CommandManager
            %
            % Syntax:
            %   mgr = dragon.commands.CommandManager(maxHistory)
            %
            % Input:
            %   maxHistory - Maximum commands in history (default: 100)
            %
            % Example:
            %   mgr = dragon.commands.CommandManager(50);
            
            if nargin < 1
                maxHistory = 100;
            end
            
            obj.undo_stack = {};
            obj.redo_stack = {};
            obj.max_history = maxHistory;
        end
        
        % Method signatures (implementations in separate files)
        executeCommand(obj, command)
        undo(obj)
        redo(obj)
        result = canUndo(obj)
        result = canRedo(obj)
        clear(obj)
        history = getHistory(obj)
    end
end