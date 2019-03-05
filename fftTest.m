graphics_toolkit gnuplot
pkg load signal
#graphics_toolkit qt

fc=10e9;       %carrier

n=256; #points
n=512; #points
#n=2**16;

hf = figure ();
set (hf, "visible", "off"); 

P_dBm=-10;

R=@(t) dBmToVpk(P_dBm)*cos(2*pi*fc*t);

subplot(4,3,1:3);
t=0:2/fc/n:2/fc;
plot (t, R(t) ,'k');

#title( sprintf('%f dBm %d Vrms\n%d',P_dBm,dBmToVrms(P_dBm),max(fftR)));
title( sprintf('%d Ghz',fc/1e9));
xlabel('t (s)');
ylabel('Vpk (V)');

subplot(4,3,4:12);
fs=fc*4;
t=(0:n-1)/fs;
[f,fftR] = fftPoints(fs,R(t));
plot (f, fftR ,'k');
xlabel('Freq (hz)');
ylabel('Power (dBm)');

mkdir build;
cd build;
print (hf, "fftTest.tex", "-dpdflatexstandalone");
system ("pdflatex fftTest");

