############# IMPORTANT ################
# Dont forget set current folder as working directory #
# Pane Files >> More (little Blue Settings Icon) >> Set as Working Directory

# or run
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


library(tidyverse)
library(officer)
library(htmltab)

# create or open pptx object ----

?read_pptx
ppt <- read_pptx() 

?pptx_summary
officer::pptx_summary(ppt)

#list of length 0 (each is slide)

# or load existing
ppt <- read_pptx('Deck.pptx') 

officer::pptx_summary(ppt)

?add_slide
ppt <- add_slide(ppt, layout = "Title and Content", master = "Office Theme")

length(ppt)
officer::pptx_summary(ppt)


# save on drive ----

file_target <- 'Report.pptx'

print(ppt, target = file_target)


tempfile <- tempfile(fileext  = '.pptx')  

print(ppt, target = tempfile)

tempfile

# str_replace_all(tempfile, '\\\\', '/')

# load some content ----

url <- "https://www.x-rates.com/table/?from=USD&amount=1"

table_rates <- htmltab(url, 1)

str(table_rates)

table_rates[,2] = table_rates[,2] %>% as.numeric() %>% round(3)
table_rates[,3] = table_rates[,3] %>% as.numeric() %>% round(3)

table_rates


# write basic report ----

today <- format(Sys.Date(), "%B %d, %Y")

text_one <- paste('FX Rates as of', today)

ppt <- read_pptx() 

ppt <- add_slide(ppt, layout = "Title and Content", master = "Office Theme")

?ph_with
ppt <- ph_with(ppt, value = text_one, location = ph_location_type(type = "title"))

ppt <- ph_with(ppt, value = table_rates, 
               location = ph_location_type('body') )

ppt <- ph_with(ppt, value = url, location = ph_location_type('ftr'))

file_target <- 'Report.pptx'

print(ppt, target = file_target)



# text customization ----

?fp_text

custom_text_format <- fp_text(color = "#324C63",
                              font.size = 18,
                              bold = FALSE,
                              italic = FALSE,
                              underlined = FALSE,
                              font.family = "Calibri")

?fp_par

custom_parag_format <- fp_par(text.align = "center",
                          padding = 0,
                          line_spacing = 1
                        )


?fpar
par1 <- fpar(ftext(text_one, prop = custom_text_format),
             fp_p = custom_parag_format)


ppt <- read_pptx() 

ppt <- add_slide(ppt, layout = "Title and Content", master = "Office Theme")

ppt <- ph_with(ppt, value = par1, 
               location = ph_location_type('title') )


file_target <- 'Report.pptx'

print(ppt, target = file_target)


# formatted table ----

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

table_rates_ft

ppt <- read_pptx() 

ppt <- add_slide(ppt, layout = "Title and Content", master = "Office Theme")

ppt <- ph_with(ppt, value = table_rates_ft, 
               location = ph_location_type('body') )

ppt <- add_slide(ppt, layout = "Title and Content", master = "Office Theme")

ppt <- ph_with(ppt, value = table_rates_ft, 
               location = ph_location(left = 3, top = 2) )

file_target <- 'Report.pptx'

print(ppt, target = file_target)





