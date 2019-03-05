function [ f, fftPoints ] = fftPoints(fs,points)
  n=length(points);
  f=fs*(0:n/2)/n;
  fftPoints=abs(fft(points));
  fftPoints=fftPoints(1: n/2+1)./(n/2); % use half the samples and normalize 0-1
  fftPoints=fftPoints/sqrt(2);% Vpk = Vrms * sqrt(2) ∴ Vrms = Vpk/sqrt(2)
  fftPoints=(fftPoints.^2)/50; 
  fftPoints=10*log10(fftPoints)+30;% log scale
endfunction
