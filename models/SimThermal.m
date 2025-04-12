%% Does the thermal simulations of the battery (post battery sim)

[Tc, Ts] = simulate_thermal_postprocess(simTime,currentOutCell,VtOutCell,OCVOutCell);

function [Tc, Ts] = simulate_thermal_postprocess(time,current,Vt,OCV)
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