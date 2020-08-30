classdef SamplingSystem < handle
    % canonical = the canonical signal on which CS is tested upon
    
    % dim_signal = dimensions of the canonical signal as row vector
       
    % dim_segment = dimensions of the segment. The linear program is
    % solved for each segment separately. It pays off to try different
    % kinds of segmentation
    
    % dataunits = struct to hold multiple instances of the class DataUnit.
    
    % rate = the sampling rate
    
    % PARAM_SPGL1 = see documentation of spgl1
    
    % PARAM_sampling_centers_IS = should contain the std of 2d-gaussian
    % random variables in informed sampling.
    
    % predefined_locations_IS = contains the x,y -coordinates for the
    % gaussian centers. can be [] if not needed. coordinates should be in a
    % nx2 -matrix (2 columns)

    
    properties
        
        canonical
        dim_signal
        dim_segment
        dataunits
        rate 
        PARAM_SPGL1
        PARAM_sampling_centers_IS
        predefined_locations_IS
       
    end
    
    methods
        
        function obj = SamplingSystem(canonical,dim_segment,PARAM_SPGL1,center_parameters,rate,predefined_locations_IS)
            %   Constructor method for the class
            
            obj.canonical = canonical;
            obj.dim_signal = size(canonical);
            obj.dim_segment = dim_segment;
            obj.dataunits = struct([]);
            obj.PARAM_SPGL1 = PARAM_SPGL1;
            obj.rate = rate;
            obj.predefined_locations_IS = predefined_locations_IS;
            obj.PARAM_sampling_centers_IS = center_parameters;
            
        end
        
        function setNewRate(obj,newrate)
           obj.rate = newrate;
        end
        

        
        function addNewUnitRS(obj)
            % creates a new DataUnit and adds it to the list. Random
            % sampling
            [sample,locations] = GetMeASample.getRandomSamplingLocations(obj.canonical,obj.rate);
            unit = DataUnit(sample,locations,obj.dim_signal,obj.dim_segment,obj.rate);
            obj.dataunits(end+1).a = unit;
               
        end
        
        function addNewUnitIS(obj)
            % creates a new DataUnit and adds it to the list. Informed
            % sampling, user must define locations.
            [sample,locations] = GetMeASample.getInformedSamplingLocations(obj.canonical,obj.rate,obj.PARAM_sampling_centers_IS);
            unit = DataUnit(sample,locations,obj.dim_signal,obj.dim_segment,obj.rate);
            obj.dataunits(end+1).a = unit;
        end
        
        function addNewUnitISPredefinedLocations(obj)
            % Creates a new DataUnit and adds it to the list. Informed
            % sampling, predefined locations of IS centers. 
            [sample,locations] = GetMeASample.getInformedSamplingLocationsPredefinedLocations(obj.canonical,obj.rate,obj.PARAM_sampling_centers_IS,obj.predefined_locations_IS);
            unit = DataUnit(sample,locations,obj.dim_signal,obj.dim_segment,obj.rate);
            obj.dataunits(end+1).a = unit;
        end
        

        
        function plottingRoutine(obj)
            for index = 1:size(obj.dataunits,2)
               rate(index) = obj.dataunits(index).a.rate;
               %error(index) = norm(obj.canonical-getReconstruction(obj.dataunits(index).a));
               error(index) = getRelativeError(obj,getReconstruction(obj.dataunits(index).a));
               plot(rate,error,'*');
               xlabel('rate','FontSize',18);
               ylabel('relative error','FontSize',18);
               
            end
            
        end
        
        function rel_error = getRelativeError(obj,reconstruction)
            % gives the relative error in L1-norm
           osoittaja = sum(abs(obj.canonical-reconstruction));
           nimittaja = sum(abs(obj.canonical));
           rel_error = osoittaja/nimittaja;
        end
    end
end

