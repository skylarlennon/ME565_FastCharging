%% Simulation settings
numCycles = 1000;
SOH = 1;
SOHVec = zeros(1, numCycles);
%% --- Loop Through Charging Cycles ---
for i = 1:numCycles
        B = 1e7;
        gamma = 0.55;
        c = 1;
        Ea = 31700 - 370.3 * c;
        R = 8.3;
        Tc = 298;
        Cb = 559440;  % [As] = 155.4 Ah * 3600
    
        for j=1:length(current);
            mean_current=mean(current);
            std_current= std(current)+1e-6;
            factor(j) = (current(j)-mean_current)/std_current;
        end
        adjust=sum(factor)*1e13;
        if adjust==0
            adjust=1;
        end
        % Compute Ah_20% and N
        Ah_20pct = (20 / (B * exp(-Ea / (R * Tc))))^(1 / gamma);  % Eq. 19
        N = (3600 * Ah_20pct) / Cb;  % Eq. 20
        % Calculate ampere-seconds used in this cycle
        amp_sec_used = adjust * trapz(abs(current))/1e7;  % ∫ |I(t)| dt
        % SOH degradation equation (Eq. 21)
        SOH = SOH - amp_sec_used / (2 * N * Cb);
        SOH = max(SOH, 0);  % Clamp between 0–1
        % Store SOH
        SOHVec(i) = SOH;
        % Optional: stop early if SOH drops below 80%
        if SOH <= 0.8
            fprintf('SOH dropped below 80%% at cycle %d\n', i);
        break;
        end
end