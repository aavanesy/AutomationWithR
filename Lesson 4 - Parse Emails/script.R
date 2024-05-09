############# IMPORTANT ################
# Dont forget set current folder as working directory #
# Pane Files >> More (little Blue Settings Icon) >> Set as Working Directory

# or run
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


library(mRpostman)
#https://cran.r-project.org/web/packages/mRpostman/vignettes/basics.html

library(tidyverse)

# configure connection ----

?configure_imap

  # Outlook
  con <- configure_imap(url="imaps://outlook.office365.com",
                        username="email@outlook.com",
                        password= "......."
  )

  con$list_mail_folders()

  # Gmail
  con <- configure_imap(url="imaps://imap.gmail.com:993",
                        username="rprogr2021@gmail.com",
                        password= "......."
  )
  
  con$list_mail_folders()

  source('credentials.R')
  
  #less secure apps for gmail
  
  con$list_mail_folders()
    

# navigate through folders and find emails ----
    
    con$select_folder(name = "INBOX")
  
  #search options

  #by date: before a date, after a date, on a date 
  #by expression: sender, recipients, subject, body
  #other: by flag, fize, other
  
  #combine using AND, OR
  
    date_since = "07-Jun-2021"
    
    date_since = format(Sys.Date() - 7,  "%d-%b-%Y")
    class(date_since)
    date_since
  
    email_content <- con$search(AND(
      since(date_char = date_since),
      string(expr = "rprogr2021@gmail.com", where = "FROM")
    ))
    
    #returns an index
    email_content
    class(email_content)
        
# fetch email content ----     
        
    email_content <- email_content %>%
      con$fetch_body()
    
    email_content
    
    length(email_content)
    names(email_content)
    
    email_i = email_content[[1]]
    email_i
    
    email_i = str_replace(email_i, '=\r\n', '')
    email_i = str_split(email_i, '\r\n')
    email_i = email_i[[1]]

    data.frame(Content = email_i) %>% View()
  
    nchar(email_i)
    
    email_i <- data.frame(Content = email_i) %>% 
      filter(nchar(Content) != 76) %>% 
      filter(Content != '')
    
    email_i %>% View()
    
    email_i <- email_i %>% 
      filter(!str_detect(Content, '--000000000000'))
    
    email_i %>% View()
    
    keywords <- c('From:','To:','Subject:','Date:', 
                  'Content-Disposition: inline;',
                  'Content-Disposition: attachment;')
    
    
    keywords <- paste(keywords, collapse = '|')
  
    find_kw = str_detect(email_i$Content, keywords)
    
    email_i[find_kw,]
    
    find_content = str_detect(email_i$Content, 'UTF-8') %>% which()
    #find_content = str_detect(email_i$Content, 'utf-8') %>% which()

    email_i[(find_content[1] + 1):(find_content[2] - 1),]
        
        
# fetch email attachments ----            
        
    con$search(AND(
      since(date_char = date_since),
      string(expr = "rprogr2021@gmail.com", where = "FROM")
    )) %>%
      con$fetch_attachments_list()
    
    
    con$search(AND(
      since(date_char = date_since),
      string(expr = "rprogr2021@gmail.com", where = "FROM")
    )) %>%
      con$fetch_attachments()
    
    
    files = list.files('rprogr2021@gmail.com', full.names = T, recursive = T)
    
    ff = read.csv(files[1])
    
    head(ff)
    
    unlink('rprogr2021@gmail.com',recursive = T)
        
        