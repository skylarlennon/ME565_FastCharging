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
% Select Current Profile To Simulate
curProfile = 6;     % 1 = CC
                    % 2 = CC-CV
                    % 3 = Profile from paper #1
                    % 4 = Profile from paper #2
                    % 5 = Pulse
                    % 6 = Pulses
currentFileName = "";
switch curProfile
    case 1
        currentFileName = "csv/CC_current_profile.csv";
    case 2
        currentFileName = "csv/CCCV_current_profile.csv";
    case 3
        currentFileName = "csv/P1_current_profile.csv";
    case 4
        currentFileName = "csv/P2_current_profile.csv";
    case 5
        currentFileName = "csv/Pulse_current_profile.csv";
    case 6
        currentFileName = "csv/Pulses_current_profile.csv";
end

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





