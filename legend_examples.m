clear
close all

y = randn(100,5);


leg = ['1','2','3','4','5']
figure
plot(y)
legend(leg)


leg = {"1","2","3","4","5"}
figure
plot(y)
legend(leg)


leg = {'1','2','3','4','5'}
figure
plot(y)
legend(leg)


leg = {'','','','','5'}
figure
plot(y)
legend(leg)


n = 3;                      % number of empty cells
str = repmat({''},1,n);     % create empty char cell
actual_leg = {'4','5'}; 
leg = [str, actual_leg];    % concat cells

figure
plot(y)
legend(leg)
