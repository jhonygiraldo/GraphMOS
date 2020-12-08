clear all, close all, clc;
%% Setting of paths
path_to_change_detection = 'path_to/changedetection_dataset/'; % Change this line with your path to the change detection database
batch_size = 100;
GT_size = 350;
number_super_pixels = 300;
param.nnparam.k = 30;
param_recon.regularize_epsilon = 0.2;
output_folder = ['../batch_size-',num2str(batch_size),'-GT_size-',num2str(GT_size),...
    '-super_pixels-',num2str(number_super_pixels),'-knn_param-',num2str(param.nnparam.k),...
    '-epsilon-',num2str(param_recon.regularize_epsilon),'/'];
mkdir(output_folder);
%%
load('GT_images_with_foreground_vs_02.mat');
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
cont_sequences = 1;
for hh=2:length(folder_challenges)
    for h=1:length(folders_sequences{hh})
        %%
        path_output_sequence = [output_folder,folder_challenges{hh},'/',...
            folders_sequences{hh}{h},'/'];
        mkdir(path_output_sequence);
        %%
        disp(['Sequence: ',num2str(cont_sequences)]);
        path_to_images = [path_to_change_detection,folder_challenges{hh},'/',...
            folders_sequences{hh}{h},'/input/'];
        %% Background Image
        background_image = imread(['../../background_initialization/median_filter/',...
            folder_challenges{hh},'/',folders_sequences{hh}{h},'_background.png']);
        %% ROI image
        img_ROI = imread([path_to_change_detection,folder_challenges{hh},'/',...
            folders_sequences{hh}{h},'/ROI.bmp']);
        %%
        list_images = dir(path_to_images);
        list_images([1,2],:) = [];
        number_of_images_to_process = length(list_images);
        cont_batch = 1;
        %%
        opticFlow_sequence = opticalFlowLK('NoiseThreshold',0.009);
        %%
        while number_of_images_to_process > 0
            if number_of_images_to_process >= batch_size
                first_indx = (cont_batch-1)*batch_size+1;
                list_images_to_process = list_images(first_indx:(first_indx-1)+batch_size);
                number_of_images_to_process = number_of_images_to_process-batch_size;
            else
                first_indx = (cont_batch-1)*batch_size+1;
                list_images_to_process = list_images(first_indx:end);
                number_of_images_to_process = 0;
            end
            %%
            features = [];
            cont = 1;
            list_of_images = {};
            %%
            for ii=1:length(list_images_to_process)
                %% current image
                current_img_path = list_images_to_process(ii).name;
                current_raw_image = imread([path_to_images,current_img_path]);
                %% Previous image
                if cont_batch==1 && ii==1
                    previous_img = list_images_to_process(ii).name;
                elseif ii==1
                    previous_img = list_images(first_indx-1).name;
                else
                    previous_img = list_images_to_process(ii-1).name;
                end
                %% Read previous raw image, and previous instances
                previous_raw_image = imread([path_to_images,previous_img]);
                %%
                current_raw_image = rgb2gray(current_raw_image);
                previous_raw_image = rgb2gray(previous_raw_image);
                %% Optical flow previous frame
                if cont_batch==1 && ii==1
                    flow = estimateFlow(opticFlow_sequence,previous_raw_image);
                end
                %%
                flow = estimateFlow(opticFlow_sequence,current_raw_image);
                %% Segmentation
                [L,N] = superpixels(current_raw_image,number_super_pixels);
                [x,y] = size(current_raw_image);
                for i=1:N
                    mask_seg = (L==i);
                    boundingBox_struc = regionprops(mask_seg,'BoundingBox');
                    IoNode = sum(sum(mask_seg & ~img_ROI))/(sum(sum(mask_seg))); %Intersection over Node with the logical not ROI
                    if IoNode < 1
                        indexs_segment = find(mask_seg == 1);
                        bounding_box = boundingBox_struc.BoundingBox;
                        bounding_box = floor(bounding_box);
                        bounding_box(3) = bounding_box(3)+bounding_box(1);
                        bounding_box(4) = bounding_box(4)+bounding_box(2);
                        if bounding_box(3)-bounding_box(1) >= 3 && bounding_box(4)-bounding_box(2) >= 3 ...
                                && sum(sum(mask_seg))/(x*round(y/2)) > 0.001 % size filter 0.001 lower bound
                            %mask_seg_eroded = imerode(mask_seg,se);
                            indxes_segment = find(mask_seg == 1);
                            %mask_seg = mask_seg & img_ROI; % If we let the entire mask, this is going to be confussing for the graph signal construction algorithm.
                            %logical_sparse_mat = sparse(logical(mask_seg));
                            %%
                            if isempty(indxes_segment)
                                Orientation = 0;
                                Magnitude = 0;
                            else
                                Orientation = flow.Orientation(indxes_segment);
                                Magnitude = flow.Magnitude(indxes_segment);
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
                            list_of_images{cont,1} = current_img_path;
                            cont = cont + 1;
                        end
                    end
                end
            end
            %%
            num_features_unseen_frames = size(features,1);
            label_bin = zeros(size(features,1),3);
            %label_bin = [];
            %%
            indx_unseen_frames = find([cell_GT_images{:,3}] ~= cont_sequences);
            indx_sampled = randsample(indx_unseen_frames,GT_size);
            for ii=1:length(indx_sampled)
                opticFlow = opticalFlowLK('NoiseThreshold',0.009);
                %% current image
                current_img_GT = cell_GT_images{indx_sampled(ii),4};
                %mkdir(current_img_GT);
                ind_point = strfind(current_img_GT,'.');
                ind_GT = strfind(current_img_GT,'gt');
                current_raw_image = imread([path_to_change_detection,...
                    cell_GT_images{indx_sampled(ii),1},'/',...
                    cell_GT_images{indx_sampled(ii),2},'/input/',...
                    'in',current_img_GT(ind_GT(1)+2:ind_point(end)),'jpg']);
                %% Previous image
                previous_img_GT = cell_GT_images{indx_sampled(ii),5};
                ind_point = strfind(previous_img_GT,'.');
                ind_GT = strfind(previous_img_GT,'gt');
                %% Read previous raw image, and previous instances
                previous_raw_image = imread([path_to_change_detection,...
                    cell_GT_images{indx_sampled(ii),1},'/',...
                    cell_GT_images{indx_sampled(ii),2},'/input/',...
                    'in',previous_img_GT(ind_GT(1)+2:ind_point(end)),'jpg']);
                %%
                current_raw_image = rgb2gray(current_raw_image);
                previous_raw_image = rgb2gray(previous_raw_image);
                %%
                GT_image = imread([path_to_change_detection,...
                    cell_GT_images{indx_sampled(ii),1},'/',...
                    cell_GT_images{indx_sampled(ii),2},'/groundtruth/',...
                    current_img_GT]);
                %% Background Image
                background_image_GT = imread(['../../background_initialization/median_filter/',...
                    cell_GT_images{indx_sampled(ii),1},'/',cell_GT_images{indx_sampled(ii),2},...
                    '_background.png']);
                %% ROI image
                img_ROI_GT = imread([path_to_change_detection,cell_GT_images{indx_sampled(ii),1},...
                    '/',cell_GT_images{indx_sampled(ii),2},'/ROI.bmp']);
                %% Optical flow previous frame
                flow = estimateFlow(opticFlow,previous_raw_image);
                flow = estimateFlow(opticFlow,current_raw_image);
                %% Segmentation
                [L,N] = superpixels(current_raw_image,number_super_pixels);
                [x,y] = size(current_raw_image);
                %image_GT_super_pixel = logical(zeros(x,y));
                for i=1:N
                    mask_seg = (L==i);
                    boundingBox_struc = regionprops(mask_seg,'BoundingBox');
                    IoNode = sum(sum(mask_seg & ~img_ROI_GT))/(sum(sum(mask_seg))); %Intersection over Node with the logical not ROI
                    if IoNode < 1
                        indexs_segment = find(mask_seg == 1);
                        bounding_box = boundingBox_struc.BoundingBox;
                        bounding_box = floor(bounding_box);
                        bounding_box(3) = bounding_box(3)+bounding_box(1);
                        bounding_box(4) = bounding_box(4)+bounding_box(2);
                        if bounding_box(3)-bounding_box(1) >= 3 && bounding_box(4)-bounding_box(2) >= 3 ...
                                && sum(sum(mask_seg))/(x*round(y/2)) > 0.001 % size filter 0.001 lower bound
                            %mask_seg_eroded = imerode(mask_seg,se);
                            indxes_segment = find(mask_seg == 1);
                            mask_seg = mask_seg & img_ROI_GT; % If we let the entire mask, this is going to be confussing for the graph signal construction algorithm.
                            %logical_sparse_mat = sparse(logical(mask_seg));
                            %save([path_to_isolated_nodes,num2str(cont),'.mat'],'logical_sparse_mat');
                            %%
                            if isempty(indxes_segment)
                                Orientation = 0;
                                Magnitude = 0;
                            else
                                Orientation = flow.Orientation(indxes_segment);
                                Magnitude = flow.Magnitude(indxes_segment);
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
                            back_image_box = background_image_GT(yMin:yMax,xMin:xMax);
                            difference_current_back_box = uint8(abs(double(current_image_box)-double(back_image_box)));
                            %% For Intensity Features
                            current_intensity_features = histcounts(current_raw_image(indexs_segment),[0:2:255],'Normalization', 'probability');
                            previous_intensity_features = histcounts(previous_raw_image(indexs_segment),[0:2:255],'Normalization', 'probability');
                            background_intensity_features = histcounts(background_image_GT(indexs_segment),[0:2:255],'Normalization', 'probability');
                            difference_intensity_features = histcounts(abs(double(current_raw_image(indexs_segment))-double(background_image_GT(indexs_segment))),...
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
                            %list_of_images{cont,1} = ['in',current_img_GT(ind_GT(1)+2:ind_point(end)),'jpg'];
                            %%
                            IoNode_ROI = sum(sum(mask_seg & ~img_ROI_GT))/(sum(sum(mask_seg))); %Intersection over Node with ROI
                            if IoNode_ROI == 1
                                label_bin = [label_bin; 0 0 1]; % This is to be sure that any node outside the ROI is incorrectly classified
                            else
                                gt_image = (GT_image==255);
                                [x_gt y_gt] = size(gt_image);
                                [L_gt,n_gt] = bwlabel(gt_image);
                                all_IoU = zeros(n_gt,1);
                                for jj=1:n_gt
                                    gt_image_jj = logical(zeros(x_gt,y_gt));
                                    gt_image_jj(find(L_gt == jj)) = 1;
                                    all_IoU(jj) = jaccard(mask_seg,gt_image_jj); % Vector of intersection over union
                                end
                                IoNode = sum(sum(mask_seg & gt_image))/(sum(sum(mask_seg))); % Intersection over node
                                if ~isempty(all_IoU)
                                    if ((IoNode > 0.4) || (max(all_IoU) > 0.05 && IoNode > 0.45) || (max(all_IoU) > 0.25)) % Foreground
                                    %if ((IoNode > 0.5) || (max(all_IoU) > 0.05 && IoNode > 0.45) || (max(all_IoU) > 0.25)) % Foreground
                                    %if (max(all_IoU) > 0.02) && ...
                                    %        ((IoNode > 0.5) || (max(all_IoU) > 0.05 && IoNode > 0.45) || (max(all_IoU) > 0.25)) % Foreground
                                    %if (max(all_IoU) > 0.02) && ...
                                    %        ((IoNode > 0.9) || (max(all_IoU) > 0.05 && IoNode > 0.45) || (max(all_IoU) > 0.25)) % Foreground
                                        label_bin = [label_bin; 0 1 0];
                                        %image_GT_super_pixel = image_GT_super_pixel | mask_seg;
                                    else %Background
                                        label_bin = [label_bin; 1 0 0];
                                    end
                                else % Background
                                    label_bin = [label_bin; 1 0 0];
                                end
                            end
                            %%
                            cont = cont + 1;
                        end
                    end
                end
            end
            %%
            cont_batch = cont_batch+1;
            %% Construction of the graph
            G = gsp_nn_graph(features,param.nnparam);
            G = gsp_estimate_lmax(G);
            %% Semi-supervised learning algorithm
            x = label_bin;
            x(:,3) = [];
            x_sampled = x(num_features_unseen_frames+1:end,:);
            list_sampled_nodes = [num_features_unseen_frames+1:G.N];
            x_reconstructed = gsp_interpolate(G, x_sampled,...
                list_sampled_nodes,param_recon);
            [~,f_recon] = max(x_reconstructed,[],2); % predicted class labels
            %% Draw outputs
            cont_outputs = 1;
            for ii=1:length(list_images_to_process)
                %% current image
                current_img_path = list_images_to_process(ii).name;
                ind_point = strfind(current_img_path,'.');
                ind_in = strfind(current_img_path,'in');
                current_raw_image = imread([path_to_images,current_img_path]);
                current_raw_image = rgb2gray(current_raw_image);
                %% Segmentation
                [L,N] = superpixels(current_raw_image,number_super_pixels);
                [x,y] = size(current_raw_image);
                output_image = logical(zeros(x,y));
                for i=1:N
                    mask_seg = (L==i);
                    if f_recon(cont_outputs) == 2
                        output_image = output_image | mask_seg;
                    end
                    cont_outputs = cont_outputs+1;
                end
                imwrite(output_image,[path_output_sequence,'bin',...
                    current_img_path(ind_in(1)+2:ind_point(end)),'png']);
            end
        end
        cont_sequences = cont_sequences+1;
    end
end
