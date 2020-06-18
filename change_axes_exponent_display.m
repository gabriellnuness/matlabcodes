
close all
t = 0:0.001:20;
x = cos(t);

h = plot(t,x)
ax = ancestor(h,'axes')
ax.XAxis.Exponent = 3

