clear all, close all, clc;
k_10_R_50_COCO = load('../variational_splines-k-NN-k-10-R_50_FPN_COCO-median_filter/results_metrics.mat');
k_20_R_50_COCO = load('../variational_splines-k-NN-k-20-R_50_FPN_COCO-median_filter/results_metrics.mat');
k_30_R_50_COCO = load('../variational_splines-k-NN-k-30-R_50_FPN_COCO-median_filter/results_metrics.mat');
k_40_R_50_COCO = load('../variational_splines-k-NN-k-40-R_50_FPN_COCO-median_filter/results_metrics.mat');
%%
figure_paper = [1:11];
challenges = {'badWeather';'baseline';'cameraJitter';'dynamicBackground';...
    'intermittentObjectMotion';'lowFramerate';'nightVideos';'PTZ';'shadow';...
    'thermal';'turbulence'};
line_width = 1.5;
marker_size = 6;
font_size = 20;
width = 680;
heigth = 290;
path_figures = 'figures_pami_exp_2/';
mkdir(path_figures);
%% Figure bad weather
figure()
errorbar(k_10_R_50_COCO.sampling_density,mean(k_10_R_50_COCO.average_FMeasure{figure_paper(1)}),std(k_10_R_50_COCO.average_FMeasure{figure_paper(1)}),...
    'LineWidth',line_width,'MarkerSize',marker_size);
hold on;
errorbar(k_20_R_50_COCO.sampling_density,mean(k_20_R_50_COCO.average_FMeasure{figure_paper(1)}),std(k_20_R_50_COCO.average_FMeasure{figure_paper(1)}),...
    'o--','LineWidth',line_width,'MarkerSize',marker_size);
errorbar(k_30_R_50_COCO.sampling_density,mean(k_30_R_50_COCO.average_FMeasure{figure_paper(1)}),std(k_30_R_50_COCO.average_FMeasure{figure_paper(1)}),...
    '*-','LineWidth',line_width,'MarkerSize',marker_size);
errorbar(k_40_R_50_COCO.sampling_density,mean(k_40_R_50_COCO.average_FMeasure{figure_paper(1)}),std(k_40_R_50_COCO.average_FMeasure{figure_paper(1)}),...
    'd-.','LineWidth',line_width,'MarkerSize',marker_size);
ylabel('Average f-measure','Interpreter','Latex');
xlabel('Sampling density','Interpreter','Latex');
xlim([k_10_R_50_COCO.sampling_density(1) 0.1]);
lgd = legend({'k=10','k=20','k=30','k=40'},'Location','best');
lgd.NumColumns = 2;
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
errorbar(k_10_R_50_COCO.sampling_density,mean(k_10_R_50_COCO.average_FMeasure{figure_paper(2)}),std(k_10_R_50_COCO.average_FMeasure{figure_paper(2)}),...
    'LineWidth',line_width,'MarkerSize',marker_size);
hold on;
errorbar(k_20_R_50_COCO.sampling_density,mean(k_20_R_50_COCO.average_FMeasure{figure_paper(2)}),std(k_20_R_50_COCO.average_FMeasure{figure_paper(2)}),...
    'o--','LineWidth',line_width,'MarkerSize',marker_size);
errorbar(k_30_R_50_COCO.sampling_density,mean(k_30_R_50_COCO.average_FMeasure{figure_paper(2)}),std(k_30_R_50_COCO.average_FMeasure{figure_paper(2)}),...
    '*-','LineWidth',line_width,'MarkerSize',marker_size);
errorbar(k_40_R_50_COCO.sampling_density,mean(k_40_R_50_COCO.average_FMeasure{figure_paper(2)}),std(k_40_R_50_COCO.average_FMeasure{figure_paper(2)}),...
    'd-.','LineWidth',line_width,'MarkerSize',marker_size);
ylabel('Average f-measure','Interpreter','Latex');
xlabel('Sampling density','Interpreter','Latex');
xlim([k_10_R_50_COCO.sampling_density(1) 0.1]);
lgd = legend({'k=10','k=20','k=30','k=40'},'Location','best');
lgd.NumColumns = 2;
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
errorbar(k_10_R_50_COCO.sampling_density,mean(k_10_R_50_COCO.average_FMeasure{figure_paper(3)}),std(k_10_R_50_COCO.average_FMeasure{figure_paper(3)}),...
    'LineWidth',line_width,'MarkerSize',marker_size);
hold on;
errorbar(k_20_R_50_COCO.sampling_density,mean(k_20_R_50_COCO.average_FMeasure{figure_paper(3)}),std(k_20_R_50_COCO.average_FMeasure{figure_paper(3)}),...
    'o--','LineWidth',line_width,'MarkerSize',marker_size);
errorbar(k_30_R_50_COCO.sampling_density,mean(k_30_R_50_COCO.average_FMeasure{figure_paper(3)}),std(k_30_R_50_COCO.average_FMeasure{figure_paper(3)}),...
    '*-','LineWidth',line_width,'MarkerSize',marker_size);
errorbar(k_40_R_50_COCO.sampling_density,mean(k_40_R_50_COCO.average_FMeasure{figure_paper(3)}),std(k_40_R_50_COCO.average_FMeasure{figure_paper(3)}),...
    'd-.','LineWidth',line_width,'MarkerSize',marker_size);
ylabel('Average f-measure','Interpreter','Latex');
xlabel('Sampling density','Interpreter','Latex');
xlim([k_10_R_50_COCO.sampling_density(1) 0.1]);
lgd = legend({'k=10','k=20','k=30','k=40'},'Location','best');
lgd.NumColumns = 2;
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
errorbar(k_10_R_50_COCO.sampling_density,mean(k_10_R_50_COCO.average_FMeasure{figure_paper(4)}),std(k_10_R_50_COCO.average_FMeasure{figure_paper(4)}),...
    'LineWidth',line_width,'MarkerSize',marker_size);
hold on;
errorbar(k_20_R_50_COCO.sampling_density,mean(k_20_R_50_COCO.average_FMeasure{figure_paper(4)}),std(k_20_R_50_COCO.average_FMeasure{figure_paper(4)}),...
    'o--','LineWidth',line_width,'MarkerSize',marker_size);
errorbar(k_30_R_50_COCO.sampling_density,mean(k_30_R_50_COCO.average_FMeasure{figure_paper(4)}),std(k_30_R_50_COCO.average_FMeasure{figure_paper(4)}),...
    '*-','LineWidth',line_width,'MarkerSize',marker_size);
errorbar(k_40_R_50_COCO.sampling_density,mean(k_40_R_50_COCO.average_FMeasure{figure_paper(4)}),std(k_40_R_50_COCO.average_FMeasure{figure_paper(4)}),...
    'd-.','LineWidth',line_width,'MarkerSize',marker_size);
ylabel('Average f-measure','Interpreter','Latex');
xlabel('Sampling density','Interpreter','Latex');
xlim([k_10_R_50_COCO.sampling_density(1) 0.1]);
lgd = legend({'k=10','k=20','k=30','k=40'},'Location','best');
lgd.NumColumns = 2;
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
errorbar(k_10_R_50_COCO.sampling_density,mean(k_10_R_50_COCO.average_FMeasure{figure_paper(5)}),std(k_10_R_50_COCO.average_FMeasure{figure_paper(5)}),...
    'LineWidth',line_width,'MarkerSize',marker_size);
hold on;
errorbar(k_20_R_50_COCO.sampling_density,mean(k_20_R_50_COCO.average_FMeasure{figure_paper(5)}),std(k_20_R_50_COCO.average_FMeasure{figure_paper(5)}),...
    'o--','LineWidth',line_width,'MarkerSize',marker_size);
errorbar(k_30_R_50_COCO.sampling_density,mean(k_30_R_50_COCO.average_FMeasure{figure_paper(5)}),std(k_30_R_50_COCO.average_FMeasure{figure_paper(5)}),...
    '*-','LineWidth',line_width,'MarkerSize',marker_size);
errorbar(k_40_R_50_COCO.sampling_density,mean(k_40_R_50_COCO.average_FMeasure{figure_paper(5)}),std(k_40_R_50_COCO.average_FMeasure{figure_paper(5)}),...
    'd-.','LineWidth',line_width,'MarkerSize',marker_size);
ylabel('Average f-measure','Interpreter','Latex');
xlabel('Sampling density','Interpreter','Latex');
xlim([k_10_R_50_COCO.sampling_density(1) 0.1]);
lgd = legend({'k=10','k=20','k=30','k=40'},'Location','best');
lgd.NumColumns = 2;
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
errorbar(k_10_R_50_COCO.sampling_density,mean(k_10_R_50_COCO.average_FMeasure{figure_paper(6)}),std(k_10_R_50_COCO.average_FMeasure{figure_paper(6)}),...
    'LineWidth',line_width,'MarkerSize',marker_size);
hold on;
errorbar(k_20_R_50_COCO.sampling_density,mean(k_20_R_50_COCO.average_FMeasure{figure_paper(6)}),std(k_20_R_50_COCO.average_FMeasure{figure_paper(6)}),...
    'o--','LineWidth',line_width,'MarkerSize',marker_size);
errorbar(k_30_R_50_COCO.sampling_density,mean(k_30_R_50_COCO.average_FMeasure{figure_paper(6)}),std(k_30_R_50_COCO.average_FMeasure{figure_paper(6)}),...
    '*-','LineWidth',line_width,'MarkerSize',marker_size);
errorbar(k_40_R_50_COCO.sampling_density,mean(k_40_R_50_COCO.average_FMeasure{figure_paper(6)}),std(k_40_R_50_COCO.average_FMeasure{figure_paper(6)}),...
    'd-.','LineWidth',line_width,'MarkerSize',marker_size);
ylabel('Average f-measure','Interpreter','Latex');
xlabel('Sampling density','Interpreter','Latex');
xlim([k_10_R_50_COCO.sampling_density(1) 0.1]);
lgd = legend({'k=10','k=20','k=30','k=40'},'Location','best');
lgd.NumColumns = 2;
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
errorbar(k_10_R_50_COCO.sampling_density,mean(k_10_R_50_COCO.average_FMeasure{figure_paper(8)}),std(k_10_R_50_COCO.average_FMeasure{figure_paper(8)}),...
    'LineWidth',line_width,'MarkerSize',marker_size);
hold on;
errorbar(k_20_R_50_COCO.sampling_density,mean(k_20_R_50_COCO.average_FMeasure{figure_paper(8)}),std(k_20_R_50_COCO.average_FMeasure{figure_paper(8)}),...
    'o--','LineWidth',line_width,'MarkerSize',marker_size);
errorbar(k_30_R_50_COCO.sampling_density,mean(k_30_R_50_COCO.average_FMeasure{figure_paper(8)}),std(k_30_R_50_COCO.average_FMeasure{figure_paper(8)}),...
    '*-','LineWidth',line_width,'MarkerSize',marker_size);
errorbar(k_40_R_50_COCO.sampling_density,mean(k_40_R_50_COCO.average_FMeasure{figure_paper(8)}),std(k_40_R_50_COCO.average_FMeasure{figure_paper(8)}),...
    'd-.','LineWidth',line_width,'MarkerSize',marker_size);
ylabel('Average f-measure','Interpreter','Latex');
xlabel('Sampling density','Interpreter','Latex');
xlim([k_10_R_50_COCO.sampling_density(1) 0.1]);
lgd = legend({'k=10','k=20','k=30','k=40'},'Location','best');
lgd.NumColumns = 2;
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
errorbar(k_10_R_50_COCO.sampling_density,mean(k_10_R_50_COCO.average_FMeasure{figure_paper(9)}),std(k_10_R_50_COCO.average_FMeasure{figure_paper(9)}),...
    'LineWidth',line_width,'MarkerSize',marker_size);
hold on;
errorbar(k_20_R_50_COCO.sampling_density,mean(k_20_R_50_COCO.average_FMeasure{figure_paper(9)}),std(k_20_R_50_COCO.average_FMeasure{figure_paper(9)}),...
    'o--','LineWidth',line_width,'MarkerSize',marker_size);
errorbar(k_30_R_50_COCO.sampling_density,mean(k_30_R_50_COCO.average_FMeasure{figure_paper(9)}),std(k_30_R_50_COCO.average_FMeasure{figure_paper(9)}),...
    '*-','LineWidth',line_width,'MarkerSize',marker_size);
errorbar(k_40_R_50_COCO.sampling_density,mean(k_40_R_50_COCO.average_FMeasure{figure_paper(9)}),std(k_40_R_50_COCO.average_FMeasure{figure_paper(9)}),...
    'd-.','LineWidth',line_width,'MarkerSize',marker_size);
ylabel('Average f-measure','Interpreter','Latex');
xlabel('Sampling density','Interpreter','Latex');
xlim([k_10_R_50_COCO.sampling_density(1) 0.1]);
lgd = legend({'k=10','k=20','k=30','k=40'},'Location','best');
lgd.NumColumns = 2;
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
errorbar(k_10_R_50_COCO.sampling_density,mean(k_10_R_50_COCO.average_FMeasure{figure_paper(10)}),std(k_10_R_50_COCO.average_FMeasure{figure_paper(10)}),...
    'LineWidth',line_width,'MarkerSize',marker_size);
hold on;
errorbar(k_20_R_50_COCO.sampling_density,mean(k_20_R_50_COCO.average_FMeasure{figure_paper(10)}),std(k_20_R_50_COCO.average_FMeasure{figure_paper(10)}),...
    'o--','LineWidth',line_width,'MarkerSize',marker_size);
errorbar(k_30_R_50_COCO.sampling_density,mean(k_30_R_50_COCO.average_FMeasure{figure_paper(10)}),std(k_30_R_50_COCO.average_FMeasure{figure_paper(10)}),...
    '*-','LineWidth',line_width,'MarkerSize',marker_size);
errorbar(k_40_R_50_COCO.sampling_density,mean(k_40_R_50_COCO.average_FMeasure{figure_paper(10)}),std(k_40_R_50_COCO.average_FMeasure{figure_paper(10)}),...
    'd-.','LineWidth',line_width,'MarkerSize',marker_size);
ylabel('Average f-measure','Interpreter','Latex');
xlabel('Sampling density','Interpreter','Latex');
xlim([k_10_R_50_COCO.sampling_density(1) 0.1]);
ylim([0.58 0.76]);
lgd = legend({'k=10','k=20','k=30','k=40'},'Location','best');
lgd.NumColumns = 2;
set(lgd,'Interpreter','latex');
set(lgd,'color','none');
set(lgd,'Box','off');
title('Thermal','Interpreter','Latex');
get(gca);
set(gca,'FontName','times','FontSize',font_size,'TickLabelInterpreter','Latex');
set(gcf,'Position',[100,100,width,heigth]);
saveas(gcf,[path_figures 'thermal.svg']);
