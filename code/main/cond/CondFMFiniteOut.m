classdef CondFMFiniteOut < InstancesMapper
    %CONDFMFINITEOUT Generic conditional mean embedding operator using 
    %finite-dimensional feature map (primal solution) i.e., k(x,y)=phi(x)*phi(y)
    %where phi(x) is explicit and finite-dimensional.
    %
    % The operator is for outputs using finite-dimensional feature maps.
    % C_{Z|X} where Z is the output, X is the input. This class supports
    % multiple inputs by considering them to be from a tensor product
    % space.
    properties (SetAccess=private)
        
        featureMap;
        regParam; %regularization parameter
        
        % matrix needed in mapInstances(). dz x numFeatures
        mapMatrix;
    end
    
    methods
        
        function this = CondFMFiniteOut(fm, In, Out, lambda)
            % fm = a FeatureMap
            % In = training Instances 
            % Out = a matrix of outputs
            % lambda = regularization parameter
            %
            assert(isnumeric(Out));
            assert(isa(fm, 'FeatureMap'));
            assert(isnumeric(lambda) && lambda >= 0, 'regularization param must be non-negative.');
            
            %this.Out = Out;
            this.featureMap = fm;
            this.regParam = lambda;
            
            P = fm.genFeatures(In); % D x n where D = numFeatures
            D = size(P, 1);
            Q = Out*P'; % dy x D
            % This step can be expensive. O(D^3). But need to be done only once.
            % P*P' costs O(ND^2)
            T = Q/(P*P' + lambda*eye(D));
            this.mapMatrix = T;
        end
        
        
        function Zout = mapInstances(this, Xin)
            % Map Instances in Xin to Zout with this operator.
            assert(isa(Xin, 'Instances'));
            T = this.mapMatrix;
            fm = this.featureMap;
            Pin = fm.genFeatures(Xin);

            Zout = T*Pin;
        end
        
        function s = shortSummary(this)
            s = sprintf('%s(%s)', mfilename, this.featureMap.shortSummary());
        end
    end %end methods
    
    methods (Static)
        
        function [Op, C] = learn_operator(In, Out,  op)
            % In is likely to be a TensorInstances
            assert(isa(In, 'Instances'));
            [ C] = cond_fm_finiteout( In, Out, op );
            bestMap = C.bfeaturemap;
            lambda = C.blambda;
            % Allow the change of numFeatures in case the number is reduced 
            % during  LOOCV.
            op.num_primal_features = myProcessOptions(op, 'num_primal_features', ...
                2000);
            map = bestMap.cloneParams(op.num_primal_features);
            Op = CondFMFiniteOut(map, In, Out, lambda);
        end
        
      
    end
    
end
