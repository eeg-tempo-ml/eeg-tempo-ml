########################################################################################################################################
# This script takes the rca filtered and uniform length .mat song data files, which have to be in the path and have the format
# song21_uniform_length.mat for example, then concatenates the data from all of them into a dataframe, adds song name and target
# values, and then saves the resulting dataframe as a csv of name eeg_data_###.csv (the ### should be replaced by a descriptor 
# any changes are made to how the csv is constructed or what values are in it).
#
########################################################################################################################################
import pandas as pd
import numpy as np
from scipy.io import loadmat


def load_files():
    all_songs_df = pd.DataFrame()

    song_names = ['First  Fires', 'Oino', 'Tiptoes', 'Careless Love', 'Lebanese Blonde', 'Canopée', 'Doing Yoga', 'Until the Sun Needs to Rise', 'Silent Shout', 'The Last Thing You Should Do']
    song_bpm = [55.97, 69.44, 74.26, 82.42, 91.46, 96.15, 108.70, 120.00, 128.21, 150.00]
    beat_intervals = [(1 / (x / 60)) for x in song_bpm] # beat intervals in seconds

    for i in range(10):
        song_num = i+21
        
        # Load song files and extract data variable
        try:
            f = loadmat(f'uniform_length_song_files/song{song_num}_uniform_length.mat')
            print(f'Loaded song #{song_num}')
        except:
            print('File not found in path.')

        data = f['data'] # is a matrix of size 30000x20 columns x rows
        data = np.transpose(data) # switch rows and columns so data is a 20x30000 rows x columns matrix
        # Take the absolute value of all values (remove negative amplitudes)
        abs_data = np.abs(data)


        # Convert into a Pandas Dataframe
        column_names = range(30000)
        song_df = pd.DataFrame(abs_data, columns=column_names)
        # Insert song name, bpm, and beat interval values
        song_df.insert(loc=0, column='song_name', value=song_names[i])
        song_df.insert(loc=1, column='bpm', value=song_bpm[i])
        song_df.insert(loc=2, column='beat_interval', value=beat_intervals[i])

        # Concatenate dataframes from all songs together
        all_songs_df = pd.concat([all_songs_df, song_df], axis=0, ignore_index=True)


    # The final dataframe should be a 200x30003 matrix
    print(f'Shape of final dataframe with all songs is: {all_songs_df.shape}')
    all_songs_df.to_csv('eeg_data_absolute_values.csv', index=False)       

load_files()