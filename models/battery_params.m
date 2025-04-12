%% MECHENG 565 Project: Fast Charging Group 1
clc;clear;close all;
%% ===============Contributors===============
% Vijay Balasekaran     vbalasek@umich.edu
% Clayton Garmon        cjgarmon@umich.edu
% Skylar Lennon         skylarl@umich.edu
% Justin Ryu            jusryu@umich.edu
% Emma Tum Suden        emmadt@umich.edu

%% =============Battery Parameters=============
% Battery Environment Params
Tambient = 298; % [K] (typically function of time, going to be constant for the sake of this project)

% Series and parallel
series = 96;
parallel = 74;

% Cell params
OCVData = readmatrix("csv/OCV.csv"); % from [@vijay: insert link]
% what's the datasheet for the cell again? (need max and min terminal
% voltage
SOC = OCVData(:,1);
Vocv = OCVData(:,2);
SOC_i = 0.99;
SOC_f = 0.2;

Vtmax = 345;
Vtmin = 192;
Vtmax_cell = Vtmax/series; % double check
Vtmin_cell = Vtmin/series; % double check

Qcell = 2.25; % [Ah]
TcInit = Tambient;
TsInit = Tambient;

Rs = 0.013;
R1 = 0.026;
R2 = 0.026;
C1 = 53958;
C2 = 53958;

% C1 = 1541;
% C2 = 1541;

Rc = 1.94;
Cc = 62.7;
Ru = 3.19;
Cs = 4.5;
Rm = 0.15;

% Pack Params
Qpack = Qcell*parallel;
Rs_pack = 0.013 * (series/parallel);
R1_pack = 0.026 * (series/parallel);
R2_pack = 0.026 * (series/parallel);
C1_pack = 53958 * (parallel/series);
C2_pack = 53958 * (parallel/series);

% Note: Discharge is positive current

% TODO: 
% - Generate some test current profiles
% - Emergency stop stuff for Vt being too low. 

%% =============Load Current Profiles=============
currentVal = Qpack; % [A]
total_time = 60*60; % [s]
sz = 1000;

% Create a current vector: first half = currentVal, second half = 0
current = [ones(sz/2,1) * currentVal; zeros(sz/2,1)];

% Generate corresponding time vector
time = linspace(0, total_time, sz)';

% Create timeseries object
timeCurrentData = timeseries(current, time);

%% =============Simulate=============
% - Run the simulation here N = 1000 times
sim("battery_pack.slx")

%% =============Plot Results=============
% - Parse the results and plot here

figure;
sgtitle("166.5 Ah Battery at 1C Discharge for 1 Hr")

subplot(2,3,1)
plot(ans.simTime, ans.SOCOut,'LineWidth',2)
xlabel('Time (s)')
ylabel('SOC')
grid on

subplot(2,3,2)
plot(ans.simTime,ans.OCVOut.*ones(1,length(ans.simTime)),"LineWidth",2)
xlabel('Time (s)')
ylabel('OCV(t)')
grid on

subplot(2,3,3)
plot(ans.simTime,ans.VtOut,"LineWidth",2)
xlabel('Time (s)')
ylabel('V_T(t)')
grid on

subplot(2,3,4)
plot(time,current)
xlabel('Time (s)')
ylabel('Current (A)')
grid on

% Ts_C = (ans.TsOut-273.15)./series;
% Tc_C = (ans.TcOut-273.15)./series;

Ts_C = (ans.TsOut-273.15);
Tc_C = (ans.TcOut-273.15);


figure
hold on
plot(ans.simTime,Ts_C,'LineWidth',2)
plot(ans.simTime,Tc_C,'LineWidth',2)
hold off
xlabel('Time (s)')
ylabel("Temp (C)")
title("Surface and Core Temperature")
legend('Surface Temp','Core Temp')
grid on


simulate_thermal_postprocess(ans.simTime,ans.currentOutCell,ans.VtOutCell,ans.OCVOutCell.*ones(1,length(ans.simTime)))

K = 1000;
KVec = (linspace(0,K,K));
SOHVec = zeros(1,K);
Ah_20pct = Qpack*0.80;
for i = 1:K
    SOH = compute_soh(ans.simTime, ans.currentOut, Qpack,Qpack*0.8);  % Assume Ah_20pct = 600 Ah
    SOHVec(i) = SOH(end);
    Qpack = Qpack*SOH(end);
end


figure;
plot(KVec, SOHVec, 'LineWidth', 2);
xlabel('Cycles');
ylabel('SOH');
title('State of Health Over 1000 Cycles');
grid on;

%% Functions

function simulate_thermal_postprocess(time,current,Vt,OCV)
    % Load your simulation data from Simulink

    % Parameters
    N = 96;                     % Number of cells in series
    R_c = 1.94;                  % [K/W] conduction resistance (core <-> surface)
    R_u = 3.19;                  % [K/W] convection resistance (surface <-> air)
    R_m = 0.15;                  % [K/W] mutual thermal resistance (cell <-> neighbor)
    C_c = 62.7;                  % [J/K] core thermal capacitance
    C_s = 4.5;                  % [J/K] surface thermal capacitance
    Tf = 298;                   % Ambient temperature [K]

    % Time setup
    tspan = time;              % Use same time vector as simulation
    Ts0 = Tf * ones(N, 1);     % Initial surface temps
    Tc0 = Tf * ones(N, 1);     % Initial core temps
    y0 = [Tc0; Ts0];           % Full state vector

    % Solve the ODE
    [~, y] = ode45(@(t, y) thermal_ode(t, y, tspan, current, Vt, OCV, ...
                                       R_c, R_u, R_m, C_c, C_s, Tf, N), tspan, y0);

    % Extract results
    Tc = y(:, 1:N);              % Core temps [time x cell]
    Ts = y(:, N+1:end);          % Surface temps [time x cell]

    % Plot
    figure;
    subplot(2,1,1);
    plot(tspan, Tc);
    title('Core Temperatures');
    xlabel('Time [s]'); ylabel('Temp [K]');

    subplot(2,1,2);
    plot(tspan, Ts);
    title('Surface Temperatures');
    xlabel('Time [s]'); ylabel('Temp [K]');
end

function dydt = thermal_ode(t, y, tspan, I_vec, Vt_vec, OCV, ...
                            Rc, Ru, Rm, Cc, Cs, Tf, N)

    % Interpolate input data
    I_val = interp1(tspan, I_vec, t);
    Vt_val = interp1(tspan, Vt_vec, t);
    OCV_val = interp1(tspan, OCV, t);


    % Extract state
    Tc = y(1:N);
    Ts = y(N+1:end);

    % Heat generation
    q_gen = repmat(I_val * (OCV_val - Vt_val), N, 1);  % Same heat for all cells

    % Core temperature dynamics
    dTc = (Ts - Tc) / (Rc * Cc) + q_gen / Cc;

    % Surface temperature dynamics
    Tsp1 = [Ts(2:end); Ts(end)];    % T_{k+1}
    Tsm1 = [Ts(1); Ts(1:end-1)];    % T_{k-1}

    dTs = (Tf - Ts) / (Ru * Cs) ...
        - (Ts - Tc) / (Rc * Cs) ...
        + (Tsp1 - Ts) / (Rm * Cs) ...
        + (Tsm1 - Ts) / (Rm * Cs);

    % Combine into dydt
    dydt = [dTc; dTs];
end

function SOH = compute_soh(time, current, C_b, Ah_20pct)
    % time:       [s] time vector from simulation
    % current:    [A] current vector (positive = discharge)
    % C_b:        [Ah] cell or pack capacity
    % Ah_20pct:   [Ah] amp-hour throughput when 20% capacity lost (from Eq. 19)
    
    % Step 1: Compute number of cycles until 20% loss
    N = (3600 * Ah_20pct) / C_b;   % from Eq. (20)

    % Step 2: Compute cumulative amp-hour throughput
    dt = diff(time);                              % time steps [s]
    Iavg = (abs(current(1:end-1)) + abs(current(2:end))) / 2;  % average abs current
    dAh = Iavg .* dt / 3600;                      % Ah per time step
    ampHoursUsed = [0; cumsum(dAh)];              % integrate

    % Step 3: Compute SOH over time
    SOH = 1 - ampHoursUsed / (2 * N * C_b);        % Eq. (21), assuming SOH(t0) = 1

    % Clamp to [0, 1] range
    SOH = max(min(SOH, 1), 0);
end

