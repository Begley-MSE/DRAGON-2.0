function odfRecon = createODFReconstruction(name, description, author)
% CREATEODFRECONSTRUCTION Creates a new ODFReconstruction structure
%
% Syntax:
%   odfRecon = createODFReconstruction(name, description, author)
%
% Inputs:
%   name - String, name of the reconstruction
%   description - String, description of the reconstruction
%   author - String (optional), author name
%
% Outputs:
%   odfRecon - ODFReconstruction structure
%
% Example:
%   odf = createODFReconstruction('Steel Sheet', 'Cold rolled texture');

    % Handle optional inputs
    if nargin < 3
        author = '';
    end
    if nargin < 2
        description = '';
    end
    
    % Generate unique ID
    id = char(java.util.UUID.randomUUID());
    
    % Get current timestamp
    timestamp = datetime('now');
    
    % Create structure
    odfRecon.info.id = id;
    odfRecon.info.name = name;
    odfRecon.info.description = description;
    odfRecon.info.created = timestamp;
    odfRecon.info.modified = timestamp;
    odfRecon.info.author = author;
    
    odfRecon.pole_figures = {};
    
    odfRecon.odf_results.odf_data = [];
    odfRecon.odf_results.calculation_params = struct();
    odfRecon.odf_results.timestamp = [];
    
    odfRecon.settings = struct();
    
end