# Vargin-TFA-Plotter
Quick and easy time-frequency plotting function for .csv files of preprocessed  EEG wavelet data that assumes a 1-40 Hz frequency mapping.

Authors: Bradley E. Buchanan from the Department of Psychology at the University of South Florida

Description: VarginFrq is a quick function to plot APA quality Time-Frequency data in MatLab. The function asks to specify preprocessed .csv files in your current working directory to plot. It then asks for you to specify the .csv directory you wish to pull from, the .csv title, the condition, the power limits for the z scale, and to specify whether to look for outliers within the data in the final readout.

Example Input: %   VarginFrq(  "E:\LEEA-Alpha-Block\FINALMAT\FULL","ALPHA_HIGH_LOAD.csv","Stim", [-2 1.5], true);

Prerequisites: MATLAB 
