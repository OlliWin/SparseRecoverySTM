%%

% addpath('SUMMER_PROJECT/ToolkitCompressedSensing');
% addpath('spgl1-2.1');

%%

 canonical = D(:,:,41);
 dim_segment = [20,20];
 PARAM_SPGL1 = [];
 rate = 0.5;
 predef_locs =[x0,y0];
 center_parameters = [300,7];
 system = SamplingSystem(canonical,dim_segment,PARAM_SPGL1,center_parameters,rate,predef_locs);
 
%%


 for i = 1:5
    %addNewUnit_RS(system);
    addNewUnitISPredefinedLocations(system);
    makeSparseReconstruction(system.dataunits(i).a);
    reko = getReconstruction(system.dataunits(i).a);
    figure
    imshow(reko)
    setNewRate(system,(i*1.0)/10);
 end

 
% %%
% figure
% imshow(getReconstruction(unit));
% figure
% surf(getFrequencySpace(unit),'edgecolor','none');
% view([0,0,1]);
% caxis([0,100]);
% %%





