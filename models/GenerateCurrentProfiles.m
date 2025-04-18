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

profileNumber = 2;      % 1 = CC
                        % 2 = CC - CV
                        % 3 = P1-1
                        % 4 = P2-1
                        % 5 = P2-2
                        % For battery testing:
                        % 6 = Single Pulse
                        % 7 = Repeating Pulses
                        % 8 = CC - Rest

delta_t = 1;
time = [];
current = [];
chareTimeGoal = 25*60; %seconds (typical fast charging speed)
total_time = 60*60; % greater to ensure sim finishes.

% Initial values
I_CC = -500;             % starting CC current (A)
I_CCCV_Init = -600;      % starting CC portion of CCCV (A)
V_des = 321.129671339922;            % initial CV target voltage (V)
SOC_target = 0.8;
tolerance = 5;           % seconds

max_iter = 30;
iter = 0;
done = false;


%% ==================== Optimization Loop ====================

while ~done && iter < max_iter
    iter = iter + 1;
    fprintf("\n--- Iteration %d ---\n", iter);

    % Regenerate current profile
    switch profileNumber
        case 1  % Constant Current
            time = [0:delta_t:total_time]';
            current = I_CC * ones(length(time),1);
            timeCurrentData = timeseries(current, time);
            sim("battery_pack.slx");

        case 2  % CC-CV
            assignin('base', 'I_CCCV_Init', I_CCCV_Init);
            assignin('base', 'V_des', V_des);  % CV voltage target
            sim("battery_pack_CCCV.slx");

        otherwise
            error("Unsupported profileNumber for optimization")
    end

    % Post-simulation processing
    GatherResults;
    SimThermal;

    % Metrics
    final_SOC = SOCOut(end);
    charge_time = simTime(end);
    max_temp = max(Tc(:));

    fprintf("SOC = %.3f | Time = %.1f s | Max T = %.2f °C\n", final_SOC, charge_time, max_temp);

    % Check all conditions
    soc_met = final_SOC >= SOC_target;
    time_met = charge_time <= chareTimeGoal + tolerance;
    temp_met = max_temp < TcMax;

    if soc_met && time_met && temp_met
        fprintf("✅ All charging constraints met.\n");
        done = true;
        break;
    end

    % Adjust inputs based on which constraints failed
    switch profileNumber
        case 1  % CC adjustment
            if ~soc_met || ~time_met
                I_CC = I_CC - 25; % increase charging rate
            end
            if ~temp_met
                I_CC = I_CC + 10; % back off if too hot
            end

        case 2  % CCCV adjustment
            if ~soc_met || ~time_met
                I_CCCV_Init = I_CCCV_Init - 25;
                V_des = V_des + 0.01; % try to end at a slightly higher voltage
            end
            if ~temp_met
                I_CCCV_Init = I_CCCV_Init + 10;
            end
    end
end

if ~done
    fprintf("⚠️ Constraints not met after %d iterations.\n", max_iter);
end




% conditions:
% FOR CONSTANT CURRENT CHARGING:
% - SOC didn't get to 80% before the over voltage protection tripped.
% (check SOCOut(end) that it's 0.8 or slightly greater 
% - Didn't get too hot during the cycle (check that max(Tc) < TcMax
% - Took too long to get to 80% SOC (check simTime(end), if it's greater
% than chareTimeGoal, then increase I_CC

% FOR CC-CV CHARGING:
% - SOC didn't get to 80% before the over voltage protection tripped.
% (check SOCOut(end) that it's 0.8 or slightly greater 
% - Didn't get too hot during the cycle (check that max(Tc) < TcMax
% - Took too long to get to 80% SOC (check simTime(end), if it's greater
% than chareTimeGoal, then increase I_CCCV_Init, OR perhaps increase V_des
% such that battery is shooting for higher SS terminal voltage



% while conditions aren't met
%     check which conditions aren't met
%     adjust them accordingly
%     run the simulation again
%     gather the results
%     adjust
%     see if conditions are met again
