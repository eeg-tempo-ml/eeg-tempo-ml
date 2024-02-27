function dataOut = run_rca(song_num)

% Example usage:
% plot1 = run_and_plot_RCA(5)
% --------------------------------
% Blair Kaneshiro - Feb 2024
% Revision 1 - Eleonora SC - Feb 2024
%   converted into function
%
% This function applies the RCA filter to each trial using
% rcaRun125_parpoolAlready2021() and returns a figure with 3 subplots:
% cross-trial-average of RC1 filtered data in time domain, cross-trial-average of RC1
% filtered data in frequency domain, and a plot of all trials, RC1 filtered, in time domain.
%
% Input
% - song_num (required): Number of the song used (1 - 10). 
%
% Output
% - fig: the figure object created in this function


%% Input Checks
% Make sure this repo is in the path https://github.com/blairkan/BKanMatEEGToolbox
assert(~isempty(which('ccc')), 'Make sure the ''BKanMatEEGToolbox'' repo is in your path.')

% Make sure this repo is in the path: https://github.com/dmochow/rca
assert(~isempty(which('rcaProject')), 'Make sure the ''rca'' repo is in your path.')


%% Load Song Data
% Load the data from that song
X = loadOneFile(song_num); % Will be a 3D [time x space x trial] matrix


%% Compute RCA

% In this section we'll spatially filter the data using Reliable Components
% Analysis (RCA). 
% - For now we'll only return the 1st (maximally reliable)
%   component, but you can return more by increasing the value of "nComp".
% - The function has an option to plot the data while it's running, but
%   we'll turn that off ("doPlot" variable) and plot it ourselves later.
% - Currently, the parallel pool ("parpool") should be disabled, but we
%   could turn it back on if needed.
% - As is, the function should take 2-4 minutes to run per song (and in
%   fact seems to run faster with the parpool disabled).

% RCA parameters
nComp = 1; % How many components to return
nReg = 7; % Regularization parameter - probably don't need to change ever 

% Run RCA using a slightly modified version of the "rcaRun" function. The
% function we are calling is in the "HelperFiles" folder of this repo.
%
% Inputs are as follows:
% - X: The input data matrix. Can also be a cell array of matrices if you
%   want to compute RCA across multiple songs
% - nReg: Regularization parameter
% - nComp: How many components' worth of data to return
% - condRange: If inputting multiple conditions, which ones to run
% - subjRange: If inputting multiple subject matrices, which ones to run
% - show: Whether to plot the figure that comes with this function
% - locfile: If plotting a figure, need to specify the corresponding sensor
%   locations file
%
% Outputs:
% - dataOut:
% - W:
% - A:
% - Rxx:
% - Ryy:
%
%
% Apologies for the confusing function name re. parpool. Will be addressed
% in a future code revision!
[dataOut,W,A,Rxx,Ryy,Rxy,dGen] = rcaRun125_parpoolAlready2021(...
    X, nReg, nComp, [], [], 0, []);

%% Address singleton dimension of output data if applicable

% The size of the output data are time x component x trial, e.g.,
% dataOut      [36114 x 1 x 20] for Song 25. 
% If we compute only 1 component, there is a "singleton" dimension in the
% middle that will be annoying later on. We can get rid of it using the
% "squeeze" function.
if size(dataOut,2) == 1 
    dataOut = squeeze(dataOut); 
    disp(['Removed singleton dimension from RCA output data.'])
end

% In this case of returning only 1 component, dataOut is now a 2D matrix
% after squeezing!  
% dataOut      [36114 x 20] <-- time x trial matrix
