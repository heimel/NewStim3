function [MTI,MTI2] = NSCaptureMovie(stimclass)
%NSCaptureMovie runs NewStim script and saves result as movie
%
%  [MTI,MTI2] = NSCaptureMovie(stimclass)
%
% 200X, Steve Van Hooser
% 200X-2025, Alexander Heimel

MTI = [];
MTI2 = [];

if usejava('jvm') && ispc
    disp('Recording a movie while JAVA capabilities is turned on is not supported by');
    disp('Psychtoolbox and gstreamer. Start matlab without java by typing matlab -nojvm');
    disp('in a command window. Then load your script (e.g. ps) and at the matlab prompt');
    disp('type NSCaptureMovie(ps) to write a movie to your current folder.');
    disp('I am now attempting to do this for you. Might not work.');
    save('tempscript.mat','stimclass');
    system('matlab -nojvm -r "load(''tempscript.mat'');NSCaptureMovie(stimclass);quit"')
    % s
    return
end

NewStimGlobals;
StimWindowGlobals;

currLut = Screen('ReadNormalizedGammaTable', StimWindowMonitor);
mypriority = MaxPriority(StimWindowMonitor,'WaitBlanking','SetClut','GetSecs'); % PD

if isa(stimclass,'stimscript')
    myscript = stimclass;
else % make script out of stim
    mystim = NSGetTestStim(stimclass);
    if iscell(mystim) || isa(mystim,'stimulus')
        myscript = stimscript(0);
        if iscell(mystim)
            for i=1:length(mystim)
                myscript = append(myscript,mystim{i}); 
            end
        else
            myscript = append(myscript,mystim);
        end
    else
        myscript = mystim;
    end
end

ShowStimScreen;
disp('Got past ShowStimScreen');
myscript = loadStimScript(myscript);
disp('Got past loading');
MTI = DisplayTiming(myscript);
disp('Got past DisplayTiming');
MTI2 = DisplayStimScript(myscript,MTI,mypriority,1,true);
myscript = unloadStimScript(myscript);
CloseStimScreen;

Screen('LoadNormalizedGammaTable', StimWindowMonitor, currLut);

