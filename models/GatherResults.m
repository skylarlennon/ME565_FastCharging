%% Gather the results from the battery simulation
simTime = ans.simTime;

% Pack
currentOut = ans.currentOut;
OCVOut = ans.OCVOut.*ones(1,length(ans.simTime));
VtOut = ans.VtOut;
SOCOut = ans.SOCOut;

% Cell
currentOutCell = ans.currentOutCell;
OCVOutCell = ans.OCVOutCell.*ones(1,length(ans.simTime));
VtOutCell = ans.VtOutCell;
SOCOutCell = ans.SOCOutCell;


Ts_C = (ans.TsOut-273.15);
Tc_C = (ans.TcOut-273.15);