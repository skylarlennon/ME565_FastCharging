%% MECHENG 565 Project: Fast Charging Group 1
clc;clear;close all;
%% ===============Contributors===============
% Vijay Balasekaran     vbalasek@umich.edu
% Clayton Garmon        cjgarmon@umich.edu
% Skylar Lennon         skylarl@umich.edu
% Justin Ryu            jusryu@umich.edu
% Emma Tum Suden        emmadt@umich.edu

%% ===============Parameters===============
% - Add constants here
% - Include constraints
%   - Max battery charging/discharging power
%   - Max temperature (would need to integrate with the battery SOH_&_Temp
%   model?
% - Perhaps need to load battery parameters, or run the battery simulation
% - Include things like delta SOC & goal charging time, tolerances, etc. 


%% ===============From Paper===============
rawFromPaper = readmatrix("csv/Current_Profile.csv");
rawTime = rawFromPaper(:,1);
rawCurrent = rawFromPaper(:,2);

figure
plot(rawTime,rawCurrent)
xlabel("Time (s)")
ylabel("Current (A)")
title("Charge Current Profile from Paper __?__")
grid on

%% ===============CC===============

%% ===============CC-CV===============

%% ===============Pulse===============







% - Run the simulation and the optimizer to generate the charging profile

% - Save the charging profile(s) to be used in the battery degredation
% simulations


% Notes:
% - Perhaps to simplify, we only include effects of charging and not
% discharging, don't really know how to estimate the expected discharge
% profiles of an EV unless we wanted to run like a EPA drive cycle and
% simple road load model