classdef SamplingSystem < handle
%This Class contains DataUnits and acts as a storage for the data

    
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
            % set new rate for the SamplingSystem. Newly created DataUnits
            % are always given the current sampling rate of the
            % SamplingSystem
           obj.rate = newrate;
        end
        

        
        function addNewUnitRS(obj)
            % creates a new DataUnit and adds it to the list. Random
            % sampling
            [sample,locations] = GetMeASample.getRandomSamplingLocations(obj.canonical,obj.rate);
            unit = DataUnit(sample,locations,obj.dim_signal,obj.dim_segment,obj.rate,obj.PARAM_SPGL1);
            obj.dataunits(end+1).a = unit;
               
        end
        
        function addNewUnitIS(obj)
            % creates a new DataUnit and adds it to the list. Informed
            % sampling, user must define locations on the run.
            [sample,locations] = GetMeASample.getInformedSamplingLocations(obj.canonical,obj.rate,obj.PARAM_sampling_centers_IS);
            unit = DataUnit(sample,locations,obj.dim_signal,obj.dim_segment,obj.rate,obj.PARAM_SPGL1);
            obj.dataunits(end+1).a = unit;
        end
        
        function addNewUnitISPredefinedLocations(obj)
            % Creates a new DataUnit and adds it to the list. Informed
            % sampling, user must give valid predefined locations of POINT SCATTERERS for this to work. 
            [sample,locations] = GetMeASample.getInformedSamplingLocationsPredefinedLocations(obj.canonical,obj.rate,obj.PARAM_sampling_centers_IS,obj.predefined_locations_IS);
            unit = DataUnit(sample,locations,obj.dim_signal,obj.dim_segment,obj.rate,obj.PARAM_SPGL1);
            obj.dataunits(end+1).a = unit;
        end
        
        function addExistingUnits(obj,units)
            %adds an already existing unit(s) to the system, for example from
            %earlier simulations
            for j = 1:length(units)
                obj.dataunits(end+1).a = units(j).a;
            end
        end
        

        
        function plottingRoutine(obj)
            %plots error as function of sampling rate for all DataUnits in
            %this SamplingSystem
            for index = 1:size(obj.dataunits,2)
               rate(index) = obj.dataunits(index).a.rate;
               %error(index) = norm(obj.canonical-getReconstruction(obj.dataunits(index).a));
               error(index) = getRelativeError(obj,getReconstruction(obj.dataunits(index).a));
               plot(rate,error,'*');
               xlabel('rate','FontSize',18);
               ylabel('relative error','FontSize',18);
               
            end
            
        end
        
        function stds =  getStd(obj,rates) 
            %this function returns standard deviations of errors, for all rates
           dummymatrix = []; 
           for index = 1:size(obj.dataunits,2)
               unit = obj.dataunits(index).a;
               [loog,loc]=ismember(unit.rate,rates)
               dummymatrix(end+1,loc)=getRelativeError(obj,unit.reconstruction);
           end
           
           for index2 = 1:length(rates)
               nonzeros = dummymatrix(:,index2);
               nonzeros = nonzeros(nonzeros>0);
               stds(index2)=std(nonzeros);
           end
           
            
        end
        
        function rel_error = getRelativeError(obj,reconstruction)
            %aux method
           osoittaja = sum(abs(obj.canonical-reconstruction));
           nimittaja = sum(abs(obj.canonical));
           rel_error = osoittaja/nimittaja;
        end
        
    end
    
end

