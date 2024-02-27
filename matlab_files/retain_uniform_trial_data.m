% retain_uniform_trial_data.m
% ------------------------------------------------------------
% This script retains 4 minutes of data from each trial starting 15 seconds
% in and saves that data to uniform_length_song_files

% Load in the rca filtered song matrices, iterating through songs 1-10
for i = 1:10
    song_num = i + 20; 
    % Create the filename to be loaded
    fnIn = strcat('song',num2str(song_num),'_rca_filtered.mat');

    try
        load(fnIn);
    catch
        error(['Could not load file ' fnIn '. Make sure the file is in your path.']);
    end

    whos data

    % 15 seconds has 15x125 = 1875 datapoints
    fifteen_seconds_in_data = data(1876:end, :); 

    whos fifteen_seconds_in_data
    % 4 minutes has 4x60x125 = 30'000 datapoints
    four_minutes_data = fifteen_seconds_in_data(1:30000, :);

    whos four_minutes_data
    
    filename = strcat('eeg-tempo-ml/uniform_length_song_files/song', num2str(song_num), '_uniform_length.mat');
    save(filename,"four_minutes_data");
    
end



