function monitor_calibration(duration,levels)
% monitor_calibration. Displays 10 stimuli of linearly increasing luminance
%
%    monitor_calibration(DURATION=5,N_LEVELS=10)
%
% 2026, Alexander Heimel

if nargin<1 || isempty(duration)
    duration = 5; % s to display each stimulus
end
if nargin<2 || isempty(n_levels)
    n_levels = 10; % number of levels to display
end

s = periodicstim();
p = getparameters(s);
p.contrast = 0.0;
p.background = 0.5; % base level 
p.backdrop = [0 255 0]; % surrounding stimulus
p.chromhigh = [255 255 255];
p.chromlow = [0 0 0];
p.imageType = 2;
p.animType = 0;
p.flickerType = 0;
p.tFrequency = 1;
p.nCycles = duration;
p.rect = [0 0 1920 1080];
p.windowShape = 1;
p.dispprefs={'BGpretime',0.2,'BGposttime',0.2};


warmup = stimscript(0);

levels = linspace(0,1,n_levels);
for i = 1:n_levels
    p.background = levels(i);
    s = periodicstim(p);
    warmup = append(warmup,s);
end

NSLoadAndRunTest(warmup)

%warmup = loadStimScript(warmup);
%MTI=DisplayTiming(warmup);
%DisplayStimScript(warmup,MTI,0,0);



