%% MECHENG 565 Project: Fast Charging Group 1
clc;clear;close all;
%% ===============Contributors===============
% Vijay Balasekaran     vbalasek@umich.edu
% Clayton Garmon        cjgarmon@umich.edu
% Skylar Lennon         skylarl@umich.edu
% Justin Ryu            jusryu@umich.edu
% Emma Tum Suden        emmadt@umich.edu

%% =============Battery Parameters=============
% Note: Discharge is positive current
series = 96;
parallel = 74;

SOC_i = 0.99;
SOC_f = 0.2;

Qcell = 2.25; % [Ah]
Qpack = Qcell*parallel;
Rs_pack = 0.013*(series/parallel);
R1_pack = 0.026*(series/parallel);
R2_pack = 0.026*(series/parallel);
% C1 = 1541;
C1_pack = 53958*(parallel/series);
C2_pack = 53958*(parallel/series);

OCVData = readmatrix("csv/OCV.csv");
SOC = OCVData(:,1);
Vocv = OCVData(:,2);

% TODO: 
% - Make it so that it's actually like a battery pack
% - Generate some test current profiles
% - Emergency stop stuff for Vt being too low. 

%% =============Load Current Profiles=============
cc = Qpack; % [A]
total_time = 60*60; % [s]
sz = 1000;
current = ones(sz,1) .* cc;
time = linspace(0,total_time,sz);

timeCurrentData = timeseries(current,time);

%% =============Simulate=============
% - Run the simulation here N = 1000 times
sim("battery_pack.slx")

%% =============Plot Results=============
% - Parse the results and plot here

figure;
sgtitle("166.5 Ah Battery at 1C Discharge for 1 Hr")

subplot(1,3,1)
plot(ans.simTime, ans.SOCOut,'LineWidth',2)
xlabel('Time (s)')
ylabel('SOC')
grid on

subplot(1,3,2)
plot(ans.simTime,ans.OCVOut,"LineWidth",2)
xlabel('Time (s)')
ylabel('OCV(t)')
grid on

subplot(1,3,3)
plot(ans.simTime,ans.VtOut,"LineWidth",2)
xlabel('Time (s)')
ylabel('V_T(t)')
grid on

