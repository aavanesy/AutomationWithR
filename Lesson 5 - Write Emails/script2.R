
library(tidyverse)
library(htmltools)


library(emayili)
# https://datawookie.github.io/emayili/

source('credentials.R')

email <- envelope()

email <- email %>%
  from('rprogr2021@gmail.com') %>%
  to(c('rprogr2021@gmail.com','aavanesy@outlook.com'))


email <- email %>% subject("test")

mytext = paste('<html><body>', 
               
               '<b>',
               "<span style=\"color:red\">Text in red</span>",
               '</b>',
               
               '</body></html>')

email <- email %>% emayili::html(mytext)


mytext = paste('<html><body>', 
               
               '<p>',
               
               a("My website", href="https://google.com/"),
               
               '</p>',
               
               '</body></html>')

email <- email %>% emayili::html(mytext)

smtp(email, verbose = F)