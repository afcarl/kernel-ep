classdef KLaplace < Kernel
    %KLAPLACE Laplace kernel on features generated by the specified FeatureExtractor
    %   - Kernel: exp( -sqrt( (x-y)'diag(widths)^-2 (x-y)) )
    
    properties (SetAccess=private)
        widths;
        featureExtractor;
    end
    
    methods
        
        function this=KLaplace(widths, fe)
            % widths of the Laplace kernel. One for each dimension of the input.
            % fe = a FeatureExtractor for input distributions
            assert(isnumeric(widths));
            assert(all(widths > 0));
            assert(isa(fe, 'FeatureExtractor'));
            % keep it as a row
            this.widths = widths(:)';
            this.featureExtractor = fe;

        end
        
        function Kmat = eval(this, d1, d2)
            assert(isa(d1, 'Distribution'));
            assert(isa(d2, 'Distribution'));
            w = this.widths;
            diagwInv = diag(1./w);
            F1 = this.featureExtractor.extractFeatures(d1);
            F2 = this.featureExtractor.extractFeatures(d2);
            % this will produce an error message if the number of parameters 
            % is not consistent with the number of features.
            F1 = diagwInv*F1;
            F2 = diagwInv*F2;
            D = sqrt(bsxfun(@plus, sum(F1.^2, 1)', sum(F2.^2, 1)) - 2*F1'*F2);
            Kmat = exp(-D);
        end
        
        function Kvec = pairEval(this, d1, d2)
            assert(isa(d1, 'Distribution'));
            assert(isa(d2, 'Distribution'));
            w = this.widths;
            diagwInv = diag(1./w);
            F1 = this.featureExtractor.extractFeatures(d1);
            F2 = this.featureExtractor.extractFeatures(d2);
            F1 = diagwInv*F1;
            F2 = diagwInv*F2;
            D = sqrt(sum((F1-F2).^2, 1));
            Kvec = exp(-D);
        end
        
        function Param = getParam(this)
            Param = num2cell(this.widths);
        end
        
        function s=shortSummary(this)
            s = sprintf('%s([%s], fe=%s)', mfilename, num2str(this.widths), ...
                this.featureExtractor.shortSummary());
        end
    end
    
    methods (Static)
        function Ks=candidates(params)
            % params is a numeric array
            KLap = KLaplace(params);
            Ks = num2cell(KLap);
        end
    end
    
end

