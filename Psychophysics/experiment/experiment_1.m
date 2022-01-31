function results = robust_features(subID,dataset,block_id)

path = '/home/matlab/Documents/Periphery_Adversarial/256x256_full_1';

addpath(genpath(path));

% Make sure the script is running on Psychtoolbox-3:
AssertOpenGL;
Screen('Preference', 'SkipSyncTests', 0);

%set default values for input arguments
if ~exist('subID','var')
    subID=66;
end

fileName = [num2str(subID)  '_oddity_data' num2str(dataset) '.mat']
if ~exist(fileName,'file')
    if dataset==1
        practice_mat_save_peripheral_oddityb(fileName,'robust',3,12);
    elseif dataset==2
        practice_mat_save_peripheral_oddityb(fileName,'texform',2,8);
    end
end


% load block parameters
conditions = load(fileName);
condtable = conditions.full_condtable;
block = conditions.blocks(:,block_id);
block_conditions = condtable(block,:);
pixel_positions = conditions.pixel_positions;
pixel_hori = 3340;
w = 800;
d = 500;
distance_per_pixel = w/pixel_hori;
%256x256 image covers about 7.02 degrees
%2*atan(256*distance_per_pixel/(2*500))*180/pi
trials_per_block = size(block,1);
completed_trials = sum(block_conditions(:,16) ~= -1);
start = 1;
if completed_trials == trials_per_block
    resp=questdlg({['this block is complete']; 'do you want to overwrite it?'},...
        'duplicate warning','cancel','ok','ok');
    
    if ~strcmp(resp,'ok') %abort experiment if overwriting was not confirmed
        disp('experiment aborted')
        return
    end
elseif completed_trials < trials_per_block & completed_trials > 0;
    resp=questdlg({['this block is partially complete']; 'do you want to start where you left off?'},...
        'duplicate warning','cancel','ok','ok');
    
    if ~strcmp(resp,'ok') %abort experiment if overwriting was not confirmed
        disp('experiment aborted')
        return
    else
        block_ids_todo = find(block_conditions(:,13) == -1);
        start = block_ids_todo(1)
    end
end



if dataset==1
    stimulus_type = {'original', 'robust_results0', 'robust_results1', ...
        'standard_results0', 'standard_results1'};
    im_dir = '256x256_full_1/';
elseif dataset==2
    stimulus_type = {'original', 'texforms0', 'texforms1'};
    im_dir = 'texforms/';
end



ntrials=size(block,1);
nans = 0;
% pre-reading the images
all_target = zeros(256,256,3,size(block,1),'uint8');
all_im1 = zeros(256,256,3,size(block,1),'uint8');
all_im2 = zeros(256,256,3,size(block,1),'uint8');

for i=start:ntrials
    current_condition = condtable(block(i),:);
    eccen_id = current_condition(1);
    target_id = current_condition(4);
    left_id = current_condition(5);
    right_id = current_condition(6);
    class_id = current_condition(7)-1 ; %renames classes
    im_id = current_condition(8);
    target_im_file = [im_dir char(stimulus_type(target_id)) '/' 'class_' num2str(class_id) '/' num2str(im_id) '.png'];
    im1_file = [im_dir char(stimulus_type(left_id)) '/' 'class_' num2str(class_id) '/' num2str(im_id) '.png'];
    im2_file = [im_dir char(stimulus_type(right_id)) '/' 'class_' num2str(class_id) '/' num2str(im_id) '.png'];
    target_im = imread(target_im_file);
    im1 = imread(im1_file);
    im2 = imread(im2_file);
    all_target(:,:,:,i) = target_im;
    all_im1(:,:,:,i) = im1;
    all_im2(:,:,:,i) = im2;

end

try
    % Enable unified mode of KbName, so KbName accepts identical key names on
    % all operating systems (not absolutely necessary, but good practice):
    KbName('UnifyKeyNames');
    KbCheck;

    %disable output of keypresses to Matlab.
    ListenChar(2);

    olddebuglevel=Screen('Preference', 'VisualDebuglevel', 3);

    screens=Screen('Screens');
    screenNumber=max(screens);

    %open an (the only) onscreen Window, if you give only two input arguments
    %this will make the full screen white (=default)
    [expWin,rect]=Screen('OpenWindow',screenNumber);
    [w h] = Screen('WindowSize',screenNumber);
    ifi = Screen('GetFlipInterval', expWin);
    flips_per_sec = round(1/ifi);
    

    %get the midpoint (mx, my) of this window, x and y
    [mx, my] = RectCenter(rect);
    vert_offset = 90;

    %get rid of the mouse cursor, we don't have anything to click at anyway
    HideCursor;

    % Preparing and displaying the welcome screen
    % We choose a text size of 24 pixels - Well readable on most screens:
    Screen('TextSize', expWin, 24);
    
    % This is our intro text. The '\n' sequence creates a line-feed:
    myText = ['Instructions \n \n' ...
          '(1) Fix your gaze at the black cross \n \n' ...
          '(2) In each trial, you will see a sequence on three images.  One image will be different from the other two (the oddball). \n \n'...
          '(3) On your keyboard, press  1, 2, or 3 to indicate which image was different from the others (the oddball). \n \n' ...
          '(Press any key to start)\n \n' ];

    DrawFormattedText(expWin, myText,'center', my-vert_offset/distance_per_pixel);

    [~,flip_time] = Screen('Flip', expWin);
     % Wait for key stroke. This will first make sure all keys are
     % released, then wait for a keypress and release:
    KbWait([],[]);

    FixCr=ones(20,20)*255;
%     FixCr=ones(20,20)*180;
    FixCr(10:11,:)=0;
    FixCr(:,10:11)=0;
    fixcross = Screen('MakeTexture',expWin,FixCr);
%     Screen('FillRect',expWin,[180, 180, 180]);
    
    for i=start:ntrials
        if nans >=35
            txt = ['Please see experimentor for instructions!'];
            DrawFormattedText(expWin, txt,'center', my-vert_offset/distance_per_pixel);
            Screen('Flip', expWin);
            KbWait([],[]);
        end
        current_condition = condtable(block(i),:);
        eccen_id = current_condition(1);
        target_id = current_condition(4);
        left_id = current_condition(5);
        right_id = current_condition(6);
        class_id = current_condition(7)-1 ; %renames classes
        im_id = current_condition(8);
        target_position = current_condition(2);
        target = Screen('MakeTexture', expWin , all_target(:,:,:,i));
        [dx,dy,c] = size(target_im);
        im1Texture = Screen('MakeTexture', expWin , all_im1(:,:,:,i));
        im2Texture = Screen('MakeTexture', expWin , all_im2(:,:,:,i));

        % positions
        im_position = pixel_positions(eccen_id);
        fixcross_position = [mx-12,my-12 - vert_offset/distance_per_pixel,mx+12,my+12 - vert_offset/distance_per_pixel];
        position0 = [mx-dx/2-im_position my-dy/2-vert_offset/distance_per_pixel mx+dx/2-im_position my+dy/2-vert_offset/distance_per_pixel];
        position1 = [mx-dx/2+im_position my-dy/2-vert_offset/distance_per_pixel mx+dx/2+im_position my+dy/2-vert_offset/distance_per_pixel];
        Screen('PreloadTextures',expWin,[target,im1Texture,im2Texture,fixcross]);
        Screen('DrawTexture', expWin, fixcross,[],fixcross_position);

        [~,tfixation] = Screen('Flip', expWin);
        
        Screen('DrawTexture', expWin, fixcross,[],fixcross_position);
        if target_position == 0
            Screen('DrawTexture', expWin, target, [], position0, 0);
        elseif target_position == 1
            Screen('DrawTexture', expWin, target, [],position1, 0);
        end

        
        [VBLTimestamp, StimulusOnsetTime, FlipTimestamp]= Screen('Flip', expWin, tfixation + ifi*(1*flips_per_sec-0.5));
        
        Screen('DrawTexture', expWin, fixcross,[],fixcross_position);
        telapsed = Screen('DrawingFinished', expWin, [], 1);
        [VBLTimestamp, StimulusOnsetTime, FlipTimestamp]=Screen('Flip', expWin, FlipTimestamp+(0.1*flips_per_sec-0.5)*ifi);
        
        Screen('DrawTexture', expWin, fixcross,[],fixcross_position);
        if target_position == 0
            Screen('DrawTexture', expWin, im1Texture, [], position0, 0);
            telapsed = Screen('DrawingFinished', expWin, [], 1);
            [VBLTimestamp, StimulusOnsetTime, FlipTimestamp]=Screen('Flip', expWin, FlipTimestamp+(0.5*flips_per_sec-0.5)*ifi);
            Screen('DrawTexture', expWin, fixcross,[],fixcross_position);
            [VBLTimestamp, StimulusOnsetTime, FlipTimestamp]=Screen('Flip', expWin, FlipTimestamp+(0.1*flips_per_sec-0.5)*ifi);
            Screen('DrawTexture', expWin, im2Texture, [], position0, 0);
        elseif target_position == 1
            Screen('DrawTexture', expWin, im1Texture, [],position1, 0);
            telapsed = Screen('DrawingFinished', expWin, [], 1);
            [VBLTimestamp, StimulusOnsetTime, FlipTimestamp]=Screen('Flip', expWin, FlipTimestamp+(0.5*flips_per_sec-0.5)*ifi);
            Screen('DrawTexture', expWin, fixcross,[],fixcross_position);
            [VBLTimestamp, StimulusOnsetTime, FlipTimestamp]=Screen('Flip', expWin, FlipTimestamp+(0.1*flips_per_sec-0.5)*ifi);
            Screen('DrawTexture', expWin, im2Texture, [],position1, 0);
        end
        Screen('DrawTexture', expWin, fixcross,[],fixcross_position);
        telapsed = Screen('DrawingFinished', expWin, [], 1);
        [VBLTimestamp, StimulusOnsetTime, FlipTimestamp]=Screen('Flip', expWin, FlipTimestamp+(0.5*flips_per_sec-0.5)*ifi);
        [VBLTimestamp, StimulusOnsetTime, FlipTimestamp] = Screen('Flip', expWin, FlipTimestamp + ifi*(0.1*flips_per_sec-0.5));

        response_text = ['Which image was different (the oddball)?'];

        DrawFormattedText(expWin, response_text, 'center', my-vert_offset/distance_per_pixel+13);

        [VBLTimestamp, StimulusOnsetTime, FlipTimestamp] = Screen('Flip', expWin, FlipTimestamp+(0.3*flips_per_sec-0.5)*ifi);
        [resptime, keyCode] = KbWait([],[],FlipTimestamp+(4.5*flips_per_sec-0.5)*ifi);
        rt=resptime-StimulusOnsetTime;

        %find out which key was pressed
        cc=KbName(keyCode);  %translate code into letter (string)
        cc;
        wrong_key = false;
        condtable(block(i),16) = rt;
        full_condtable = condtable;
        save(fileName,'full_condtable','-append')
        %calculate performance or detect forced exit
        if strcmp(cc,'ESCAPE');
            condtable(block(i),14) = nan;
            condtable(block(i),13) = nan;
            condtable(block(i),12) = nan;
            condtable(block(i),15) = nan;
            condtable(block(i),16) = nan;
            break;   
        elseif ~any(strcmp(cc,'1!') || strcmp(cc,'2@') || strcmp(cc,'3#'));
            nans = nans+1;
            condtable(block(i),14) = nan;
            condtable(block(i),13) = nan;
            condtable(block(i),12) = nan;
            condtable(block(i),15) = nan;
            condtable(block(i),16) = nan;
        elseif strcmp(cc,'1!');
            condtable(block(i),12) = 1;
            condtable(block(i),13) = 0;
            condtable(block(i),14) = 0;
            if current_condition(9) == 1;
                condtable(block(i),15) = 1;
            else
                condtable(block(i),15) = 0;
            end
        elseif strcmp(cc,'2@');
            condtable(block(i),12) = 0;
            condtable(block(i),13) = 1;
            condtable(block(i),14) = 0;
            if current_condition(10) == 1;
                condtable(block(i),15) = 1;
            else
                condtable(block(i),15) = 0;
            end
        elseif strcmp(cc,'3#');
            condtable(block(i),12) = 0;
            condtable(block(i),13) = 0;
            condtable(block(i),14) = 1;
            if current_condition(11) == 1;
                condtable(block(i),15) = 1;
            else
                condtable(block(i),15) = 0;
            end
        end
        Screen('Close', [im1Texture, im2Texture, target])
        [~,FlipTimeStamp] = Screen('Flip', expWin,resptime+(flips_per_sec*0.05-0.5)*ifi);
        jitter_id = randi(5);
        jitters = (2:10)/100;
        WaitSecs('untilTime',FlipTimeStamp + (flips_per_sec*jitters(jitter_id)-0.5)*ifi);

    end %of trials loop

%     save

    full_condtable = condtable;
    save(fileName,'full_condtable','-append')
    endtext = [''];

    endtext = cat(2,endtext,'Thank you for completing the block!\n (Press any key to exit)');
    DrawFormattedText(expWin,endtext, 'center', my-vert_offset/distance_per_pixel);
    Screen('Flip', expWin);
    KbWait([], 2); %wait for keystroke

    %clean up before exit
    ShowCursor;
    sca; %or sca;
    ListenChar(0);
    %return to olddebuglevel
    Screen('Preference', 'VisualDebuglevel', olddebuglevel);

catch
    % This section is executed only in case an error happens in the
    % experiment code implemented between try and catch...
    ShowCursor;
    sca; %or sca
    ListenChar(0);
    Screen('Preference', 'VisualDebuglevel', olddebuglevel);
    %output the error message
    psychrethrow(psychlasterror);
    % if you escapem still want to save ...
end
