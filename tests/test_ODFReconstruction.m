%% Test ODFReconstruction Class
% Tests for dragon.core.ODFReconstruction

%% Test 1: Create ODFReconstruction
fprintf('Test 1: Create ODFReconstruction... ');
odf = dragon.core.ODFReconstruction('Test ODF', 'Test description', 'Benjamin');

assert(~isempty(odf.info.id), 'ID should not be empty');
assert(strcmp(odf.info.name, 'Test ODF'), 'Name mismatch');
assert(strcmp(odf.info.author, 'Benjamin'), 'Author mismatch');
assert(isempty(odf.pole_figures), 'pole_figures should be empty');
assert(odf.numPoleFigures() == 0, 'Should have 0 pole figures');
fprintf('PASSED\n');

%% Test 2: Create with minimal arguments
fprintf('Test 2: Create with minimal arguments... ');
odf2 = dragon.core.ODFReconstruction('Minimal');
assert(strcmp(odf2.info.name, 'Minimal'), 'Name mismatch');
assert(strcmp(odf2.info.description, ''), 'Description should be empty');
assert(strcmp(odf2.info.author, ''), 'Author should be empty');
fprintf('PASSED\n');

%% Test 3: Validate empty ODFReconstruction
fprintf('Test 3: Validate empty ODFReconstruction... ');
isValid = odf.validate();
assert(isValid, 'Empty reconstruction should be valid');
fprintf('PASSED\n');

%% Test 4: Add pole figure
fprintf('Test 4: Add pole figure... ');
pf1 = dragon.core.PoleFigureData([1 1 1], 'cubic');
pf1 = pf1.setSource('Test Paper', 'Fig 1a');
odf = odf.addPoleFigure(pf1);

assert(odf.numPoleFigures() == 1, 'Should have 1 pole figure');
fprintf('PASSED\n');

%% Test 5: Add multiple pole figures
fprintf('Test 5: Add multiple pole figures... ');
pf2 = dragon.core.PoleFigureData([2 0 0], 'cubic');
pf3 = dragon.core.PoleFigureData([2 2 0], 'cubic');
odf = odf.addPoleFigure(pf2);
odf = odf.addPoleFigure(pf3);

assert(odf.numPoleFigures() == 3, 'Should have 3 pole figures');
fprintf('PASSED\n');

%% Test 6: Get pole figure
fprintf('Test 6: Get pole figure... ');
retrieved = odf.getPoleFigure(2);

assert(isa(retrieved, 'dragon.core.PoleFigureData'), 'Should be PoleFigureData');
assert(isequal(retrieved.miller_indices, [2 0 0]), 'Should get correct pole figure');
fprintf('PASSED\n');

%% Test 7: Get pole figure - invalid index
fprintf('Test 7: Get pole figure - invalid index... ');
try
    odf.getPoleFigure(10);
    error('Should have thrown an error');
catch ME
    assert(contains(ME.identifier, 'InvalidIndex'), 'Should throw InvalidIndex error');
end
fprintf('PASSED\n');

%% Test 8: Remove pole figure
fprintf('Test 8: Remove pole figure... ');
odf = odf.removePoleFigure(2);

assert(odf.numPoleFigures() == 2, 'Should have 2 pole figures after removal');
retrieved = odf.getPoleFigure(2);
assert(isequal(retrieved.miller_indices, [2 2 0]), 'Indices should shift after removal');
fprintf('PASSED\n');

%% Test 9: Remove pole figure - invalid index
fprintf('Test 9: Remove pole figure - invalid index... ');
try
    odf.removePoleFigure(10);
    error('Should have thrown an error');
catch ME
    assert(contains(ME.identifier, 'InvalidIndex'), 'Should throw InvalidIndex error');
end
fprintf('PASSED\n');

%% Test 10: Add invalid pole figure
fprintf('Test 10: Add invalid pole figure... ');
try
    odf = odf.addPoleFigure('not a pole figure');
    error('Should have thrown an error');
catch ME
    assert(contains(ME.identifier, 'InvalidInput'), 'Should throw InvalidInput error');
end
fprintf('PASSED\n');

%% Test 11: Validate with pole figures
fprintf('Test 11: Validate with pole figures... ');
isValid = odf.validate();
assert(isValid, 'Reconstruction with valid pole figures should be valid');
fprintf('PASSED\n');

%% Test 12: Unique IDs
fprintf('Test 12: Verify unique IDs... ');
odf3 = dragon.core.ODFReconstruction('Test 3');
odf4 = dragon.core.ODFReconstruction('Test 4');
assert(~strcmp(odf3.info.id, odf4.info.id), 'IDs should be unique');
fprintf('PASSED\n');

%% Test 13: Modified timestamp updates
fprintf('Test 13: Verify modified timestamp updates... ');
odf5 = dragon.core.ODFReconstruction('Test 5');
t1 = odf5.info.modified;
pause(0.01);
pf = dragon.core.PoleFigureData([1 0 0], 'cubic');
odf5 = odf5.addPoleFigure(pf);
t2 = odf5.info.modified;

assert(t2 > t1, 'Modified timestamp should update after adding pole figure');
fprintf('PASSED\n');

%% Test 14: Save and load
fprintf('Test 14: Save and load... ');
projectRoot = dragon.utils.getDRAGONRoot();
testFile = fullfile(projectRoot, 'data', 'projects', 'test_odf.mat');
odf.save(testFile);

assert(exist(testFile, 'file') == 2, 'File should exist after save');

odfLoaded = dragon.core.ODFReconstruction.load(testFile);
assert(strcmp(odfLoaded.info.id, odf.info.id), 'Loaded ID should match');
assert(strcmp(odfLoaded.info.name, odf.info.name), 'Loaded name should match');
assert(odfLoaded.numPoleFigures() == odf.numPoleFigures(), ...
       'Loaded should have same number of pole figures');

% Clean up
delete(testFile);
fprintf('PASSED\n');

%% Test 15: Save without extension
fprintf('Test 15: Save without extension... ');
projectRoot = dragon.utils.getDRAGONRoot();
testFile2 = fullfile(projectRoot, 'data', 'projects', 'test_odf2');
odf.save(testFile2);

assert(exist([testFile2 '.mat'], 'file') == 2, ...
       'File with .mat extension should exist');

% Clean up
delete([testFile2 '.mat']);
fprintf('PASSED\n');

%% Test 16: Load non-existent file
fprintf('Test 16: Load non-existent file... ');
try
    dragon.core.ODFReconstruction.load('nonexistent_file.mat');
    error('Should have thrown an error');
catch ME
    assert(contains(ME.identifier, 'FileNotFound'), 'Should throw FileNotFound error');
end
fprintf('PASSED\n');

%% Test 17: Copy ODFReconstruction
fprintf('Test 17: Copy ODFReconstruction... ');
odf_original = dragon.core.ODFReconstruction('Original', 'Test copy', 'Benjamin');
pf1 = dragon.core.PoleFigureData([1 1 1], 'cubic');
pf2 = dragon.core.PoleFigureData([2 0 0], 'cubic');
odf_original = odf_original.addPoleFigure(pf1);
odf_original = odf_original.addPoleFigure(pf2);

odf_copy = odf_original.copy();

% Verify copy has same data
assert(strcmp(odf_copy.info.name, odf_original.info.name), ...
       'Copy should have same name');
assert(odf_copy.numPoleFigures() == odf_original.numPoleFigures(), ...
       'Copy should have same number of pole figures');

% Verify different IDs
assert(~strcmp(odf_copy.info.id, odf_original.info.id), ...
       'Copy should have different ID');
fprintf('PASSED\n');

%% Test 18: Copy is independent
fprintf('Test 18: Copy is independent... ');
% Add a pole figure to the copy
pf3 = dragon.core.PoleFigureData([1 1 0], 'cubic');
odf_copy = odf_copy.addPoleFigure(pf3);

assert(odf_copy.numPoleFigures() == 3, 'Copy should have 3 pole figures');
assert(odf_original.numPoleFigures() == 2, 'Original should still have 2 pole figures');
fprintf('PASSED\n');

%% Test 19: Copy pole figures are independent
fprintf('Test 19: Copy pole figures are independent... ');
% Modify a pole figure in the copy
odf_copy.pole_figures{1} = odf_copy.pole_figures{1}.setMetadata('test', 'modified');

assert(isfield(odf_copy.pole_figures{1}.metadata, 'test'), ...
       'Copy pole figure should be modified');
assert(~isfield(odf_original.pole_figures{1}.metadata, 'test'), ...
       'Original pole figure should be unchanged');
fprintf('PASSED\n');

%% Summary
fprintf('\n========================================\n');
fprintf('All ODFReconstruction tests PASSED!\n');
fprintf('========================================\n');