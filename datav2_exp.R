library(tidyverse)
library(lubridate)
library(ggplot2)
library(gridExtra)
library(ggmap)


#rtr <- read_rds('Datav2/RTRv2.rds')
#calls <- read_rds('Datav2/CAllsv2.rds')
#persons <- read_rds('Datav2/personsv2.rds')
#mo <- read_rds('Datav2/MOv2.rds')
incid <- read_rds('Datav2/incidentsv2.rds')

#NEEDS MORE WORK TO CORRECT FOR DATE SOURCE

#wi <- incid %>% select(Incident.Number,Year.of.Incident,Date1.of.Occurrence,Year1.of.Occurrence,Month1.of.Occurrence,
#                       Time1.of.Occurrence,Day1.of.the.Year,Call.Received.Date.Time,
#                       Call.Date.Time,Call.Cleared.Date.Time,Call.Dispatch.Date.Time,Victim.Race,Victim.Ethnicity,
#                       Victim.Gender,Victim.Age,Victim.Age.at.Offense,Victim.Zip.Code,Responding.Officer.1.Badge.No,
#                       Responding.Officer.2.Badge.No,X.Coordinate,Y.Coordinate,Zip.Code,xcoord,ycoord,calcMonth) %>%
#               mutate(Day1.of.the.Year=factor(Day1.of.the.Year,levels=c(1:366)))

#saveRDS(wi,'Datav2/condensed_incid.rds')

wi <- read_rds('Datav2/condensed_incid.rds')

#w2015 <- wi %>% select(Date1.of.Occurrence,Day1.of.the.Year) %>% filter(Date1.of.Occurrence >= '2015-01-01' & Date1.of.Occurrence <= '2015-12-31') %>% group_by(Day1.of.the.Year) %>% mutate(cn2015=n()) %>% arrange(Day1.of.the.Year)
#w2016 <- wi %>% select(Date1.of.Occurrence,Day1.of.the.Year) %>% filter(Date1.of.Occurrence >= '2016-01-01' & Date1.of.Occurrence <= '2016-12-31') %>% group_by(Day1.of.the.Year) %>% mutate(cn2016=n()) %>% arrange(Day1.of.the.Year) 
#w2017 <- wi %>% select(Date1.of.Occurrence,Day1.of.the.Year) %>% filter(Date1.of.Occurrence >= '2017-01-01' & Date1.of.Occurrence <= '2017-12-31') %>% group_by(Day1.of.the.Year) %>% mutate(cn2017=n()) %>% arrange(Day1.of.the.Year)

mdf <- wi %>% select(Date1.of.Occurrence) %>% filter(Date1.of.Occurrence >= '2015-01-01' & Date1.of.Occurrence <= '2017-12-31') %>% group_by(Date1.of.Occurrence) %>% mutate(Year.of.Occurrence=year(Date1.of.Occurrence),Day.of.Year=yday(Date1.of.Occurrence),cn=n()) %>% arrange(Date1.of.Occurrence)
mdf <- unique(mdf)
w2015 <- mdf  %>% filter(Year.of.Occurrence==2015)
w2016 <- mdf  %>% filter(Year.of.Occurrence==2016)
w2017 <- mdf  %>% filter(Year.of.Occurrence==2017)

#mdf <- wi %>% filter(Date1.of.Occurrence == '2015-07-07') %>% arrange(Incident.Number)

#######################################################################################



dallas <- get_map(c(lon=-96.7988235,lat=32.7774442),zoom=10)
DallasMap <- ggmap(dallas,extent="panel",legend="topright")

DallasMap + stat_density2d(aes(x=xcoord,y=ycoord),size=2,bins=4,data=mdf,geom="polygon")

DallasMap + geom_point(aes(x=xcoord,y=ycoord),data=mdf,color="red")


exp <- filter(wi, Date1.of.Occurrence=='2017-01-01')



lsize=1

 smpl <- filter(w2017,Day.of.Year<101) 
   

  ggplot() +
  geom_line(aes(x=Day.of.Year,y=cn,color='2017'),smpl,na.rm=TRUE,size=lsize) +
  geom_line(aes(x=Day.of.Year,y=mean(cn),color='mean'),smpl,na.rm=TRUE,size=lsize) +  
  scale_color_manual(name="Year",values=c('mean'="red", '2017'="black")) +
  labs(x='Day of the Year',y='Number of Incidents',title='Incidents Per Day')



ggplot() +
  geom_line(aes(x=doy2015,y=cn,color='2015'),w2015,na.rm=TRUE,size=lsize) +
  geom_line(aes(x=doy2016,y=cn,color='2016'),w2016,na.rm=TRUE,size=lsize) +
  geom_line(aes(x=doy2017,y=cn,color='2017'),w2017,na.rm=TRUE,size=lsize) +
  scale_color_manual(name="Year",values=c('2015'="red", '2016'="blue", '2017'="black")) +
  labs(x='Day of the Year',y='Number of Incidents',title='Incidents Per Day')


#######################################################################################
#mxx <- -96.556819
#mnx <- -96.999444
#mxy <- 33.017063
#mny <- 32.619478

mxx <- 2540000
mnx <- 2450000
mxy <- 7025000
mny <- 6925000

w2015<- select(wi,Incident.Number,Year.of.Incident,X.Coordinate,Y.Coordinate) %>% filter(is.na(X.Coordinate)==FALSE,Year.of.Incident==2015,X.Coordinate > mnx & X.Coordinate < mxx,Y.Coordinate > mny & Y.Coordinate < mxy)
#w2015<- select(wi,Incident.Number,Year.of.Incident,X.Coordinate,Y.Coordinate) %>% filter(is.na(X.Coordinate)==FALSE,Year.of.Incident==2015)
w2015 <- w2015 %>% select(X.Coordinate,Y.Coordinate) %>% group_by(X.Coordinate,Y.Coordinate) %>% mutate(cnt=n())


#View(w2015)
#ng <- w2015 %>% select(Incident.Number) %>% group_by(Incident.Number) %>% mutate(cn=n())
#ng2 <- filter(ng,cn>1)
#idx <- which(w2015$Incident.Number %in% ng2$Incident.Number)

w2016<- select(wi,Year.of.Incident,X.Coordinate,Y.Coordinate) %>% filter(Year.of.Incident==2016,X.Coordinate > mnx & X.Coordinate < mxx,Y.Coordinate > mny & Y.Coordinate < mxy)
w2016 <- w2016 %>% select(X.Coordinate,Y.Coordinate) %>% group_by(X.Coordinate,Y.Coordinate) %>% mutate(cnt=n())

w2017<- select(wi,Incident.Number,Year.of.Incident,X.Coordinate,Y.Coordinate) %>% filter(Year.of.Incident==2017,X.Coordinate > mnx & X.Coordinate < mxx,Y.Coordinate > mny & Y.Coordinate < mxy)
w2017 <- w2017 %>% select(X.Coordinate,Y.Coordinate) %>% group_by(X.Coordinate,Y.Coordinate) %>% mutate(cnt=n())

#w2015 <- mutate(w2015,ycoord=round(ycoord,6),xcoord=round(xcoord,6))
#w2016 <- mutate(w2016,ycoord=ycoord+.6,xcoord=xcoord+.6)
#w2017 <- mutate(w2017,ycoord=ycoord-.6,xcoord=xcoord-.6)

#summarize(w2015,mxx=max(xcoord),mxy=max(ycoord),mnx=min(xcoord),mny=min(ycoord),medx=median(xcoord),medy=median(ycoord),meanx=mean(xcoord),meany=mean(ycoord),sdx=sd(xcoord),sdy=sd(ycoord))
#summarize(w2016,mxx=max(xcoord),mxy=max(ycoord),mnx=min(xcoord),mny=min(ycoord),medx=median(xcoord),medy=median(ycoord),meanx=mean(xcoord),meany=mean(ycoord),sdx=sd(xcoord),sdy=sd(ycoord))
#summarize(w2017,mxx=max(xcoord),mxy=max(ycoord),mnx=min(xcoord),mny=min(ycoord),medx=median(xcoord),medy=median(ycoord),meanx=mean(xcoord),meany=mean(ycoord),sdx=sd(xcoord),sdy=sd(ycoord))

specialsy <- c(32.783960,32.843002,32.738252,32.744253,32.703065,32.832777,32.646958,32.680523,32.717153)
specialsx <- c(-96.783417,-96.796746,-96.888121,-96.726645,-96.716288,-96.723129,-96.908818,-96.867250,-96.963997)
specialsn <- c('Deep Ellum','Highland Park','Cockrell Hill','Blair Park','Trinity Greenbelt','Whiterock Lake','Duncanville','Dallas Exec Airport','Mountain Creek Lake')
#,'Cotton Bowl'  ,-96.7595458   ,32.779484   'City Hall', -96.797031,32.776328,
specials <- data.frame(name=specialsn,x=specialsx,y=specialsy)

w2015 <- arrange(w2015,X.Coordinate,Y.Coordinate)


#p1 <- 
  ggplot() + labs(x='Longitude',y='Latitude',title='Incidents for 2015') + geom_point(aes(x=w2015$X.Coordinate,y=w2015$Y.Coordinate),color='red',na.rm=TRUE) + geom_density_2d() #+
#   geom_text(aes(x=specials$x,y=specials$y,label=specials$name),color='blue',na.rm=TRUE)
#p2 <- 
  ggplot() + labs(x='Longitude',y='Latitude',title='Incidents for 2016') + geom_point(aes(x=w2016$X.Coordinate,y=w2016$Y.Coordinate),color='blue',na.rm=TRUE) + geom_density_2d() #+
#  geom_text(aes(x=specials$x,y=specials$y,label=specials$name),color='red',na.rm=TRUE)
#p3 <- 
  ggplot() + labs(x='Longitude',y='Latitude',title='Incidents for 2017') + geom_point(aes(x=w2017$X.Coordinate,y=w2017$Y.Coordinate),na.rm=TRUE) + geom_density_2d() #+
#  geom_text(aes(x=specials$x,y=specials$y,label=specials$name),color='red',na.rm=TRUE)

#grid.arrange(p1, p2, p3)


DallasMap <- qmap("dallas",zoom=14,color="bw",legend="topright")
DallasMap + geom_point(aes(x=X.Coordinate,y=Y.Coordinate),data=w2015,color="red")

dallas <- get_map('dallas',zoom=14)
DallasMap <- ggmap("dallas",extent="device",legend="topright")

DallasMap + stat_density2d(aes(x=X.Coordinate,y=Y.Coordinate),size=2,bins=4,data=w2015,geom="polygon")


wg <- wi %>% select(Responding.Officer.1.Badge.No,Year1.of.Occurrence) %>% 
  filter(is.na(Responding.Officer.1.Badge.No)==FALSE & is.na(Year1.of.Occurrence)==FALSE) %>% 
  group_by(Responding.Officer.1.Badge.No,Year1.of.Occurrence) %>% summarise(nc=n()) %>%
  arrange(Responding.Officer.1.Badge.No,Year1.of.Occurrence,nc)



#top 5
{
  w10 <- wg[1:5,]
  }

