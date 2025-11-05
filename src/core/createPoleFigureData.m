function pfData = createPoleFigureData(millerIndices, crystalSymmetry)
% CREATEPOLEFIGUREDATA Creates a new PoleFigureData structure
%
% Syntax:
%   pfData = createPoleFigureData(millerIndices, crystalSymmetry)
%
% Inputs:
%   millerIndices - Vector [h k l] or [h k i l] for hexagonal
%   crystalSymmetry - String ('cubic', 'hexagonal', 'orthorhombic', etc.)
%
% Outputs:
%   pfData - PoleFigureData structure
%
% Example:
%   pf = createPoleFigureData([1 1 1], 'cubic');

    % Generate unique ID
    id = char(java.util.UUID.randomUUID());
    
    % Create structure
    pfData.id = id;
    pfData.miller_indices = millerIndices;
    pfData.crystal_symmetry = crystalSymmetry;
    
    pfData.raw_image = [];
    pfData.corrected_image = [];
    pfData.correction_params = struct();
    pfData.circle_geometry.center = [];
    pfData.circle_geometry.radius = [];
    
    pfData.annotations = struct();
    pfData.extracted_data = [];
    
    % Initialize metadata
    pfData.metadata.source.title = '';
    pfData.metadata.source.figure = '';
    pfData.metadata.specimen_info = '';
    pfData.metadata.timestamp = datetime('now');
    pfData.metadata.notes = '';
    
end