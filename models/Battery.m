%% MECHENG 565 Project: Fast Charging Group 1
clc;clear;close all;
%% ===============Contributors===============
% Vijay Balasekaran     vbalasek@umich.edu
% Clayton Garmon        cjgarmon@umich.edu
% Skylar Lennon         skylarl@umich.edu
% Justin Ryu            jusryu@umich.edu
% Emma Tum Suden        emmadt@umich.edu

%% =============Load Battery Parameters=============
LoadBatteryParams;

%% =============Load Current Profiles=============
currentFileName = "Active_Current_Profile.csv";
rawData = readmatrix(currentFileName);
time = rawData(:,1);
total_time = time(end);
current = rawData(:,2);

% Create timeseries object
timeCurrentData = timeseries(current, time);

%% =============Simulate=============
sim("battery_pack.slx")
GatherResults;
SimThermal;
SimSOH;

%% =============Plot Results=============
PlotPack;
PlotCell;
PlotThermal;
PlotSOH;





