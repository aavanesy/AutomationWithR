############# IMPORTANT ################
# Dont forget set current folder as working directory #
# Pane Files >> More (little Blue Settings Icon) >> Set as Working Directory

# or run
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


library(tidyverse)
library(htmltools)

library(emayili)
# https://datawookie.github.io/emayili/



# configure connection ----

smtp <- emayili::server(host = "smtp.gmail.com",
                        port = 465,
                        username="rprogr2021@gmail.com",
                        password= ".......")

source('credentials.R')

# create and send test email ----

?envelope

email <- envelope()

recipient <- "rprogr2021@gmail.com"

email <- email %>%
  from(recipient) %>% 
  to(c('rprogr2021@gmail.com')) %>% 
  cc(c('rprogr2021@gmail.com'))


email <- email %>% subject("test")

smtp(email, verbose = T)

smtp(email, verbose = F)

paste('Email sent on', Sys.time())


# email body ----
?emayili::html

email <- envelope()

email <- email %>%
  from('rprogr2021@gmail.com') %>%
  to(c('rprogr2021@gmail.com')) %>% 
  cc(c('rprogr2021@gmail.com'))

email_body <- 'Some text'

email <- email %>% emayili::html(email_body)

smtp(email, verbose = F)

#add html

email <- envelope()

email <- email %>%
  from('rprogr2021@gmail.com') %>%
  to(c('rprogr2021@gmail.com')) %>% 
  cc(c('rprogr2021@gmail.com'))

email_body = paste('<html>', 
               
               'Some content',
               
               '</html>')

email <- email %>% emayili::html(email_body)

smtp(email, verbose = F)

# ....

email <- envelope()

email <- email %>%
  from('rprogr2021@gmail.com') %>%
  to(c('rprogr2021@gmail.com')) %>% 
  cc(c('rprogr2021@gmail.com'))

email_body = paste(
               
               '<b>',
               'Some bold content',
               '</b>'
               
               )

email <- email %>% emayili::html(email_body)

smtp(email, verbose = F)


# text color

email <- envelope()

email <- email %>%
  from('rprogr2021@gmail.com') %>%
  to(c('rprogr2021@gmail.com')) %>% 
  cc(c('rprogr2021@gmail.com'))

email_body = paste(
               '<b>',
               
               "<span style=\"color:red\">Text in red</span>",
               
               '</b>'
               )

email <- email %>% emayili::html(email_body)

smtp(email, verbose = F)


# hyperlink and paragraph

email <- envelope()

email <- email %>%
  from('rprogr2021@gmail.com') %>%
  to(c('rprogr2021@gmail.com')) %>% 
  cc(c('rprogr2021@gmail.com'))

email_body = paste(
              '<b>',
              'Some bold content',
              '</b>',
  
               '<p>',
               
               a("My website", href="https://google.com/"),
               
               '</p>')

email <- email %>% emayili::html(email_body)

smtp(email, verbose = F)


# attachment 

email <- envelope()

email <- email %>%
  from('rprogr2021@gmail.com') %>%
  to(c('rprogr2021@gmail.com', 'aavanesy@outlook.com')) %>% 
  cc(c('rprogr2021@gmail.com'))

email_body_one = paste(
                   
                   '<b>',
                   "<span style=\"color:red\">Text in red</span>",
                   '</b>')

email_body_two = paste(
                   
                   '<p>',
                   
                   a("My website", href="https://google.com/"),
                   
                   '</p>')

email_body = paste(email_body_one, email_body_two)

email <- email %>% emayili::html(email_body)

my_file = 'attachment.txt'

email <- email %>% attachment(my_file)

smtp(email, verbose = F)


