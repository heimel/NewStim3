function st = loomingstim( params, oldstim )
%loomingstim. NewStim3 stimulus to show looming bitmaps
%
% 2014, Azadeh Tafreshiha, Alexander Heimel
% 2025, Alexander Heimel, Huaxing Ou

if nargin<2
    oldstim = [];
end

% Default parameters from Yang, Xing, et al. "A simple threat-detection strategy in mice." BMC biology 18 (2020): 1-11.
default.filename = 'large_circle.png';
default.expansion_time = 0.75;
default.static_time = 0.250;
default.extent_deg = [0 0 0]; % initial width and height in degree
default.n_repetitions = 5;
default.expanded_diameter_deg = 30;
default.inter_looming_time = 0.5;
default.backdrop = [0.5 0.5 0.5];
default.dispprefs = '{''BGpretime'',0}';
if isempty(oldstim)
    oldstimpar = default;
else
    oldstimpar = getparameters(oldstim);
end

if nargin<1
    params = default;
elseif ischar(params)
    switch lower(params)
        case 'graphical'
            params = structgui( oldstimpar ,capitalize(mfilename));
        case 'default'
            params = default;
        otherwise
            errormsg(['Unknown argument ' params]);
            st = [];
            return
    end
end
if ischar(params.dispprefs) % str to cell
    params.dispprefs = eval(params.dispprefs);
end

NewStimListAdd(mfilename);
s = stimulus(5);
data = struct('params', params);
st = class(data,mfilename,s);
st.stimulus = setdisplayprefs(st.stimulus,displayprefs(params.dispprefs));


