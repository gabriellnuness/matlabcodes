% This script makes a sigmoid function to use in simulink. Coded by
% Roberta.

function sgn(block)

setup(block);

end
 
function setup(block)
 
block.NumInputPorts = 1;
block.NumOutputPorts = 1; 
block.SetPreCompInpPortInfoToDynamic; 
block.SetPreCompOutPortInfoToDynamic;
block.SampleTimes = [plot(simout2.time,simout2.signals.values,'LineWidth',1,'Color','r')
set(gca,'FontSize',18,'LineWidth',1,'FontName', 'Times new roman')%,'FontWeight','bold')
hold on
plot(simout1.time,simout1.signals.values,'LineWidth',1,'Color','k')
set(gca,'FontSize',18,'LineWidth',1,'FontName', 'Times new roman')%,'FontWeight','bold')
grid on
xlabel('t [s]')%'x_1')
ylabel('Amplitude [rad]')%'x_2')0001 0];%[0.00001 0];%[0.005 0]; 
block.SetAccelRunOnTLC(true);
block.RegBlockMethod('Outputs',@Output);

end
 
function Output(block)
 
ENTRADA1=block.InputPort(1).Data; 
    if ENTRADA1>0
    block.OutputPort(1).Data =15;
    end
    if ENTRADA1==0;
    block.OutputPort(1).Data =0;    
    end
    if ENTRADA1<0;
    block.OutputPort(1).Data =-15;
    end
    
 %block.OutputPort(1).Data=15*(ENTRADA1/(abs(ENTRADA1)+0.9));
end         