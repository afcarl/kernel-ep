classdef Gauss1TensorMapper2In < DistMapper2
    %GAUSS1TENSORMAPPER2IN A distribution mapper taking 2 Distribution's.
    % and outputs another DistNormal.
    %   - Use an InstancesMapper supporting TensorInstances of 2
    %   MV1Instances. 
    
    properties (SetAccess=private)
        % a conditional mean embedding operator
        operator;
    end
    
    methods
        function this=Gauss1TensorMapper2In(operator)
            assert(isa(operator, 'InstancesMapper'));
            this.operator = operator;
        end
        
        
        function dout = mapDist2(this, din1, din2)
            assert(isa(din1, 'Distribution'));
            assert(isa(din2, 'Distribution'));
            
            dins1 = MV1Instances(din1);
            dins2 = MV1Instances(din2);
            tensorIn =  TensorInstances({dins1, dins2});
            zout = this.operator.mapInstances(tensorIn);
            
            % we are working with a 1d Gaussian (for now)
            % mean = zout(1), uncenter 2nd moment = zout(2)
            dout = DistNormal(zout(1), zout(2)-zout(1)^2);
            
        end

        function s = shortSummary(this)
            s = sprintf('%s(%s)', mfilename, this.operator.shortSummary());
        end
    end
    
    
end

