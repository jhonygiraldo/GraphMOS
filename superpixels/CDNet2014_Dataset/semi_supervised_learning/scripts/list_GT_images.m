clear all, close all, clc;
%% Setting of paths
path_to_change_detection = 'path_to/changedetection_dataset/'; % Change this line with your path to the change detection database
%%
folder_challenges = {'badWeather';'baseline';'cameraJitter';'dynamicBackground';...
    'intermittentObjectMotion';'lowFramerate';'nightVideos';'PTZ';'shadow';...
    'thermal';'turbulence'};
folders_sequences = {{'blizzard';'skating';'snowFall';'wetSnow'};...
    {'PETS2006';'highway';'office';'pedestrians'};...
    {'badminton';'boulevard';'sidewalk';'traffic'};...
    {'boats';'canoe';'fall';'fountain01';'fountain02';'overpass'};...
    {'abandonedBox';'parking';'sofa';'streetLight';'tramstop';'winterDriveway'};...
    {'port_0_17fps';'tramCrossroad_1fps';'tunnelExit_0_35fps';'turnpike_0_5fps'};...
    {'bridgeEntry';'busyBoulvard';'fluidHighway';'streetCornerAtNight';'tramStation';'winterStreet'};...
    {'continuousPan';'intermittentPan';'twoPositionPTZCam';'zoomInZoomOut'};...
    {'backdoor';'bungalows';'busStation';'copyMachine';'cubicle';'peopleInShade'};...
    {'corridor';'diningRoom';'lakeSide';'library';'park'};...
    {'turbulence0';'turbulence1';'turbulence2';'turbulence3'}};
%%
cell_GT_images = {};
cont_total = 1;
cont_sequences = 1;
%%
for h=1:length(folder_challenges)
    cont_sequences
    for i=1:length(folders_sequences{h})
        path_to_images = [path_to_change_detection,folder_challenges{h},'/',...
            folders_sequences{h}{i},'/groundtruth/'];
        list_images = dir(path_to_images);
        for j=1:length(list_images)-2
            image_GT_name = list_images(j+2).name;
            image = imread([path_to_images,image_GT_name]);
            [x,y] = size(image);
            image = (image >= 255);
            percentage_foreground_pixels = length(find(image == 1))/(x*y);
            if percentage_foreground_pixels > 0.05%length(find(image == 1)) > 0
                %percentage_foreground_pixels
                cell_GT_images{cont_total,1} = folder_challenges{h};
                cell_GT_images{cont_total,2} = folders_sequences{h}{i};
                cell_GT_images{cont_total,3} = cont_sequences;
                cell_GT_images{cont_total,4} = image_GT_name;
                cell_GT_images{cont_total,5} = list_images(j+1).name;                
                cont_total = cont_total+1;
            end
        end
        cont_sequences = cont_sequences+1;
    end
end
save('GT_images_with_foreground_vs_02.mat','cell_GT_images');
