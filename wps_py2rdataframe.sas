proc datasets lib=work                                                          
  nolist nodetails;                                                             
delete &out;                                                                    
run;quit;                                                                       
options set=RHOME "D:\d451";                                                    
proc r;                                                                         
submit;                                                                         
&out <- readRDS("&inp")                                                         
head(&out)                                                                      
endsubmit;                                                                      
import data=&out r=&out;                                                        
;quit;run;                                                                      
