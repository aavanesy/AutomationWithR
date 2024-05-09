
library(openxlsx)
library(tidyverse)
library(htmltab)

# create a workbook and save it ----
?createWorkbook
wb <- openxlsx::createWorkbook()

?saveWorkbook
openxlsx::saveWorkbook(wb, 'file.xlsx', overwrite = T, returnValue = TRUE)

# add sheets and data, view before saving ----

wb <- openxlsx::createWorkbook()


?addWorksheet
addWorksheet(wb, sheetName = 'Summary', tabColour = 'grey')

openxlsx::openXL(wb)

?writeData
writeData(wb, sheet = 'Summary', x = 1234)

openxlsx::openXL(wb)

openxlsx::saveWorkbook(wb, 'file.xlsx', overwrite = T)


# write table with basic styling ----

url <- "https://www.x-rates.com/table/?from=USD&amount=1"

table_rates <- htmltab(url, 1) 

wb <- openxlsx::createWorkbook()
sh1 <- "FX Rates"

addWorksheet(wb, sheetName = sh1, gridLines = FALSE)

writeData(wb, sheet = sh1,
          x = table_rates)

openxlsx::openXL(wb)

str(table_rates)

table_rates[,2] = table_rates[,2] %>% as.numeric() %>% round(3)
table_rates[,3] = table_rates[,3] %>% as.numeric() %>% round(3)

str(table_rates)


writeData(wb, sheet = sh1,
          x = table_rates,
          startCol = 2,
          startRow = 2,
          borders = 'surrounding',
          borderColour = 'grey',
          borderStyle = 'thin')

openxlsx::openXL(wb)

writeData(wb, sheet = sh1,
          x = table_rates,
          startCol = 2,
          startRow = 2,
          borders = c('rows'),
          borderColour = 'grey',
          borderStyle = 'thin',
          withFilter = TRUE)

openxlsx::openXL(wb)



# styles ----

?createStyle

style_body <- createStyle(
  fontName = "Calibri",
  fontSize = 11,
  fontColour = 'black',
  numFmt = "GENERAL",
  border = 'TopBottomLeftRight',
  borderColour = "black",
  borderStyle = "thin" ,
  bgFill = NULL,
  fgFill = '#FBFBFB',
  halign = 'center',
  valign = 'center'
)

?addStyle
addStyle(wb, sh1, style = style_body,
         rows = 3:12, cols = 2:4,
         gridExpand = TRUE )

openxlsx::openXL(wb)

style_header <- createStyle(
  fontName = "Calibri",
  fontSize = 12,
  fontColour = 'white',
  numFmt = "GENERAL",
  border = 'TopBottomLeftRight',
  borderColour = "black",
  borderStyle = "thin" ,
  fgFill = '#31869B',
  halign = 'center',
  valign = 'center',
  textDecoration = "bold"
)

addStyle(wb, sh1, style = style_header,
         rows = 2, cols = 2:4,
         gridExpand = TRUE )

openxlsx::openXL(wb)



# height width and other customization ----

url <- "https://www.x-rates.com/table/?from=USD&amount=1"
table_rates <- htmltab(url, 1) 
table_rates[,2] = table_rates[,2] %>% as.numeric() %>% round(3)
table_rates[,3] = table_rates[,3] %>% as.numeric() %>% round(3)

wb <- openxlsx::createWorkbook()
sh1 <- "FX Rates"
addWorksheet(wb, sheetName = sh1, gridLines = FALSE)

writeData(wb, sheet = sh1,
          x = table_rates,
          startCol = 2,
          startRow = 2,
          borders = c('rows'),
          borderColour = 'grey',
          borderStyle = 'thin',
          withFilter = TRUE)

addStyle(wb, sh1, style = style_body,
         rows = 3:12, cols = 2:4,
         gridExpand = TRUE)

addStyle(wb, sh1, style = style_header,
         rows = 2, cols = 2:4,
         gridExpand = TRUE)


# col width
?openxlsx::setColWidths

# auto
setColWidths(wb, sh1, cols = 2:4, widths = 'auto') 
openxlsx::openXL(wb)

#predefined
setColWidths(wb, sh1, cols = 2:4, widths = c(24, 18, 18)) 
openxlsx::openXL(wb)

#using nchar

?nchar
n1 = table_rates[,1] %>% nchar() %>% max()

setColWidths(wb, sh1, cols = 2:4, widths = c(n1 + 3, 18, 18)) 
openxlsx::openXL(wb)

# row width

?openxlsx::setRowHeights

setRowHeights(wb, sh1, rows = 2, heights = 20)
openxlsx::openXL(wb)


# add a date object ----

today = Sys.Date()

writeData(wb, sh1, "FX rates as of:", startCol = 2, startRow = 14)
writeData(wb, sh1, today, startCol = 2, startRow = 15)
openxlsx::openXL(wb)

date_style = createStyle(numFmt = "mmmm dd, yyyy", halign = 'left')
#m, or mmm, or mmmm
#d or dd
#yy or yyyy

addStyle(wb, sh1, style = date_style, cols = 2, rows = 15 )
openxlsx::openXL(wb)



# sales data, loops and excel ----

# myfiles <- list.files(path = 'data', pattern = '2021-06',
#                       recursive = T, full.names = T)
# 
# wb <- openxlsx::createWorkbook()
# 
# 
# for(i in 1:length(myfiles)){
#   
#   file_path <- myfiles[i]
#   
#   file_path2 = str_replace(file_path, '/', '_')
#   file_path2 = str_replace(file_path2, '.csv', '')
#   file_path2 = str_replace(file_path2, 'data_TechOnline_sales_', '')
# 
#   df <- read.csv(file = file_path, header = T)
#   
#   addWorksheet(wb, sheetName = file_path2)
#   
#   writeData(wb, file_path2, df)
# }
# 
# openxlsx::openXL(wb)

# conditional formatting ----

?openxlsx::conditionalFormatting

myfiles <- list.files(path = 'data', pattern = '2021-06',
                      recursive = T, full.names = T)

wb <- openxlsx::createWorkbook()

 i = 1
 
file_path <- myfiles[i]

file_path2 = str_replace(file_path, '/', '_')
file_path2 = str_replace(file_path2, '.csv', '')
file_path2 = str_replace(file_path2, 'data_TechOnline_sales_', '')

df <- read.csv(file = file_path, header = T)

addWorksheet(wb, sheetName = file_path2)
writeData(wb, file_path2, df)

openxlsx::openXL(wb)

avg_val = mean(df$Sale_In_Local_Currency)
rule_v = paste0(">=",avg_val)

conditionalFormatting(
  wb,
  file_path2,
  cols = 2,
  rows = 2:(nrow(df)+1),
  rule = rule_v,
  style = createStyle(fontColour = "#FC0000", bgFill = "#C6EFCE"),
  type = "expression"
)
openxlsx::openXL(wb)


conditionalFormatting(
  wb,
  file_path2,
  cols = 2,
  rows = 2:(nrow(df)+1),
  rule = NULL,
  style = "#31869B",
  type = "databar"
)
openxlsx::openXL(wb)


# saving the excel ----

myfiles <- list.files(path = 'data', pattern = '2021-06',
                      recursive = T, full.names = T)

wb <- openxlsx::createWorkbook()


for(i in 1:length(myfiles)){
  
  file_path <- myfiles[i]
  
  file_path2 = str_replace(file_path, '/', '_')
  file_path2 = str_replace(file_path2, '.csv', '')
  file_path2 = str_replace(file_path2, 'data_TechOnline_sales_', '')
  
  df <- read.csv(file = file_path, header = T)
  
  addWorksheet(wb, sheetName = file_path2)
  
  writeData(wb, file_path2, df)
}

sheets(wb)
openxlsx::openXL(wb)

?openxlsx::sheetVisibility

sheetVisibility(wb)[1:(length(myfiles)-1)] = FALSE 

openxlsx::openXL(wb)


saveWorkbook(wb, file = 'SalesReport.xlsx', overwrite = T)


# non covered important functions ----

?openxlsx::createComment

?openxlsx::dataValidation

?openxlsx::deleteData

?openxlsx::freezePane

?openxlsx::replaceStyle

?openxlsx::pageSetup

?openxlsx::writeFormula







