function isValid = validateCrop(obj, image, cropRect)
    % VALIDATECROP Validate crop rectangle parameters
    %
    % Syntax:
    %   isValid = obj.validateCrop(image, cropRect)
    %
    % Inputs:
    %   image - Input image
    %   cropRect - [x, y, width, height] crop rectangle
    %
    % Output:
    %   isValid - Boolean, true if valid
    
    isValid = true;
    
    % Check cropRect format
    if ~isnumeric(cropRect) || length(cropRect) ~= 4
        warning('ImagePreprocessor:InvalidFormat', ...
                'cropRect must be [x, y, width, height]');
        isValid = false;
        return;
    end
    
    [rows, cols, ~] = size(image);
    
    x = cropRect(1);
    y = cropRect(2);
    w = cropRect(3);
    h = cropRect(4);
    
    % Check if values are positive
    if w <= 0 || h <= 0
        warning('ImagePreprocessor:InvalidDimensions', ...
                'Width and height must be positive');
        isValid = false;
        return;
    end
    
    % Check if crop is within image bounds
    if x < 1 || y < 1 || (x + w - 1) > cols || (y + h - 1) > rows
        warning('ImagePreprocessor:OutOfBounds', ...
                'Crop rectangle extends outside image bounds');
        isValid = false;
        return;
    end
    
    % Check minimum size (pole figure should be at least 50x50)
    if w < 50 || h < 50
        warning('ImagePreprocessor:TooSmall', ...
                'Crop region too small (minimum 50x50 pixels)');
        isValid = false;
        return;
    end
end