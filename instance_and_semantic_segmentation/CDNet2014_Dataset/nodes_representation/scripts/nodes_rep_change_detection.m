clear all, close all, clc;
%% Setting of paths
path_to_change_detection = 'path_to/change_detection/'; % Change this line with your path to the change detection database
segmentation_algorithm = 'X_101_FPN_COCO';
background_inti_algorithm = 'median_filter';
path_to_nodes_representation = [pwd,'/../',segmentation_algorithm,'-',...
    background_inti_algorithm,'/'];
mkdir(path_to_nodes_representation);
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
%% Likely static objects from the COCO 2017 dataset
statics_objects = {'traffic light','fire hydrant',...
    'stop sign','parking meter','bench','chair','couch','potted plant','bed',...
    'dining table','toilet','tv','microwave','oven','toaster','sink','refrigerator',...
    'clock','vase'};
%% Load COCO instances.mat
load([pwd,'/../../COCO_instaces/COCO_instances.mat']);
%% Generate mask of COCO instances for static objects
COCO_instances = COCO_instances';
indx_static_objects = zeros(length(COCO_instances),1);
for i=1:length(statics_objects)
    indx_static_objects = indx_static_objects | strcmp(COCO_instances,statics_objects{i});
end
%% Erosion of mask
se = strel('disk',4);
%% Features extraction
for hh=1:size(folder_challenges,1)
    disp(['Computing the nodes representantion of challenge ',folder_challenges{hh}]);
    path_to_sequences = [path_to_change_detection,folder_challenges{hh},'/'];
    mkdir([path_to_nodes_representation,folder_challenges{hh}]);
    for h=1:size(folders_sequences{hh},1)
        disp(['Sequence: ',folders_sequences{hh}{h}]);
        path_to_instances = [pwd,'/../../instance_segmentation/',segmentation_algorithm,...
            '/',folder_challenges{hh},'/',folders_sequences{hh}{h},'/'];
        path_to_raw_imgs = [path_to_sequences,folders_sequences{hh}{h},'/input/'];
        list_img_path = dir(path_to_raw_imgs);
        %% Path to isolated nodes (before segment_results)
        path_to_isolated_nodes = [pwd,'/../../isolated_nodes/',segmentation_algorithm,...
            '/',folder_challenges{hh},'/',folders_sequences{hh}{h},'/'];
        mkdir(path_to_isolated_nodes);
        %%
        features = [];
        cont = 1;
        %%
        list_of_images = {};
        %% Background image
        background_image = imread([pwd,'/../../background_initialization/',...
            background_inti_algorithm,'/',folder_challenges{hh},'/',folders_sequences{hh}{h},...
            '_background.png']);
        %% ROI image
        img_ROI = imread([path_to_sequences,folders_sequences{hh}{h},'/ROI.bmp']);
        %% Opticalflow objects
        opticFlow = opticalFlowLK('NoiseThreshold',0.009);
        for i=1:length(list_img_path)-2
            %% current image
            current_img_path = list_img_path(i+2).name;
            ind_point_current = strfind(current_img_path,'.');
            current_img_path(ind_point_current:end) = [];
            %% Read current raw image, and current instances
            load([path_to_instances,current_img_path,'.mat']);
            current_raw_image = imread([path_to_raw_imgs,current_img_path,'.jpg']);
            %% Previous image
            if i==1
                previous_img_path = list_img_path(i+2).name;
            else
                previous_img_path = list_img_path(i+1).name;
            end
            ind_point_current = strfind(previous_img_path,'.');
            previous_img_path(ind_point_current:end) = [];
            %% Read previous raw image, and previous instances
            previous_raw_image = imread([path_to_raw_imgs,previous_img_path,'.jpg']);
            %%            
            current_raw_image = rgb2gray(current_raw_image);
            previous_raw_image = rgb2gray(previous_raw_image);
            %% Optical flow previous frame
            flow = estimateFlow(opticFlow,current_raw_image);
            %% Instances
            [n_instances x y] = size(masks);
            for j=1:n_instances
                mask_seg = masks(j,:,:);
                mask_seg = reshape(mask_seg,[x,y]);
                indx_static_objects(classes(j)+1);
                IoNode = sum(sum(mask_seg & ~img_ROI))/(sum(sum(mask_seg))); %Intersection over Node with the logical not ROI
                if ~indx_static_objects(classes(j)+1) && IoNode < 1
                    indexs_segment = find(mask_seg == 1);
                    bounding_box = boundig_boxes(j,:);
                    if bounding_box(3)-bounding_box(1) >= 3 && bounding_box(4)-bounding_box(2) >= 3 ...
                            && sum(sum(mask_seg))/(x*round(y/2)) > 0.001 % size filter 0.001 lower bound
                        mask_seg_eroded = imerode(mask_seg,se);
                        indxes_segment_eroded = find(mask_seg_eroded == 1);
                        %% Write image
                        mask_seg = mask_seg & img_ROI; % If we let the entire mask, this is going to be confussing for the graph signal construction algorithm.
                        logical_sparse_mat = sparse(logical(mask_seg));
                        save([path_to_isolated_nodes,num2str(cont),'.mat'],'logical_sparse_mat');
                        %%
                        if isempty(indxes_segment_eroded)
                            Orientation = 0;
                            Magnitude = 0;
                        else
                            Orientation = flow.Orientation(indxes_segment_eroded);
                            Magnitude = flow.Magnitude(indxes_segment_eroded);
                        end
                        %% Histograms flow
                        bins_orientation = 50;
                        hist_orientation = histcounts(Orientation,linspace(-pi,pi,bins_orientation),'Normalization', 'probability');
                        bins_magnitude = 50;
                        hist_magnitude = histcounts(Magnitude,linspace(0,30,bins_magnitude),'Normalization', 'probability');
                        % Texture features
                        xMin = round(bounding_box(1))+1;
                        yMin = round(bounding_box(2))+1;
                        xMax = round(bounding_box(3));
                        yMax = round(bounding_box(4));
                        current_image_box = current_raw_image(yMin:yMax,xMin:xMax);
                        previous_image_box = previous_raw_image(yMin:yMax,xMin:xMax);
                        back_image_box = background_image(yMin:yMax,xMin:xMax);
                        difference_current_back_box = uint8(abs(double(current_image_box)-double(back_image_box)));
                        %% For Intensity Features
                        current_intensity_features = histcounts(current_raw_image(indexs_segment),[0:2:255],'Normalization', 'probability');
                        previous_intensity_features = histcounts(previous_raw_image(indexs_segment),[0:2:255],'Normalization', 'probability');
                        background_intensity_features = histcounts(background_image(indexs_segment),[0:2:255],'Normalization', 'probability');
                        difference_intensity_features = histcounts(abs(double(current_raw_image(indexs_segment))-double(background_image(indexs_segment))),...
                            [0:2:255],'Normalization', 'probability');
                        %%
                        current_LBP_features = extractLBPFeatures(current_image_box);
                        previous_LBP_features = extractLBPFeatures(previous_image_box);
                        background_LBP_features = extractLBPFeatures(back_image_box);
                        difference_LBP_features = extractLBPFeatures(difference_current_back_box);
                        %%
                        features(cont,:) = [max(Magnitude) mean(Magnitude) range(Magnitude) std(Magnitude) mad(Magnitude),...
                            min(Orientation) max(Orientation) mean(Orientation) range(Orientation) std(Orientation) mad(Orientation),...
                            hist_orientation, hist_magnitude,...
                            current_LBP_features, previous_LBP_features, background_LBP_features, difference_LBP_features,...
                            current_intensity_features, previous_intensity_features, background_intensity_features, difference_intensity_features];
                        %%
                        list_of_images{cont,1} = list_img_path(i+2).name;
                        cont = cont + 1;
                    end
                end
            end
        end
        save([path_to_nodes_representation,folder_challenges{hh},...
            '/list_of_images_',folders_sequences{hh}{h},'.mat'],'list_of_images');
        save([path_to_nodes_representation,folder_challenges{hh},...
            '/features_',folders_sequences{hh}{h},'.mat'],'features');
    end
end
