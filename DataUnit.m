classdef DataUnit < handle
    %DATAUNIT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        sample
        locations
        dim_signal
        dim_segment
        rate
        
        numberofsegments 
        
        
        binarymatrix
        skeleton      
        
        reconstruction
        frequencyspace
        
    end
    
    methods
        
        function obj = DataUnit(sample,locations,dim_signal,dim_segment,rate)
            %   DATAUNIT Construct an instance of this class
            %   Detailed explanation goes here
            obj.sample = sample;
            obj.locations = locations;
            obj.dim_signal = dim_signal;
            obj.dim_segment = dim_segment;
            obj.numberofsegments = (obj.dim_signal)./(obj.dim_segment);
            makeBinaryMatrix(obj);
            makeSkeleton(obj);
            obj.rate=rate;
            
            % error catching : length(locations) == length(sample);
        end
        
        
        function makeBinaryMatrix(obj)
            binarymatrix = zeros(obj.dim_signal);
            binarymatrix(obj.locations)=1;
            obj.binarymatrix = binarymatrix;
        end
        
        function makeSkeleton(obj)
            skeleton = zeros(obj.dim_signal);
            skeleton(obj.locations)=obj.sample;
            obj.skeleton = skeleton;
        end
        
        function [signalsegment,binarysegment] = getSegment(obj,index_row,index_col)
            indices_row = (1:obj.dim_segment(1))+(index_row-1)*obj.dim_segment(1);
            indices_col = (1:obj.dim_segment(2))+(index_col-1)*obj.dim_segment(2);
            signalsegment = obj.skeleton(indices_row,indices_col);
            binarysegment = obj.binarymatrix(indices_row,indices_col);
        end
        
        
        function  makeSparseReconstruction(obj)
            tabula_rasa = zeros(obj.dim_signal);
            for index_col = 1:obj.numberofsegments(1)
                for index_row = 1:obj.numberofsegments(2)
                    
                    indices_row = (1:obj.dim_segment(1))+(index_row-1)*obj.dim_segment(1);
                    indices_col = (1:obj.dim_segment(2))+(index_col-1)*obj.dim_segment(2);
                    
                    [signalsegment,binarysegment] = getSegment(obj,index_row,index_col);
                    locations = find(binarysegment);
                    b = signalsegment(locations);
                    N = length(indices_row)*length(indices_col);
                    x_hat = DataUnit.getSparseRecoverySegment(b,locations,N);
                    tabula_rasa(indices_row,indices_col) = reshape(x_hat,obj.dim_segment(1),obj.dim_segment(2));
                end
            end
            obj.reconstruction = tabula_rasa;
        end
        
        function  makeFrequencySpace(obj)
            obj.frequencyspace = abs(fftshift(fft2(obj.reconstruction)));
        end
        
        
        
        
        
        function frequencyspace = getFrequencySpace(obj)
           makeFrequencySpace(obj);
           frequencyspace = obj.frequencyspace; 
        end
        
        function reconstruction = getReconstruction(obj)
            reconstruction = obj.reconstruction;
        end
        
    end
    
    
    methods (Static)
        
        
        function recovery_segment = getSparseRecoverySegment(b,locations,N)
            b = b(:);
            A = DataUnit.getSensingMatrix(N,locations);
            sigma = 0.001;
            recovery_segment=DataUnit.getSensingMatrix(N,1:N)*spgl1(A,b,0,sigma);
        end
        
        function samplingmatrix = getSensingMatrix(n,samplingLocations)
             k=n/2;
            [I,J] = meshgrid(1:n,samplingLocations);
            w = exp(2*pi*1i/n);
            iDFT = w.^((J-1).*(I-1));
            iDCT = real(iDFT);
            iDST = imag(iDFT);

            %real part is even
            iDCT1 = iDCT(:,1:(k+1));
            %zeros(size(iDCT,2),1);
            iDCT2 = [zeros(size(iDCT,1),1),flip(iDCT(:,(k+1):n),2)];

            %imaginary part is off
            iDST1 = iDST(:,1:(k+1));
            iDST2 = [zeros(size(iDST,1),1),-flip(iDST(:,(k+1):n),2)];

            A = iDCT1 + iDCT2;
            B = iDST1 + iDST2;

            %the final product
            samplingmatrix = 1/n*[A,-A,B,-B];
        end
        
        

        
        function distortion = getDistortion(canonical,reconstruction)
            
            distortion =[];
        end
        
        function frobba = getFrobeniusNorm(x) 
            
           frobba = [];
        end
        
        function L1 = getL1Norm(x)
            
            L1 = [];
        end
        
        
    end
    

    
    
end

