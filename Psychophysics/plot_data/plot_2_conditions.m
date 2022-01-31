function [  ] = plot_2_conditions( data1, data2, experiment, name1, name2, line1, line2, subID)
%plot 2 conditions together.  For example, original vs robust and robust vs
%robust.  Provide the data for each, name them, choose a color/style,
%include the ID (a subject or pool)
%Saves as .svg in current directory

fig = figure('Position',[0 0 400 300]);
hold on
x = 5:5:30;
% ylabel('Proportion Correct')
% xlabel('Eccentricity')
errorbar(x, data1(:,:,1),data1(:,:,2),data1(:,:,3),line1, 'LineWidth',1.2)
errorbar(x, data2(:,:,1),data2(:,:,2),data2(:,:,3),line2, 'LineWidth',1.2)

if experiment == 1
%     title(['Matching' ' ' subID])
    plot([0 34],[1/2 1/2], '--k','LineWidth',0.8)
elseif experiment == 2
%     title(['Oddity' ' ' subID])
    plot([0 34],[1/3 1/3], '--k','LineWidth',0.8)
end
      
legend(name1, name2,'Location', 'southwest')
set(gca,'xtick',x);
set(gca,'ytick',0:0.1:1);
set(gca,'fontname','helvatica')
ylim([0 1.05])
xlim([0 34])

% saveas(fig,['figures/new/all/' 'experiment_' num2str(experiment) '_' subID '_' name1 name2 '.svg']);
% set(fig, 'PaperPositionMode','auto');
% print(['figures/new/pool/' 'epxeriment_' num2str(experiment) '_' subID '_' name1 name2 '.png'],'-dpng','-r300');

set(fig, 'PaperPositionMode','auto');
print(['testing/' 'experiment_' num2str(experiment) '_' subID '_' name1 name2 '.svg'],'-dsvg');
end

