
library(dplyr)
library(lubridate)

# pattern one ----

#in project
?list.files
myfiles <- list.files(path = 'data', pattern = '.csv')

head(myfiles)

tail(myfiles)

length(myfiles)

# pattern two ----

myfiles <- list.files(path = 'data', pattern = 'TechOnline_sales') 

length(myfiles)

# full name

myfiles <- list.files(path = 'data', pattern = 'TechOnline_sales', full.names = TRUE)

head(myfiles)

# files in other folders ----

#using /
myfiles <- list.files(path = 'C:/Users/Work/Dropbox/data',
                      full.names = TRUE, pattern = '.csv')

head(myfiles)

length(myfiles)

## Aggregate data ----

myfiles <- list.files(path = 'data', pattern = 'TechOnline_sales', full.names = TRUE)

length(myfiles)

sales_data <- NULL

#read files using loops

# loop step 1 ----

for(i in 1:length(myfiles)){
  
  print(i)
  
}


# loop v2 ----

for(i in 1:length(myfiles)){
  
  print('------')
  
  print(i)
  
  file_path <- myfiles[i]
  
  print(file_path)
  
}

# loop v3 ----

?read.csv

for(i in 1:length(myfiles)){

  file_path <- myfiles[i]
  
  df <- read.csv(file = file_path, header = T)
  
  sales_data <- sales_data %>% 
    bind_rows(df)
  
}


# Overview and basic clean-up ----

# %>% operator

sales_data %>% head()

?dplyr::distinct

sales_data <- sales_data %>% 
  distinct()



?str

sales_data %>% str()


?as.Date

class('2020-05-30')

as.Date('2020-05-30', format = c("%Y-%m-%d"))

as.Date('2020-05-30', format = c("%Y-%m-%d")) + 10

as.Date('2020-05-30', format = c("%Y-%d-%m"))

as.Date('03/23/1980', format = c("%m/%d/%Y"))
as.Date('03/23/1980', format = c("%m/%d/%Y")) + 10

?dplyr::mutate

sales_data <- sales_data %>%
  mutate(Date = as.Date(Date))

sales_data %>% str()



# Task one: save data for each Region in separate files ----

?count
sales_data %>% count(Country)

?dplyr::filter
sales_north_america <- sales_data %>% 
  filter(Country %in% c('US','Canada','ANFJLKJ'))

sales_north_america %>% count(Country)


?dir.create
dir.create('Region Data')


?write.csv
?file.path
write.csv(sales_north_america, 
          file = file.path('Region Data', 'sales_north_america.csv'),
          row.names = F)

sales_europe <- sales_data %>% 
  filter(Country %in% c('UK','France'))

write.csv(sales_europe, 
          file = file.path('Region Data', 'sales_europe.csv'),
          row.names = F)


sales_data %>% 
  filter(Country %in% c('UK','France')) %>% 
  filter(Item %in% 'Mouse')

# Task two: calculate aggregate sales for this month (later to be sent by email) for US ----

current_month <- month(Sys.Date()) #later we automate

?month
sales_current_month <- sales_data %>% 
  filter(month(Date) == current_month) 

# quick check
sales_current_month %>% distinct(Date)

?pull

sales_us <- sales_current_month %>% 
  filter(Country %in% c('US')) %>% 
  pull(Sale_In_Local_Currency)

print(sales_us)

sales_us %>% sum()
sum(sales_us)

#some stats

sales_us %>% mean()

sales_us %>% max()

sales_us %>% min()

?summary
sales_us %>% summary()

