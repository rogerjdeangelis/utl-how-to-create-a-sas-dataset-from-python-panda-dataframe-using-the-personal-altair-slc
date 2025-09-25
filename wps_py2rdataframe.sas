proc datasets lib=work                                                          
  nolist nodetails;                                                             
delete &out;                                                                    
run;quit;                                                                       
proc r;                                                                         
submit;                                                                         
&out <- readRDS("&inp")                                                         
head(&out)                                                                      
endsubmit;                                                                      
import data=&out r=&out;                                                        
;quit;run;                                                                      
