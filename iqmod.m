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
#graphics_toolkit qt

fm=2e9;        %message
fc=10e9;       %carrier

#n=512; #points
#n=51;
n=2**16;

#t=(0:n-1)/(fm*4);
#Q=dBmToVpk(-10)*cos(2*pi*fm*t+pi/2);
#LO=dBmToVpk(0)*cos(2*pi*fc*t);

#R=real(I.*cos(2*pi*fc*t)+Q.*sin(2*pi*fc*t)*i);
#R=I+Q;
#R=dBmToVpk(-10)*cos(2*pi*fc*t);
#R=real(cos(2*pi*fc*t)+1*sin(2*pi*fm*t));

hf = figure ();
set (hf, "visible", "off"); 

fbm=@(t) fm*sin(2*pi*100e3*t);
#fbm=@(t) fm;
I=@(t) dBmToVpk(-10)*cos(2*pi*fbm(t).*t);
Q=@(t) dBmToVpk(-10)*cos(2*pi*fbm(t).*t+pi/2);
R=@(t) real(I(t).*cos(2*pi*fc*t)+Q(t).*sin(2*pi*fc*t)*i);

subplot(3,3,1);
t=0:2/fm/n:2/fm;
plot (t, I(t),'r');

subplot(3,3,2:3);
fs=fm*4;
t=(0:n-1)/fs;
f=fs*(0:n/2)/n;
fftI=fftshift(abs(fft(I(t))));
fftI=fftI(1:n/2+1);
plot (f, fftI ,'r');

subplot(3,3,4);
t=0:2/fm/n:2/fm;
plot (t, Q(t),'b');

subplot(3,3,5:6);
fs=fm*4;
t=(0:n-1)/fs;
f=fs*(0:n/2)/n;
fftQ=fftshift(abs(fft(Q(t))));
fftQ=fftQ(1:n/2+1);
plot (f, fftQ ,'b');

subplot(3,3,7);
t=0:2/fc/n:2/fc;
plot (t, R(t),'b');

subplot(3,3,8:9);
fs=fc*4;
t=(0:n-1)/fs;
f=fs*(0:n/2)/n;
fftR=fftshift(abs(fft(R(t))));
fftR=fftR(1:n/2+1);
plot (f, fftR ,'b');

mkdir build;
cd build;
print (hf, "iqmod.tex", "-dpdflatexstandalone");
system ("pdflatex iqmod");

