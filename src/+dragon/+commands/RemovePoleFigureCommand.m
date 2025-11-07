classdef RemovePoleFigureCommand < dragon.commands.Command
    % REMOVEPOLEFIGURECOMMAND Command to remove a pole figure from reconstruction
    
    properties (Access = private)
        odf_recon dragon.core.ODFReconstruction
        index double
        removed_pf dragon.core.PoleFigureData
    end
    
    methods
        function obj = RemovePoleFigureCommand(odfRecon, index)
            % Constructor
            %
            % Inputs:
            %   odfRecon - dragon.core.ODFReconstruction object
            %   index - Index of pole figure to remove
            
            pf = odfRecon.getPoleFigure(index);
            description = sprintf('Remove pole figure (%s)', ...
                                  mat2str(pf.miller_indices));
            obj@dragon.commands.Command(description);
            
            obj.odf_recon = odfRecon;
            obj.index = index;
            obj.removed_pf = pf; % Store for undo
        end
        
        function execute(obj)
            % Execute the command
            obj.odf_recon = obj.odf_recon.removePoleFigure(obj.index);
        end
        
        function undo(obj)
            % Undo the command - add pole figure back (at end)
            % Note: Order doesn't affect ODF calculation
            obj.odf_recon = obj.odf_recon.addPoleFigure(obj.removed_pf);
        end
    end
end