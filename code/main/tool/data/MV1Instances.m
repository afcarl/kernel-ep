classdef MV1Instances < Instances
    %MV1INSTANCES Instances representing many 1d Distribution's as
    %matrices of mean's and variance's
     %  data variable is a struct with fields
    %  - mean = a matrix with each column representing one mean. dxn
    %  - variance = a row vector
    %  - d = dimension of the distribution (= size(mean,1))
    %
    properties (SetAccess=private)
        mean;
        variance;
    end
    
    methods
        function this=MV1Instances(arr)
            % make sure it is 1d
            assert(any(size(arr)==1), 'array must be 1d');
            assert(isa(arr, 'Distribution'));
            
            this.mean = [arr.mean];
            assert(size(this.mean, 1)==1);
            this.variance = [arr.variance];
            assert(size(this.variance, 1)==1);

            warning('Should use DistArray instead of MV1Instances.')
        end
        
        function Data=get(this, Ind)
            Data = struct('d', 1, 'mean', this.mean(Ind), 'variance', ...
                this.variance(Ind));
        end
        
        function Data=getAll(this)
            Data = struct('d', 1, 'mean', this.mean, 'variance', ...
                this.variance);
        end
        

        function Ins=instances(this, Ind)
            
            % make a dummy MV1Instances
            Ins = MV1Instances(DistNormal(0, 1));
            Ins.mean = this.mean(Ind);
            Ins.variance = this.variance(Ind);
        end
        
        function l = count(this)
            l = length(this.mean);
        end
    end
end

