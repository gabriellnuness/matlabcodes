clear
close all
clc

VM = 8.87
vm = 1.25

volts2bits(VM)
volts2bits(vm)
sp0v = (VM + vm)/2
sp0b = volts2bits(sp0v)


V536 = bits2volts(536)

V1536 = bits2volts(1536)
V1746 = bits2volts(1746)

function [v] = bits2volts(b)
    v = b*20 /(2^12);
end
function [b] = volts2bits(v)
    b = round(v*2^12 / 20);
end

