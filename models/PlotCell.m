figure;
sgtitle("Battery Cell Outputs")

subplot(2,2,1)
plot(simTime, currentOutCell,'LineWidth',2)
xlabel('Time (s)')
ylabel('Current (A)')
grid on

subplot(2,2,2)
plot(simTime, SOCOutCell,'LineWidth',2)
xlabel('Time (s)')
ylabel('SOC')
grid on

subplot(2,2,3)
plot(simTime,OCVOutCell,"LineWidth",2)
xlabel('Time (s)')
ylabel('OCV(t)')
grid on

subplot(2,2,4)
plot(simTime,VtOutCell,"LineWidth",2)
xlabel('Time (s)')
ylabel('V_T(t)')
grid on