clear all, close all, clc;
%% Setting of paths
path_to_change_detection = 'path_to/change_detection/'; % Change this line with your path to the change detection database
segmentation_algorithm = 'R_50_FPN_COCO';
background_inti_algorithm = 'median_filter';
path_to_graph_signal = [pwd,'/../graph_signal_',segmentation_algorithm,...
    '-',background_inti_algorithm,'/'];
mkdir(path_to_graph_signal);
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
for h=1:length(folder_challenges)
    disp(['Computing the graph signal of challenge ',folder_challenges{h}]);
    label_bin = [];
    path_to_features = [pwd,'/../../nodes_representation/',segmentation_algorithm,...
        '-',background_inti_algorithm,'/',folder_challenges{h},'/'];
    path_to_sequences = [path_to_change_detection,folder_challenges{h},'/'];
    for i=1:size(folders_sequences{h},1)
        disp(['Sequence: ',folders_sequences{h}{i}]);
        %% 
        load([path_to_features,'list_of_images_',folders_sequences{h}{i},'.mat']);
        %% 
        path_to_category = [path_to_sequences,folders_sequences{h}{i},'/'];
        file_txt_ID = fopen([path_to_category,'temporalROI.txt'],'r');
        range_eval = fscanf(file_txt_ID,'%f');
        fclose(file_txt_ID);
        path_to_ground_truth = [path_to_category,'groundtruth/'];
        path_to_nodes = [pwd,'/../../isolated_nodes/',segmentation_algorithm,...
            '/',folder_challenges{h},'/',folders_sequences{h}{i},'/'];
        %% ROI
        ROI = logical(imread([path_to_category,'ROI.bmp']));
        for j=1:size(list_of_images,1)
            number_image = list_of_images{j};
            indx_n = strfind(number_image,'n');
            indx_point = strfind(number_image,'.');
            number_image = number_image(indx_n+1:indx_point-1);
            if str2num(number_image) < range_eval(1) || str2num(number_image) > range_eval(2)
                label_bin = [label_bin; 0 0 1];
            else
                %% Read isolated node
                load([path_to_nodes,num2str(j),'.mat']);
                node_image = full(logical_sparse_mat);
                IoNode_ROI = sum(sum(node_image & ~ROI))/(sum(sum(node_image))); %Intersection over Node with ROI
                if IoNode_ROI == 1
                    label_bin = [label_bin; 0 0 1]; % This is to be sure that any node outside the ROI is not incorrectly classified
                else
                    gt_image_temp = imread([path_to_ground_truth,'gt',number_image,'.png']);
                    [x_gt y_gt] = size(gt_image_temp);
                    gt_image = zeros(x_gt,y_gt);
                    gt_image(find(gt_image_temp == 255)) = 1;
                    [L_gt,n_gt] = bwlabel(gt_image);
                    all_IoU = zeros(n_gt,1);
                    for k=1:n_gt
                        gt_image_k = logical(zeros(x_gt,y_gt));
                        gt_image_k(find(L_gt == k)) = 1;
                        all_IoU(k) = jaccard(node_image,gt_image_k); % Vector of intersection over union
                    end
                    IoNode = sum(sum(node_image & gt_image))/(sum(sum(node_image))); % Intersection over node
                    if ~isempty(all_IoU)
                        if (max(all_IoU) > 0.02) && ...
                                ((IoNode > 0.9) || (max(all_IoU) > 0.05 && IoNode > 0.45) || (max(all_IoU) > 0.25)) % Foreground
                            label_bin = [label_bin; 0 1 0];
                        else %Background
                            label_bin = [label_bin; 1 0 0];
                        end
                    else % Background
                        label_bin = [label_bin; 1 0 0];
                    end
                end
            end
        end
    end
    save([path_to_graph_signal,folder_challenges{h},'.mat'],'label_bin');
end
