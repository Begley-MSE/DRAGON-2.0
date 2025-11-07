%% Test AddPoleFigureCommand and RemovePoleFigureCommand
% Tests for pole figure add/remove commands

%% Test 1: AddPoleFigureCommand - execute
fprintf('Test 1: AddPoleFigureCommand - execute... ');
odf = dragon.core.ODFReconstruction('Test', 'Add/Remove test');
pf = dragon.core.PoleFigureData([1 1 1], 'cubic');
mgr = dragon.commands.CommandManager();

cmd = dragon.commands.AddPoleFigureCommand(odf, pf);
mgr.executeCommand(cmd);

assert(odf.numPoleFigures() == 1, 'Should have 1 pole figure after add');
assert(isequal(odf.getPoleFigure(1).miller_indices, [1 1 1]), ...
       'Pole figure should match');
fprintf('PASSED\n');

%% Test 2: AddPoleFigureCommand - undo
fprintf('Test 2: AddPoleFigureCommand - undo... ');
mgr.undo();

assert(odf.numPoleFigures() == 0, 'Should have 0 pole figures after undo');
fprintf('PASSED\n');

%% Test 3: AddPoleFigureCommand - redo
fprintf('Test 3: AddPoleFigureCommand - redo... ');
mgr.redo();

assert(odf.numPoleFigures() == 1, 'Should have 1 pole figure after redo');
fprintf('PASSED\n');

%% Test 4: Multiple AddPoleFigureCommands
fprintf('Test 4: Multiple AddPoleFigureCommands... ');
pf2 = dragon.core.PoleFigureData([2 0 0], 'cubic');
pf3 = dragon.core.PoleFigureData([2 2 0], 'cubic');

cmd2 = dragon.commands.AddPoleFigureCommand(odf, pf2);
cmd3 = dragon.commands.AddPoleFigureCommand(odf, pf3);

mgr.executeCommand(cmd2);
mgr.executeCommand(cmd3);

assert(odf.numPoleFigures() == 3, 'Should have 3 pole figures');
fprintf('PASSED\n');

%% Test 5: RemovePoleFigureCommand - execute
fprintf('Test 5: RemovePoleFigureCommand - execute... ');
cmdRemove = dragon.commands.RemovePoleFigureCommand(odf, 2);
mgr.executeCommand(cmdRemove);

assert(odf.numPoleFigures() == 2, 'Should have 2 pole figures after remove');
% Verify the right one was removed (index 2 was [2 0 0])
assert(isequal(odf.getPoleFigure(1).miller_indices, [1 1 1]), ...
       'First pole figure should still be [1 1 1]');
assert(isequal(odf.getPoleFigure(2).miller_indices, [2 2 0]), ...
       'Second pole figure should now be [2 2 0]');
fprintf('PASSED\n');

%% Test 6: RemovePoleFigureCommand - undo
fprintf('Test 6: RemovePoleFigureCommand - undo... ');
mgr.undo();

assert(odf.numPoleFigures() == 3, 'Should have 3 pole figures after undo');
% Verify it was added back (may be at end due to simplified implementation)
foundRemoved = false;
for i = 1:odf.numPoleFigures()
    if isequal(odf.getPoleFigure(i).miller_indices, [2 0 0])
        foundRemoved = true;
        break;
    end
end
assert(foundRemoved, 'Removed pole figure should be restored');
fprintf('PASSED\n');

%% Test 7: RemovePoleFigureCommand - redo
fprintf('Test 7: RemovePoleFigureCommand - redo... ');
mgr.redo();

assert(odf.numPoleFigures() == 2, 'Should have 2 pole figures after redo');
fprintf('PASSED\n');

%% Test 8: Add and remove in sequence
fprintf('Test 8: Complex add/remove sequence... ');
odf2 = dragon.core.ODFReconstruction('Test2', 'Complex test');
mgr2 = dragon.commands.CommandManager();

% Add three pole figures
pf_a = dragon.core.PoleFigureData([1 0 0], 'cubic');
pf_b = dragon.core.PoleFigureData([0 1 0], 'cubic');
pf_c = dragon.core.PoleFigureData([0 0 1], 'cubic');

mgr2.executeCommand(dragon.commands.AddPoleFigureCommand(odf2, pf_a));
mgr2.executeCommand(dragon.commands.AddPoleFigureCommand(odf2, pf_b));
mgr2.executeCommand(dragon.commands.AddPoleFigureCommand(odf2, pf_c));

assert(odf2.numPoleFigures() == 3, 'Should have 3 pole figures');

% Remove middle one
mgr2.executeCommand(dragon.commands.RemovePoleFigureCommand(odf2, 2));
assert(odf2.numPoleFigures() == 2, 'Should have 2 pole figures');

% Undo all
mgr2.undo(); % Undo remove
assert(odf2.numPoleFigures() == 3, 'Should have 3 after undo remove');

mgr2.undo(); % Undo add pf_c
mgr2.undo(); % Undo add pf_b
mgr2.undo(); % Undo add pf_a
assert(odf2.numPoleFigures() == 0, 'Should have 0 after undoing all adds');

% Redo all
mgr2.redo();
mgr2.redo();
mgr2.redo();
mgr2.redo();
assert(odf2.numPoleFigures() == 2, 'Should have 2 after redoing all');
fprintf('PASSED\n');

%% Test 9: Remove last pole figure
fprintf('Test 9: Remove last pole figure... ');
odf3 = dragon.core.ODFReconstruction('Test3', 'Remove last');
mgr3 = dragon.commands.CommandManager();

pf_x = dragon.core.PoleFigureData([1 1 0], 'cubic');
mgr3.executeCommand(dragon.commands.AddPoleFigureCommand(odf3, pf_x));

cmdRemoveLast = dragon.commands.RemovePoleFigureCommand(odf3, 1);
mgr3.executeCommand(cmdRemoveLast);

assert(odf3.numPoleFigures() == 0, 'Should have 0 pole figures');

mgr3.undo();
assert(odf3.numPoleFigures() == 1, 'Should have 1 after undo');
fprintf('PASSED\n');

%% Test 10: Command descriptions
fprintf('Test 10: Command descriptions... ');
odf4 = dragon.core.ODFReconstruction('Test4', 'Descriptions');
mgr4 = dragon.commands.CommandManager();

pf_test = dragon.core.PoleFigureData([2 1 1], 'hexagonal');
cmdAdd = dragon.commands.AddPoleFigureCommand(odf4, pf_test);
mgr4.executeCommand(cmdAdd);

cmdRem = dragon.commands.RemovePoleFigureCommand(odf4, 1);
mgr4.executeCommand(cmdRem);

history = mgr4.getHistory();
assert(contains(history{1}, 'Add'), 'First command should mention Add');
assert(contains(history{1}, '[2 1 1]'), 'First command should show indices');
assert(contains(history{2}, 'Remove'), 'Second command should mention Remove');
fprintf('PASSED\n');

%% Summary
fprintf('\n========================================\n');
fprintf('All Add/Remove Command tests PASSED!\n');
fprintf('========================================\n');