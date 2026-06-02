# Installation

[Back to manual index](README.md)

For installation of NewStim check out the wiki of the InVivoTools repository.

## Configuration

After installing matlab, psychtoolbox and the invivotools, some computer and setup specific details have to be entered.  These details will be stored locally in a file called NewStimConfiguration. Start matlab and at the prompt type:

```matlab
initstims
```

This will most probably quickly lead to an error, but it will have created a new NewStimConfiguration.m file. Edit this file by:

```matlab
edit NewStimConfiguration
```

and go line by line over all the options and set them to match your setup and computer. You can find example configuration files by:

```matlab
lookfor NewStimConfiguration
```

and open one of these examples for help.

- For a stimulus computer make sure that:

```matlab
Remote_Comm_isremote = 1;
StimComputer = 1;
StimDebug = false;
StimSerialSerialPort = 1;
NSUseInitialSerialTrigger = 1;
pixels_per_cm = 1920/92.8; % DEPENDS ON MONITOR RESOLUTION AND WIDTH
```

- On the accompanying host computer give settings for stimulus computer, e.g.

```matlab
StimWindowRefresh = 60; %Hz, usually 60 for LCD
StimWindowRect = [0 0 1920 1080];% depends on monitor
StimWindowDepth = 8; % pixeldepth
```

## Monitor linearization / Gamma correction

Both CRT and LCD monitor have a non-linear rgb vs intensity relationship. This relationship is usually well-described by a gamma function like intensity = rgb ^ gamma, with gamma somewhere between 1 and 4. Check out http://en.wikipedia.org/wiki/Gamma_correction for more information.To be able to compare stimuli across labs, and especially to remove unwanted luminance changes when stimuli are started, monitors should be linearized. To do this, one needs a luminance meter (available from Joris Coppens at TSO, or from Maarten Kamermans). The two-photon PMTs also responds linear to light and can also be used.

First make sure that GammaCorrection is turned off, by typing in Matlab:

```matlab
edit NewStimConfiguration
```

and checking that GammaCorrectionEnable  = 0. If not, change and save, and rerun it by typing

```matlab
NewStimConfiguration
```

Luminance of white should be adjusted to 10 cd/m2, by changing the brightness.

Run initstims and check the luminance. This will in the end cause the gray background (50% intensity) to be 5 cd/m2.

To make a calibration stimulus, the NewStim package can be used, which is the easiest way for the two-photon setup. A stimulus would be a small part in the center of the screen, with contrast 0%, shown at a range of background intensities, e.g. (0:0.1:1) for a couple of seconds. Each stimulus should be shown long enough to be able to measure the luminance.

Alternatively, and perhaps easier, you can run the Matlab script monitor_calibration from the Matlab prompt at the stimulus computer

```matlab
monitor_calibration
```

A sequence of 11 luminances are shown and need to be measured with the luminance meter (set to cd/m2). The measurements of the luminance meter (in cd/m2) should be entered into matlab to create a gamma correction table using:

```matlab
CreateGammaCorrectionTable( (0:0.1:1), [0.518 0.518 ... 5.836 8.736] )
```

This will calculate a best fit to the data and save a gamma correction table as gct_hostname.txt in the folder with monitor calibration.

To use the table, switch on gamma correction in NewStimConfiguration and select loading of the newly created file. Open NewStimConfiguration at the matlab prompt

```matlab
edit NewStimConfiguration
```

If a message appears, that NewStimConfiguration does not exist yet, do not create it, but select Cancel. In this case, run initstims by typing

```matlab
initstims
```

This should create NewStimConfiguration. Next retry editing NewStimConfiguration. Search the line with GammaCorrectionEnabled and set to 1, and add or edit the following line (note the exact use of spaces.)

```matlab
LoadGammaCorrectionTable(['gct_' host '.txt']);
```

Save the file, and run it for the gamma correction to take effect:

```matlab
NewStimConfiguration
```

Next, repeat the luminance measurements by typing 'monitor_calibration' or rerunning the script and check if the input-output relationship is now linear, by making a plot of the results:

```matlab
plot( [0.718 1.512 ... 7.826 8.707])
```

For visual checks of monitor capabilities, see http://www.lagom.nl/lcd-test/

## Calibrating the spatial frequency

To present stimuli of a specified spatial frequency, the stimulus computer needs to know the number of pixels per cm on the screen and the distance of the subject to the screen. To measure the number of pixels per cm, check the resolution of the monitor (Start menu / System / Preferences / Monitor) and measure the size of the screen. Compute the values for the horizontal and vertical directions. Correct height and width if necessary to ensure pixels are square. Measure again and edit the line setting 'pixels_per_cm' in NewStimConfiguration by typing at the Matlab prompt:

```matlab
>> edit NewStimConfiguration
```

Just above this line set NewStimViewingDistance to the correct value.

Rerun NewStimConfiguration, reload possible stimuli and check the spatial frequency by measuring the width of a single cycle of (static) grating stimulus.

## Stimulus timing issues

Make sure all visual effects are turned off. In Ubuntu this can be done by selecting None in Taskbar: System / Preference / Appearance - Visual Effects.

For more info on timing issues, check out the faq at http://psychtoolbox.org/PsychtoolboxFaq

#### Two-photon computer

To calibrate timing for two-photon display, make a fullscreen 0% contrast stimulus with a background different from backdrop in NewStim and display it several times for some minutes. (e.g. timing_test.mat). Scan the monitor with the microscope as fast as possible using frame imaging. Next analyse the timing of the stimulus by clicking [PSTH] in the two-photon analysis window (while the 'Mean' option is unchecked). Onset timing should not jitter more than the monitor refresh rate and the microscope scan rate. Pick the time at which the response is still 0 and set this (if necessary) in tpcorrectmti.m as timeshift, by

```matlab
>> edit tpcorrectmti
```

If the response, does not go up before say 0.100 s, than timeshift should be 0.100s. If the response is 0.100 s too early, timeshift should be -0.100s.

After the correction, check the timing again by clearing the computed data by pressing the [Clear] button and reclick [PSTH] analysis. The response should now start going up from 0s.

#### Electrophysiology computer

To calibrate timing for an electrophysiology setup, make a fullscreen 0% contrast stimulus with a background different from backdrop in NewStim and display it for several seconds (e.g. timing_test.mat). Take photocell (in CCD-camera box) and connect it via BNC to the spiking channel of the acquistion board (CED1401). Run the stimulus and detect spikes from the photocell signal, when the stimulus is on. Then run the analysis. Carefully check the PSTH spike rastogram to see the alignment of the spikes to the stimulus. You may need to zoom in around the stimulus start at t=0, by for example xlim([-0.02 0.02]). If the line is not perfectly straight, adjust trial_ttl_delay and secondsmultiplier in ecprocessparams.mat. And redo the analysis. No need to redo the test.
