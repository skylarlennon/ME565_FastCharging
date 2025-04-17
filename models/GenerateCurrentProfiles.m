%% MECHENG 565 Project: Fast Charging Group 1
clc;clear;close all;
%% ===============Contributors===============
% Vijay Balasekaran     vbalasek@umich.edu
% Clayton Garmon        cjgarmon@umich.edu
% Skylar Lennon         skylarl@umich.edu
% Justin Ryu            jusryu@umich.edu
% Emma Tum Suden        emmadt@umich.edu

% Idea: There are 5 current profile shapes that we'd like to investigate
% using for fast charging of our electric vehicle model. CC, CC-CV, and
% P1-1, P2-1, & P2-2. The shapes of these current profiles can be found in 
% the csv/ folder. However, the magnitude and duration of the profiles must
% be adapted in order to make them comparable such that they produce the
% same change in SOC over the same period of time without exceeding the
% temperature, power, and voltage constraints of the battery. Thus, this
% program takes in these current profile shapes, and iteratively runs the
% battery simulation to determine the optimal magnitude and duration of the
% current profile. 

% decisions to make: use the OCV(z) LUT?

%% ===============Parameters===============
LoadBatteryParams;

% Constraints
% chargeTime = 10*60; %S
% maxTemp = 60; %C ???
% maxVoltage = ; % ???
% maxPower = ; % ???
% chargeTimeTolerance = 20; % s ???

profileNumber = 1;      % 1 = CC
                        % 2 = CC - CV
                        % 3 = P1-1
                        % 4 = P2-1
                        % 5 = P2-2
                        % For battery testing:
                        % 6 = Single Pulse
                        % 7 = Repeating Pulses
                        % 8 = CC - Rest

switch profileNumber
    case 1
        curProfileShapeName = "csv/CC_current_profile.csv";
    case 2
        curProfileShapeName = "csv/CC_CV_current_profile.csv";
    case 3
        curProfileShapeName = "csv/P11_current_profile.csv";
    case 4
        curProfileShapeName = "csv/P21_current_profile.csv";
    case 5
        curProfileShapeName = "csv/P22_current_profile.csv";
    case 6
        curProfileShapeName = "csv/Pulse_current_profile.csv";
    case 7
        curProfileShapeName = "csv/Pulses_current_profile.csv";
    case 8
        curProfileShapeName = "csv/CC_Rest_current_profile.csv";
    otherwise
        error("Incorrect current profile number selected.")
end


% Extract shape into timeseries object for input to battery sim
raw = readmatrix(curProfileShapeName);
time = raw(:,1);
current = raw(:,2);
total_time = time(end);

timeCurrentData = timeseries(current,time);

% Simulate once
sim("battery_pack.slx");

% while conditions aren't met
%     check which conditions aren't met
%           SOC not high enough @ end of time? increase current        
%           too hot? decrease current
%           etc. 
%     adjust them accordingly
%     run the simulation again
%     gather the results
%     adjust
%     see if conditions are met again

% Once you have a profile that's working, use that as an input the the
% SimSOH and see how much the battery degrades in N cycles. 

GatherResults;
PlotCell;
PlotPack;