%% MECHENG 565 Project: Fast Charging Group 1
clc;clear;close all;
%% ===============Contributors===============
% Vijay Balasekaran     vbalasek@umich.edu
% Clayton Garmon        cjgarmon@umich.edu
% Skylar Lennon         skylarl@umich.edu
% Justin Ryu            jusryu@umich.edu
% Emma Tum Suden        emmadt@umich.edu

%% ===============CC===============
Time_CC= 700; %seconds
I_CC= -600; %A 
delta_t = 1;
time_CC = 0:delta_t:Time_CC;
current_CC = I_CC* ones(size(time_CC));
data= [time_CC', current_CC'];
filename = "csv/CC_current_profile.csv";
writematrix(data,filename)

figure;
plot(time_CC,current_CC)
grid on
title("CC")

%% ===== CC-CV=====
% TODO: I think this might need to just be done using
% GenerateCurrentProfiles, bc you need to know the voltage of the battery
% to make sure it stays the same. Not sure?

Time_CCCV = 600; %seconds
I_CCCV = 600;  
TransitionTime_CCCV = 200; %arbitrary (s)
timeConstant = 250;       % Time constant for exponential current decay in CV phase (seconds)
N_CCCV = 1000;

time_CCCV = linspace(0,Time_CCCV,N_CCCV);
current_CCCV = zeros(1,length(time_CCCV));

for i = 1:N_CCCV
    if time_CCCV(i) < TransitionTime_CCCV
        current_CCCV(i) = I_CCCV;
    else
        current_CCCV(i) = max(I_CCCV * exp(-(time_CCCV(i) - TransitionTime_CCCV)/timeConstant),0.01);
    end
end

data = [time_CCCV',current_CCCV'];
filename = "csv/CCCV_current_profile.csv";
writematrix(data,filename);

figure;
plot(time_CCCV,current_CCCV)
grid on
title("CC-CV")

%% ===============Paper 1, Profile 1===============
rawPaper1Profile1 = readmatrix("csv/P1_current_profile.csv");
rawTimeP1P1 = rawPaper1Profile1(:,1);
rawCurrentP1P1 = rawPaper1Profile1(:,2);

figure;
plot(rawTimeP1P1,rawCurrentP1P1)
grid on
title("Paper 1 Profile 1")

%% ===============Paper 2, Profile 1===============
% rawPaper2Profile1 = readmatrix("csv/P2P1_current_profile.csv");
% rawTimeP2P1 = rawPaper2Profile1(:,1);
% rawCurrentP2P1 = rawPaper2Profile1(:,2);
% 
% figure;
% plot(rawTimeP2P1,rawCurrentP2P1)
% grid on
% title("Paper 2 Profile 1")
% 
% 
% 
% %% ===============Paper 2, Profile 2===============
% rawPaper2Profile2 = readmatrix("csv/P2P2_current_profile.csv");
% rawTimeP2P2 = rawPaper2Profile2(:,1);
% rawCurrentP2P2 = rawPaper2Profile2(:,2);
% 
% figure;
% plot(rawTimeP2P2,rawCurrentP2P2)
% grid on
% title("Paper 2 Profile 1")

%% ===============Pulse===============
Time_Pulse = 600; %seconds
delta_t = 1;
time_Pulse = 0:delta_t:Time_Pulse;
I_base = 0; % A
I_pulse = 4; % A
t_pulse = 5; % s
pulse_start_t = 10; %s
pulse_end = pulse_start_t + t_pulse;
current_Pulse = I_base * ones(size(time_Pulse));

for i=1:length(time_Pulse)
    t= time_Pulse(i);
    if t>= pulse_start_t && t<pulse_end
        current_Pulse(i)= I_pulse;
    else
        current_Pulse(i)= I_base;
    end
end

data = [time_Pulse', current_Pulse'];
filename = "csv/Pulse_current_profile.csv";
writematrix( data, filename )

figure;
plot(time_Pulse,current_Pulse)
grid on
title("Pulse")

%% ===============Pulses===============
Time_Pulses= 600; %seconds
delta_t= 1;
time_Pulses= 0:delta_t:Time_Pulses;
I_base= 0; % A
I_pulse= 4; % A
t_pulse= 5; %s
t_break= 10; %s
current_Pulses = zeros(size(time_Pulses));
pulse_time = t_pulse + t_break;

for i = 1:length(time_Pulses)
    t = time_Pulses(i);
    % Determine if we're in the ON or OFF part of the pulse cycle
    remainder = mod(t, pulse_time);
    
    if remainder < t_pulse
        current_Pulses(i) = I_pulse;  % ON phase
    else
        current_Pulses(i) = I_base;   % OFF phase
    end
end
data= [time_Pulses', current_Pulses'];
filename = "csv/Pulses_current_profile.csv";
writematrix( data, filename )

figure;
plot(time_Pulses,current_Pulses)
grid on
title("Pulses")

%% ===============CC-Rest===============
I_CC_Rest = 300; % [A]
Time_CC_Rest = 60*60; % [s]
N_CC_Rest = 1000;

% Create a current vector: first half = currentVal, second half = 0
current_CC_Rest = [ones(N_CC_Rest/2,1) * I_CC_Rest; zeros(N_CC_Rest/2,1)];

% Generate corresponding time vector
time_CC_Rest = linspace(0, Time_CC_Rest, N_CC_Rest)';

data = [time_CC_Rest',current_CC_Rest'];
filename = "csv/CC_Rest_current_profile";
writematrix(data,filename);

figure;
plot(time_CC_Rest,current_CC_Rest);
grid on
title("CC Rest")


%% PLOT ALL OF THE CURRENT PROFILE SHAPES OVER ONE ANOTHER
% figure
% sgtitle("All Current Profile Shapes (unrefined)")
% 
% hold on
