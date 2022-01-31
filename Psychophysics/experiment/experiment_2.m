function results = robust_features(subID,dataset,block_id)
path = '/home/matlab/Documents/Periphery_Adversarial/256x256_full';

addpath(genpath(path));

% Make sure the script is running on Psychtoolbox-3:
AssertOpenGL;
Screen('Preference', 'SkipSyncTests', 0);

%set default values for input arguments
if ~exist('subID','var')
    subID=66;
end

if ~exist('dataset','var')
    dataset=1;
end

fileName = [num2str(subID)  '_data' num2str(dataset) '.mat'];

if ~exist(fileName,'file')
    if dataset==1
        practice_mat_save_6b(fileName,'robust',10,10);
    elseif dataset==2
        practice_mat_save_6b(fileName,'texform',5,5);
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
completed_trials = sum(block_conditions(:,12) ~= -1);
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
        block_ids_todo = find(block_conditions(:,12) == -1);
        start = block_ids_todo(1)
    end
end


if dataset==1
    stimulus_type = {'original', 'robust_results0', 'robust_results1', ...
        'standard_results0', 'standard_results1'};
    im_dir = '256x256_full/';
elseif dataset==2
    stimulus_type = {'original', 'texforms0', 'texforms1'};
    im_dir = 'texforms/';
end



ntrials=size(block,1);

% pre-reading the images
all_target = zeros(256,256,3,size(block,1),'uint8');
all_im1 = zeros(256,256,3,size(block,1),'uint8');
all_im2 = zeros(256,256,3,size(block,1),'uint8');
nans = 0;
for i=start:ntrials
    current_condition = condtable(block(i),:);
    eccen_id = current_condition(1);
    target_id = current_condition(3);
    left_id = current_condition(4);
    right_id = current_condition(5);
    class_id = current_condition(6)-1 ; %rename classes
    im_id = current_condition(7);
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

    %disable output of keypresses to Matlab
    ListenChar(2);

    olddebuglevel=Screen('Preference', 'VisualDebuglevel', 3);

    %Choosing the display with the highest display number is
    %a best guess about where you want the stimulus displayed.
    %usually there will be only one screen with id = 0, unless you use a
    %multi-display setup:
    screens=Screen('Screens');
    screenNumber=max(screens);

    %open an (the only) onscreen Window, if you give only two input arguments
    %this will make the full screen white (=default)
    [expWin,rect]=Screen('OpenWindow',screenNumber);
    [w h] = Screen('WindowSize',screenNumber);
    ifi = Screen('GetFlipInterval', expWin)
    flips_per_sec = round(1/ifi)

    %get the midpoint (mx, my) of this window, x and y
    [mx, my] = RectCenter(rect);
    vert_offset = 90;

    %get rid of the mouse cursor, we don't have anything to click at anyway
    HideCursor;

    % Preparing and displaying the welcome screen
    Screen('TextSize', expWin, 24);
    
    % intro text
    myText = ['Instructions \n \n' ...
          '(1) Fix your gaze at the black cross \n \n' ...
          '(2) You will see two images briefly in your periphery, and then a single, centered image \n \n'...
          '(3) Please indicate if the single image matches either the left or right peripheral image.  On your keyboard, press  f  to indicate left and  j  to indicate right \n \n' ...
          '(Press any key to start)\n \n' ];
      
      
    myText = ['Instructions \n \n' ...
          '(1) Fix your gaze at the black cross \n \n' ...
          '(2) You will see a single, centered image, then two images briefly in your periphery \n \n'...
          '(3) Please indicate if the single image matches either the left or right peripheral image.  On your keyboard, press  f  to indicate left and  j  to indicate right \n \n' ...
          '(Press any key to start)\n \n' ];
    DrawFormattedText(expWin, myText,'center', my-vert_offset/distance_per_pixel);

    [~,flip_time] = Screen('Flip', expWin);
     % Wait for key stroke. This will first make sure all keys are
     % released, then wait for a keypress and release:
    KbWait([],[]);

    FixCr=ones(20,20)*255;
    FixCr(10:11,:)=0;
    FixCr(:,10:11)=0;
    fixcross = Screen('MakeTexture',expWin,FixCr);
    
    for i=start:ntrials
        if nans >=35
            txt = ['Please see experimentor for instructions!'];
            DrawFormattedText(expWin, txt,'center', my-vert_offset/distance_per_pixel);
            Screen('Flip', expWin);
            KbWait([],[]);
        end
        % stimulus parameters
        current_condition = condtable(block(i),:);
        eccen_id = current_condition(1);
        target_id = current_condition(3);
        left_id = current_condition(4);
        right_id = current_condition(5);
        class_id = current_condition(6)-1 ; %renames classes
        im_id = current_condition(7);
        target = Screen('MakeTexture', expWin , all_target(:,:,:,i));
        [dx,dy,c] = size(target_im);
        im1Texture = Screen('MakeTexture', expWin , all_im1(:,:,:,i));
        im2Texture = Screen('MakeTexture', expWin , all_im2(:,:,:,i));
        Screen('PreloadTextures',expWin,[target,im1Texture,im2Texture,fixcross]);
        
        % positions
        position = pixel_positions(eccen_id);
        fixcross_position = [mx-12,my-12 - vert_offset/distance_per_pixel,mx+12,my+12 - vert_offset/distance_per_pixel];
        target_position = [mx-dx/2 my-dy/2-vert_offset/distance_per_pixel mx+dx/2 my+dy/2-vert_offset/distance_per_pixel];
        im1_position = [mx-dx/2-position my-dy/2-vert_offset/distance_per_pixel mx+dx/2-position my+dy/2-vert_offset/distance_per_pixel];
        im2_position = [mx-dx/2+position my-dy/2-vert_offset/distance_per_pixel mx+dx/2+position my+dy/2-vert_offset/distance_per_pixel];

        Screen('DrawTexture', expWin, fixcross, [], fixcross_position);
        [~,tfixation] = Screen('Flip', expWin);

        Screen('DrawTexture', expWin, target, [], target_position, 0);
        [~,targ_time] = Screen('Flip', expWin, tfixation + ifi*(1*flips_per_sec-0.5));

        Screen('DrawTexture', expWin, fixcross,[],fixcross_position);
        [~,tfixation] = Screen('Flip', expWin, targ_time+ifi*(0.1*flips_per_sec-0.5));

        Screen('DrawTexture', expWin, fixcross,[],fixcross_position);
        Screen('DrawTexture', expWin, im1Texture, [], im1_position, 0);
        Screen('DrawTexture', expWin, im2Texture, [], im2_position, 0);
        telapsed = Screen('DrawingFinished', expWin, [], 1);

        [VBLTimestamp, StimulusOnsetTime, FlipTimestamp]=Screen('Flip', expWin, tfixation+(1*flips_per_sec-0.5)*ifi);

	    [VBLTimestamp, StimulusOnsetTime, FlipTimestamp] = Screen('Flip', expWin, FlipTimestamp + ifi*(0.1*flips_per_sec-0.5));


        response_text = ['Which image matched the target?'];
        DrawFormattedText(expWin, response_text, 'center', my-vert_offset/distance_per_pixel+13);

        [VBLTimestamp, StimulusOnsetTime, FlipTimestamp] = Screen('Flip', expWin, FlipTimestamp+(0.2*flips_per_sec-0.5)*ifi);
        [resptime, keyCode] = KbWait([],[],FlipTimestamp+(2*flips_per_sec-0.5)*ifi);
        rt=resptime-StimulusOnsetTime;

        %find out which key was pressed
        cc=KbName(keyCode);  %translate code into letter (string)
        cc;
        wrong_key = false;
        condtable(block(i),13) = rt;
        full_condtable = condtable;
        save(fileName,'full_condtable','-append')
        %calculate performance or detect forced exit
        if strcmp(cc,'ESCAPE');
            condtable(block(i),13) = nan;
            condtable(block(i),12) = nan;
            condtable(block(i),10) = nan;
            condtable(block(i),11) = nan;
            break;   
        elseif ~any(strcmp(cc,'f') || strcmp(cc,'j'));
            nans = nans+1;
            wrong_key = true;
            condtable(block(i),13) = nan;
            condtable(block(i),12) = nan;
            condtable(block(i),10) = nan;
            condtable(block(i),11) = nan;
        elseif strcmp(cc,'f');
            condtable(block(i),10) = 1;
            condtable(block(i),11) = 0;
            if current_condition(8) == 1;
                condtable(block(i),12) = 1;
            else
                condtable(block(i),12) = 0;
            end
        elseif strcmp(cc,'j');
            condtable(block(i),10) = 0;
            condtable(block(i),11) = 1;
            if current_condition(9) == 1;
                condtable(block(i),12) = 1;
            else
                condtable(block(i),12) = 0;
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
    % This section is executed only in case an error happens
    ShowCursor;
    sca; %or sca
    ListenChar(0);
    Screen('Preference', 'VisualDebuglevel', olddebuglevel);
    %output the error message
    psychrethrow(psychlasterror);
    % if you escapem still want to save ...
end
