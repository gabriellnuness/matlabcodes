

interf_sensitivity_linearization

function interf_sensitivity_linearization
% This function is used convert the scale factor from a cosine curve function
% to linearized value in volts/rad around pi/2

    % calibration of the interferometer v = A+A*V*cos()
    A = 5.275;  % A = 5.275;
    V = 0.9507; % V = 0.807;

    phi = 0:0.001:pi; % phase vector
    delta_phi = 0; % signal of interest

    v = A + A*V*cos(phi+delta_phi);
    line = A-A*V*(phi-pi/2);
    p = polyfit(phi',line',1);
    sens_v = p(1);

    fprintf("For an interferometric signal from %.2f V to %.2f V,\n the sensitivity around pi/2 is: %.2f V/rad\n", min(v), max(v), sens_v)

    figure
        hold on
        plot(phi,v)
        plot(phi,line)
            xlim([0 pi])
            grid on
            legend('Interferometer','Linearization')
            xlabel('Phase [rad]')
            ylabel('Amplitude [V]')

end