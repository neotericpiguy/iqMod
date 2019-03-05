graphics_toolkit gnuplot
pkg load signal
#graphics_toolkit qt

fc=10e9;       %carrier
fdev=1e9
saw_rate=150e3;

n=256; #points
#n=512; #points
n=2**17;

hf = figure ();
set (hf, "visible", "off"); 

P_dBm=5;

fm=@(t) fdev/2*(sawtooth(2*pi*saw_rate*t)+1);
#fm=@(t) fdev*0*t;
I=@(t) dBmToVpk(P_dBm)*cos(2*pi*fm(t).*t);
Q=@(t) dBmToVpk(P_dBm)*cos(2*pi*fm(t).*t+pi/2);
LO=@(t) dBmToVpk(P_dBm)*cos(2*pi*fc*t);

fm=@(t) fdev*sawtooth(2*pi*saw_rate*t)+fc;
R=@(t) dBmToVpk(P_dBm)*cos(2*pi*fm(t).*t);
#R=@(t) real((I(t)+i*Q(t)).*LO(t));

subplot(4,3,1:6);
t=0:2/saw_rate/n:2/saw_rate;
plot (t, fm(t) ,'k');

title( sprintf('%d Ghz',fc/1e9));
xlabel('t (s)');
ylabel('Vpk (V)');

subplot(4,3,7:12);
fs=fc*4;
t=(0:n-1)/fs;
[f,fftR] = fftPoints(fs,R(t));
[f,fftLO] = fftPoints(fs,LO(t));
#plot (f, fftR ,'k',f,fftLO);
plot (f, fftR ,'k');
xlabel('Freq (hz)');
ylabel('Power (dBm)');

axis([fc-fdev*2,fc+fdev*2,min(fftR),max(fftLO)]);

mkdir build;
cd build;
print (hf, "fftIq.tex", "-dpdflatexstandalone");
system ("pdflatex fftIq");

