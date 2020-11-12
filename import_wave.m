% This script is used to import waveform data captured with 
% LabVIEW and the block save waveform to spreadsheet
% the first column is a datetime string and the second is 
% the amplitude in mV in double format

function wave = import_wave(path ,filename)
%% Setup the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 2);

% Specify range and delimiter
opts.DataLines = [5, Inf];
opts.Delimiter = "\t";

% Specify column names and types
opts.VariableNames = ["t0", "VarName2"];
opts.VariableTypes = ["string", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "t0", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "t0", "EmptyFieldRule", "auto");
%%

% Import the data
% filename = '20Hz.csv';
% path = "D:\Users\Stinky\Google Drive\ITA\Data\0 - Fiber Michelson Data\FOM MC\11.11.2020-20-200_data1\data1\";
file = [path, filename];
wave = readtable(file, opts);


%% Clear temporary variables
clear opts

end