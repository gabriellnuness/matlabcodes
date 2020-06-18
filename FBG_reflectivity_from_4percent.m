clc
clear all
close all


noise = ['D:\Users\Stinky\Google Drive\ITA\Data\4 - FBG written in doped fibers\2019_12_02\'...
    ,'LabVIEW Data 0 _14.lvm'];
ref = ['D:\Users\Stinky\Google Drive\ITA\Data\4 - FBG written in doped fibers\2019_12_02\'...
    ,'LabVIEW Data 0 _15.lvm'];
fbg = ['D:\Users\Stinky\Google Drive\ITA\Data\4 - FBG written in doped fibers\2019_12_02\'...
    ,'LabVIEW Data 0 _16.lvm'];

ref = importdata(ref);
fbg = importdata(fbg);
noise = importdata(noise);

ref = ref(:,(2:3)); %1 column = power in dbm; 2 column = wavelength 
fbg = fbg(:,(2:3));
noise = noise(:,(2:3));



reflect = 3.5/100 .* (10.^((fbg(:,1)-ref(:,1))/10));
plot(ref(:,2),reflect)

figure
plot(noise(:,2),noise(:,1))
figure
plot(ref(:,2),ref(:,1))
figure
plot(fbg(:,2),fbg(:,1))