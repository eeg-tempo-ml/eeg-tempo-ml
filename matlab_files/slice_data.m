% This script does 3 things:
% (1) Loads a single song's data and picks out the given trial.
% (2) Reduces the amount of datapoints by 125 (into 1 second windows). It does
% this by slicing the matrix into 1 second windows and calculating the average
% tempo of the datapoints in the window as well as the tempo bin the
% datapoints in the window fall into. 
% (3) Saves the sliced matrices and a .txt file containing the average
% tempo of the window on the first line and the tempo bin on the second
% line into a folder.


