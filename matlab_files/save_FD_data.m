%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% save_FD_data.m
% This script transforms the EEG data into the frequency domain and saves it to local files.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% For each song, load in the data, convert it to frequency domain, and save
% to .mat file
for i = 1:10
    song_num = i + 20;
    % We are using the rca filtered and uniform length song matrix data
    fnIn = strcat('song', num2str(song_num), '_uniform_length.mat');
    % Will load in a time x trial matrix 
    % No more electrode (3rd) dimension, since electrodes were "averaged"
    load(fnIn, 'data'); % implicitly, the data variable contains the matrix

    % Initialize matrix 
    song_data = zeros(2881,20);

    % For each trial, perform the conversion to frequency domain
    for j = 1:20
        trial_data = data(:,j);
        % Hard coding the sampling rate to 125 Hz
        sampling_rate = 125;
    
        %% Transforming Data into Frequency Domain
        % Compute the frequency axis
        frequency_axis = computeFFTFrequencyAxis(size(trial_data,1), sampling_rate);
    
        % Compute the magnitude spectrum of the data. 
        trial_data_frequency = abs(fft(trial_data));

        %% Keep only the low-frequency data (below 12Hz)
        maxHz = 12;
        % Get indices in the frequency range we want
        frequency_maxHz_indices = find(frequency_axis <= maxHz); % with this maxHz, fIdx is a 1x2881 matrix regardless of song or trial
        % Filter down the data based on maxHz
        trial_data_maxHz = trial_data_frequency(frequency_maxHz_indices,:);
        frequency_axis_maxHz = frequency_axis(frequency_maxHz_indices);
        
        % Add ith trial to final song_data matrix
        song_data(:,j) = trial_data_maxHz;
    
    end 
    data = song_data';
    filename = strcat('eeg-tempo-ml/FD_song_files/song', num2str(song_num), '_FD_data.mat');
    save(filename,"data");
end

