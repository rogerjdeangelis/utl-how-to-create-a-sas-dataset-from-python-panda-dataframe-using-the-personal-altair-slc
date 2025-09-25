proc datasets lib=work                                                          
  nolist nodetails;                                                             
delete rwant;                                                                    
run;quit;                                                                       
proc r;                                                                         
submit;                                                                         
rwant <- readRDS("d:/rds/pywant.rds")                                                         
head(rwant)                                                                      
endsubmit;                                                                      
import data=rwant r=rwant;                                                        
;quit;run;                                                                      
