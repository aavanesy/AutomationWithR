

packages_check = c('tidyverse', 'emayili', 'openxlsx', 'officer', 'htmltab',
       'lubridate', 'pdftools', 'gsheet', 'mRpostman', 'htmltools', 'tableHTML')

ip = as.data.frame(installed.packages()[,c(1,3:4)])

ip = ip[is.na(ip$Priority),1:2,drop=FALSE]
  
  print(packages_check %in% ip$Package)
  
  if(all(packages_check %in% ip$Package)){
    print('Test script successful')
  }else{
    print('Packages are missing')
  }
  
