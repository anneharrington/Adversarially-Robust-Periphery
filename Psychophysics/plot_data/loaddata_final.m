%subject ids
subjects_1 = {'JH_63' 'SO_18' 'TH_34' 'LB_55' 'AE_11' 'FF_30'};
subjects_2 = {'HC_12' 'SJ_32' 'EC_02' 'NO_75' 'MD_89' 'WL_03full'};
all_subjects = cat(2,subjects_1,subjects_2);
%%
% pool data according to which data type (robust/texform) was seen first

[pool_1_data1_boot, num_pool_1_data1] = get_data_pool(subjects_1,1,1);
[pool_2_data1_boot, num_pool_2_data1] = get_data_pool(subjects_2,1,1);

[pool_1_data2_boot, num_pool_1_data2]= get_data_pool(subjects_1,2,1);
[pool_2_data2_boot, num_pool_2_data2] = get_data_pool(subjects_2,2,1);

[pool_1_oddity1_boot, num_pool_1_oddity1] = get_data_pool(subjects_1,3,2);
[pool_2_oddity1_boot, num_pool_2_oddity1] = get_data_pool(subjects_2,3,2);

[pool_1_oddity2_boot, num_pool_1_oddity2] = get_data_pool(subjects_1,4,2);
[pool_2_oddity2_boot, num_pool_2_oddity2] = get_data_pool(subjects_2,4,2);

%%
%save all the pool data

save('bootstrap/pool1_data1.mat','pool_1_data1_boot');
save('bootstrap/pool2_data1.mat','pool_2_data1_boot');

save('new_bootstrap/pool1_data2.mat','pool_1_data2_boot');
save('new_bootstrap/pool2_data2.mat','pool_2_data2_boot');

save('bootstrap/pool1_oddity1.mat','pool_1_oddity1_boot');
save('bootstrap/pool2_oddity1.mat','pool_2_oddity1_boot');

save('new_bootstrap/pool1_oddity2.mat','pool_1_oddity2_boot');
save('new_bootstrap/pool2_oddity2.mat','pool_2_oddity2_boot');

%%
%load the pool data
pool_1_data1_boot = load('bootstrap/pool1_data1.mat');
pool_2_data1_boot = load('bootstrap/pool2_data1.mat');

pool_1_data2_boot = load('new_bootstrap/pool1_data2.mat');
pool_2_data2_boot = load('new_bootstrap/pool2_data2.mat');

pool_1_oddity1_boot = load('bootstrap/pool1_oddity1.mat');
pool_2_oddity1_boot = load('bootstrap/pool2_oddity1.mat');

pool_1_oddity2_boot = load('new_bootstrap/pool1_oddity2.mat');
pool_2_oddity2_boot = load('new_bootstrap/pool2_oddity2.mat');

pool_1_data1_boot = pool_1_data1_boot.pool_1_data1_boot;
pool_2_data1_boot = pool_2_data1_boot.pool_2_data1_boot;

pool_1_data2_boot = pool_1_data2_boot.pool_1_data2_boot;
pool_2_data2_boot = pool_2_data2_boot.pool_2_data2_boot;

pool_1_oddity1_boot = pool_1_oddity1_boot.pool_1_oddity1_boot;
pool_2_oddity1_boot = pool_2_oddity1_boot.pool_2_oddity1_boot;

pool_1_oddity2_boot = pool_1_oddity2_boot.pool_1_oddity2_boot;
pool_2_oddity2_boot = pool_2_oddity2_boot.pool_2_oddity2_boot;

%%
%get data pooled over all subjects

[all_data1_boot, num_pool_1_data1] = get_data_pool(all_subjects,1,1);

[all_data2_boot, num_pool_1_data2]= get_data_pool(all_subjects,2,1);

[all_oddity1_boot, num_pool_1_oddity1] = get_data_pool(all_subjects,3,2);

[all_oddity2_boot, num_pool_1_oddity2] = get_data_pool(all_subjects,4,2);

%%
%save all subject pool
save('bootstrap/all_data1.mat','all_data1_boot');

save('new_bootstrap/all_data2.mat','all_data2_boot');

save('bootstrap/all_oddity1.mat','all_oddity1_boot');

save('new_bootstrap/all_oddity2.mat','all_oddity2_boot');
%%
% load all subject pool
all_data1_boot = load('bootstrap/all_data1.mat');

all_data2_boot = load('new_bootstrap/all_data2.mat');

all_oddity1_boot=load('bootstrap/all_oddity1.mat');

all_oddity2_boot =load('new_bootstrap/all_oddity2.mat');


all_data1_boot = all_data1_boot.all_data1_boot;

all_data2_boot = all_data2_boot.all_data2_boot;

all_oddity1_boot=all_oddity1_boot.all_oddity1_boot;

all_oddity2_boot =all_oddity2_boot.all_oddity2_boot;

%%
%plot pool 1.  Would recommend making a folder for all these, but the name
%should have all the important details.

plot_2_conditions(pool_1_data1_boot(:,3,:),pool_1_data1_boot(:,4,:), 1, 'original vs standard','standard vs standard', '-ro', '--ro', 'pool1')
plot_2_conditions(pool_1_data1_boot(:,1,:),pool_1_data1_boot(:,2,:), 1, 'original vs robust','robust vs robust', '-bo', '--bo', 'pool1')
plot_2_conditions(pool_1_data1_boot(:,1,:),pool_1_data2_boot(:,1,:), 1, 'original vs robust','original vs texform', '-bo', '-mo', 'pool1')
plot_2_conditions(pool_1_data1_boot(:,1,:),pool_1_data1_boot(:,3,:), 1, 'original vs robust','original vs standard', '-bo', '-ro', 'pool1')
plot_2_conditions(pool_1_data1_boot(:,2,:),pool_1_data1_boot(:,4,:), 1, 'robust vs robust', 'standard vs standard', '--bo', '--ro', 'pool1')
plot_2_conditions(pool_1_data1_boot(:,2,:),pool_1_data2_boot(:,2,:), 1, 'robust vs robust', 'texform vs texform', '--bo', '--mo', 'pool1')
plot_2_conditions(pool_1_data2_boot(:,1,:),pool_1_data2_boot(:,2,:), 1, 'original vs texform','texform vs texform', '-mo', '--mo', 'pool1')

plot_2_conditions(pool_1_oddity1_boot(:,3,:),pool_1_oddity1_boot(:,4,:), 2, 'original vs standard','standard vs standard', '-ro', '--ro', 'pool1')
plot_2_conditions(pool_1_oddity1_boot(:,1,:),pool_1_oddity1_boot(:,2,:), 2, 'original vs robust','robust vs robust', '-bo', '--bo', 'pool1')
plot_2_conditions(pool_1_oddity1_boot(:,1,:),pool_1_oddity2_boot(:,1,:), 2, 'original vs robust','original vs texform', '-bo', '-mo', 'pool1')
plot_2_conditions(pool_1_oddity1_boot(:,1,:),pool_1_oddity1_boot(:,3,:), 2, 'original vs robust','original vs standard', '-bo', '-ro', 'pool1')
plot_2_conditions(pool_1_oddity1_boot(:,2,:),pool_1_oddity1_boot(:,4,:), 2, 'robust vs robust', 'standard vs standard', '--bo', '--ro', 'pool1')
plot_2_conditions(pool_1_oddity1_boot(:,2,:),pool_1_oddity2_boot(:,2,:), 2, 'robust vs robust', 'texform vs texform', '--bo', '--mo', 'pool1')
plot_2_conditions(pool_1_oddity2_boot(:,1,:),pool_1_oddity2_boot(:,2,:), 2, 'original vs texform','texform vs texform', '-mo', '--mo', 'pool1')

%close all;
%%
%pool 2

plot_2_conditions(pool_2_data1_boot(:,3,:),pool_2_data1_boot(:,4,:), 1, 'original vs standard','standard vs standard', '-ro', '--ro', 'pool2')
plot_2_conditions(pool_2_data1_boot(:,1,:),pool_2_data1_boot(:,2,:), 1, 'original vs robust','robust vs robust', '-bo', '--bo', 'pool2')
plot_2_conditions(pool_2_data1_boot(:,1,:),pool_2_data2_boot(:,1,:), 1, 'original vs robust','original vs texform', '-bo', '-mo', 'pool2')
plot_2_conditions(pool_2_data1_boot(:,1,:),pool_2_data1_boot(:,3,:), 1, 'original vs robust','original vs standard', '-bo', '-ro', 'pool2')
plot_2_conditions(pool_2_data1_boot(:,2,:),pool_2_data1_boot(:,4,:), 1, 'robust vs robust', 'standard vs standard', '--bo', '--ro', 'pool2')
plot_2_conditions(pool_2_data1_boot(:,2,:),pool_2_data2_boot(:,2,:), 1, 'robust vs robust', 'texform vs texform', '--bo', '--mo', 'pool2')
plot_2_conditions(pool_2_data2_boot(:,1,:),pool_2_data2_boot(:,2,:), 1, 'original vs texform','texform vs texform', '-mo', '--mo', 'pool2')

plot_2_conditions(pool_2_oddity1_boot(:,3,:),pool_2_oddity1_boot(:,4,:), 2, 'original vs standard','standard vs standard', '-ro', '--ro', 'pool2')
plot_2_conditions(pool_2_oddity1_boot(:,1,:),pool_2_oddity1_boot(:,2,:), 2, 'original vs robust','robust vs robust', '-bo', '--bo', 'pool2')
plot_2_conditions(pool_2_oddity1_boot(:,1,:),pool_2_oddity2_boot(:,1,:), 2, 'original vs robust','original vs texform', '-bo', '-mo', 'pool2')
plot_2_conditions(pool_2_oddity1_boot(:,1,:),pool_2_oddity1_boot(:,3,:), 2, 'original vs robust','original vs standard', '-bo', '-ro', 'pool2')
plot_2_conditions(pool_2_oddity1_boot(:,2,:),pool_2_oddity1_boot(:,4,:), 2, 'robust vs robust', 'standard vs standard', '--bo', '--ro', 'pool2')
plot_2_conditions(pool_2_oddity1_boot(:,2,:),pool_2_oddity2_boot(:,2,:), 2, 'robust vs robust', 'texform vs texform', '--bo', '--mo', 'pool2')
plot_2_conditions(pool_2_oddity2_boot(:,1,:),pool_2_oddity2_boot(:,2,:), 2, 'original vs texform','texform vs texform', '-mo', '--mo', 'pool2')

%%
%all

plot_2_conditions(all_data1_boot(:,3,:),all_data1_boot(:,4,:), 1, 'original vs standard','standard vs standard', '-ro', '--ro', 'all')
plot_2_conditions(all_data1_boot(:,1,:),all_data1_boot(:,2,:), 1, 'original vs robust','robust vs robust', '-bo', '--bo', 'all')
plot_2_conditions(all_data1_boot(:,1,:),all_data2_boot(:,1,:), 1, 'original vs robust','original vs texform', '-bo', '-mo', 'all')
plot_2_conditions(all_data1_boot(:,1,:),all_data1_boot(:,3,:), 1, 'original vs robust','original vs standard', '-bo', '-ro', 'all')
plot_2_conditions(all_data1_boot(:,2,:),all_data1_boot(:,4,:), 1, 'robust vs robust', 'standard vs standard', '--bo', '--ro', 'all')
plot_2_conditions(all_data1_boot(:,2,:),all_data2_boot(:,2,:), 1, 'robust vs robust', 'texform vs texform', '--bo', '--mo', 'all')
plot_2_conditions(all_data2_boot(:,1,:),all_data2_boot(:,2,:), 1, 'original vs texform','texform vs texform', '-mo', '--mo', 'all')

plot_2_conditions(all_oddity1_boot(:,3,:),all_oddity1_boot(:,4,:), 2, 'original vs standard','standard vs standard', '-ro', '--ro', 'all')
plot_2_conditions(all_oddity1_boot(:,1,:),all_oddity1_boot(:,2,:), 2, 'original vs robust','robust vs robust', '-bo', '--bo', 'all')
plot_2_conditions(all_oddity1_boot(:,1,:),all_oddity2_boot(:,1,:), 2, 'original vs robust','original vs texform', '-bo', '-mo', 'all')
plot_2_conditions(all_oddity1_boot(:,1,:),all_oddity1_boot(:,3,:), 2, 'original vs robust','original vs standard', '-bo', '-ro', 'all')
plot_2_conditions(all_oddity1_boot(:,2,:),all_oddity1_boot(:,4,:), 2, 'robust vs robust', 'standard vs standard', '--bo', '--ro', 'all')
plot_2_conditions(all_oddity1_boot(:,2,:),all_oddity2_boot(:,2,:), 2, 'robust vs robust', 'texform vs texform', '--bo', '--mo', 'all')
plot_2_conditions(all_oddity2_boot(:,1,:),all_oddity2_boot(:,2,:), 2, 'original vs texform','texform vs texform', '-mo', '--mo', 'all')
