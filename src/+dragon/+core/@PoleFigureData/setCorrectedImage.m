function obj = setCorrectedImage(obj, image, params, geometry)
    % SETCORRECTEDIMAGE Set the corrected image with parameters
    %
    % Syntax:
    %   obj = obj.setCorrectedImage(image, params, geometry)
    %
    % Inputs:
    %   image - Corrected image array
    %   params - Structure with correction parameters
    %   geometry - Structure with circle center and radius
    
    obj.corrected_image = image;
    obj.correction_params = params;
    obj.circle_geometry = geometry;
    obj.metadata.timestamp = datetime('now');
end