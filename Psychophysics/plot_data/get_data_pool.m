function [ interval_data, num_per_condition ] = get_data_pool_final( subjects, data_type, experiment)
% pool data across observers and perform 10000 sample bootstrap
% given all subject ids, the data type
% (1:robust_2AFC,2:texform_2AFC,3:robust_oddity,4:texform_oddity)
% return the mean for all conditions and the error bounds in 'interval
% data'.  return the valid trials per observed condition as
% 'num_per_condition'

data_types = {'_data1.mat', '_data2.mat', '_oddity_data1.mat', '_oddity_data2.mat'};

% pool data
pool_data = [];

for i=1:length(subjects)
        fileName = [char(subjects(i)) char(data_types(data_type))]
        if exist(fileName,'file')
            collected_values = load(fileName);
            data = collected_values.full_condtable;
            if experiment==1
                im = data(:,7);
                class = data(:,6);
                % discard repeated entries for our data
                % to_discard =((class==1 & (im==22|im==25|im==26|im==27|im==29|im==93|im==94|im==95|im==96|im==97|im==98|im==99)) | (class==2 & (im==20|im==21|im==22|im==23|im==73|im==74)));
                % data = data(~to_discard,:);
            elseif experiment ==2
                im = data(:,8);
                class = data(:,7);
                % discard repeated entries for our data
                % to_discard =((class==1 & (im==22|im==25|im==26|im==27|im==29|im==93|im==94|im==95|im==96|im==97|im==98|im==99)) | (class==2 & (im==20|im==21|im==22|im==23|im==73|im==74)));
                % data = data(~to_discard,:);
            end
            pool_data = cat(1,pool_data,data);
        end
end

% bootstrap
interval_data = zeros(6,4,3);
rt = zeros(6,4);
num_per_condition = zeros(6,4);

for e=1:6
    for c=1:4
        if experiment == 1
            condition = pool_data(pool_data(:,1)==e & pool_data(:,2)==c,12);
        elseif experiment == 2
            condition = pool_data(pool_data(:,1)==e & pool_data(:,3)==c,15);
        end

        % omit invalid trials
        condition_clean = condition(~isnan(condition));
        condition_clean = condition_clean(condition_clean ~= -1); % omit not seen
        num_per_condition(e,c) = size(condition_clean,1);

        % get sample mean
        u = mean(condition_clean);
        interval_data(e,c,1) = u;

        % get bootstrap samples
        sample_size = size(condition_clean,1);
        n=10000;
        bootstrap_samples = zeros(sample_size,n);
        
        % loop could be replace by matlab bootstrapping function, but this
        % works
        for i=1:n
            bootstrap_samples(:,i) = datasample(condition_clean,size(condition_clean,1));
        end

        % 95% confidence interval estimating SE with SD of bootstrap
        % parameter
        bootstrap_means = mean(bootstrap_samples,1);
        bootstrap_std = std(bootstrap_means);

        interval_data(e,c,2) = 1.96*bootstrap_std;
        interval_data(e,c,3) = 1.96*bootstrap_std;
    end
end
end

