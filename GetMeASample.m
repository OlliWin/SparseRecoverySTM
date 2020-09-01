% https://github.com/OlliWin
classdef GetMeASample
    % This Class contains static methods, which return sparse sample and
    % corresponding locations, given the canonical signal, sampling rate,
    % and possibly IS-locations
    
    properties
        
    end
    
    methods 
 
    end
    
    
    
    methods (Static)
        
        function [sample,locations] = getRandomSamplingLocations(canonical,rate)
            %aux method
            binarymatrix = binornd(1,rate*ones(size(canonical)));
            locations = find(binarymatrix);
            sample = canonical(locations);
        end
        
        function [sample,locations] = getInformedSamplingLocations(canonical,rate,center_parameters)
            %aux method
            pointspercenter = center_parameters(1);
            sigma = center_parameters(2);
            
            rows = size(canonical,1);
            cols = size(canonical,2);
            n=rows*cols*rate;
            samplingmatrix = zeros(rows,cols);

            xv = [1 1 260 260];
            yv = [1 260 1 260];

            fig=figure
            imshow(canonical)
            [x0,y0] = getpts(fig);

            m=length(x0)*pointspercenter;

            if(m<n)
                newrate = ((n-m)*1.0)/(rows*cols)
                bernoullimatrix = binornd(1,newrate*ones(rows,cols));
            end
            samplingmatrix =samplingmatrix+ bernoullimatrix;
            
            
            for index = 1:length(x0)
                dummy=0;
                while(dummy<pointspercenter)
                    % x =  x0(index) + normrnd(0,1);
                    % y = y0(index) + normrnd(0,1);
                    % x = x0(index)+-15+binornd(30,0.5);
                    % y = y0(index) + -15+ binornd(30,0.5);
                    x0(index)
                    y0(index)
                    sigma
                    [y,x] = GetMeASample.getGaussian2D(y0(index),x0(index),sigma);
                    %if(inpolygon(x,y,xv,yv)&&~(samplingmatrix(y,x)==1))
                    x=floor(x);
                    y=floor(y);
                    if(GetMeASample.isInRegionOfInterest(rows,cols,y,x)&&(samplingmatrix(y,x)==0))
                        samplingmatrix(y,x)=1;
                        dummy=dummy+1;
                    end
                end
            end
            locations = find(samplingmatrix);
            sample = canonical(locations);
            
            
            
        end
        
        function [sample,locations] = getInformedSamplingLocationsPredefinedLocations(canonical,rate,center_parameters,predefined_locations)
            %aux method
            [rows,cols] = size(canonical);
            sigma = center_parameters(2);
            pointspercenter = center_parameters(1);
            x0 = predefined_locations(:,1);
            y0 = predefined_locations(:,2);
            
            n=rows*cols*rate;
            samplingmatrix = zeros(rows,cols);

            xv = [1 1 260 260];
            yv = [1 260 1 260];

            % fig=figure
            % imshow(oimage)
            % [x0,y0] = getpts(fig);

            m=length(x0)*pointspercenter;

            if(m<n)
                newrate = ((n-m)*1.0)/(rows*cols)
                bernoullimatrix = binornd(1,newrate*ones(rows,cols));
            end
            samplingmatrix =samplingmatrix+ bernoullimatrix;

            for index = 1:length(x0)
                dummy=0;
                while(dummy<pointspercenter)
                  % x =  x0(index) + normrnd(0,1);
                  % y = y0(index) + normrnd(0,1);
                  % x = x0(index)+-15+binornd(30,0.5);
                  % y = y0(index) + -15+ binornd(30,0.5);
                  [y,x] = GetMeASample.getGaussian2D(y0(index),x0(index),sigma);
                    %if(inpolygon(x,y,xv,yv)&&~(samplingmatrix(y,x)==1))
                    x=floor(x);
                    y=floor(y);
                    if(GetMeASample.isInRegionOfInterest(rows,cols,y,x)&&(samplingmatrix(y,x)==0))
                        samplingmatrix(y,x)=1;
                        dummy=dummy+1;

                    end
                end
            end
            
            locations = find(samplingmatrix);
            sample = canonical(locations);
        end
        
        function booleani = isInRegionOfInterest(rows,cols,rivi,sarake)
            % auxiliary function to help method makeInformedSensingMatrix()
            booleani = (1<=rivi)&&(rivi<=rows)&&(1<=sarake)&&(sarake<=cols);

        end
        
        function [x,y] = getGaussian2D(x0,y0,sigma)
            x = floor(x0+normrnd(0,sigma));
            y = floor(y0+normrnd(0,sigma));
        end
        
   end
end

