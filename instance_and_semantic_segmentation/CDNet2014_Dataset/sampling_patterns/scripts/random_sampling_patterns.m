clear all, close all, clc;
%% Setting of paths
path_to_change_detection = 'path_to/change_detection/'; % Change this line with your path to the change detection database
segmentation_algorithm = 'R_50_FPN_COCO';
background_inti_algorithm = 'median_filter';
construction_algorithm = 'k-NN-k-30';
path_to_results = [pwd,'/../',construction_algorithm,...
    '-',segmentation_algorithm,'-',background_inti_algorithm,'/'];
mkdir(path_to_results);
%%
load([pwd,'/../../graph_construction/',construction_algorithm,'-',...
    segmentation_algorithm,'-',background_inti_algorithm,'/full_graph.mat']);
%%
clear Dist G Idx points
%%
folder_challenges = {'badWeather';'baseline';'cameraJitter';'dynamicBackground';...
    'intermittentObjectMotion';'lowFramerate';'nightVideos';'PTZ';'shadow';...
    'thermal';'turbulence'};
folders_categories = {{'blizzard';'skating';'snowFall';'wetSnow'};...
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
percentage_sampling = [0.001, 0.005, 0.01, 0.02:0.02:0.1];
%%
list_raw_images = cell(size(folder_challenges,1),1);
list_of_images_cell = cell(size(folder_challenges,1),1);
indx_first_image_in_list = cell(size(folder_challenges,1),1);
for i=1:size(folder_challenges,1)
    list_raw_images_temp = cell(size(folders_categories{i},1),1);
    list_of_images_cell_temp = cell(size(folders_categories{i},1),1);
    indx_first_image_in_list_temp = zeros(size(folders_categories{i},1),1);
    for j=1:size(folders_categories{i,1},1)
        folder_raw_images = [path_to_change_detection,folder_challenges{i},'/',...
            folders_categories{i}{j},'/input/'];
        list_raw_images_temp{j} = dir(folder_raw_images);
        %%
        path_to_category = [path_to_change_detection,folder_challenges{i},'/',...
            folders_categories{i}{j},'/'];
        file_txt_ID = fopen([path_to_category,'temporalROI.txt'],'r');
        range_eval = fscanf(file_txt_ID,'%f');
        fclose(file_txt_ID);
        %%
        indx_first_image_in_list_temp(j) = range_eval(1) + 2;
        %%
        list_of_images_cell_temp{j} = load([pwd,'/../../nodes_representation/',...
            segmentation_algorithm,'-',background_inti_algorithm,'/',folder_challenges{i},...
            '/list_of_images_',folders_categories{i}{j},'.mat']);
    end
    list_raw_images{i} = list_raw_images_temp;
    list_of_images_cell{i} = list_of_images_cell_temp;
    indx_first_image_in_list{i} = indx_first_image_in_list_temp;
end
%%
repetitions = 5;
random_sampling_pattern = {};
%%
for h=1:length(percentage_sampling)
    disp(['Sampling density: ',num2str(percentage_sampling(h))]);
    for ii=1:repetitions
        cont = 1;
        for i=1:size(folder_challenges,1)
            for jj=1:size(folders_categories{i},1)
                %% Sampling pattern
                [S_opt_random,indentifier_category_in_nodes,indx_category] = unseen_sampling_pattern(percentage_sampling(h),...
                    path_to_change_detection,indx_first_image_in_list,...
                    list_of_images_cell,list_raw_images,folders_categories{i}{jj});
                %% Check any node has is unknown, i.e., label_bin = 0 0 1
                for kk=1:length(S_opt_random)
                    if S_opt_random(kk) == 1 && label_bin(kk,3) == 1
                        S_opt_random(kk) = 0;
                    end
                end
                random_sampling_pattern{ii,h}(cont,:) = sparse(S_opt_random);
                cont = cont + 1;
            end
        end
    end
end
save([path_to_results,'random_sampling.mat'],'random_sampling_pattern','percentage_sampling',...
    'repetitions','indentifier_category_in_nodes');
