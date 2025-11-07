function [croppedImage, cropRect] = cropImage(obj, image, cropRect)
    % CROPIMAGE Crop image to region of interest
    %
    % Syntax:
    %   [croppedImage, cropRect] = obj.cropImage(image, cropRect)
    %   [croppedImage, cropRect] = obj.cropImage(image) % Interactive
    %
    % Inputs:
    %   image - Input image (grayscale or RGB)
    %   cropRect - [x, y, width, height] crop rectangle (optional)
    %              If not provided, uses interactive selection
    %
    % Outputs:
    %   croppedImage - Cropped image
    %   cropRect - [x, y, width, height] of the crop
    %
    % Example:
    %   preprocessor = dragon.correction.ImagePreprocessor();
    %   [cropped, rect] = preprocessor.cropImage(img, [100 100 300 300]);
    
    % Validate input
    if ~isnumeric(image) && ~islogical(image)
        error('ImagePreprocessor:InvalidImage', ...
              'Image must be numeric or logical array');
    end
    
    [rows, cols, ~] = size(image);
    
    % If cropRect not provided, use interactive selection
    if nargin < 3 || isempty(cropRect)
        fprintf('Select crop region interactively...\n');
        [croppedImage, cropRect] = imcrop(image);
    else
        % Validate crop rectangle
        if ~obj.validateCrop(image, cropRect)
            error('ImagePreprocessor:InvalidCrop', ...
                  'Invalid crop rectangle');
        end
        
        % Use imcrop with specified rectangle
        croppedImage = imcrop(image, cropRect);
    end
    
    % Store crop parameters
    obj.crop_params.original_size = [rows, cols];
    obj.crop_params.crop_rect = cropRect;
    obj.crop_params.cropped_size = size(croppedImage);
end