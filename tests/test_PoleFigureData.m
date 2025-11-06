%% Test PoleFigureData Class
% Tests for dragon.core.PoleFigureData

%% Test 1: Create PoleFigureData - cubic
fprintf('Test 1: Create PoleFigureData (cubic)... ');
pf1 = dragon.core.PoleFigureData([1 1 1], 'cubic');

assert(~isempty(pf1.id), 'ID should not be empty');
assert(isequal(pf1.miller_indices, [1 1 1]), 'Miller indices mismatch');
assert(strcmp(pf1.crystal_symmetry, 'cubic'), 'Crystal symmetry mismatch');
assert(isempty(pf1.raw_image), 'raw_image should be empty initially');
assert(isstruct(pf1.metadata), 'metadata should be a struct');
fprintf('PASSED\n');

%% Test 2: Create PoleFigureData - hexagonal (4-index)
fprintf('Test 2: Create PoleFigureData (hexagonal)... ');
pf2 = dragon.core.PoleFigureData([0 0 0 1], 'hexagonal');

assert(isequal(pf2.miller_indices, [0 0 0 1]), 'Miller indices mismatch');
assert(strcmp(pf2.crystal_symmetry, 'hexagonal'), 'Crystal symmetry mismatch');
fprintf('PASSED\n');

%% Test 3: Validate valid PoleFigureData
fprintf('Test 3: Validate valid PoleFigureData... ');
isValid = pf1.validate();
assert(isValid, 'Validation should pass');
fprintf('PASSED\n');

%% Test 4: Validate invalid miller indices
fprintf('Test 4: Validate invalid miller indices... ');
pfBad = pf1.copy(); % Use copy() instead of assignment
pfBad.miller_indices = [1 2]; % Wrong length
try
    pfBad.validate();
    error('Should have thrown an error');
catch ME
    assert(contains(ME.identifier, 'InvalidIndices'), ...
           'Should throw InvalidIndices error');
end
fprintf('PASSED\n');

%% Test 5: Validate invalid crystal symmetry
fprintf('Test 5: Validate invalid crystal symmetry... ');
pfBad = pf1.copy(); % Use copy() instead of assignment
pfBad.crystal_symmetry = 'invalid_symmetry';
try
    pfBad.validate();
    error('Should have thrown an error');
catch ME
    assert(contains(ME.identifier, 'InvalidSymmetry'), ...
           'Should throw InvalidSymmetry error');
end
fprintf('PASSED\n');

%% Test 6: Set raw image
fprintf('Test 6: Set raw image... ');
testImage = rand(100, 100);
pf1 = pf1.setRawImage(testImage);

assert(isequal(pf1.raw_image, testImage), 'Raw image not set correctly');
assert(~isempty(pf1.metadata.timestamp), 'Timestamp should be updated');
fprintf('PASSED\n');

%% Test 7: Set corrected image
fprintf('Test 7: Set corrected image... ');
correctedImage = rand(100, 100);
params = struct('transform', eye(3), 'scale', 1.0);
geometry = struct('center', [50, 50], 'radius', 45);

pf1 = pf1.setCorrectedImage(correctedImage, params, geometry);

assert(isequal(pf1.corrected_image, correctedImage), 'Corrected image not set');
assert(isequal(pf1.correction_params, params), 'Correction params not set');
assert(isequal(pf1.circle_geometry, geometry), 'Circle geometry not set');
fprintf('PASSED\n');

%% Test 8: Set metadata
fprintf('Test 8: Set metadata... ');
pf1 = pf1.setMetadata('specimen_info', 'Cold rolled steel');

assert(strcmp(pf1.metadata.specimen_info, 'Cold rolled steel'), ...
       'Metadata not set correctly');
fprintf('PASSED\n');

%% Test 9: Set source
fprintf('Test 9: Set source... ');
pf1 = pf1.setSource('Smith et al. 1985', 'Figure 3a');

assert(strcmp(pf1.metadata.source.title, 'Smith et al. 1985'), ...
       'Source title not set');
assert(strcmp(pf1.metadata.source.figure, 'Figure 3a'), ...
       'Source figure not set');
fprintf('PASSED\n');

%% Test 10: Unique IDs
fprintf('Test 10: Verify unique IDs... ');
pf3 = dragon.core.PoleFigureData([2 0 0], 'cubic');
pf4 = dragon.core.PoleFigureData([2 0 0], 'cubic');

assert(~strcmp(pf3.id, pf4.id), 'IDs should be unique');
fprintf('PASSED\n');

%% Test 11: Metadata timestamp updates
fprintf('Test 11: Verify timestamp updates... ');
pf5 = dragon.core.PoleFigureData([1 0 0], 'cubic');
t1 = pf5.metadata.timestamp;
pause(0.01); % Small pause to ensure different timestamp
pf5 = pf5.setRawImage(rand(50, 50));
t2 = pf5.metadata.timestamp;

assert(t2 > t1, 'Timestamp should be updated after setRawImage');
fprintf('PASSED\n');

%% Test 12: Copy creates independent object
fprintf('Test 12: Copy creates independent object... ');
pf_original = dragon.core.PoleFigureData([1 1 0], 'cubic');
pf_original = pf_original.setMetadata('specimen_info', 'Original sample');
pf_original = pf_original.setSource('Smith 2020', 'Fig 5');

pf_copy = pf_original.copy();

% Verify copy has same data
assert(isequal(pf_copy.miller_indices, pf_original.miller_indices), ...
       'Copy should have same Miller indices');
assert(strcmp(pf_copy.crystal_symmetry, pf_original.crystal_symmetry), ...
       'Copy should have same crystal symmetry');
assert(strcmp(pf_copy.metadata.specimen_info, pf_original.metadata.specimen_info), ...
       'Copy should have same metadata');

% Verify they have different IDs
assert(~strcmp(pf_copy.id, pf_original.id), ...
       'Copy should have different ID');
fprintf('PASSED\n');

%% Test 13: Copy is truly independent (deep copy)
fprintf('Test 13: Copy is independent (modifications don''t affect original)... ');
pf_copy = pf_copy.setMetadata('specimen_info', 'Modified sample');

assert(strcmp(pf_copy.metadata.specimen_info, 'Modified sample'), ...
       'Copy metadata should be modified');
assert(strcmp(pf_original.metadata.specimen_info, 'Original sample'), ...
       'Original metadata should be unchanged');
fprintf('PASSED\n');

%% Test 14: Copy with images
fprintf('Test 14: Copy with images... ');
pf_with_images = dragon.core.PoleFigureData([1 0 0], 'cubic');
testImage = rand(50, 50);
pf_with_images = pf_with_images.setRawImage(testImage);

pf_copy2 = pf_with_images.copy();

assert(isequal(pf_copy2.raw_image, pf_with_images.raw_image), ...
       'Copy should have same raw image data');

% Modify copy's image and verify original is unchanged
pf_copy2.raw_image(1,1) = 999;
assert(pf_with_images.raw_image(1,1) ~= 999, ...
       'Original image should be unchanged');
fprintf('PASSED\n');

%% Summary
fprintf('\n========================================\n');
fprintf('All PoleFigureData tests PASSED!\n');
fprintf('========================================\n');