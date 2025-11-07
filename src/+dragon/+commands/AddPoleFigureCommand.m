classdef AddPoleFigureCommand < dragon.commands.Command
    % ADDPOLEFIGURECOMMAND Command to add a pole figure to reconstruction
    
    properties (Access = private)
        odf_recon dragon.core.ODFReconstruction
        pf_data dragon.core.PoleFigureData
    end
    
    methods
        function obj = AddPoleFigureCommand(odfRecon, pfData)
            % Constructor
            %
            % Inputs:
            %   odfRecon - dragon.core.ODFReconstruction object
            %   pfData - dragon.core.PoleFigureData object to add
            
            description = sprintf('Add pole figure (%s)', ...
                                  mat2str(pfData.miller_indices));
            obj@dragon.commands.Command(description);
            
            obj.odf_recon = odfRecon;
            obj.pf_data = pfData;
        end
        
        function execute(obj)
            % Execute the command
            obj.odf_recon = obj.odf_recon.addPoleFigure(obj.pf_data);
        end
        
        function undo(obj)
            % Undo the command - remove the last pole figure
            n = obj.odf_recon.numPoleFigures();
            obj.odf_recon = obj.odf_recon.removePoleFigure(n);
        end
    end
end