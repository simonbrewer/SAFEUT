## Simon's version

library(dplyr)
library(lubridate)
library(data.table)
library(timetk)
library(ggpubr)
library(tidyr)
library(sf)
library(spdep)
library(tmap)
library(INLA)
library(INLAutils)

load("./data/summeddata_for_inla2ax.RData")

dat_covid$Age10to19 <- ifelse(dat_covid$Age10to19 < 1, 1, dat_covid$Age10to19)
dat_ts$Age10to19 <- ifelse(dat_ts$Age10to19 < 1, 1, dat_ts$Age10to19)
dat_ts$covid <- ifelse(dat_ts$date<= "2020-03-01",0,1)

# SUMMER DUMMY
dat_ts$summer <- ifelse((dat_ts$date>= "2020-06-01" & dat_ts$date<= "2020-08-01") | (dat_ts$date>= "2019-06-01" & dat_ts$date<= "2019-08-01") ,1,0)

dat_ts <- dat_ts %>%
  mutate(crisis = ifelse(is.na(crisis), 0, crisis))

## Expected numbers
nbanxTS = sum(dat_ts$crisis) 
total_popnTS = sum(dat_ts$Age10to19)

## standard  rate
rsTS = nbanxTS / total_popnTS

#Estimate the expected number and SIRSIR
dat_ts$Ei <- rsTS * dat_ts$Age10to19
dat_ts$SIR <- dat_ts$crisis / dat_ts$Ei

#summary(dat_ts$SIR)

#INLA
#Setup
#Graph
nb2INLA("map.adj", dat_nb)
g <- inla.read.graph(filename = "map.adj")

