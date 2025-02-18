function [data_new] = AddFrameCounter(data)%  function AddFrameCounter(data)%%  Attempts to add a frame counter to the stimulus.%  If the FrameCounter has an outline border, it is drawn using the last%  color table entry.%FrameCounterGlobals;switch data.displayType,case 'CLUTanim', 	inds = find(data.clut_usage==0);	if (length(inds)>0),		[frameCounter,clut_entries] = MakeClutFrameCounter([255 inds(1)], data.frames);		for i=1:data.frames,                       data.clut{i}(inds(1),:) = clut_entries(i,:);                end;		data.clut_usage(inds(1)) = 1;		data.frameCounter = frameCounter;	else,		warning('Could not add frame counter to CLUTanim with no free entries.');	end;case 'Movie', 	% find desired colors in color table        colors = repmat(fix(255 * [ 1 : -1/(FrameCounterDivs-1) : 0]),3,1)';	inds = zeros(size(colors));	good_match = 1;	unused = find(data.clut_usage==0);	unusedSave = unused;	for i=1:length(colors),  % look through the color table for good matches 	  [p,v] = min(sum(abs(data.clut-colors(ones(size(data.clut,1),1),:))'));         if (p>5) % if we didn't find a match, try to add one 			 if (length(unused)>0),				 data.clut(unused(1),:) = colors(i,:);				 inds(i) = unused(1)-1;				 data.clut_usage(unused(1)) = 1;				 unused = unused(2:end);			 else,  % else, there is failure			     good_match = 0;			 end;	     else, inds(i) = v(1)-1;		 end;	end;	if (good_match),		 [frameCounter] = MakeImageFrameCounter([255 inds]);		 data.frameCounter = frameCounter;	else,		 data.clut_usage(unusedSave) = 0; % return any clut entries used	    warning('Could not add frame counter to Movie b/c no suitable color table entries or slots.');	end;otherwise, warning(['Could not add frame counter to displayType ' data.displayType '.']);end;data_new = data;