function obj = setRawImage(obj, image)
    % SETRAWIMAGE Set the raw pole figure image
    %
    % Syntax:
    %   obj = obj.setRawImage(image)
    %
    % Input:
    %   image - Raw pole figure image array
    
    obj.raw_image = image;
    obj.metadata.timestamp = datetime('now');
end