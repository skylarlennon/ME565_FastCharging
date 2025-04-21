%% MECHENG 565 Project: Fast Charging Group 1
clc;clear;close all;
%% ===============Contributors===============
% Vijay Balasekaran     vbalasek@umich.edu
% Clayton Garmon        cjgarmon@umich.edu
% Skylar Lennon         skylarl@umich.edu
% Justin Ryu            jusryu@umich.edu
% Emma Tum Suden        emmadt@umich.edu

%% =============Load Current Profiles=============
% determine number of cycles 'numCycles'
numCycles=1000;
cycleVec = [1:1:numCycles];

% load profile 1 from csv_final
raw= readmatrix('csv_final/CC_final.csv');
current=raw(:,2);
SimSOH;
SOH_CC= SOHVec;

%load profile 2
raw= readmatrix('csv_final/CCCV_final.csv');
current=raw(:,2);
SimSOH;
SOH_CCCV= SOHVec;

% load profile 3 from csv_final
raw= readmatrix('csv_final/P1_final.csv');
current=raw(:,2);
SimSOH;
SOH_P1_final= SOHVec;

% plot all 3 over one another
figure;
hold on
plot(cycleVec,SOH_CC, LineWidth=2);
plot(cycleVec, SOH_CCCV, LineWidth=2);
plot(cycleVec, SOH_P1_final, LineWidth=2);
title('SOH for Varying Profiles');
xlabel('Number of Cycles');
ylabel('SOH');
legend('CC','CCCV','P1');
hold off
grid on





