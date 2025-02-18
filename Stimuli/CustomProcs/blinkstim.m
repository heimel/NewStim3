function [done,stamp,infoO]=blinkstim(info,StimScreen,dispstruct,dispprefs)
%blinkstim.
%
%  [done,stamp,infoO]=blinkstim(info,StimScreen,dispstruct,dispprefs)
%
%  What you get:
%
%     Background is drawn, the appropriate number of background frames are
%     shown, the color table is not installed.
%
%  output:
%
%    done -       0/1 is the stimulus done
%    stamp -      0/1 should we record the time?
%    info -       whatever, it is passed again
%
%  input -
%      if info not a structure, then it is just loading in memory
%      if info = [], then it is the first frame
%      else, just show the next frame
%
% 200X, Steve Van Hooser
% 2025, Alexander Heimel

NewStimGlobals;
StimWindowGlobals;

done = 0; stamp = 0;

if ~isstruct(info)&~isempty(info
    dispstruct.userfield; % make sure we're in memory
elseif isempty(info)
    Screen('LoadNormalizedGammaTable',StimScreen,dispstruct.clut);
    Screen(StimScreen,'FillRect',0);
    rectshift = [dispprefs.rect(1) dispprefs.rect(2) ...
        dispprefs.rect(1) dispprefs.rect(2)];
    frameLength = dispstruct.userfield.frameLength - 1;
    if (frameLength<1)
        frameLength = 1;
    end
    info=struct('frame',0,'bgcount',0,'rectshift',rectshift, ...
        'frameLength',frameLength,'lastvbl',Screen('Flip',StimScreen));
    done=0; stamp=0;
else % info has our info
    % clean up the mess from the last frame
    % if PTB2, wait until waitblanking, do our drawing
    % if PTB3, do our drawing, flip the page at waitblanking
    if info.frame>dispstruct.userfield.N
        done = 1;
        stamp=0;
    else
       stamp = 1;
           if dispstruct.userfield.bgpause~=0
               info.lastvbl = Screen('Flip',StimScreen,info.lastvbl+(dispstruct.userfield.frameLength-0.5)/StimWindowRefresh);
           end
           if info.frame~=dispstruct.userfield.N % draw next frame for all but last frame
               Screen('DrawTexture',StimScreen,dispstruct.offscreen(1),dispstruct.userfield.rects(1,:),info.rectshift+dispstruct.userfield.rects(...
                   dispstruct.userfield.blinkList(info.frame+1),:));
           else
               done = 1; stamp=0;
           end
           info.lastvbl = Screen('Flip',StimScreen,info.lastvbl+(dispstruct.userfield.frameLength*(1+dispstruct.userfield.bgpause)-0.5)/StimWindowRefresh);
           info.bgcount = dispstruct.userfield.bgpause;
       info.frame = info.frame + 1;
    end
end

infoO = info;

