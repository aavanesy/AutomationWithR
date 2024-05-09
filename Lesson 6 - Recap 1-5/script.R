
library(emayili)
library(tidyverse)
library(lubridate)
library(htmltools)
library(gsheet)
library(tableHTML)

source('credentials.R')

# read config ----

url <- 'https://docs.google.com/spreadsheets/d/1ATCD4QKtGqvkYCmx4L1g6L54OsnUkydFNxN6QGE0goE/edit#gid=0'

config <- gsheet2tbl(url)

config

url = 'https://docs.google.com/spreadsheets/d/1ATCD4QKtGqvkYCmx4L1g6L54OsnUkydFNxN6QGE0goE/edit#gid=340209022'

recipients <- gsheet2tbl(url)

recipients_to = recipients$To[!is.na(recipients$To)]
recipients_cc = recipients$Cc[!is.na(recipients$Cc)]
recipients_bcc = recipients$Bcc[!is.na(recipients$Bcc)]



# load local files ----

source <- config %>% 
  filter(Param == 'Source') %>% 
  pull(Value)


if(source == 'Local'){
  
  myfiles <- list.files(path = 'data', pattern = '.csv',
                        recursive = T, full.names = T)
  
  myfiles
  
  sales_data <- NULL
  
  for(i in 1:length(myfiles)){
    
    file_path <- myfiles[i]
    
    df <- read.csv(file = file_path, header = T)
    
    sales_data <- sales_data %>% 
      bind_rows(df)
    
  }
  
}else if(source == 'Dropbox'){
  #dropbox code
}

# US Report ----

us_report_check <- config %>% 
  filter(Param == 'ReportUS') %>% 
  pull(Value)

if(us_report_check == 'Yes'){
  
  sales_us <- sales_data %>% 
    filter(Country %in% c('US')) %>% 
    filter(Year == 2021) %>% 
    group_by(Year, Month, Item) %>% 
    summarise(Sales = sum(Sale_In_Local_Currency))
  
}

write.csv(sales_us, file = 'sales_us.csv', row.names = F)


# Date and time variables for email ----

Sys.Date()

format(Sys.Date(), "%m %d %Y")
format(Sys.Date(), "%m %d %y")

format(Sys.Date(), "%b %d %Y")
format(Sys.Date(), "%B %d %Y")

this_month <- format(Sys.Date(), "%B %Y")
this_month

today <- format(Sys.Date(), "%B %d, %Y")
today

# Email setup ----

email <- envelope()

recipients

email <- email %>%
  from('rprogr2021@gmail.com') %>%
  to(recipients_to) %>%
  cc(recipients_cc) %>% 
  bcc(recipients_bcc)

# Subject text ----

subject_text <- paste('Sales Report as of', today)

email <- email %>% subject(subject_text)

# Body text ----

body_1 <- paste('<html>', 
               
               'Please see below the sales summary for', this_month,
               
               '</html>')

#empty paragraph - line

body_2 <- paste('<html>','<p>','</p>','</html>')

# Body HTML table ----

sales_table = sales_us %>%
  filter(Month == 6)

sales_table = sales_table %>%
  tableHTML(rownames = F,  widths = rep(100, 4)) %>% 
  add_css_header(css = list(c('text-align', 'background-color'),
                            c('left', ' #e6e6e6')),
                 headers = 1:4) 

body_3 <- sales_table

# Attachment ----

attachment <- config %>% 
  filter(Param == 'Attachment') %>% 
  pull(Value)

attachment

body_4 = ''
body_5 = ''

if(attachment == 'Yes'){
  
  
  body_4 = paste('<html>','<p>','</p>','</html>')
  
  body_5 = paste('<html>', 
                 
                 'Attached you may find the complete data for', year(Sys.Date()),
                 
                 '</html>')
  
  my_file = 'sales_us.csv'
  
  email <- email %>% attachment(my_file)

  # email <- email %>% attachment('script.R')
  
}

email_body <- paste(body_1, body_2, body_3, body_4, body_5)

email <- email %>% emayili::html(email_body)

smtp(email, verbose = T)


