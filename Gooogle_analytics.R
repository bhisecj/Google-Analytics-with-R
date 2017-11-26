#set current working directory

setwd("E:/Kaggle/Google_analytics")

#load the google analytics libraries
library(RGoogleAnalytics)


client.id<-'360198131753-pr526hsofavllrelhehk1c081ffb81k3.apps.googleusercontent.com'
client.secret.key<-'IIslILrQ1Jly4f1Fhsnrf6JL'


#Authenticate the app to use google analytics api

token<-Auth(client.id,client.secret.key)
ValidateToken(token)

#save token for future use

save(token, file = "./token_file")
load("./token_file")

#build query to get month-wise pageviews and new users to the site

query.list<-Init(start.date = "2015-01-01",end.date = "2017-11-21",dimensions = "ga:month,ga:year",
                 metrics = "ga:pageviews,ga:newUsers",sort = "ga:year",table.id = "ga:82809247")

#query to get users captured through "WinTheWorld" campaign

query.list<-Init(start.date = "2015-01-01",end.date = "2017-11-21",dimensions = "ga:date",
                 metrics = "ga:transactions,ga:transactionRevenue",
                 segment = "users::sequence::
                 ^ga:userType== New Visitor;dateOfSession<>2015-01-01_2017-11-21;
                 ga:campaign==WinTheWorld;
                 ->>perSession::ga:transactions>0",
                 sort="ga:date",
                 table.id = "ga:82809247"
                 )

query.list<-Init(start.date = "2017-01-01",end.date = "2017-11-21",dimensions = "ga:city,ga:country,ga:browser",
                 metrics = "ga:hits",
                 sort = "ga:browser",table.id = "ga:82809247")

#ga:organicSearches,ga:impressions,ga:adClicks,ga:adCost,ga:CPM,ga:CPC

ga.query<-QueryBuilder(query.list)

ga.data<-GetReportData(ga.query,token)

library(ggplot2)
ggplot(data=ga.data,aes(x=ga.data$country,y=ga.data$hits))+geom_bar(stat="identity")+facet_wrap(~ga.data$browser)+theme_bw()

# Create the Query Builder object so that the query parameters are validated

ga.query<-QueryBuilder(query.list)

ga.data<-GetReportData(ga.query,token)


# load library to forcast future trends in pageviews and new users

library(forecast)

#build time series object

ts.data<-ts(data = ga.data$pageviews,start =c(2015,01,01),end = c(2017,11,21),frequency = 12)

#plot time series

plot.ts(ts.data)

#automated forcasting using exponential smoothing model

fit<-ets(ts.data)
accuracy(fit)
plot.ts(fit$residuals)

#forecat pageviews trend for next 4 months

trend<-forecast(fit,4)
