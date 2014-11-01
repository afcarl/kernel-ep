classdef KLaplace < Kernel
    %KLAPLACE Laplace kernel on features generated by the specified FeatureExtractor
    %   - Kernel: exp( -|x-y|/width )
    
    properties (SetAccess=private)
        width;
        featureExtractor;
    end
    
    methods
        
        function this=KLaplace(width, fe)
            % width of the Laplace kernel
            % fe = a FeatureExtractor for input distributions
            assert(isnumeric(width));
            assert(width > 0);
            assert(isa(fe, 'FeatureExtractor'));
            this.width = width;
            this.featureExtractor = fe;

        end
        
        function Kmat = eval(this, d1, d2)
            assert(isa(d1, 'Distribution'));
            assert(isa(d2, 'Distribution'));
            w = this.width;
            F1 = this.featureExtractor.extractFeatures(d1);
            F2 = this.featureExtractor.extractFeatures(d2);
            D = sqrt(bsxfun(@plus, sum(F1.^2, 1)', sum(F2.^2, 1)) - 2*F1'*F2);
            Kmat = exp(-D/w);
            
        end
        
        function Kvec = pairEval(this, d1, d2)
            assert(isa(d1, 'Distribution'));
            assert(isa(d2, 'Distribution'));
            w = this.width;
            F1 = this.featureExtractor.extractFeatures(d1);
            F2 = this.featureExtractor.extractFeatures(d2);
            D = sqrt(sum((F1-F2).^2, 1));
            Kvec = exp(-D/w);
        end
        
        function Param = getParam(this)
            Param = {this.width};
        end
        
        function s=shortSummary(this)
            s = sprintf('%s(%.3g, fe=%s)', mfilename, this.width, ...
                this.featureExtractor.shortSummary());
        end
    end
    
    methods (Static)
        function Ks=candidates(params)
            % params is a numeric array
            Kgauss = KLaplace(params);
            Ks = num2cell(Kgauss);
        end
    end
    
end

