#  t=0:0.00001:2
#  
#  #x=2*sin(20*pi*t) + sin(100*pi*t)
#  x=70e-3*cos(2*pi*1e9*t)
#  subplot(2,1,1)
#  plot(1*t,x)
#  grid
#  xlabel("Time in milliseconds")
#  ylabel("Signal amplitude")
#  
#  subplot(2,1,2)
#  y=fft(x)
#  plot(1000*t,abs(y))
#  xlabel("Frequency")
#  ylabel("Signal amplitude")
#  
#  pause

graphics_toolkit gnuplot
pkg load signal
#graphics_toolkit qt

fm=2e9;        %message
fdev=5e9;        %message
fc=10e9;       %carrier
saw_rate=100e3; %hz

#n=512; #points
#n=51;
n=2**16;

hf = figure ();
set (hf, "visible", "off"); 

#fbm=@(t) fdev*sin(2*pi*saw_rate*t);
#fbm=@(t) fdev/2*(sin(2*pi*saw_rate*t)+1);
fbm=@(t) fdev/2*(sawtooth(2*pi*saw_rate*t)+1);
#fbm=@(t) fm;
I=@(t) dBmToVpk(-10)*cos(2*pi*fbm(t).*t);
Q=@(t) dBmToVpk(-10)*cos(2*pi*fbm(t).*t+pi/2);
R=@(t) real(I(t).*cos(2*pi*fc*t)+Q(t).*sin(2*pi*fc*t)*i);

subplot(4,3,1:3);
t=0:1/saw_rate/n:1/saw_rate;
plot (t, I(t),'r');

#subplot(4,3,2:3);
#fs=fm*4;
#t=(0:n-1)/fs;
#f=fs*(0:n/2)/n;
#fftI=fftshift(abs(fft(I(t))));
#fftI=fftI(1:n/2+1);
#plot (f, fftI ,'r');

subplot(4,3,4);
t=0:2/fm/n:2/fm;
plot (t, Q(t),'b');

subplot(4,3,5:6);
fs=fm*4;
t=(0:n-1)/fs;
f=fs*(0:n/2)/n;
fftQ=fftshift(abs(fft(Q(t))));
fftQ=fftQ(1:n/2+1);
plot (f, fftQ ,'b');

subplot(4,3,7:9);
t=0:5/saw_rate/n:5/saw_rate;
plot (t, fbm(t),'k');

subplot(4,3,10);
t=0:2/fc/n:2/fc;
plot (t, R(t),'k');

subplot(4,3,11:12);
fs=fc*4;
t=(0:n-1)/fs;
f=fs*(0:n/2)/n;
fftR=fftshift(abs(fft(R(t))));
fftR=20*log10(fftR(1:n/2+1))-30;
plot (f, fftR ,'k');

mkdir build;
cd build;
print (hf, "iqmod.tex", "-dpdflatexstandalone");
system ("pdflatex iqmod");

