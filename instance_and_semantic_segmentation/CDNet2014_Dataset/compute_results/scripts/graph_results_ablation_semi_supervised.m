clear all, close all, clc;
TV = load('../TV-k-NN-k-30-R_50_FPN_COCO-median_filter/results_metrics.mat');
e02 = load('../variational_splines-k-NN-k-30-R_50_FPN_COCO-median_filter/results_metrics.mat');
e05 = load('../variational_splines-k-NN-k-30-R_50_FPN_COCO-median_filter-epsilon-0.5/results_metrics.mat');
e50 = load('../variational_splines-k-NN-k-30-R_50_FPN_COCO-median_filter-epsilon-50/results_metrics.mat');
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
path_figures = 'figures_pami_exp_4/';
mkdir(path_figures);
%% Figure bad weather
figure()
errorbar(TV.sampling_density,mean(TV.average_FMeasure{figures_paper(1)}),std(TV.average_FMeasure{figures_paper(1)}),...
    'LineWidth',line_width,'MarkerSize',marker_size);
hold on;
errorbar(e02.sampling_density,mean(e02.average_FMeasure{figures_paper(1)}),std(e02.average_FMeasure{figures_paper(1)}),...
    'o--','LineWidth',line_width,'MarkerSize',marker_size);
errorbar(e05.sampling_density,mean(e05.average_FMeasure{figures_paper(1)}),std(e05.average_FMeasure{figures_paper(1)}),...
    '*-','LineWidth',line_width,'MarkerSize',marker_size);
errorbar(e50.sampling_density,mean(e50.average_FMeasure{figures_paper(1)}),std(e50.average_FMeasure{figures_paper(1)}),...
    'd-.','LineWidth',line_width,'MarkerSize',marker_size);
ylabel('Average f-measure','Interpreter','Latex');
xlabel('Sampling density','Interpreter','Latex');
xlim([TV.sampling_density(1) 0.1]);
lgd = legend({'TV','$\epsilon=0.2$','$\epsilon=0.5$','$\epsilon=50$'},'Location','best');
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
errorbar(TV.sampling_density,mean(TV.average_FMeasure{figures_paper(2)}),std(TV.average_FMeasure{figures_paper(2)}),...
    'LineWidth',line_width,'MarkerSize',marker_size);
hold on;
errorbar(e02.sampling_density,mean(e02.average_FMeasure{figures_paper(2)}),std(e02.average_FMeasure{figures_paper(2)}),...
    'o--','LineWidth',line_width,'MarkerSize',marker_size);
errorbar(e05.sampling_density,mean(e05.average_FMeasure{figures_paper(2)}),std(e05.average_FMeasure{figures_paper(2)}),...
    '*-','LineWidth',line_width,'MarkerSize',marker_size);
errorbar(e50.sampling_density,mean(e50.average_FMeasure{figures_paper(2)}),std(e50.average_FMeasure{figures_paper(2)}),...
    'd-.','LineWidth',line_width,'MarkerSize',marker_size);
ylabel('Average f-measure','Interpreter','Latex');
xlabel('Sampling density','Interpreter','Latex');
xlim([TV.sampling_density(1) 0.1]);
ylim([0.48 1]);
lgd = legend({'TV','$\epsilon=0.2$','$\epsilon=0.5$','$\epsilon=50$'},'Location','best');
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
errorbar(TV.sampling_density,mean(TV.average_FMeasure{figures_paper(3)}),std(TV.average_FMeasure{figures_paper(3)}),...
    'LineWidth',line_width,'MarkerSize',marker_size);
hold on;
errorbar(e02.sampling_density,mean(e02.average_FMeasure{figures_paper(3)}),std(e02.average_FMeasure{figures_paper(3)}),...
    'o--','LineWidth',line_width,'MarkerSize',marker_size);
errorbar(e05.sampling_density,mean(e05.average_FMeasure{figures_paper(3)}),std(e05.average_FMeasure{figures_paper(3)}),...
    '*-','LineWidth',line_width,'MarkerSize',marker_size);
errorbar(e50.sampling_density,mean(e50.average_FMeasure{figures_paper(3)}),std(e50.average_FMeasure{figures_paper(3)}),...
    'd-.','LineWidth',line_width,'MarkerSize',marker_size);
ylabel('Average f-measure','Interpreter','Latex');
xlabel('Sampling density','Interpreter','Latex');
xlim([TV.sampling_density(1) 0.1]);
ylim([0.46 0.7]);
lgd = legend({'TV','$\epsilon=0.2$','$\epsilon=0.5$','$\epsilon=50$'},'Location','best');
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
errorbar(TV.sampling_density,mean(TV.average_FMeasure{figures_paper(4)}),std(TV.average_FMeasure{figures_paper(4)}),...
    'LineWidth',line_width,'MarkerSize',marker_size);
hold on;
errorbar(e02.sampling_density,mean(e02.average_FMeasure{figures_paper(4)}),std(e02.average_FMeasure{figures_paper(4)}),...
    'o--','LineWidth',line_width,'MarkerSize',marker_size);
errorbar(e05.sampling_density,mean(e05.average_FMeasure{figures_paper(4)}),std(e05.average_FMeasure{figures_paper(4)}),...
    '*-','LineWidth',line_width,'MarkerSize',marker_size);
errorbar(e50.sampling_density,mean(e50.average_FMeasure{figures_paper(4)}),std(e50.average_FMeasure{figures_paper(4)}),...
    'd-.','LineWidth',line_width,'MarkerSize',marker_size);
ylabel('Average f-measure','Interpreter','Latex');
xlabel('Sampling density','Interpreter','Latex');
xlim([TV.sampling_density(1) 0.1]);
lgd = legend({'TV','$\epsilon=0.2$','$\epsilon=0.5$','$\epsilon=50$'},'Location','best');
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
errorbar(TV.sampling_density,mean(TV.average_FMeasure{figures_paper(5)}),std(TV.average_FMeasure{figures_paper(5)}),...
    'LineWidth',line_width,'MarkerSize',marker_size);
hold on;
errorbar(e02.sampling_density,mean(e02.average_FMeasure{figures_paper(5)}),std(e02.average_FMeasure{figures_paper(5)}),...
    'o--','LineWidth',line_width,'MarkerSize',marker_size);
errorbar(e05.sampling_density,mean(e05.average_FMeasure{figures_paper(5)}),std(e05.average_FMeasure{figures_paper(5)}),...
    '*-','LineWidth',line_width,'MarkerSize',marker_size);
errorbar(e50.sampling_density,mean(e50.average_FMeasure{figures_paper(5)}),std(e50.average_FMeasure{figures_paper(5)}),...
    'd-.','LineWidth',line_width,'MarkerSize',marker_size);
ylabel('Average f-measure','Interpreter','Latex');
xlabel('Sampling density','Interpreter','Latex');
xlim([TV.sampling_density(1) 0.1]);
lgd = legend({'TV','$\epsilon=0.2$','$\epsilon=0.5$','$\epsilon=50$'},'Location','best');
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
errorbar(TV.sampling_density,mean(TV.average_FMeasure{figures_paper(6)}),std(TV.average_FMeasure{figures_paper(6)}),...
    'LineWidth',line_width,'MarkerSize',marker_size);
hold on;
errorbar(e02.sampling_density,mean(e02.average_FMeasure{figures_paper(6)}),std(e02.average_FMeasure{figures_paper(6)}),...
    'o--','LineWidth',line_width,'MarkerSize',marker_size);
errorbar(e05.sampling_density,mean(e05.average_FMeasure{figures_paper(6)}),std(e05.average_FMeasure{figures_paper(6)}),...
    '*-','LineWidth',line_width,'MarkerSize',marker_size);
errorbar(e50.sampling_density,mean(e50.average_FMeasure{figures_paper(6)}),std(e50.average_FMeasure{figures_paper(6)}),...
    'd-.','LineWidth',line_width,'MarkerSize',marker_size);
ylabel('Average f-measure','Interpreter','Latex');
xlabel('Sampling density','Interpreter','Latex');
xlim([TV.sampling_density(1) 0.1]);
lgd = legend({'TV','$\epsilon=0.2$','$\epsilon=0.5$','$\epsilon=50$'},'Location','best');
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
errorbar(TV.sampling_density,mean(TV.average_FMeasure{figures_paper(8)}),std(TV.average_FMeasure{figures_paper(8)}),...
    'LineWidth',line_width,'MarkerSize',marker_size);
hold on;
errorbar(e02.sampling_density,mean(e02.average_FMeasure{figures_paper(8)}),std(e02.average_FMeasure{figures_paper(8)}),...
    'o--','LineWidth',line_width,'MarkerSize',marker_size);
errorbar(e05.sampling_density,mean(e05.average_FMeasure{figures_paper(8)}),std(e05.average_FMeasure{figures_paper(8)}),...
    '*-','LineWidth',line_width,'MarkerSize',marker_size);
errorbar(e50.sampling_density,mean(e50.average_FMeasure{figures_paper(8)}),std(e50.average_FMeasure{figures_paper(8)}),...
    'd-.','LineWidth',line_width,'MarkerSize',marker_size);
ylabel('Average f-measure','Interpreter','Latex');
xlabel('Sampling density','Interpreter','Latex');
xlim([TV.sampling_density(1) 0.1]);
lgd = legend({'TV','$\epsilon=0.2$','$\epsilon=0.5$','$\epsilon=50$'},'Location','best');
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
errorbar(TV.sampling_density,mean(TV.average_FMeasure{figures_paper(9)}),std(TV.average_FMeasure{figures_paper(9)}),...
    'LineWidth',line_width,'MarkerSize',marker_size);
hold on;
errorbar(e02.sampling_density,mean(e02.average_FMeasure{figures_paper(9)}),std(e02.average_FMeasure{figures_paper(9)}),...
    'o--','LineWidth',line_width,'MarkerSize',marker_size);
errorbar(e05.sampling_density,mean(e05.average_FMeasure{figures_paper(9)}),std(e05.average_FMeasure{figures_paper(9)}),...
    '*-','LineWidth',line_width,'MarkerSize',marker_size);
errorbar(e50.sampling_density,mean(e50.average_FMeasure{figures_paper(9)}),std(e50.average_FMeasure{figures_paper(9)}),...
    'd-.','LineWidth',line_width,'MarkerSize',marker_size);
ylabel('Average f-measure','Interpreter','Latex');
xlabel('Sampling density','Interpreter','Latex');
xlim([TV.sampling_density(1) 0.1]);
lgd = legend({'TV','$\epsilon=0.2$','$\epsilon=0.5$','$\epsilon=50$'},'Location','best');
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
errorbar(TV.sampling_density,mean(TV.average_FMeasure{figures_paper(10)}),std(TV.average_FMeasure{figures_paper(10)}),...
    'LineWidth',line_width,'MarkerSize',marker_size);
hold on;
errorbar(e02.sampling_density,mean(e02.average_FMeasure{figures_paper(10)}),std(e02.average_FMeasure{figures_paper(10)}),...
    'o--','LineWidth',line_width,'MarkerSize',marker_size);
errorbar(e05.sampling_density,mean(e05.average_FMeasure{figures_paper(10)}),std(e05.average_FMeasure{figures_paper(10)}),...
    '*-','LineWidth',line_width,'MarkerSize',marker_size);
errorbar(e50.sampling_density,mean(e50.average_FMeasure{figures_paper(10)}),std(e50.average_FMeasure{figures_paper(10)}),...
    'd-.','LineWidth',line_width,'MarkerSize',marker_size);
ylabel('Average f-measure','Interpreter','Latex');
xlabel('Sampling density','Interpreter','Latex');
xlim([TV.sampling_density(1) 0.1]);
ylim([0.46 0.72]);
lgd = legend({'TV','$\epsilon=0.2$','$\epsilon=0.5$','$\epsilon=50$'},'Location','best');
lgd.NumColumns = 2;
set(lgd,'Interpreter','latex');
set(lgd,'color','none');
set(lgd,'Box','off');
title('Thermal','Interpreter','Latex');
get(gca);
set(gca,'FontName','times','FontSize',font_size,'TickLabelInterpreter','Latex');
set(gcf,'Position',[100,100,width,heigth]);
saveas(gcf,[path_figures 'thermal.svg']);
