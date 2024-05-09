
# load packages

library(tidyverse)
library(emayili)
library(openxlsx)
library(officer)
library(htmltab)
library(lubridate)
library(pdftools)
library(gsheet)
library(mRpostman)
library(htmltools)
library(tableHTML)
library(rdrop2)
library(flextable)

source('credentials.R')

# load config ---- 

url <- 'https://docs.google.com/spreadsheets/d/1ATCD4QKtGqvkYCmx4L1g6L54OsnUkydFNxN6QGE0goE/edit#gid=0'

config <- gsheet2tbl(url)

config

url = 'https://docs.google.com/spreadsheets/d/1ATCD4QKtGqvkYCmx4L1g6L54OsnUkydFNxN6QGE0goE/edit#gid=340209022'

recipients <- gsheet2tbl(url)

recipients_to = recipients$To[!is.na(recipients$To)]
recipients_cc = recipients$Cc[!is.na(recipients$Cc)]
recipients_bcc = recipients$Bcc[!is.na(recipients$Bcc)]


# load data ----

url <- "https://www.x-rates.com/table/?from=USD&amount=1"

table_rates <- htmltab(url, 1)

str(table_rates)

table_rates[,2] = table_rates[,2] %>% as.numeric() %>% round(3)
table_rates[,3] = table_rates[,3] %>% as.numeric() %>% round(3)

current_month <- substr(Sys.Date(),1,7)
current_month

token <- readRDS("token.rds")
# Then pass the token to each drop_ function
drop_acc(dtoken = token)

files <- drop_dir('data') %>% 
  arrange(path_display) %>% 
  filter(str_detect(name, current_month))

files %>% pull(path_display) 

# download all and store in sales_data
sales_data <- NULL

for(i in 1:length(files$path_display)){

  tempfile <- tempfile(fileext = ".csv")  
  
  drop_download(files$path_display[i], 
                overwrite = TRUE,
                verbose = TRUE,
                progress = FALSE,
                local_path = tempfile)
  
  df <- read.csv(tempfile)
  
  sales_data <- sales_data %>% 
    bind_rows(df)

}

sales_data %>% head(2)
sales_data %>% tail(2)

sales_data <- sales_data %>% 
  group_by(Month, Day, Country, Item) %>% 
  summarise(Sales = sum(Sale_In_Local_Currency)) %>% 
  ungroup()

# Email setup ----

today <- format(Sys.Date(), "%B %d, %Y")
today

email <- envelope()

email <- email %>%
  from('rprogr2021@gmail.com') %>%
  to(recipients_to) %>%
  cc(recipients_cc) %>% 
  bcc(recipients_bcc)

# Subject text

subject_text <- paste('Sales Report as of', today)

email <- email %>% subject(subject_text)

# Body table 

sales_table = sales_data %>%
  filter(Day == max(Day))

sales_table = sales_table %>%
  tableHTML(rownames = F,  widths = rep(100, 5)) %>% 
  add_css_header(css = list(c('text-align', 'background-color'),
                            c('left', ' #e6e6e6')),
                 headers = 1:5) 

email <- email %>% emayili::html(sales_table)

  
# attachment one - csv file ----

tempfile <- tempfile(fileext = ".csv")

write.csv(sales_data, tempfile, row.names = F)

email <- email %>% attachment(tempfile, name = 'Report.csv')

# attachment two - excel file ----

tempfile <- tempfile(fileext = ".xlsx")

write.xlsx(sales_data, tempfile)

email <- email %>% attachment(tempfile, name = 'Report.xlsx')

# attachment three - pptx file ----

table_rates_ft <- table_rates %>% 
  flextable() %>% 
  autofit() %>% 
  fontsize(part = "all", size = 9)

table_rates_ft

ppt <- read_pptx() 

ppt <- add_slide(ppt, layout = "Title and Content", master = "Office Theme")

ppt <- ph_with(ppt, value = table_rates_ft, 
               location = ph_location(left = 3, top = 2) )

tempfile <- tempfile(fileext = ".pptx")

print(ppt, target = tempfile)

email <- email %>% attachment(tempfile, name = 'Rates.pptx')

# attachment four - docx file ----


doc <- read_docx()

doc <- doc %>% 
  body_add_par(value = 'FX Rates', style = 'Normal') %>% 
  body_add_par(value = '', style = 'Normal') %>% 
  body_add_par(value = '', style = 'Normal') %>% 
  body_add_flextable(value = table_rates_ft)

doc <- doc %>% 
  body_add_break() %>% 
  body_add_par(value = 'This is page 2', style = 'Normal') 

tempfile <- tempfile(fileext = ".docx")

print(doc, target = tempfile)

email <- email %>% attachment(tempfile, name = 'Rates.docx')
# send all by email ----

smtp(email, verbose = T)



