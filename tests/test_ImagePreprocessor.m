%% Test ImagePreprocessor Class
% Tests for dragon.correction.ImagePreprocessor

%% Setup - Load test images
projectRoot = dragon.utils.getDRAGONRoot();
% User should place test images in data/examples/
% For now, we'll create synthetic images if real ones aren't available

%% Test 1: Create ImagePreprocessor
fprintf('Test 1: Create ImagePreprocessor... ');
preprocessor = dragon.correction.ImagePreprocessor();

assert(isa(preprocessor, 'dragon.correction.ImagePreprocessor'), ...
       'Should create ImagePreprocessor');
assert(isstruct(preprocessor.crop_params), 'crop_params should be struct');
fprintf('PASSED\n');

%% Test 2: Create synthetic test image
fprintf('Test 2: Create synthetic test image... ');
% Create a synthetic pole figure image with labels
imgSize = 500;
img = 255 * ones(imgSize, imgSize, 'uint8');

% Draw circular pole figure
center = [250, 250];
radius = 150;
[xx, yy] = meshgrid(1:imgSize, 1:imgSize);
circleMask = sqrt((xx - center(1)).^2 + (yy - center(2)).^2) <= radius;
img(circleMask) = 200;

% Add some contours
for r = 50:30:radius
    contourMask = abs(sqrt((xx - center(1)).^2 + (yy - center(2)).^2) - r) < 2;
    img(contourMask) = 50;
end

assert(size(img, 1) == imgSize && size(img, 2) == imgSize, ...
       'Image should be created');
fprintf('PASSED\n');

%% Test 3: Validate good crop rectangle
fprintf('Test 3: Validate good crop rectangle... ');
goodCrop = [100, 100, 300, 300];
isValid = preprocessor.validateCrop(img, goodCrop);

assert(isValid, 'Good crop should be valid');
fprintf('PASSED\n');

%% Test 4: Validate bad crop (out of bounds)
fprintf('Test 4: Validate bad crop (out of bounds)... ');
badCrop = [400, 400, 300, 300]; % Extends outside image
lastwarn('');
isValid = preprocessor.validateCrop(img, badCrop);

assert(~isValid, 'Out of bounds crop should be invalid');
[~, warnId] = lastwarn;
assert(contains(warnId, 'OutOfBounds'), 'Should warn about out of bounds');
fprintf('PASSED\n');

%% Test 5: Validate bad crop (negative dimensions)
fprintf('Test 5: Validate bad crop (negative dimensions)... ');
badCrop2 = [100, 100, -50, 100];
lastwarn('');
isValid = preprocessor.validateCrop(img, badCrop2);

assert(~isValid, 'Negative dimension crop should be invalid');
fprintf('PASSED\n');

%% Test 6: Validate bad crop (too small)
fprintf('Test 6: Validate bad crop (too small)... ');
badCrop3 = [100, 100, 30, 30]; % Smaller than 50x50 minimum
lastwarn('');
isValid = preprocessor.validateCrop(img, badCrop3);

assert(~isValid, 'Too small crop should be invalid');
[~, warnId] = lastwarn;
assert(contains(warnId, 'TooSmall'), 'Should warn about size');
fprintf('PASSED\n');

%% Test 7: Programmatic crop
fprintf('Test 7: Programmatic crop... ');
cropRect = [100, 100, 300, 300];
[croppedImg, returnedRect] = preprocessor.cropImage(img, cropRect);

% imcrop may return slightly different size due to coordinate handling
% Check that it's approximately correct (within 1 pixel)
assert(abs(size(croppedImg, 1) - 300) <= 1, 'Cropped height should be ~300');
assert(abs(size(croppedImg, 2) - 300) <= 1, 'Cropped width should be ~300');
assert(isequal(returnedRect, cropRect), 'Returned rect should match input');
assert(~isempty(preprocessor.crop_params.crop_rect), ...
       'Crop params should be stored');
fprintf('PASSED\n');

%% Test 8: Crop parameters storage
fprintf('Test 8: Crop parameters storage... ');
assert(isequal(preprocessor.crop_params.original_size, [500, 500]), ...
       'Original size should be stored');
% Check cropped size is approximately correct
cropSize = preprocessor.crop_params.cropped_size;
assert(abs(cropSize(1) - 300) <= 1 && abs(cropSize(2) - 300) <= 1, ...
       'Cropped size should be approximately correct');
fprintf('PASSED\n');

%% Test 9: Crop RGB image
fprintf('Test 9: Crop RGB image... ');
imgRGB = cat(3, img, img, img);
preprocessor2 = dragon.correction.ImagePreprocessor();
cropRect2 = [50, 50, 200, 200];
[croppedRGB, ~] = preprocessor2.cropImage(imgRGB, cropRect2);

assert(size(croppedRGB, 3) == 3, 'Should preserve RGB channels');
assert(abs(size(croppedRGB, 1) - 200) <= 1, 'RGB height should be ~200');
assert(abs(size(croppedRGB, 2) - 200) <= 1, 'RGB width should be ~200');
fprintf('PASSED\n');

%% Test 10: Crop near boundaries
fprintf('Test 10: Crop near image boundaries... ');
preprocessor3 = dragon.correction.ImagePreprocessor();
cropRect3 = [1, 1, 100, 100]; % Top-left corner
[croppedCorner, ~] = preprocessor3.cropImage(img, cropRect3);

assert(abs(size(croppedCorner, 1) - 100) <= 1, 'Corner crop height should be ~100');
assert(abs(size(croppedCorner, 2) - 100) <= 1, 'Corner crop width should be ~100');
fprintf('PASSED\n');

%% Manual test instructions (commented out - requires user interaction)
fprintf('\n=== Manual Interactive Test ===\n');
fprintf('Uncomment this section to test interactive cropping\n');
preprocessor4 = dragon.correction.ImagePreprocessor();
figure; imshow(img, []);
title('Test image - will open crop tool next');
pause(2);
[croppedInteractive, rectInteractive] = preprocessor4.cropImage(img);
figure; imshow(croppedInteractive, []);
title('Interactively cropped result');

%% Summary
fprintf('\n========================================\n');
fprintf('All ImagePreprocessor tests PASSED!\n');
fprintf('========================================\n');
fprintf('\nTo test with real pole figure images:\n');
fprintf('1. Place images in data/examples/\n');
fprintf('2. Load with: img = imread(''data/examples/yourimage.png'');\n');
fprintf('3. Test cropping: [cropped, rect] = preprocessor.cropImage(img);\n');