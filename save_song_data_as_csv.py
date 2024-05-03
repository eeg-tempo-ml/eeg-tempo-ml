########################################################################################################################################
# 
# These scripts takes the rca filtered and uniform length .mat song data files OR frequency domain data files, which have to be in the path and have the format
# song21_uniform_length.mat for example, then concatenates the data from all of them into a dataframe, adds song name and target
# values, and then saves the resulting dataframe as a csv of name eeg_data_###.csv (the ### should be replaced by a descriptor 
# any changes are made to how the csv is constructed or what values are in it).
#
########################################################################################################################################
import pandas as pd
import numpy as np
from scipy.io import loadmat
from IPython.display import display
import matplotlib.pyplot as plt


def uniform_length_song_files_to_csv():
    all_songs_df = pd.DataFrame()
    num_songs = 10
    song_names = ['First  Fires', 'Oino', 'Tiptoes', 'Careless Love', 'Lebanese Blonde', 'Canopée', 'Doing Yoga', 'Until the Sun Needs to Rise', 'Silent Shout', 'The Last Thing You Should Do']
    song_bpm = [55.97, 69.44, 74.26, 82.42, 91.46, 96.15, 108.70, 120.00, 128.21, 150.00]
    beat_intervals = [(1 / (x / 60)) for x in song_bpm] # beat intervals in seconds

    for i in range(num_songs):
        song_num = i+21
        
        # Load song files and extract data variable
        try:
            f = loadmat(f'uniform_length_song_files/song{song_num}_uniform_length.mat')
            print(f'Loaded song #{song_num}')
        except:
            print('File not found in path.')

        data = f['data'] # is a matrix of size 30000x20 columns x rows
        print(data.shape)
        data = np.transpose(data) # switch rows and columns so data is a 20x30000 rows x columns matrix
        print(data.shape)


        num_datapoints = 30000
        # Convert into a Pandas Dataframe
        column_names = range(num_datapoints)
        song_df = pd.DataFrame(data, columns=column_names)
        # Insert song name, bpm, and beat interval values
        song_df.insert(loc=0, column='song_name', value=song_names[i])
        song_df.insert(loc=1, column='bpm', value=song_bpm[i])
        song_df.insert(loc=2, column='beat_interval', value=beat_intervals[i])

        # Concatenate dataframes from all songs together
        all_songs_df = pd.concat([all_songs_df, song_df], axis=0, ignore_index=True)


    # The final dataframe should be a 200x30003 matrix
    print(f'Shape of final dataframe with all songs is: {all_songs_df.shape}')
    all_songs_df.to_csv('eeg_data_beat_intervals.csv', index=False)       


def FD_song_files_to_csv():
    all_songs_df = pd.DataFrame()
    num_songs = 10
    song_names = ['First  Fires', 'Oino', 'Tiptoes', 'Careless Love', 'Lebanese Blonde', 'Canopée', 'Doing Yoga', 'Until the Sun Needs to Rise', 'Silent Shout', 'The Last Thing You Should Do']
    song_bpm = [55.97, 69.44, 74.26, 82.42, 91.46, 96.15, 108.70, 120.00, 128.21, 150.00]
    song_label = [0, 0, 1, 1, 2, 2, 2, 3, 3, 4]

    for i in range(num_songs):
        song_num = i+21

        try:
            f = loadmat(f'FD_song_files/song{song_num}_FD_data.mat')
            print(f'Loaded song #{song_num}')
            data = f['data'] # data is a matrix of size 20x2881 rows x columns
        except:
            print('File not found in path.')

        num_datapoints = 2881
        # Convert into a Pandas Dataframe
        column_names = range(num_datapoints)
        song_df = pd.DataFrame(data, columns=column_names)
        # Insert song name, bpm, and beat interval values
        song_df.insert(loc=0, column='song_name', value=song_names[i])
        song_df.insert(loc=0, column='label', value=song_label[i])
        song_df.insert(loc=2, column='bpm', value=song_bpm[i])

        # Concatenate dataframes from all songs together
        all_songs_df = pd.concat([all_songs_df, song_df], axis=0, ignore_index=True)

    # The final dataframe should be a 200x2884 matrix
    print(f'Shape of final dataframe with all songs is: {all_songs_df.shape}')
    all_songs_df.to_csv('FD_data_5_labels.csv', index=False)       



def add_3_labels_classification():
    try:
        df = pd.read_csv('model_ready_data/eeg_data_beat_intervals.csv')
        display(df)

        df.insert(1, 'label', '')

        # Function to categorize bpm values
        def categorize_bpm(bpm):
            # less than 1 Hz - 1.5 Hz
            if bpm <= 90:
                return 0
            # 1.5 Hz - 2 Hz
            elif 90 < bpm <= 120:
                return 1
            # 2 Hz - 2.5 Hz
            elif 120 < bpm <= 150:
                return 2

        # Apply the function to each value in the 'bpm' column
        df['label'] = df['bpm'].apply(categorize_bpm)

        display(df)

        df.to_csv('eeg_data_classification.csv', index=False)   

    except:
        print("File could not be found.")

    
def add_5_labels_classification():
    try:
        df = pd.read_csv('model_ready_data/eeg_data_beat_intervals.csv')
        display(df)

        df.insert(1, 'label', '')

        # Function to categorize bpm values
        def categorize_bpm(bpm):
            # less than 1 Hz - 1.5 Hz
            if 50 < bpm <= 70:
                return 0
            # 1.5 Hz - 2 Hz
            elif  70 < bpm <= 90:
                return 1
            # 2 Hz - 2.5 Hz
            elif 90 < bpm <= 110:
                return 2
            
            elif 110 < bpm <= 130:
                return 3
            
            elif 130 < bpm <= 150:
                return 4

        # Apply the function to each value in the 'bpm' column
        df['label'] = df['bpm'].apply(categorize_bpm)

        display(df)

        df.to_csv('eeg_data_classification_5labels.csv', index=False)   

    except:
        print("File could not be found.")
    
    
# Main function
if __name__=="__main__":
    add_5_labels_classification()








