clear all
close all
clc

funcGen = visa('keysight','GPIB0::1::INSTR');
fopen(funcGen)
%% % write command and read

% fprintf(funcGen, '*IDN?');
% idn = fscanf(funcGen)

idn = query(funcGen,'*IDN?')

%%
fclose(funcGen)
delete(funcGen)