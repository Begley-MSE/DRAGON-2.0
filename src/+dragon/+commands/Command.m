classdef (Abstract) Command < handle
    % COMMAND Abstract base class for undoable commands
    %
    % All commands must implement:
    %   execute() - Perform the action
    %   undo() - Reverse the action
    %
    % Properties:
    %   description - Human-readable description of the command
    %   timestamp - When the command was created
    
    properties
        description char
        timestamp datetime
    end
    
    methods
        function obj = Command(description)
            % Constructor
            %
            % Input:
            %   description - String describing the command
            
            if nargin > 0
                obj.description = description;
            else
                obj.description = 'Unnamed command';
            end
            obj.timestamp = datetime('now');
        end
    end
    
    methods (Abstract)
        % Execute the command
        execute(obj)
        
        % Undo the command (reverse its effects)
        undo(obj)
    end
end