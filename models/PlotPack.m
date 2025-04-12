figure;
sgtitle("Battery Pack Outputs")

subplot(2,2,1)
plot(simTime, currentOut,'LineWidth',2)
xlabel('Time (s)')
ylabel('Current (A)')
grid on

subplot(2,2,2)
plot(simTime, SOCOut,'LineWidth',2)
xlabel('Time (s)')
ylabel('SOC')
grid on

subplot(2,2,3)
plot(simTime,OCVOut,"LineWidth",2)
xlabel('Time (s)')
ylabel('OCV(t)')
grid on

subplot(2,2,4)
plot(simTime,VtOut,"LineWidth",2)
xlabel('Time (s)')
ylabel('V_T(t)')
grid on