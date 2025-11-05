% DRAGON Startup Script
% Adds DRAGON folders to MATLAB path

% Get the directory where this script is located
dragonRoot = fileparts(mfilename('fullpath'));

% Add source directories to path
addpath(genpath(fullfile(dragonRoot, 'src')));
addpath(fullfile(dragonRoot, 'examples'));

% Display confirmation
fprintf('DRAGON paths added successfully.\n');
fprintf('Project root: %s\n', dragonRoot);

% Check for MTEX
if exist('crystalSymmetry', 'class')
    fprintf('MTEX detected: OK\n');
else
    warning('MTEX not found. Please install MTEX and add it to your path.');
end

% Check for Image Processing Toolbox
if license('test', 'Image_Toolbox')
    fprintf('Image Processing Toolbox: OK\n');
else
    warning('Image Processing Toolbox not found.');
end

clear dragonRoot