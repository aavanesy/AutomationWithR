
library(taskscheduleR)

myscript <- c("C:/Users/Work/Dropbox/cron/sch.R")


?taskscheduler_create

taskscheduler_create(taskname = "1.task",
                     rscript = myscript, 
                     schedule = "MINUTE", 
                     startdate = format(Sys.Date(), "%m/%d/%Y"), 
                     modifier = 1)



taskscheduler_delete(taskname = "1.task")

tasks <- taskscheduler_ls()
View(tasks)
