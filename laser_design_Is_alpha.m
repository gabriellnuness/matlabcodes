clear all
close all
clc

header = {'Pump','alpha0_er30','Is_er30','alpha0_m12','Is_m12','alpha0_m5','Is_m5'};
% data =[100, 4.08, 0.77e8, 2.74, 0.69e8, 0.64, 1.06e8
%        200, 4.35, 2.30e8, 2.64, 2.25e8, 0.66, 2.94e8
%        300, 4.44, 3.85e8, 2.64, 3.74e8, 0.66, 4.67e8
%        400, 4.47, 5.39e8, 2.67, 4.66e8, 0.64, 6.92e8
%        500, 4.48, 6.97e8, 2.68, 5.92e8, 0.67, 7.63e8
%        600, 4.50, 8.56e8, 2.69, 7.07e8, 0.68, 8.36e8
%        650, 4.52, 9.14e8, 2.65, 7.79e8, 0.68, 8.21e8]; % [m^-1] [w/m^2]

data = readmatrix('doped_fiber_characterization_data.csv','NumHeaderLines',1);
   
%%
% defining data
medium_len = 10e-2; % [m] 
number_of_splices = 2;
splice_loss_db = -0.1; % dB --> db = 20*log10(mag) --> power
A = pi*(5e-6)^2;% optical fiber area

loss = 1 - number_of_splices * (1 - 10^(splice_loss_db/20)); % [mag]

%
fiber_model = 'Fiber ER30';
figure()
hold on
title([fiber_model,' - ',num2str(medium_len*1000),' mm'])
fprintf([fiber_model,'\n'])
alpha0 = data(:,2);
Is = data(:,3);
for i=1:length(Is)

    [reflect,I_laser,r_min,r_peak,I_max] = laser_intensity(alpha0(i), Is(i), medium_len, loss);
    plot(reflect, I_laser*A*1000)
    fprintf('Pump: %.2f mA, r_min: %.2f, r_peak: %.2f, P_max: %.2f mW\n',...
        data(i,1), r_min, r_peak,I_max*A*1000)

end
    ylim([0 max(I_laser*A*1000)])
    ylabel('Power [mW]')
    xlabel('FBG Reflectivity')   
% ylim([0 3e8])
    
%%    
fiber_model = 'Fiber M12';
figure()
hold on
fprintf([fiber_model,'\n'])
title([fiber_model,' - ',num2str(medium_len*1000),' mm'])
alpha0 = data(:,4);
Is = data(:,5);
for i=1:length(Is)

    [reflect,I_laser,r_min,r_peak,I_max] = laser_intensity(alpha0(i), Is(i), medium_len, loss);
    plot(reflect, I_laser*A*1000)
    fprintf('Pump: %.2f mA, r_min: %.2f, r_peak: %.2f, P_max: %.2f mW\n',...
        data(i,1), r_min, r_peak,I_max*A*1000)
end
    ylim([0 max(I_laser*A*1000)])
    ylabel('Power [mW]')
    xlabel('FBG Reflectivity')   
%     ylim([0 3e8])

%%
fiber_model = 'Fiber M5';
figure()
hold on
fprintf([fiber_model,'\n'])
title([fiber_model,' - ',num2str(medium_len*1000),' mm'])
alpha0 = data(:,6);
Is = data(:,7);
for i=1:length(Is)

    [reflect,I_laser,r_min,r_peak,I_max] = laser_intensity(alpha0(i), Is(i), medium_len, loss);
    plot(reflect, I_laser*A*1000)
    fprintf('Pump: %.2f mA, r_min: %.2f, r_peak: %.2f, P_max: %.2f mW\n',...
        data(i,1), r_min, r_peak,I_max*A*1000)
end
    ylim([0 max(I_laser*A*1000)])
    ylabel('Power [mW]')
    xlabel('FBG Reflectivity')   
% ylim([0 3e8])

    
    
%%
% Function to calculate output laser intensity
function [reflect, I_laser,r_min, r_peak, I_max] = laser_intensity(alpha0, Is, medium_len, loss)
reflect = linspace(0,1,1000);   % reflectivity vector
gains = alpha0 * medium_len;
losses = (1/2) * log(loss^2 .* reflect);

I_laser = (((1-sqrt(reflect))*loss) ./ (1 - loss*sqrt(reflect)))...
    *Is.*(gains+losses);

r_min = reflect(I_laser>0);
r_min = r_min(1);

I_max = (max(I_laser));
r_peak = reflect(I_laser == I_max);
end

















