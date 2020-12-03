clear all, close all, clc;
R_50_COCO = load('../variational_splines-k-NN-k-30-R_50_FPN_COCO-median_filter/results_metrics.mat');
X_101_COCO = load('../variational_splines-k-NN-k-30-X_101_FPN_COCO-median_filter/results_metrics.mat');
%%
figures_paper = [1:11];
challenges = {'badWeather';'baseline';'cameraJitter';'dynamicBackground';...
    'intermittentObjectMotion';'lowFramerate';'nightVideos';'PTZ';'shadow';...
    'thermal';'turbulence'};
line_width = 1.5;
marker_size = 6;
font_size = 20;
width = 680;
heigth = 290;
path_figures = 'figures_pami_exp_1/';
mkdir(path_figures);
%% Figure bad weather
figure()
errorbar(R_50_COCO.sampling_density,mean(R_50_COCO.average_FMeasure{figures_paper(1)}),std(R_50_COCO.average_FMeasure{figures_paper(1)}),...
    'LineWidth',line_width,'MarkerSize',marker_size);
hold on;
errorbar(X_101_COCO.sampling_density,mean(X_101_COCO.average_FMeasure{figures_paper(1)}),std(X_101_COCO.average_FMeasure{figures_paper(1)}),...
    'o--','LineWidth',line_width,'MarkerSize',marker_size);
ylabel('Average f-measure','Interpreter','Latex');
xlabel('Sampling density','Interpreter','Latex');
xlim([R_50_COCO.sampling_density(1) 0.1]);
lgd = legend({'ResNet50','ResNeXt-101'},'Location','northeast');
set(lgd,'Interpreter','latex');
set(lgd,'color','none');
set(lgd,'Box','off');
title('Bad Weather','Interpreter','Latex');
get(gca);
set(gca,'FontName','times','FontSize',font_size,'TickLabelInterpreter','Latex');
set(gcf,'Position',[100,100,width,heigth]);
saveas(gcf,[path_figures 'bad_weather.svg']);
%% Figure baseline
figure()
errorbar(R_50_COCO.sampling_density,mean(R_50_COCO.average_FMeasure{figures_paper(2)}),std(R_50_COCO.average_FMeasure{figures_paper(2)}),...
    'LineWidth',line_width,'MarkerSize',marker_size);
hold on;
errorbar(X_101_COCO.sampling_density,mean(X_101_COCO.average_FMeasure{figures_paper(2)}),std(X_101_COCO.average_FMeasure{figures_paper(2)}),...
    'o--','LineWidth',line_width,'MarkerSize',marker_size);
ylabel('Average f-measure','Interpreter','Latex');
xlabel('Sampling density','Interpreter','Latex');
xlim([R_50_COCO.sampling_density(1) 0.1]);
lgd = legend({'ResNet50','ResNeXt-101'},'Location','southeast');
set(lgd,'Interpreter','latex');
set(lgd,'color','none');
set(lgd,'Box','off');
title('Baseline','Interpreter','Latex');
get(gca);
set(gca,'FontName','times','FontSize',font_size,'TickLabelInterpreter','Latex');
set(gcf,'Position',[100,100,width,heigth]);
saveas(gcf,[path_figures 'baseline.svg']);
%% Figure camera jitter
figure()
errorbar(R_50_COCO.sampling_density,mean(R_50_COCO.average_FMeasure{figures_paper(3)}),std(R_50_COCO.average_FMeasure{figures_paper(3)}),...
    'LineWidth',line_width,'MarkerSize',marker_size);
hold on;
errorbar(X_101_COCO.sampling_density,mean(X_101_COCO.average_FMeasure{figures_paper(3)}),std(X_101_COCO.average_FMeasure{figures_paper(3)}),...
    'o--','LineWidth',line_width,'MarkerSize',marker_size);
ylabel('Average f-measure','Interpreter','Latex');
xlabel('Sampling density','Interpreter','Latex');
xlim([R_50_COCO.sampling_density(1) 0.1]);
lgd = legend({'ResNet50','ResNeXt-101'},'Location','southeast');
set(lgd,'Interpreter','latex');
set(lgd,'color','none');
set(lgd,'Box','off');
title('Camera Jitter','Interpreter','Latex');
get(gca);
set(gca,'FontName','times','FontSize',font_size,'TickLabelInterpreter','Latex');
set(gcf,'Position',[100,100,width,heigth]);
saveas(gcf,[path_figures 'camera_jitter.svg']);
%% Figure dynamic background
figure()
errorbar(R_50_COCO.sampling_density,mean(R_50_COCO.average_FMeasure{figures_paper(4)}),std(R_50_COCO.average_FMeasure{figures_paper(4)}),...
    'LineWidth',line_width,'MarkerSize',marker_size);
hold on;
errorbar(X_101_COCO.sampling_density,mean(X_101_COCO.average_FMeasure{figures_paper(4)}),std(X_101_COCO.average_FMeasure{figures_paper(4)}),...
    'o--','LineWidth',line_width,'MarkerSize',marker_size);
ylabel('Average f-measure','Interpreter','Latex');
xlabel('Sampling density','Interpreter','Latex');
xlim([R_50_COCO.sampling_density(1) 0.1]);
lgd = legend({'ResNet50','ResNeXt-101'},'Location','southeast');
set(lgd,'Interpreter','latex');
set(lgd,'color','none');
set(lgd,'Box','off');
title('Dynamic Background','Interpreter','Latex');
get(gca);
set(gca,'FontName','times','FontSize',font_size,'TickLabelInterpreter','Latex');
set(gcf,'Position',[100,100,width,heigth]);
saveas(gcf,[path_figures 'dynamic_background.svg']);
%% Figure intermittent object motion
figure()
errorbar(R_50_COCO.sampling_density,mean(R_50_COCO.average_FMeasure{figures_paper(5)}),std(R_50_COCO.average_FMeasure{figures_paper(5)}),...
    'LineWidth',line_width,'MarkerSize',marker_size);
hold on;
errorbar(X_101_COCO.sampling_density,mean(X_101_COCO.average_FMeasure{figures_paper(5)}),std(X_101_COCO.average_FMeasure{figures_paper(5)}),...
    'o--','LineWidth',line_width,'MarkerSize',marker_size);
ylabel('Average f-measure','Interpreter','Latex');
xlabel('Sampling density','Interpreter','Latex');
xlim([R_50_COCO.sampling_density(1) 0.1]);
lgd = legend({'ResNet50','ResNeXt-101'},'Location','southeast');
set(lgd,'Interpreter','latex');
set(lgd,'color','none');
set(lgd,'Box','off');
title('Intermittent Object Motion','Interpreter','Latex');
get(gca);
set(gca,'FontName','times','FontSize',font_size,'TickLabelInterpreter','Latex');
set(gcf,'Position',[100,100,width,heigth]);
saveas(gcf,[path_figures 'io_motion.svg']);
%% Figure low frame rate
figure()
errorbar(R_50_COCO.sampling_density,mean(R_50_COCO.average_FMeasure{figures_paper(6)}),std(R_50_COCO.average_FMeasure{figures_paper(6)}),...
    'LineWidth',line_width,'MarkerSize',marker_size);
hold on;
errorbar(X_101_COCO.sampling_density,mean(X_101_COCO.average_FMeasure{figures_paper(6)}),std(X_101_COCO.average_FMeasure{figures_paper(6)}),...
    'o--','LineWidth',line_width,'MarkerSize',marker_size);
ylabel('Average f-measure','Interpreter','Latex');
xlabel('Sampling density','Interpreter','Latex');
xlim([R_50_COCO.sampling_density(1) 0.1]);
lgd = legend({'ResNet50','ResNeXt-101'},'Location','southeast');
set(lgd,'Interpreter','latex');
set(lgd,'color','none');
set(lgd,'Box','off');
title('Low Frame Rate','Interpreter','Latex');
get(gca);
set(gca,'FontName','times','FontSize',font_size,'TickLabelInterpreter','Latex');
set(gcf,'Position',[100,100,width,heigth]);
saveas(gcf,[path_figures 'low_frame_rate.svg']);
%% Figure PTZ
figure()
errorbar(R_50_COCO.sampling_density,mean(R_50_COCO.average_FMeasure{figures_paper(8)}),std(R_50_COCO.average_FMeasure{figures_paper(8)}),...
    'LineWidth',line_width,'MarkerSize',marker_size);
hold on;
errorbar(X_101_COCO.sampling_density,mean(X_101_COCO.average_FMeasure{figures_paper(8)}),std(X_101_COCO.average_FMeasure{figures_paper(8)}),...
    'o--','LineWidth',line_width,'MarkerSize',marker_size);
ylabel('Average f-measure','Interpreter','Latex');
xlabel('Sampling density','Interpreter','Latex');
xlim([R_50_COCO.sampling_density(1) 0.1]);
lgd = legend({'ResNet50','ResNeXt-101'},'Location','southeast');
set(lgd,'Interpreter','latex');
set(lgd,'color','none');
set(lgd,'Box','off');
title('PTZ','Interpreter','Latex');
get(gca);
set(gca,'FontName','times','FontSize',font_size,'TickLabelInterpreter','Latex');
set(gcf,'Position',[100,100,width,heigth]);
saveas(gcf,[path_figures 'ptz.svg']);
%% Figure Shadow
figure()
errorbar(R_50_COCO.sampling_density,mean(R_50_COCO.average_FMeasure{figures_paper(9)}),std(R_50_COCO.average_FMeasure{figures_paper(9)}),...
    'LineWidth',line_width,'MarkerSize',marker_size);
hold on;
errorbar(X_101_COCO.sampling_density,mean(X_101_COCO.average_FMeasure{figures_paper(9)}),std(X_101_COCO.average_FMeasure{figures_paper(9)}),...
    'o--','LineWidth',line_width,'MarkerSize',marker_size);
ylabel('Average f-measure','Interpreter','Latex');
xlabel('Sampling density','Interpreter','Latex');
xlim([R_50_COCO.sampling_density(1) 0.1]);
lgd = legend({'ResNet50','ResNeXt-101'},'Location','southeast');
set(lgd,'Interpreter','latex');
set(lgd,'color','none');
set(lgd,'Box','off');
title('Shadow','Interpreter','Latex');
get(gca);
set(gca,'FontName','times','FontSize',font_size,'TickLabelInterpreter','Latex');
set(gcf,'Position',[100,100,width,heigth]);
saveas(gcf,[path_figures 'shadow.svg']);
%% Figure Thermal
figure()
errorbar(R_50_COCO.sampling_density,mean(R_50_COCO.average_FMeasure{figures_paper(10)}),std(R_50_COCO.average_FMeasure{figures_paper(10)}),...
    'LineWidth',line_width,'MarkerSize',marker_size);
hold on;
errorbar(X_101_COCO.sampling_density,mean(X_101_COCO.average_FMeasure{figures_paper(10)}),std(X_101_COCO.average_FMeasure{figures_paper(10)}),...
    'o--','LineWidth',line_width,'MarkerSize',marker_size);
ylabel('Average f-measure','Interpreter','Latex');
xlabel('Sampling density','Interpreter','Latex');
xlim([R_50_COCO.sampling_density(1) 0.1]);
lgd = legend({'ResNet50','ResNeXt-101'},'Location','northeast');
set(lgd,'Interpreter','latex');
set(lgd,'color','none');
set(lgd,'Box','off');
title('Thermal','Interpreter','Latex');
get(gca);
set(gca,'FontName','times','FontSize',font_size,'TickLabelInterpreter','Latex');
set(gcf,'Position',[100,100,width,heigth]);
saveas(gcf,[path_figures 'thermal.svg']);
