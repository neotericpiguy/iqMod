function retval = dBmToVpk (pow)
  retval = dBmToVrms(pow)*sqrt(2);
endfunction
