function history = getHistory(obj)
    % GETHISTORY Get list of command descriptions in undo stack
    %
    % Syntax:
    %   history = obj.getHistory()
    %
    % Output:
    %   history - Cell array of command descriptions (most recent last)
    
    history = cell(length(obj.undo_stack), 1);
    for i = 1:length(obj.undo_stack)
        history{i} = obj.undo_stack{i}.description;
    end
end