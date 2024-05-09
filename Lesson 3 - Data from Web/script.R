############# IMPORTANT ################
# Dont forget set current folder as working directory #
# Pane Files >> More (little Blue Settings Icon) >> Set as Working Directory

# or run
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


# download files from the web ----

# https://www.bis.org/statistics/about_fx_stats.htm

?download.file

url = 'https://www.bis.org/statistics/xrusd/xrusd_doc.pdf'

download.file(url, destfile = 'file10.pdf', mode = 'wb')

url = 'https://www.bis.org/statistics/full_webstats_xru_current_d_dataflow_csv_col.zip'

download.file(url, 'files.zip', mode = 'wb')

# read file directly

data = openxlsx::read.xlsx('https://www.bis.org/statistics/rpfx19_fx_tables.xlsx', startRow = 4)

head(data)

data %>% View()

?drop_na

data <- data %>% 
  tidyr::drop_na()

str(data)


# html table from websites ----

library(htmltab)
library(dplyr)

?htmltab

url = 'https://www.slickcharts.com/dowjones'

htmltab(url, which = 1)

htmltab(url, which = 1) %>% str()

table = htmltab(url, 1) %>% select(Company, Symbol, Weight)

table

url = 'https://www.x-rates.com/table/?from=USD&amount=1'

htmltab(url, 1) %>% head()

htmltab(url, 2) %>% head()

htmltab(url, 3) %>% head()

table = htmltab(url, 1) 

# Google Sheets and Dropbox ----

library(gsheet)

google_url  = 'https://docs.google.com/spreadsheets/d/1CuSYH_WOVtBS0JYWxpsJfmg7bdyEEjTWPIu38aGOyig/edit#gid=0'

?gsheet2tbl

gs <- gsheet2tbl(google_url)

gsheet2tbl('https://docs.google.com/spreadsheets/d/1CuSYH_WOVtBS0JYWxpsJfmg7bdyEEjTWPIu38aGOyig/edit#gid=515638326')

gs

dropbox_url = 'https://www.dropbox.com/s/ki9869z9hrpuh03/TechOnline_sales_2020-10-19.csv?dl=1'

read.csv(dropbox_url)





















