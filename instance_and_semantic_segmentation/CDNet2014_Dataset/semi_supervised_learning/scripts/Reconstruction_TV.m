clear all, close all, clc;
%% Setting of paths
path_to_change_detection = 'path_to/change_detection/'; % Change this line with your path to the change detection database
segmentation_algorithm = 'X_101_FPN_COCO';
background_inti_algorithm = 'median_filter';
construction_algorithm = 'k-NN-k-20';
semi_supervised_learning = 'TV';
path_to_results = [pwd,'/../',semi_supervised_learning,'-',construction_algorithm,...
    '-',segmentation_algorithm,'-',background_inti_algorithm,'/'];
mkdir(path_to_results);
%%
load([pwd,'/../../graph_construction/',construction_algorithm,'-',...
    segmentation_algorithm,'-',background_inti_algorithm,'/full_graph.mat']);
load([pwd,'/../../sampling_patterns/',construction_algorithm,'-',...
    segmentation_algorithm,'-',background_inti_algorithm,'/random_sampling.mat']);
%%
clear Dist Idx points
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
x = label_bin;
x(:,3) = [];
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
epsilon_set_pesenson = [0];
param.maxit = 200;
%%
for hh=1:length(epsilon_set_pesenson)
    disp(['Computing epsilon: ',num2str(epsilon_set_pesenson(hh))]);
    param.regularize_epsilon = epsilon_set_pesenson(hh);
    for h=1:length(percentage_sampling)
        disp(['Sampling density: ',num2str(percentage_sampling(h))]);
        for ii=1:repetitions
            cont_category = 1;
            for i=1:size(folder_challenges,1)
                for jj=1:size(folders_categories{i},1)
                    results_path = [path_to_results,...
                        'sampling_percentage_',num2str(percentage_sampling(h)),'_epsilon_',num2str(epsilon_set_pesenson(hh)),...
                        '_repet_',num2str(ii),'/',folder_challenges{i},'/',...
                        folders_categories{i}{jj},'/'];
                    mkdir(results_path)
                    %% Sampling pattern
                    indx_category = cont_category;
                    cont_category = cont_category + 1;
                    S_opt_random = random_sampling_pattern{ii,h}(indx_category,:);
                    x_sampled_random = S_opt_random'.*x;
                    %%
                    x_reconstructed_random = gsp_regression_tv(G,S_opt_random,...
                        full(x_sampled_random),epsilon_set_pesenson(hh),param);
                    [~,f_recon_random] = max(x_reconstructed_random,[],2); % predicted class labels
                    %%
                    indx_category = find(indentifier_category_in_nodes == indx_category);
                    nodes_path_category = [pwd,'/../../isolated_nodes/',...
                        segmentation_algorithm,'/',folder_challenges{i},...
                        '/',folders_categories{i}{jj},'/'];
                    for kk=1:length(indx_category)
                        original_image = list_of_images_cell{i}{jj}.list_of_images(kk);
                        indx_point = strfind(original_image{1},'.');
                        indx_n = strfind(original_image{1},'n');
                        original_image_mat = ['bin' original_image{1}(indx_n+1:indx_point-1) '.mat'];
                        if exist([results_path,original_image_mat]) == 0
                            node_image = load([nodes_path_category,num2str(kk),'.mat']);
                            image_result = sparse(logical(zeros(size(node_image.logical_sparse_mat))));
                            save([results_path,original_image_mat],'image_result');
                        end
                        if f_recon_random(indx_category(kk)) == 2 % Foreground
                            node_image = load([nodes_path_category,num2str(kk),'.mat']);
                            node_image = node_image.logical_sparse_mat;
                            if exist([results_path,original_image_mat]) == 2
                                old_result_image = load([results_path,original_image_mat]);
                                image_result = old_result_image.image_result | node_image;
                                save([results_path,original_image_mat],'image_result');
                            else
                                image_result = node_image;
                                save([results_path,original_image_mat],'image_result');
                            end
                        end
                    end
                end
            end
        end
    end
end
