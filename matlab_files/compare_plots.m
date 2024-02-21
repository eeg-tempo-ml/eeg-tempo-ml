%%%%%%%%%%%%%%%%%%%%%
% This script loads in one song's EEG data and one song's .wav data.
% It then displays one trial's data in the time and frequency domains 
% opposite to the song's soundwaves in the time and frequency domains.
%
%%%%%%%%%%%%%%%%%%%%%
%% Pick a song (1-10) and a trial (1-20).
song = 5;  % song 25, tempo in the middle of the range, very recognizable beat
trial = 4; 

%% Set fixed beat interval and audio file names
% 1 / Beats per second (song tempo) = interval of the beats
song_tempos_Hz = [1/0.9328, 1/1.1574, 1/1.2376, 1/1.3736, 1/1.5244, 1/1.6026, 1/1.8116, 1/2.0000, 1/2.1368, 1/2.5000];
audio_file_names = ['21_FirstFiresMono.wav', '22_OinoMono.wav', '23_TiptoesMono.wav', '24_CarelessLoveMono.wav', '25_LebaneseBlondeMono.wav', '26_CanopeeMono.wav', '27_DoingYogaMono.wav', '28_UntilTheSunNeedsToRiseMono.wav', '29_SilentShoutMono.wav', '30_TheLastThingYouShouldDoMono.wav'];
% Delay of song start - beat start
song_tempo_delays = [];

%% Load EEG Data and Audio Data
% TIP: use semicolons to hide the output of a function or calculation
disp(['Loading data from song ' num2str(song)]);
song_data = loadOneFile(song+20); % Returns time x space x trial matrix

% TIP: full or relative path is not necessary if files are in path
% Loads audio data, returns y: time x 1 matrix of type double and Fs: sample rate x 1 matrix of type double
disp(['Loading song data from song ' num2str(song)]);
[y, Fs] = audioread('25_LebaneseBlondeMono.wav'); % add argument 'native' to get the non-normalized amplitude

% Length of the song
t = (0:length(y)-1)/Fs; 

% Prepare audio data.
y = y - mean(y); % Remove DC offset, helps center the signal around 0
Y = fft(y); % Computes the Discrete Fourier Transform (DFT) of the audio signal y using the Fast Fourier Transform (FFT) algorithm. Transform into frequency domain.
Y_half = Y(1:floor(length(Y)/2)); % Take the first half of the FFT result did this because it gets mirrored, so we eliminate redundant information.
f = (0:length(Y_half)-1)*Fs/length(Y); % Frequency vector for the first half

%% Vertical Beat Lines
time_interval = song_tempos_Hz(1, song);
% Define the x-axis range
x_min = 0;  % Minimum value of x-axis
x_max = max(t); % Maximum value of x-axis
% Calculate the number of intervals based on the time interval
num_intervals = floor((x_max - x_min) / time_interval);
% Generate the x-coordinates for the lines
x_lines = x_min + (0:num_intervals) * time_interval;

%% Plot Time Domain Graphs
figure();

% EEG Data
subplot(2, 1, 1); 
plot1 = plot_trial_TD(song_data(:,:,trial));
title('Time Domain - EEG Data');

% Draw lines at the specified intervals
for i = 1:length(x_lines)
    x_line = [x_lines(i), x_lines(i)]; % X coordinates of the line
    y_line = ylim; % Y coordinates of the line will be ylim from plot1
    line(x_line, y_line, 'Color', 'r', 'LineStyle', '-'); % Draw the line
end


% Audio Data
subplot(2, 1, 2);
plot2 = plot(t, y);
xlabel('Time (seconds)');
ylabel('Normalized Amplitude');
title('Time Domain - Audio Data');
ylim([min(y), max(y)]); % Set y-axis limits to match the range of the signal
xlim([min(t), max(t)])

% Draw lines at the specified intervals
for i = 1:length(x_lines)
    x_line = [x_lines(i), x_lines(i)]; % X coordinates of the line
    y_line = ylim; % Y coordinates of the line
    line(x_line, y_line, 'Color', 'r', 'LineStyle', '-'); % Draw the line
end

linkaxes([subplot(2,1,1), subplot(2,1,2)], 'x') 

%% Plot Frequency Domain Graphs
% Plot frequency domain of the EEG data and the audio data soundwaves
figure();

subplot(2, 1, 1);  % Create subplot for EEG frequency domain
plotTrial_FD(song_data(:,:,trial));
title('Frequency Domain - EEG Data');

% Plot the magnitude spectrum of the first half
subplot(2, 1, 2);
plot(f, abs(Y_half));
xlabel('Frequency (Hz)');
ylabel('|Amplitude|');
title('Frequency Domain - Audio Data');

%% Plot RCA results
% Apply the RCA filter to all trials of one song
% Takes a few minutes to run
dataOut = run_and_plot_RCA(song);

% We could average the data across trials and plot the average
% The "2" here indicates that we want to average across the 2nd (trial)
% dimension.
dataOut_trialAverage = mean(dataOut, 2);

%%% We could plot the data in a few different ways
figure();

% Trial-averaged RC1 data: Time domain
subplot(3, 1, 1)
plot_trial_TD(dataOut_trialAverage)

% Draw lines at the specified intervals
for i = 1:length(x_lines)
    x_line = [x_lines(i), x_lines(i)]; % X coordinates of the line
    y_line = ylim; % Y coordinates of the line will be ylim from subplot
    line(x_line, y_line, 'Color', 'r', 'LineStyle', '-'); % Draw the line
end

% Trial-averaged RC1 data: Frequency domain
subplot(3, 1, 2)
plot_trial_FD(dataOut_trialAverage)

% Overlay single-trial RC1 data: Frequency domain
% In this case we're appropriating the plotTrial_FD function, but now the
% matrix columns are trials rather than electrodes. 
subplot(3, 1, 3)
plot_trial_FD(dataOut)

% Access subplot 1 of the figure
subplot(3, 1, 1);

% -----------------------------------------------------------------------
% Exercise for the user: Compare the 2nd and 3rd subplots. 
% - The 2nd subplot is both spatially filtered and trial averaged. Do you 
%   see any clear spectral peaks at a multliple or divisor of 2x related 
%   to your song's tempo? 
% - Given what you see in the 2nd plot, do you see any evidence of the same
%   peak frequency/frequencies in the single-trial data? 
% - How does the noise floor of the 2nd plot compare to the noise floor of
%   the 3rd plot?
