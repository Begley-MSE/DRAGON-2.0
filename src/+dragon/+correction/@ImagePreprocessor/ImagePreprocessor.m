classdef ImagePreprocessor < handle
    % IMAGEPREPROCESSOR Handles image preprocessing for pole figures
    %
    % Properties:
    %   crop_params - Structure containing crop parameters
    
    properties
        crop_params struct
    end
    
    methods
        function obj = ImagePreprocessor()
            % Constructor for ImagePreprocessor
            %
            % Syntax:
            %   preprocessor = dragon.correction.ImagePreprocessor()
            
            obj.crop_params = struct();
        end
        
        % Method signatures (implementations in separate files)
        [croppedImage, cropRect] = cropImage(obj, image, cropRect)
        isValid = validateCrop(obj, image, cropRect)
    end
end