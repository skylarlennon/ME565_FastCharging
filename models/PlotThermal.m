    % Plot
    figure;
    subplot(2,1,1);
    plot(simTime, Tc);
    title('Core Temperatures');
    xlabel('Time [s]'); ylabel('Temp [K]');

    subplot(2,1,2);
    plot(simTime, Ts);
    title('Surface Temperatures');
    xlabel('Time [s]'); ylabel('Temp [K]');