
require(dplyr)
require(readr)
require(stringr)
require(reshape2)

#setwd("~/GITHUB/ABXBEESURV")
suppressWarnings(dir.create("air_quality_data"))
suppressWarnings(dir.create("tables"))


#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# 1) Download Historic Air Quality Data from Government of Canada 
#    (https://data-donnees.az.ec.gc.ca/data/air/monitor/national-air-pollution-surveillance-naps-program)
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

download.file("https://data-donnees.az.ec.gc.ca/api/file?path=/air%2Fmonitor%2Fnational-air-pollution-surveillance-naps-program%2FData-Donnees%2F2014%2FContinuousData-DonneesContinu%2FAnnualSummaries-SommairesAnnuels%2F2014_Means.xlsx",
              destfile=paste("air_quality_data/2014_Means.xlsx", sep=""), mode="wb")
download.file("https://data-donnees.az.ec.gc.ca/api/file?path=/air%2Fmonitor%2Fnational-air-pollution-surveillance-naps-program%2FData-Donnees%2F2015%2FContinuousData-DonneesContinu%2FAnnualSummaries-SommairesAnnuels%2F2015_Means.xlsx",
              destfile=paste("air_quality_data/2015_Means.xlsx", sep=""), mode="wb")
download.file("https://data-donnees.az.ec.gc.ca/api/file?path=/air%2Fmonitor%2Fnational-air-pollution-surveillance-naps-program%2FData-Donnees%2F2016%2FContinuousData-DonneesContinu%2FAnnualSummaries-SommairesAnnuels%2F2016_Means_EN.xlsx",
              destfile=paste("air_quality_data/2016_Means_EN.xlsx", sep=""), mode="wb")
download.file("https://data-donnees.az.ec.gc.ca/api/file?path=/air%2Fmonitor%2Fnational-air-pollution-surveillance-naps-program%2FData-Donnees%2F2017%2FContinuousData-DonneesContinu%2FAnnualSummaries-SommairesAnnuels%2F2017_Means_EN.xlsx",
              destfile=paste("air_quality_data/2017_Means_EN.xlsx", sep=""), mode="wb")
download.file("https://data-donnees.az.ec.gc.ca/api/file?path=/air%2Fmonitor%2Fnational-air-pollution-surveillance-naps-program%2FData-Donnees%2F2018%2FContinuousData-DonneesContinu%2FAnnualSummaries-SommairesAnnuels%2F2018_Means_EN.xlsx",
              destfile=paste("air_quality_data/2018_Means_EN.xlsx", sep=""), mode="wb")
download.file("https://data-donnees.az.ec.gc.ca/api/file?path=/air%2Fmonitor%2Fnational-air-pollution-surveillance-naps-program%2FData-Donnees%2F2019%2FContinuousData-DonneesContinu%2FAnnualSummaries-SommairesAnnuels%2F2019_Means_EN.xlsx",
              destfile=paste("air_quality_data/2019_Means_EN.xlsx", sep=""), mode="wb")
download.file("https://data-donnees.az.ec.gc.ca/api/file?path=/air%2Fmonitor%2Fnational-air-pollution-surveillance-naps-program%2FData-Donnees%2F2020%2FContinuousData-DonneesContinu%2FAnnualSummaries-SommairesAnnuels%2F2020_Means_EN.xlsx",
              destfile=paste("air_quality_data/2020_Means_EN.xlsx", sep=""), mode="wb")
download.file("https://data-donnees.az.ec.gc.ca/api/file?path=/air%2Fmonitor%2Fnational-air-pollution-surveillance-naps-program%2FData-Donnees%2F2021%2FContinuousData-DonneesContinu%2FAnnualSummaries-SommairesAnnuels%2F2021_Means_EN.xlsx",
              destfile=paste("air_quality_data/2021_Means_EN.xlsx", sep=""), mode="wb")
download.file("https://data-donnees.az.ec.gc.ca/api/file?path=/air%2Fmonitor%2Fnational-air-pollution-surveillance-naps-program%2FData-Donnees%2F2022%2FContinuousData-DonneesContinu%2FAnnualSummaries-SommairesAnnuels%2F2022_Means_EN.xlsx",
              destfile=paste("air_quality_data/2022_Means_EN.xlsx", sep=""), mode="wb")

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# 2) Add province information and adjust year to match CAPA survey bee years
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

city.prov <- readr::read_tsv("city_prov_index.tsv")
city.prov.index <- setNames(city.prov$Province, 
                            city.prov$City)

air2014 <- readxl::read_xlsx("air_quality_data/2014_Means.xlsx", 
                             sheet="Means Report") %>% 
  mutate(Year = 2014) %>% 
  mutate(Year_lag = Year+1) %>% 
  mutate(Province = dplyr::recode(!!!city.prov.index, 
                                  City, .missing="0"))

air2015 <- readxl::read_xlsx("air_quality_data/2015_Means.xlsx", 
                             sheet="Means Report") %>% 
  mutate(Year = 2015) %>% 
  mutate(Year_lag = Year+1) %>% 
  mutate(Province = dplyr::recode(!!!city.prov.index, City, .missing="0"))

air2016 <- readxl::read_xlsx("air_quality_data/2016_Means_EN.xlsx", 
                             sheet="Means Report") %>% 
  mutate(Year = 2016) %>% 
  mutate(Year_lag = Year+1) %>% 
  mutate(Province = dplyr::recode(!!!city.prov.index, 
                                  City, .missing="0"))
air2017 <- readxl::read_xlsx("air_quality_data/2017_Means_EN.xlsx", 
                             sheet="Means Report") %>% 
  mutate(Year = 2017) %>%
  mutate(Year_lag = Year+1) %>% 
  mutate(Province = dplyr::recode(!!!city.prov.index, 
                                  City, .missing="0"))

air2018 <- readxl::read_xlsx("air_quality_data/2018_Means_EN.xlsx", 
                             sheet="Means Report") %>% 
  mutate(Year = 2018) %>% 
  mutate(Year_lag = Year+1) %>% 
  mutate(Province = dplyr::recode(!!!city.prov.index, 
                                  City, .missing="0"))
air2019 <- readxl::read_xlsx("air_quality_data/2019_Means_EN.xlsx", 
                             sheet="Means Report") %>% 
  mutate(Year = 2019) %>% 
  mutate(Year_lag = Year+1) %>% 
  mutate(Province = dplyr::recode(!!!city.prov.index, 
                                  City, .missing="0"))
air2020 <- readxl::read_xlsx("air_quality_data/2020_Means_EN.xlsx", 
                             sheet="Means Report") %>% 
  mutate(Year = 2020) %>% 
  mutate(Year_lag = Year+1) %>% 
  mutate(Province = dplyr::recode(!!!city.prov.index, 
                                  City, .missing="0"))
air2021 <- readxl::read_xlsx("air_quality_data/2021_Means_EN.xlsx", 
                             sheet="Means Report") %>% 
  mutate(Year = 2021) %>% 
  mutate(Year_lag = Year+1) %>% 
  mutate(Province = dplyr::recode(!!!city.prov.index, 
                                  City, .missing="0"))

air2022 <- readxl::read_xlsx("air_quality_data/2022_Means_EN.xlsx", 
                             sheet="Means Report") %>% 
  mutate(Year = 2022) %>% 
  mutate(Year_lag = Year+1) %>% 
  mutate(Province = dplyr::recode(!!!city.prov.index, 
                                  City, .missing="0"))

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# 3) Calculate means per province
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#unique(air.all$City)
#nrow(air.all %>% filter(Pollutant!="PM10"))#/length(unique(air.all$Pollutant))

suppressWarnings(
  air.all <- rbind(air2014, 
                 air2015, 
                 air2016, 
                 air2017, 
                 air2018,
                 air2019, 
                 air2020, 
                 air2021,
                 air2022) %>%
  melt(., id.var=c("NAPS ID", 
                   "Province",
                   "City", 
                   "Year",
                   "Year_lag", 
                   "Latitude",
                   "Longitude",
                   "Elevation", 
                   "Pollutant")) %>% 
  filter(grepl("January|February|March|April|May|June|July|August|September|October|November|December", 
               variable)) %>% 
  droplevels() %>%
  mutate_at(vars(value), 
            as.numeric) %>%
  mutate(Year_beeyear_lag = ifelse(grepl("January|February",variable), 
                                   Year_lag -1 , 
                                   Year_lag)) %>%
  mutate(seasons = case_when(
    grepl("March|April|May", variable) ~ "Spring",
    grepl("June|July|August", variable) ~ "Summer",
    grepl("September|October|November", variable) ~ "Fall",
    grepl("December|January|February", variable) ~ "Winter",
    TRUE ~ "ns")) %>%
  group_by(Province, Pollutant, 
           Year_beeyear_lag) %>%
  mutate(mean_spring = ifelse(seasons == "Spring", 
                              value, NA)) %>% 
  mutate(mean_spring = mean(mean_spring, 
                                             na.rm=TRUE)) %>% 
  mutate(mean_spring = ifelse(mean_spring == "NaN", 
                              NA, mean_spring)) %>%
  mutate(mean_summer = ifelse(seasons == "Summer",
                              value, NA)) %>% 
  mutate(mean_summer = mean(mean_summer, 
                                             na.rm=TRUE)) %>% 
  mutate(mean_summer = ifelse(mean_summer == "NaN", 
                              NA, mean_summer)) %>%
  mutate(mean_fall = ifelse(seasons == "Fall", 
                            value, NA)) %>% 
  mutate(mean_fall = mean(mean_fall, 
                                           na.rm=TRUE)) %>%
  mutate(mean_fall = ifelse(mean_fall == "NaN",
                            NA, mean_fall)) %>%
  mutate(mean_winter = ifelse(seasons == "Winter", 
                              value, NA)) %>% 
  mutate(mean_winter = mean(mean_winter, 
                                             na.rm=TRUE)) %>% 
  mutate(mean_winter = ifelse(mean_winter == "NaN", 
                              NA, mean_winter)) %>%
  ungroup() %>%
  group_by(Year_beeyear_lag, 
           Province, 
           Pollutant) %>% 
  mutate(test = paste(Year_beeyear_lag, 
                      Province, 
                      Pollutant, 
                      sep="_")) %>% 
  mutate(mean_value = mean(value,
                           na.rm =TRUE)) %>%
  slice(1) %>%
  ungroup()
)
  

readr::write_tsv(air.all, "tables/air_quality_data_adj.tsv")



