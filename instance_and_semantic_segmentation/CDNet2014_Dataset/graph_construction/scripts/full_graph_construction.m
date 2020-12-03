% This code needs the GSP toolbox
clear all, close all, clc;
%% Setting of paths
segmentation_algorithm = 'R_50_FPN_COCO';
background_inti_algorithm = 'median_filter';
construction_algorithm = 'k-NN-k-40';
path_to_construction = [pwd,'/../',construction_algorithm,'-',segmentation_algorithm,...
    '-',background_inti_algorithm,'/'];
mkdir(path_to_construction);
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
points = []; % all features
label_bin = []; % all graph signals
for i=1:length(folder_challenges)
    graph_signals = load([pwd,'/../graph_signal_',segmentation_algorithm,'-',...
        background_inti_algorithm,'/',folder_challenges{i},'.mat']);
    label_bin = [label_bin; graph_signals.label_bin];
    for j=1:length(folders_sequences{i})
        features = load([pwd,'/../../nodes_representation/',segmentation_algorithm,...
            '-',background_inti_algorithm,'/',folder_challenges{i},'/features_',...
            folders_sequences{i}{j},'.mat']);
        points = [points; features.features];
    end
end
%%
N = size(points,1);
knn_param = 40;
[Idx Dist] = knnsearch(points,points,'K',knn_param+1);
sigma = mean(mean(Dist));
W = spalloc(N,N,(2*N*knn_param));
for i=1:N
    i/N
    W(i,Idx(i,2:end)) = exp(-(Dist(i,2:end).^2)./(sigma^2));
    W(Idx(i,2:end),i) = W(i,Idx(i,2:end));
end
%%
G.N = N;
G.W = W;
G.coords = points;
G.type = 'nearest neighbors';
G.sigma = sigma;
G = gsp_graph_default_parameters(G);
G = gsp_estimate_lmax(G);
save([path_to_construction,'full_graph.mat'],'G','label_bin','points','Idx','Dist');
