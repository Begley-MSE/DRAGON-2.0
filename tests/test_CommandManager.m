%% Test CommandManager and Command Framework
% Tests for dragon.commands.CommandManager and example commands

%% Test 1: Create CommandManager
fprintf('Test 1: Create CommandManager... ');
mgr = dragon.commands.CommandManager();

assert(isa(mgr, 'dragon.commands.CommandManager'), 'Should create CommandManager');
assert(~mgr.canUndo(), 'Should not be able to undo initially');
assert(~mgr.canRedo(), 'Should not be able to redo initially');
fprintf('PASSED\n');

%% Test 2: Create CommandManager with custom history size
fprintf('Test 2: Create CommandManager with custom history... ');
mgr2 = dragon.commands.CommandManager(50);
assert(isa(mgr2, 'dragon.commands.CommandManager'), 'Should create CommandManager');
fprintf('PASSED\n');

%% Test 3: Execute a command
fprintf('Test 3: Execute a command... ');
pf = dragon.core.PoleFigureData([1 1 1], 'cubic');
cmd = dragon.commands.SetMetadataCommand(pf, 'test_field', 'test_value');

mgr.executeCommand(cmd);

assert(strcmp(pf.metadata.test_field, 'test_value'), 'Field should be set');
assert(mgr.canUndo(), 'Should be able to undo after executing command');
assert(~mgr.canRedo(), 'Should not be able to redo');
fprintf('PASSED\n');

%% Test 4: Undo a command
fprintf('Test 4: Undo a command... ');
mgr.undo();

assert(~isfield(pf.metadata, 'test_field'), 'Field should be removed after undo');
assert(~mgr.canUndo(), 'Should not be able to undo after undoing last command');
assert(mgr.canRedo(), 'Should be able to redo');
fprintf('PASSED\n');

%% Test 5: Redo a command
fprintf('Test 5: Redo a command... ');
mgr.redo();

assert(strcmp(pf.metadata.test_field, 'test_value'), 'Field should be restored after redo');
assert(mgr.canUndo(), 'Should be able to undo after redo');
assert(~mgr.canRedo(), 'Should not be able to redo after redoing last command');
fprintf('PASSED\n');

%% Test 6: Multiple commands
fprintf('Test 6: Multiple commands... ');
cmd2 = dragon.commands.SetMetadataCommand(pf, 'field2', 'value2');
cmd3 = dragon.commands.SetMetadataCommand(pf, 'field3', 'value3');

mgr.executeCommand(cmd2);
mgr.executeCommand(cmd3);

assert(strcmp(pf.metadata.field2, 'value2'), 'Field2 should be set');
assert(strcmp(pf.metadata.field3, 'value3'), 'Field3 should be set');
assert(mgr.canUndo(), 'Should be able to undo');
fprintf('PASSED\n');

%% Test 7: Multiple undos
fprintf('Test 7: Multiple undos... ');
mgr.undo(); % Undo field3
assert(~isfield(pf.metadata, 'field3'), 'Field3 should be removed');
assert(isfield(pf.metadata, 'field2'), 'Field2 should still exist');

mgr.undo(); % Undo field2
assert(~isfield(pf.metadata, 'field2'), 'Field2 should be removed');
fprintf('PASSED\n');

%% Test 8: Multiple redos
fprintf('Test 8: Multiple redos... ');
mgr.redo(); % Redo field2
assert(strcmp(pf.metadata.field2, 'value2'), 'Field2 should be restored');

mgr.redo(); % Redo field3
assert(strcmp(pf.metadata.field3, 'value3'), 'Field3 should be restored');
fprintf('PASSED\n');

%% Test 9: New command clears redo stack
fprintf('Test 9: New command clears redo stack... ');
mgr.undo(); % Undo field3
assert(mgr.canRedo(), 'Should be able to redo');

cmd4 = dragon.commands.SetMetadataCommand(pf, 'field4', 'value4');
mgr.executeCommand(cmd4);

assert(~mgr.canRedo(), 'Redo stack should be cleared after new command');
assert(strcmp(pf.metadata.field4, 'value4'), 'Field4 should be set');
fprintf('PASSED\n');

%% Test 10: Command history
fprintf('Test 10: Command history... ');
history = mgr.getHistory();

assert(iscell(history), 'History should be a cell array');
assert(~isempty(history), 'History should not be empty');
assert(contains(history{end}, 'field4'), 'Last command should mention field4');
fprintf('PASSED\n');

%% Test 11: Clear command manager
fprintf('Test 11: Clear command manager... ');
mgr.clear();

assert(~mgr.canUndo(), 'Should not be able to undo after clear');
assert(~mgr.canRedo(), 'Should not be able to redo after clear');
history = mgr.getHistory();
assert(isempty(history), 'History should be empty after clear');
fprintf('PASSED\n');

%% Test 12: Modifying existing field (undo restores old value)
fprintf('Test 12: Modify existing field... ');
pf2 = dragon.core.PoleFigureData([2 0 0], 'cubic');
pf2.metadata.existing_field = 'original_value';

mgr2 = dragon.commands.CommandManager();
cmd5 = dragon.commands.SetMetadataCommand(pf2, 'existing_field', 'new_value');
mgr2.executeCommand(cmd5);

assert(strcmp(pf2.metadata.existing_field, 'new_value'), 'Field should be updated');

mgr2.undo();
assert(strcmp(pf2.metadata.existing_field, 'original_value'), ...
       'Field should be restored to original value');
fprintf('PASSED\n');

%% Test 13: Max history enforcement
fprintf('Test 13: Max history limit... ');
mgr3 = dragon.commands.CommandManager(3); % Only keep 3 commands
pf3 = dragon.core.PoleFigureData([1 0 0], 'cubic');

for i = 1:5
    cmd = dragon.commands.SetMetadataCommand(pf3, sprintf('field%d', i), i);
    mgr3.executeCommand(cmd);
end

history = mgr3.getHistory();
assert(length(history) == 3, 'History should be limited to 3 commands');
fprintf('PASSED\n');

%% Test 14: Warning on empty undo
fprintf('Test 14: Warning on empty undo... ');
mgr4 = dragon.commands.CommandManager();
lastwarn(''); % Clear last warning
mgr4.undo();
[warnMsg, warnId] = lastwarn;
assert(contains(warnId, 'NothingToUndo'), 'Should warn when nothing to undo');
fprintf('PASSED\n');

%% Test 15: Warning on empty redo
fprintf('Test 15: Warning on empty redo... ');
lastwarn(''); % Clear last warning
mgr4.redo();
[warnMsg, warnId] = lastwarn;
assert(contains(warnId, 'NothingToRedo'), 'Should warn when nothing to redo');
fprintf('PASSED\n');

%% Summary
fprintf('\n========================================\n');
fprintf('All CommandManager tests PASSED!\n');
fprintf('========================================\n');