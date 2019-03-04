function retval = dBmToVrms (pow)
  Pw=10**((pow-30)/10);
  retval = sqrt(50*Pw);
endfunction
