function results=practice_mat_save(subID,dataset,repetitions, num_blocks)
% conditions = [1,2,3,4]
% eccentricites, robust/standard, left/right, correct_response,
% buttom-press, correct/incorrect
% add completed blocks list so you can check for overwriting
pixel_hori = 3340;
w = 800;
d = 500;
% convert image positions to pixels
distance_per_pixel = w/pixel_hori;
eccentricities = [5,10,15,20,25,30];
num_eccentricities = length(eccentricities);
pixel_positions = zeros(size(eccentricities));

for i = 1:num_eccentricities
    pixel_positions(i) = d*tan(eccentricities(i)*pi/180)/distance_per_pixel;
end

condtable_0 = [1,1, 1, 2;
    1,1,2,1;
    1,2,1,2;
    1,2,2,1];

condtable_0b = [1,1, 1, 3;
    1,1,3,1;
    1,3,1,3;
    1,3,3,1];

condtable_0 = cat(1,condtable_0,condtable_0b);

condtable_1 = [
    2,2,2,3;%r_synth r_synth
    2,2,3,2;
    2,3,2,3;
    2,3,3,2];

condtable_1 = cat(1,condtable_1,condtable_1);

condtable_2 = [3,1, 1, 4;
    3,1,4,1;
    3,4,1,4;
    3,4,4,1];

condtable_2b = [3,1, 1, 5;
    3,1,5,1;
    3,5,1,5;
    3,5,5,1];

condtable_2 = cat(1,condtable_2,condtable_2b);

condtable_3 = [
    4,5,5,4;%r_synth r_synth
    4,5,4,5;
    4,4,4,5;
    4,4,5,4];

condtable_3 = cat(1,condtable_3,condtable_3);

if strcmp(dataset,'robust')
    conditions = [repelem(condtable_0,repetitions,1);
        repelem(condtable_1,repetitions,1);
        repelem(condtable_2,repetitions,1);
        repelem(condtable_3,repetitions,1)];
elseif strcmp(dataset,'texform')
    conditions = [repelem(condtable_0,repetitions,1);
        repelem(condtable_0,repetitions,1);
        repelem(condtable_1,repetitions,1);
        repelem(condtable_1,repetitions,1);];
end

full_condtable = repmat(conditions, num_eccentricities,1);
full_condtable = cat(2,ones(size(full_condtable,1),1)*(-1),full_condtable,ones(size(full_condtable,1),8)*(-1));
eccentricity_cond = repelem(1:num_eccentricities, 4*8*repetitions)';
    
full_condtable(:,1) = eccentricity_cond;
full_condtable(:,8) = full_condtable(:,3) == full_condtable(:,4);
full_condtable(:,9) = full_condtable(:,3) == full_condtable(:,5);
ims = repmat(0:99, 1, repetitions*size(full_condtable,1))';
classes = datasample(1:9,size(full_condtable,1));
full_condtable(:,6) = classes';
offset = randi(4);
full_condtable(:,7) = ims(offset:size(full_condtable,1)+offset -1);

% omit images
gray_ims = [49,nan;
    9,44;
    nan,nan;
    44,nan;
    nan,nan;
    nan,nan;
    10,nan;
    40,nan
    nan,nan;];

for s=1:2
    for c=1:9 
        if ~(isnan(gray_ims(c,s)))
            to_omit = full_condtable(:,6)==c & full_condtable(:,7)==gray_ims(c,s);
            sample = 0:99;
            sample=sample(sample~=gray_ims(c,s));
            to_add = datasample(sample,sum(to_omit));
            full_condtable(to_omit,7) = to_add;
        end
    end
end




colHeaders = {'eccentricity', 'condition_id','target', 'left', 'right', 'class_id', 'im_id', ...
    'correct_button_left', 'correct_button_right', 'response_left', 'response_right', 'portion_correct','reaction_time'};

train_ids = randi(size(full_condtable,1),1);
train_block = full_condtable(train_ids,:);
blocks = reshape(randperm(size(full_condtable,1)),size(full_condtable,1)/num_blocks,num_blocks);

mat_name = [num2str(subID)];

save(mat_name,'full_condtable','colHeaders','blocks', 'eccentricities', 'pixel_positions','-v7.3');

end
