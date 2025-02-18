function OpenStimScreenBlender
% OpenStimScreenBlender - Sets the blending mode to alpha, 1-alpha
%
% 200X, Steve Van Hooser
% 2025, Alexander Heimel

NewStimGlobals;
StimScreenBlenderGlobals;
StimWindowGlobals;

% now we might 1) have never opened the window,
%              2) have had a crash that closed the window rudely
%              3) have opened a window previously that was closed
%              4) might have the window we have been using still open
ShowStimScreen;
% ShowStimScreen will call 'CloseStimScreen' if 1, 2, or 3
%              CloseStimScreen calls CloseStimScreenBlender so we safe

% make sure we are blending
AssertGL;
Screen('BlendFunction',StimWindow,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);

