############# IMPORTANT ################
# Dont forget set current folder as working directory #
# Pane Files >> More (little Blue Settings Icon) >> Set as Working Directory

# or run
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


library(tidyverse)
library(officer)
library(htmltab)

# create or open docx object ----

?read_docx
doc <- read_docx()

?docx_summary
officer::docx_summary(doc)

# unlike pttx, no length, no pages
# continious content

# load existing
doc <- read_docx('template.docx') 

officer::docx_summary(doc)
class(doc)

# add content and save ----

body_add
?body_add_par #unformatted


doc <- read_docx()

doc <- doc %>% 
  body_add_par(value = 'Additional content', style = 'Normal') 


file_target <- 'Report.docx'

print(doc, target = file_target)


doc <- read_docx('template.docx') 


doc <- doc %>% 
  body_add_par(value = 'Additional content', style = 'Normal') 


file_target <- 'Report2.docx'

print(doc, target = file_target)





# formatted content (same as for pptx) ----

text_one = 'FX Rates Table'

custom_text_format <- fp_text(color = "grey",
                              font.size = 14,
                              bold = FALSE,
                              italic = FALSE,
                              underlined = FALSE,
                              font.family = "Calibri")

par1 <- fpar(ftext(text_one, prop = custom_text_format))


doc <- read_docx()

doc <- doc %>% 
  body_add_fpar(value = par1, style = 'Normal') %>% 
  body_add_par(value = 'Additional content', style = 'Normal') 


file_target <- 'Report.docx'

print(doc, target = file_target)


# adding a table (same as for pptx) ----

library(flextable)

url <- "https://www.x-rates.com/table/?from=USD&amount=1"

table_rates <- htmltab(url, 1)

str(table_rates)

table_rates[,2] = table_rates[,2] %>% as.numeric() %>% round(3)
table_rates[,3] = table_rates[,3] %>% as.numeric() %>% round(3)

table_rates_ft <- table_rates %>% 
  flextable() %>% 
  autofit() %>% 
  fontsize(part = "all", size = 9)


doc <- read_docx()

doc <- doc %>% 
  body_add_fpar(value = par1, style = 'centered') %>% 
  body_add_par(value = '', style = 'Normal') %>% 
  body_add_par(value = '', style = 'Normal') %>% 
  body_add_flextable(value = table_rates_ft)

doc <- doc %>% 
  body_add_break() %>% 
  body_add_par(value = 'This is page 2', style = 'Normal') 

file_target <- 'Report.docx'

print(doc, target = file_target)


