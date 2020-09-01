
%% SIMULATION 1.A

%ADD SPGL1 AND TOOLKIG FOR COMPRESSED SENSING TO YOUR MATLAB WORKING
%DIRECTORY
addpath('spgl1-2.1');
addpath('ToolkitCompressedSensing');

%% SIMULATION 1.B
% initialize variables
% dim_segment must be factor of size(canonical), entry-wise.
 
 canonical = imread('chucknorris.jpg');
 canonical = rgb2gray(canonical);
 canonical = im2double(canonical);
 dim_segment = [23,23];
 PARAM_SPGL1 = [0,0.001];
 rate = 0.5;
 predef_locs =[];
 center_parameters = [300,7];
 system = SamplingSystem(canonical,dim_segment,PARAM_SPGL1,center_parameters,rate,predef_locs);
 
 Nrep = 1;
 ratevector = [0.3,0.5];
 
 
%% SIMULATION 1.C
%run the simulation
% one reconstruction should take about few minutes
for i = 1:length(ratevector)
     for j = 1:Nrep
        setNewRate(system,ratevector(i));
        addNewUnitRS(system);
        makeSparseReconstruction(system.dataunits(j+Nrep*(i-1)).a);
        reko = getReconstruction(system.dataunits(j+Nrep*(i-1)).a);
        figure
        imshow(reko)
     end
end