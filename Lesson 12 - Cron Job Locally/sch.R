
library(lubridate)

value = Sys.time()

value = paste(year(value),
               month(value),
               day(value),
               hour(value),
               minute(value),
          sep = '_')


write.csv(mtcars,
          row.names = F,
          file = paste0('C:/Users/Work/Dropbox/cron/', value, '.csv'))