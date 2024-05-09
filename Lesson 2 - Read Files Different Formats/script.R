
library(tidyverse)

# read from csv ----

?read.csv
data <- read.csv(file = file.path('files','TechOnline_sales_2020-10-22.csv'))

head(data)

#encoding

#https://en.wikipedia.org/wiki/ISO/IEC_8859-1
#ISO 8859-1 encodes what it refers to as "Latin alphabet no. 1", 
#consisting of 191 characters from the Latin script.

#https://en.wikipedia.org/wiki/UTF-8
#UTF-8 is capable of encoding all 1,112,064 valid character code points in Unicode

read.csv(file = file.path('files','TechOnline_sales_2020-10-22.csv'),
         fileEncoding = 'UTF-8')


# write txt
?write.table
write.table(data, file = file.path('files','table.txt'),
            sep = "\t",
            row.names = FALSE)

# read from txt ----

?read.delim
data <- read.delim(file = file.path('files','table.txt'))

head(data)

# for very large files (10+ Mb of text)

?data.table::fread

data <- data.table::fread(file = file.path('files','table.txt'))

# read from Excel ----

library(openxlsx)

?loadWorkbook

workbook <- loadWorkbook(xlsxFile = file.path('files','Excel_data.xlsx'))
class(workbook)

?names
sheets(workbook)

?readWorkbook
data_1 <- readWorkbook(workbook, sheet = "Part1")
data_2 <- readWorkbook(workbook, sheet = "Part2", startRow = 1)

# read from PDF ----

# https://cran.r-project.org/web/packages/pdftools/index.html

library(pdftools)
library(stringi)

pdf_file <- file.path('files','invoice.pdf')

?pdftools::pdf_data
data <- pdf_data(pdf_file)

?pdftools::pdf_text
data <- pdf_text(pdf_file)

data <- str_split(data, '\n')

data <- data[[1]]

str_detect(data, 'NETTOLOHN')

str_detect(data, 'NETTOLOHN') %>% which()

row_netto <- str_detect(data, 'NETTOLOHN') %>% which()

value_netto = data[row_netto]
value_netto <- str_replace(value_netto, 'NETTOLOHN', '')
value_netto = as.numeric(value_netto)

value_netto
value_netto + 5

# advanced dplyr (just need to send raw data..)

data.frame(value = data) %>% 
  filter(value != '') %>% 
  mutate(value = str_replace_all(value, "\\s+", "_")) %>% 
  separate(value, into = c('c1','c2','c3','c4','c5','c6'), sep = '_')

# messy file


pdf_file <- file.path('files','data-wrangling-cheatsheet.pdf')

data <- pdf_text(pdf_file)
 data <- str_split(data, '\n')[[1]]




