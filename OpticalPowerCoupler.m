dBsplice = -0.02
potLaser = [6.62;35;62.9;90.2;117.3;144.2] %mW
inputCoupler = potLaser.*10^((dBsplice/10))

out90 = [5.83;30.3;53.0;75.8;98.5;120.8]
out10 = [0.748;1.46;2.57;3.69;4.80;5]

perc90 = (out90./inputCoupler)*100
perc10 = (out10./inputCoupler)*100
perc90+perc10