function [done,stamp,stiminfo] = customdraw( stim, stiminfo, MTI, capture_movie)
%LOOMINGSTIM/CUSTOMDRAW
%
% 200X, Sven Van der Burg, Azadeh Tafreshiha
% 2025, Alexander Heimel & Huaxing Ou

% capture_movie is not yet implemented

NewStimGlobals % for pixels_per_cm and NewStimViewingDistance
StimWindowGlobals % for StimWindowRefresh

screen_pxl = [StimWindowRect(3) StimWindowRect(4)];
screen_cm = screen_pxl / pixels_per_cm;
pixels_per_degree = tan(pi/(2 * 180)) * NewStimViewingDistance * pixels_per_cm * 2 ;
params = getparameters(stim);
n_frames_expansion = params.expansion_time *StimWindowRefresh;
duration_trial = params.expansion_time + params.static_time;
n_frames = duration_trial * StimWindowRefresh ; % should be in s and should be in stimulus definition (azadehloom)
screen_center = screen_pxl / 2;
degreevelocity = (params.expanded_diameter_deg - params.extent_deg(1))/ (2*n_frames_expansion) ;
pxlvelocity = degreevelocity * pixels_per_degree;

dp = struct(getdisplaystruct(stim));
my_texture = dp.offscreen(1);

tic
Screen(StimWindow,'FillRect',dp.clut_bg(1,:));
stamp = Screen('Flip', StimWindow);


for current_cycle = 1:params.n_repetitions
    topleft_pxl_x = screen_center(1) - pixels_per_degree * params.extent_deg(1)/2;
    topleft_pxl_y = screen_center(2) - pixels_per_degree * params.extent_deg(2)/2;
    bottomright_pxl_x = screen_center(1) + pixels_per_degree * params.extent_deg(1)/2;
    bottomright_pxl_y = screen_center(2) + pixels_per_degree * params.extent_deg(2)/2;
    topleft_pxl = [topleft_pxl_x topleft_pxl_y];
    bottomright_pxl = [bottomright_pxl_x bottomright_pxl_y];
    
    for current_frame = 1:n_frames
     
        if current_frame <= n_frames_expansion
            topleft_pxl_x = topleft_pxl_x - pxlvelocity;
            topleft_pxl_y = topleft_pxl_y - pxlvelocity;
            bottomright_pxl_x = bottomright_pxl_x + pxlvelocity;
            bottomright_pxl_y = bottomright_pxl_y + pxlvelocity;
            topleft_pxl = [topleft_pxl_x topleft_pxl_y];
            bottomright_pxl = [bottomright_pxl_x bottomright_pxl_y];
        end
        
        image_rect =[ topleft_pxl bottomright_pxl];
        Screen('DrawTexture', StimWindow, my_texture, [], image_rect);
       
        stamp = Screen('Flip', StimWindow, stamp+0.5/StimWindowRefresh);
    end
    Screen(StimWindow,'FillRect',dp.clut_bg(1,:));
    stamp = Screen('Flip', StimWindow);
    pause(params.inter_looming_time);
end

stimduration = toc;
logmsg(['Stimulus took ' num2str(stimduration) ' s.']);
done = 1;
stamp = [];

