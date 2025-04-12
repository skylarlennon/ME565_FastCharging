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
rawFromPaper = readmatrix("csv/P1_current_profile.csv");
rawTime = rawFromPaper(:,1);
rawCurrent = rawFromPaper(:,2);

figure
plot(rawTime,rawCurrent)
xlabel("Time (s)")
ylabel("Current (A)")
title("Charge Current Profile from Paper __?__")
grid on

%% ===============CC===============
run_time= 600; %seconds
I_CC= 3; 
delta_t= 1;
time= 0:delta_t:run_time;
current = I_CC* ones(size(time));
data= [time', current'];
filename = "csv/CC_current_profile.csv";
writematrix(data,filename)
%% ===============CC-Rest===============
currentVal = 300; % [A]
run_time = 60*60; % [s]
sz = 1000;

% Create a current vector: first half = currentVal, second half = 0
current = [ones(sz/2,1) * currentVal; zeros(sz/2,1)];

% Generate corresponding time vector
time = linspace(0, run_time, sz)';

% Create timeseries object
timeCurrentData = timeseries(current, time);
%% ===============CC-CV===============
% [TODO]

%% ===============Pulse===============
run_time= 600; %seconds
delta_t= 1;
time= 0:delta_t:run_time;
I_base= 0; % A
I_pulse= 4; % A
t_pulse= 5; % s
pulse_start_t= 10; %s
pulse_end= pulse_start_t + t_pulse;
current= I_base* ones(size(time));
for i=1:length(time)
    t= time(i);
    if t>= pulse_start_t && t<pulse_end
        current(i)= I_pulse;
    else
        current(i)= I_base;
    end
end
data= [time', current'];
filename = "csv/Pulse_current_profile.csv";
writematrix( data, filename )

%% ===============Pulses===============
run_time= 600; %seconds
delta_t= 1;
time= 0:delta_t:run_time;
I_base= 0; % A
I_pulse= 4; % A
t_pulse= 5; %s
t_break= 10; %s
current = zeros(size(time));
pulse_time= t_pulse + t_break;
for i = 1:length(time)
    t = time(i);
    % Determine if we're in the ON or OFF part of the pulse cycle
    remainder = mod(t, pulse_time);
    
    if remainder < t_pulse
        current(i) = I_pulse;  % ON phase
    else
        current(i) = I_base;   % OFF phase
    end
end
data= [time', current'];
filename = "csv/Pulses_current_profile.csv";
writematrix( data, filename )





% - Run the simulation and the optimizer to generate the charging profile

% - Save the charging profile(s) to be used in the battery degredation
% simulations


% Notes:
% - Perhaps to simplify, we only include effects of charging and not
% discharging, don't really know how to estimate the expected discharge
% profiles of an EV unless we wanted to run like a EPA drive cycle and
% simple road load model