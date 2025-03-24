# NewStim3 # 

Tools to remotedly present visual stimuli, forked in 2002 from the Van Hooser lab tools.
NewStim3 is a layer built on top of PsychToolbox3.

## Installation ##

Download or clone the most recent version from <https://github.com/heimel/NewStim3>. 
Add the top folder (containing NewStimInit.m) to your MATLAB path.
Add the following line to your MATLAB startup.m file to include NewStim3 folders to 
your MATLAB path. 
```
if exist('NewStimInit','file'), NewStimInit(); end
```
If no startup.m file already exists, you can create one in MATLAB by
```
edit(fullfile(userpath,'startup.m'))
```

This package is dependent on [heimel/InVivoTools](https://github.com/heimel/InVivoTools) being installed and in the Matlab path.


## Manual ##

For information on showing visual stimuli check out the manual on the NewStim3 package 
 <https://sites.google.com/site/alexanderheimel/protocols/manual-newstim-and-runexperiment>

## Maintainer ##

Maintainer: Alexander Heimel
