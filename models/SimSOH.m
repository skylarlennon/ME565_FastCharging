%% Simulate the state of health 

K = 1000;
KVec = (linspace(0,K,K));
SOHVec = zeros(1,K);
Ah_20pct = Qpack*0.80;
for i = 1:K
    SOH = compute_soh(simTime, currentOut, Qpack,Qpack*0.8);  % Assume Ah_20pct = 600 Ah
    SOHVec(i) = SOH(end);
    Qpack = Qpack*SOH(end);
end

%% Functions

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
