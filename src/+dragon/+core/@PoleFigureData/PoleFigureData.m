classdef PoleFigureData < handle
    % POLEFIGUREDATA Class for storing individual pole figure data
    %
    % Properties:
    %   id - Unique identifier
    %   miller_indices - Miller indices [h k l] or [h k i l]
    %   crystal_symmetry - Crystal symmetry system
    %   raw_image - Original image
    %   corrected_image - Geometrically corrected image
    %   correction_params - Transformation parameters
    %   circle_geometry - Circle center and radius
    %   annotations - Annotation data
    %   extracted_data - Quantified intensity grid
    %   metadata - Source, specimen info, notes
    
    properties
        id char
        miller_indices double
        crystal_symmetry char
        raw_image
        corrected_image
        correction_params struct
        circle_geometry struct
        annotations struct
        extracted_data
        metadata struct
    end
    
    methods
        function obj = PoleFigureData(millerIndices, crystalSymmetry)
            % Constructor for PoleFigureData
            %
            % Syntax:
            %   pf = dragon.PoleFigureData(millerIndices, crystalSymmetry)
            %
            % Example:
            %   pf = dragon.PoleFigureData([1 1 1], 'cubic');
            
            if nargin > 0
                % Generate unique ID
                obj.id = char(java.util.UUID.randomUUID());
                
                % Set Miller indices and symmetry
                obj.miller_indices = millerIndices;
                obj.crystal_symmetry = crystalSymmetry;
                
                % Initialize empty fields
                obj.raw_image = [];
                obj.corrected_image = [];
                obj.correction_params = struct();
                obj.circle_geometry = struct('center', [], 'radius', []);
                obj.annotations = struct();
                obj.extracted_data = [];
                
                % Initialize metadata
                obj.metadata = struct();
                obj.metadata.source = struct('title', '', 'figure', '');
                obj.metadata.specimen_info = '';
                obj.metadata.timestamp = datetime('now');
                obj.metadata.notes = '';
            end
        end
        
        % Method signatures (implementations in separate files)
        isValid = validate(obj)
        obj = setRawImage(obj, image)
        obj = setCorrectedImage(obj, image, params, geometry)
        obj = setMetadata(obj, field, value)
        obj = setSource(obj, title, figure)
        newObj = copy(obj)
    end
end