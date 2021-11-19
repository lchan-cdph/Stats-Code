library(readxl)
library(lubridate)
setwd("C:\\Users\\lawrence chan\\OneDrive - County of Orange\\Desktop")
calls_df=as.data.frame(read_xlsx("C:\\Users\\lawrence chan\\OneDrive - County of Orange\\Desktop\\All Calls Draft V2.xlsx", 1))

calls_df$CTime = gsub(":[0-9][0-9]:",":00:",calls_df$`Call Start Time`)
calls_df$dow   = as.character(wday(calls_df$Date))

df = calls_df[,c("CTime","dow","Result2")]

calls_L = split(df,df$Result2)

hourly_call_avgs_L =lapply(calls_L,function(x){
  day_hour_count = sapply(split(x, x$CTime),nrow)
  times = substr(names(day_hour_count),12,13)
  names(day_hour_count) = NULL
  x=sapply(split(day_hour_count,times),mean)
  return(x)
})

hourly_call_avgs_dow_L =lapply(calls_L,function(y){
  dow_L = split(y,y$dow)
  y =lapply(dow_L,function(x) {
    day_hour_count = sapply(split(x, x$CTime),nrow)
    times = substr(names(day_hour_count),12,13)
    names(day_hour_count) = NULL
    x=sapply(split(day_hour_count,times),mean)
    return(x)
  })
  names(y) = as.character(wday(as.numeric(names(y)),label = T))
  return(y)
})

