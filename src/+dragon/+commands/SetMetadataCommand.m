classdef SetMetadataCommand < dragon.commands.Command
    % SETMETADATACOMMAND Command to set metadata field on PoleFigureData
    %
    % This is an example command for testing the undo/redo framework
    
    properties (Access = private)
        pf_data dragon.core.PoleFigureData
        field_name char
        new_value
        old_value
    end
    
    methods
        function obj = SetMetadataCommand(pfData, fieldName, newValue)
            % Constructor
            %
            % Inputs:
            %   pfData - dragon.core.PoleFigureData object
            %   fieldName - Name of metadata field to set
            %   newValue - New value for the field
            
            description = sprintf('Set %s to "%s"', fieldName, string(newValue));
            obj@dragon.commands.Command(description);
            
            obj.pf_data = pfData;
            obj.field_name = fieldName;
            obj.new_value = newValue;
            
            % Store old value for undo
            if isfield(pfData.metadata, fieldName)
                obj.old_value = pfData.metadata.(fieldName);
            else
                obj.old_value = [];
            end
        end
        
        function execute(obj)
            % Execute the command
            obj.pf_data.metadata.(obj.field_name) = obj.new_value;
        end
        
        function undo(obj)
            % Undo the command
            if isempty(obj.old_value)
                % Field didn't exist before, remove it
                obj.pf_data.metadata = rmfield(obj.pf_data.metadata, obj.field_name);
            else
                % Restore old value
                obj.pf_data.metadata.(obj.field_name) = obj.old_value;
            end
        end
    end
end