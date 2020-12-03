clear all, close all, clc;
%% Setting of paths
path_to_change_detection = '/Users/knguye02/Documents/dataset2014/dataset/'; % Change this line with your path to the change detection database
segmentation_algorithm = 'R_50_FPN_COCO';
background_inti_algorithm = 'median_filter';
construction_algorithm = 'robust';
semi_supervised_learning = 'variational_splines';
epsilon = 0.2; % Set this parameter to 0 for TV minimization
path_to_results_semi = [pwd,'/../../semi_supervised_learning/',...
    semi_supervised_learning,'-',construction_algorithm,...
    '-',segmentation_algorithm,'-',background_inti_algorithm,'/'];
path_to_results_metrics = [pwd,'/../',...
    semi_supervised_learning,'-',construction_algorithm,...
    '-',segmentation_algorithm,'-',background_inti_algorithm,...
    '-epsilon-',num2str(epsilon),'/'];
mkdir(path_to_results_metrics);
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
sampling_density = [0.001, 0.005, 0.01, 0.02:0.02:0.1];
repetitions = 5;
%% Metrics
average_recall = cell(length(folder_challenges),1);
average_specficity = cell(length(folder_challenges),1);
average_FPR = cell(length(folder_challenges),1);
average_FNR = cell(length(folder_challenges),1);
average_PBC = cell(length(folder_challenges),1);
average_precision = cell(length(folder_challenges),1);
average_FMeasure = cell(length(folder_challenges),1);
%%
recall = cell(length(folder_challenges),repetitions);
specficity = cell(length(folder_challenges),repetitions);
FPR = cell(length(folder_challenges),repetitions);
FNR = cell(length(folder_challenges),repetitions);
PBC = cell(length(folder_challenges),repetitions);
precision = cell(length(folder_challenges),repetitions);
FMeasure = cell(length(folder_challenges),repetitions);
%%
TP = cell(length(folder_challenges),repetitions);
FP = cell(length(folder_challenges),repetitions);
FN = cell(length(folder_challenges),repetitions);
TN = cell(length(folder_challenges),repetitions);
SE = cell(length(folder_challenges),repetitions);
%%
for h=1:length(folder_challenges)
    disp(['Computing metrics challenge: ',folder_challenges{h}]);
    path_challenge = [path_to_change_detection,folder_challenges{h},'/'];
    for i=1:length(sampling_density)
        for j=1:repetitions
            path_results_challenge = [path_to_results_semi,...
                'sampling_percentage_',num2str(sampling_density(i)),'_epsilon_',num2str(epsilon),...
                '_repet_',num2str(j),'/'];
            %% Metrics categories
            for k=1:length(folders_categories{h,1})
                path_results_category = [path_results_challenge,folder_challenges{h},'/',...
                    folders_categories{h,1}{k,1},'/'];
                path_gt_category = [path_to_change_detection,folder_challenges{h},'/',folders_categories{h,1}{k,1},'/groundtruth/'];
                list_gt_images = dir(path_gt_category);
                %% Read temporal file
                range = readTemporalFile([path_to_change_detection,folder_challenges{h},'/',...
                    folders_categories{h,1}{k,1}]);
                idxFrom = range(1);
                idxTo = range(2);
                %% Confusion matrix
                confusionMatrix = [0 0 0 0 0]; % TP FP FN TN SE
                for hh=idxFrom:idxTo
                    name_gt_image = list_gt_images(hh+2).name;
                    im_gt = imread([path_gt_category,name_gt_image]);
                    [x,y] = size(im_gt);
                    %%
                    indx_gt = strfind(name_gt_image,'gt');
                    indx_point = strfind(name_gt_image,'.');
                    name_result_image = ['bin',name_gt_image(indx_gt+2:indx_point),'mat'];
                    if exist([path_results_category,name_result_image]) == 2
                        load([path_results_category,name_result_image]);
                        im_binary = full(image_result);
                    else
                        im_binary = logical(zeros(x,y));
                    end
                    int8trap = isa(im_binary, 'uint8') && min(min(im_binary)) == 0 && max(max(im_binary)) == 1;
                    if size(im_binary, 3) > 1
                        im_binary = rgb2gray(im_binary);
                    end
                    if islogical(im_binary) || int8trap
                        im_binary = uint8(im_binary)*255;
                    end
                    confusionMatrix = confusionMatrix + compare(im_binary,im_gt);
                end
                %% Computation metrics
                TP{h,j}(k,i) = confusionMatrix(1);
                FP{h,j}(k,i) = confusionMatrix(2);
                FN{h,j}(k,i) = confusionMatrix(3);
                TN{h,j}(k,i) = confusionMatrix(4);
                SE{h,j}(k,i) = confusionMatrix(5);
                
                recall{h,j}(k,i) = TP{h,j}(k,i)/(TP{h,j}(k,i)+FN{h,j}(k,i));
                specficity{h,j}(k,i) = TN{h,j}(k,i)/(TN{h,j}(k,i)+FP{h,j}(k,i));
                FPR{h,j}(k,i) = FP{h,j}(k,i)/(FP{h,j}(k,i)+TN{h,j}(k,i));
                FNR{h,j}(k,i) = FN{h,j}(k,i)/(TP{h,j}(k,i)+FN{h,j}(k,i));
                PBC{h,j}(k,i) = 100.0*(FN{h,j}(k,i)+FP{h,j}(k,i))/(TP{h,j}(k,i)+FP{h,j}(k,i)+FN{h,j}(k,i)+TN{h,j}(k,i));
                precision{h,j}(k,i) = TP{h,j}(k,i)/(TP{h,j}(k,i)+FP{h,j}(k,i));
                FMeasure{h,j}(k,i) = 2.0*(recall{h,j}(k,i)*precision{h,j}(k,i))/(recall{h,j}(k,i)+precision{h,j}(k,i));
            end
        end
    end
end
for i=1:length(folder_challenges)
    for j=1:repetitions
        average_recall{i}(j,:) = mean(recall{i,j});
        average_specficity{i}(j,:) = mean(specficity{i,j});
        average_FPR{i}(j,:) = mean(FPR{i,j});
        average_FNR{i}(j,:) = mean(FNR{i,j});
        average_PBC{i}(j,:) = mean(PBC{i,j});
        average_precision{i}(j,:) = mean(precision{i,j});
        average_FMeasure{i}(j,:) = mean(FMeasure{i,j});
    end
end

save([path_to_results_metrics,'results_metrics.mat'],'recall','specficity','FPR','FNR','PBC','precision',...
    'FMeasure','sampling_density','average_recall','average_specficity',...
    'average_FPR','average_FNR','average_PBC','average_precision','average_FMeasure',...
    'TP','FP','FN','TN','SE','sampling_density');

function range = readTemporalFile(path)
    % Reads the temporal file and returns the important range

    fID = fopen([path, '/temporalROI.txt']);
    if fID < 0
        disp(ferror(fID));
        exit(0);
    end

    C = textscan(fID, '%d %d', 'CollectOutput', true);
    fclose(fID);

    m = C{1};
    range = m';
end

function confusionMatrix = compare(imBinary, imGT)
    % Compares a binary frames with the groundtruth frame

    TP = sum(sum(imGT==255&imBinary==255));		% True Positive
    TN = sum(sum(imGT<=50&imBinary==0));		% True Negative
    FP = sum(sum((imGT<=50)&imBinary==255));	% False Positive
    FN = sum(sum(imGT==255&imBinary==0));		% False Negative
    SE = sum(sum(imGT==50&imBinary==255));		% Shadow Error

    confusionMatrix = [TP FP FN TN SE];
end
