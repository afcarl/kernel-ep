classdef FeatureMap < handle 
    %FEATUREMAP A finite-dimensional features generator.
    %This is useful for implementing primal solutions using random features, for instance. 
    %The features generated by this FeatureMap do not generally have to be random. 

    properties
    end
   
    methods (Abstract)
        % Generate a feature vector Z given some input 
        Z=genFeatures(this, in)  

        % Short summary of this FeatureMap. Useful if in the form
        % mapName(param1, param2).
        s=shortSummary(this);
    end
    
end
