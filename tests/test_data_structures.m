%% Test Data Structures
% Tests for ODFReconstruction and PoleFigureData creation and validation

%% Test 1: Create ODFReconstruction
fprintf('Test 1: Create ODFReconstruction... ');
odf = createODFReconstruction('Test ODF', 'Test description', 'Benjamin');

assert(~isempty(odf.info.id), 'ID should not be empty');
assert(strcmp(odf.info.name, 'Test ODF'), 'Name mismatch');
assert(strcmp(odf.info.author, 'Benjamin'), 'Author mismatch');
assert(isempty(odf.pole_figures), 'pole_figures should be empty cell array');
fprintf('PASSED\n');

%% Test 2: Validate valid ODFReconstruction
fprintf('Test 2: Validate valid ODFReconstruction... ');
[isValid, errorMsg] = validateODFReconstruction(odf);
assert(isValid, ['Validation failed: ' errorMsg]);
fprintf('PASSED\n');

%% Test 3: Create PoleFigureData - cubic
fprintf('Test 3: Create PoleFigureData (cubic)... ');
pf1 = createPoleFigureData([1 1 1], 'cubic');

assert(~isempty(pf1.id), 'ID should not be empty');
assert(isequal(pf1.miller_indices, [1 1 1]), 'Miller indices mismatch');
assert(strcmp(pf1.crystal_symmetry, 'cubic'), 'Crystal symmetry mismatch');
fprintf('PASSED\n');

%% Test 4: Create PoleFigureData - hexagonal (4-index)
fprintf('Test 4: Create PoleFigureData (hexagonal)... ');
pf2 = createPoleFigureData([0 0 0 1], 'hexagonal');

assert(isequal(pf2.miller_indices, [0 0 0 1]), 'Miller indices mismatch');
assert(strcmp(pf2.crystal_symmetry, 'hexagonal'), 'Crystal symmetry mismatch');
fprintf('PASSED\n');

%% Test 5: Validate valid PoleFigureData
fprintf('Test 5: Validate valid PoleFigureData... ');
[isValid, errorMsg] = validatePoleFigureData(pf1);
assert(isValid, ['Validation failed: ' errorMsg]);
fprintf('PASSED\n');

%% Test 6: Validate invalid PoleFigureData (bad miller indices)
fprintf('Test 6: Validate invalid PoleFigureData (bad indices)... ');
pfBad = pf1;
pfBad.miller_indices = [1 2]; % Wrong length
[isValid, errorMsg] = validatePoleFigureData(pfBad);
assert(~isValid, 'Should have failed validation');
assert(contains(errorMsg, 'miller_indices'), 'Error message should mention miller_indices');
fprintf('PASSED\n');

%% Test 7: Validate invalid crystal symmetry
fprintf('Test 7: Validate invalid crystal symmetry... ');
pfBad = pf1;
pfBad.crystal_symmetry = 'invalid_symmetry';
[isValid, errorMsg] = validatePoleFigureData(pfBad);
assert(~isValid, 'Should have failed validation');
assert(contains(errorMsg, 'crystal_symmetry'), 'Error message should mention crystal_symmetry');
fprintf('PASSED\n');

%% Test 8: Add pole figure to ODFReconstruction
fprintf('Test 8: Add pole figure to ODFReconstruction... ');
odf.pole_figures{end+1} = pf1;
odf.pole_figures{end+1} = pf2;

assert(length(odf.pole_figures) == 2, 'Should have 2 pole figures');
[isValid, errorMsg] = validateODFReconstruction(odf);
assert(isValid, ['Validation failed after adding pole figures: ' errorMsg]);
fprintf('PASSED\n');

%% Test 9: Unique IDs
fprintf('Test 9: Verify unique IDs... ');
pf3 = createPoleFigureData([2 0 0], 'cubic');
assert(~strcmp(pf1.id, pf3.id), 'IDs should be unique');

odf2 = createODFReconstruction('Test 2', 'Another test');
assert(~strcmp(odf.info.id, odf2.info.id), 'ODF IDs should be unique');
fprintf('PASSED\n');

%% Summary
fprintf('\n========================================\n');
fprintf('All tests PASSED!\n');
fprintf('========================================\n');