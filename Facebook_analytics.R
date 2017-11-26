
setwd("E:/Kaggle/Google_analytics")
#load the libraries

library(Rfacebook)

fb_oauth <- fbOAuth(app_id="1764156620545375", app_secret="5b9bf28661d070c324f202c8ff035260")

save(fb_oauth,file = "./fb_token")

myprofile<-getUsers("me", token = fb_oauth)
myfriends<-getFriends(token = fb_oauth,simplify = TRUE)

pg.data<-getPage("google",token = fb_oauth,n=100)

View(pg.data)
pg.data$message

pg.data<-getPage("55593830907",token = fb_oauth,n=10)
head(pg.data$message)

fb_friend<-getUsers("100002478667389",token = fb_oauth, private_info = TRUE)
View(fb_friend)
