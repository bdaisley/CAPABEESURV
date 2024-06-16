require(dplyr)
require(readr)
require(stringr)
require(reshape2)

dir.create("climate_data")
#setwd("~/GITHUB/ABXBEESURV")
suppressWarnings(dir.create("climate_data"))
suppressWarnings(dir.create("tables"))

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# 1) Download Historical Climate Data from Government of Canada (https://climate.weather.gc.ca/)
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

for(i in 2014:2023){
  for(ii in 1:12){
    ii_filename <- ifelse(nchar(ii)==1, 
                          paste(0, 
                                ii, 
                                sep=""), 
                          ii)
    download.file(paste("https://climate.weather.gc.ca/prods_servs/cdn_climate_summary_report_e.html?intYear=", 
                        i, 
                        "&intMonth=", 
                        ii, 
                        "&prov=&dataFormat=csv&btnSubmit=Download+data",
                        sep=""), 
                  destfile=paste("climate_data/en_climate_summaries_All_", 
                                 ii_filename,
                                 "-", 
                                 i, 
                                 ".csv",
                                 sep=""), 
                  mode="wb")
    tmp.df <- read_csv(paste("climate_data/en_climate_summaries_All_", 
                             ii_filename, 
                             "-", 
                             i, 
                             ".csv", 
                             sep="")) %>%
      mutate(YYYY_MM = paste(i,
                             ii_filename, 
                             sep="_"))
    write_csv(tmp.df, 
              paste("climate_data/en_climate_summaries_All_", 
                    ii_filename, 
                    "-",
                    i, 
                    ".csv", 
                    sep=""))
    print(paste("climate_data/en_climate_summaries_All_",
                ii_filename,
                "-", 
                i, 
                ".csv",
                sep=""))
    }
}

#Legend information
download.file("https://climate.weather.gc.ca/prods_servs/cdn_climate_summary_report_e.html?intYear=2024&intMonth=5&prov=&dataFormat=txt&btnSubmit=Download+data",
              destfile="climate_data/en_climate_summaries_legend.txt", 
              mode="wb")


#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# 2) Read in files and get averages for winter/summer months
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

input.files <- list.files("climate_data/", full.names=TRUE, pattern="*.csv")

collector.df <- data.frame()
for(i in 1:length(input.files)){
  tmp.df <- read_csv(input.files[i])
  collector.df <- rbind(collector.df, 
                        tmp.df)
}

#Filter only provinces of relevance
collector.df <- collector.df %>% filter(grepl("BC|AB|SK|MB|ON|QC|NB|NS|PE|NL",
                                              Prov_or_Ter))
mean_rows <- collector.df %>% 
  group_by(YYYY_MM) %>% 
  mutate(mean_rows =length(Prov_or_Ter)) %>% 
  slice(1) %>% 
  ungroup() %>%
  dplyr::select(YYYY_MM, mean_rows)

#sum(mean_rows)/length(mean_rows)
#sum(mean_rows$mean_rows)/length(mean_rows$mean_rows)
#sd(mean_rows$mean_rows)

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# 3) Descriptive statistics (Optional)
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#unique.sites <- unique(collector.df$YYYY_MM)
#unique.sites <- unique(paste(collector.df$Long, 
#                             collector.df$Lat, sep=""))
#length(unique.sites)
#unique.sites

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# 3) Calculate averages for Canadian winter, spring, summer, and fall seasons
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

collector.df.mean.month <- collector.df %>%
  mutate_at(vars(Tm, 
                 DwTm, 
                 D, 
                 Tx,
                 DwTx, 
                 Tn, 
                 DwTn, 
                 S, 
                 DwS, 
                 `S%N`, 
                 P, 
                 `P%N`, 
                 S_G, 
                 Pd, 
                 BS, 
                 DwBS, 
                 `BS%`,
                 HDD, 
                 CDD), 
            as.numeric) %>%
  mutate(date_year = str_split_fixed(YYYY_MM, "_", 2)[,1]) %>% 
  mutate(date_year_lag = as.numeric(date_year)+1) %>%
  mutate(date_month = str_split_fixed(YYYY_MM, "_", 2)[,2]) %>%
  mutate(date_year_beeyear = ifelse(as.numeric(date_month) <= 2, 
                                    as.numeric(date_year)-1, 
                                    as.numeric(date_year) )) %>%
  mutate(date_year_beeyear_lag = date_year_beeyear+1) %>%
  mutate(seasons = case_when(
    grepl("_03|_04|_05", YYYY_MM) ~ "Spring",
    grepl("_06|_07|_08", YYYY_MM) ~ "Summer",
    grepl("_09|_10|_11", YYYY_MM) ~ "Fall",
    grepl("_12|_01|_02", YYYY_MM) ~ "Winter",
    TRUE ~ "ns")) %>%
  group_by(Prov_or_Ter, 
           date_year_beeyear_lag) %>%
  mutate(mean_Tm_spring = ifelse(seasons == "Spring", 
                                 Tm, NA)) %>% 
  mutate(mean_Tm_spring = mean(mean_Tm_spring, 
                               na.rm=TRUE)) %>% 
  mutate(mean_Tm_spring = ifelse(mean_Tm_spring == "NaN", 
                                 NA, mean_Tm_spring)) %>%
  mutate(mean_Tm_summer = ifelse(seasons == "Summer", 
                                 Tm, NA)) %>% 
  mutate(mean_Tm_summer = mean(mean_Tm_summer, 
                               na.rm=TRUE)) %>% 
  mutate(mean_Tm_summer = ifelse(mean_Tm_summer == "NaN",
                                 NA, mean_Tm_summer)) %>%
  mutate(mean_Tm_fall = ifelse(seasons == "Fall", 
                               Tm, NA)) %>% 
  mutate(mean_Tm_fall = mean(mean_Tm_fall, 
                             na.rm=TRUE)) %>% 
  mutate(mean_Tm_fall = ifelse(mean_Tm_fall == "NaN",
                               NA, mean_Tm_fall)) %>%
  mutate(mean_Tm_winter = ifelse(seasons == "Winter", 
                                 Tm, NA)) %>% 
  mutate(mean_Tm_winter = mean(mean_Tm_winter, 
                               na.rm=TRUE)) %>% 
  mutate(mean_Tm_winter = ifelse(mean_Tm_winter == "NaN",
                                 NA, mean_Tm_winter)) %>%
  mutate(mean_P_spring = ifelse(seasons == "Spring", 
                                P, NA)) %>% 
  mutate(mean_P_spring = mean(mean_P_spring, 
                              na.rm=TRUE)) %>% 
  mutate(mean_P_spring = ifelse(mean_P_spring == "NaN", 
                                NA, mean_P_spring)) %>%
  mutate(mean_P_summer = ifelse(seasons == "Summer", 
                                P, NA)) %>% 
  mutate(mean_P_summer = mean(mean_P_summer, 
                              na.rm=TRUE)) %>% 
  mutate(mean_P_summer = ifelse(mean_P_summer == "NaN", 
                                NA, mean_P_summer)) %>%
  mutate(mean_P_fall = ifelse(seasons == "Fall", 
                              P, NA)) %>% 
  mutate(mean_P_fall = mean(mean_P_fall, 
                            na.rm=TRUE)) %>% 
  mutate(mean_P_fall = ifelse(mean_P_fall == "NaN", 
                              NA, mean_P_fall)) %>%
  mutate(mean_P_winter = ifelse(seasons == "Winter", 
                                P, NA)) %>% 
  mutate(mean_P_winter = mean(mean_P_winter, 
                              na.rm=TRUE)) %>% 
  mutate(mean_P_winter = ifelse(mean_P_winter == "NaN",
                                NA, mean_P_winter)) %>%
  mutate(mean_S_spring = ifelse(seasons == "Spring", 
                                S, NA)) %>% 
  mutate(mean_S_spring = mean(mean_S_spring, 
                              na.rm=TRUE)) %>%
  mutate(mean_S_spring = ifelse(mean_S_spring == "NaN", 
                                NA, mean_S_spring)) %>%
  mutate(mean_S_summer = ifelse(seasons == "Summer",
                                S, NA)) %>% 
  mutate(mean_S_summer = mean(mean_S_summer, 
                              na.rm=TRUE)) %>% 
  mutate(mean_S_summer = ifelse(mean_S_summer == "NaN", 
                                NA, mean_S_summer)) %>%
  mutate(mean_S_fall = ifelse(seasons == "Fall", 
                              S, NA)) %>% 
  mutate(mean_S_fall = mean(mean_S_fall, 
                            na.rm=TRUE)) %>%
  mutate(mean_S_fall = ifelse(mean_S_fall == "NaN",
                              NA, mean_S_fall)) %>%
  mutate(mean_S_winter = ifelse(seasons == "Winter", 
                                S, NA)) %>% 
  mutate(mean_S_winter = mean(mean_S_winter, 
                              na.rm=TRUE)) %>% 
  mutate(mean_S_winter = ifelse(mean_S_winter == "NaN", 
                                NA, mean_S_winter)) %>%
  ungroup() %>%
  group_by(Prov_or_Ter, 
           YYYY_MM) %>%
  mutate(mean_Tm = mean(Tm, na.rm=TRUE)) %>%
  mutate(mean_DwTm = mean(DwTm, na.rm=TRUE)) %>%
  mutate(mean_D = mean(D, na.rm=TRUE)) %>%
  mutate(mean_Tx = mean(Tx, na.rm=TRUE)) %>%
  mutate(mean_DwTx = mean(DwTx, na.rm=TRUE)) %>%
  mutate(mean_Tn = mean(Tn, na.rm=TRUE)) %>%
  mutate(mean_DwTn = mean(DwTn, na.rm=TRUE)) %>%
  mutate(mean_S = mean(S, na.rm=TRUE)) %>%
  mutate(mean_DwS = mean(DwS, na.rm=TRUE)) %>%
  mutate(`mean_S%N` = mean(`S%N`, na.rm=TRUE)) %>%
  mutate(mean_P = mean(P, na.rm=TRUE)) %>%
  mutate(`mean_P%N` = mean(`P%N`, na.rm=TRUE)) %>%
  mutate(mean_S_G = mean(S_G, na.rm=TRUE)) %>% 
  mutate(mean_Pd = mean(Pd, na.rm=TRUE)) %>% 
  mutate(mean_BS = mean(BS, na.rm=TRUE)) %>% 
  mutate(mean_DwBS = mean(DwBS, na.rm=TRUE)) %>% 
  mutate(`mean_BS%` = mean(`BS%`, na.rm=TRUE)) %>% 
  mutate(mean_HDD = mean(HDD, na.rm=TRUE)) %>% 
  mutate(mean_CDD = mean(CDD, na.rm=TRUE)) %>% 
  slice(1) %>%
  ungroup()

collector.df.mean.month.year <- collector.df.mean.month %>% 
  group_by(Prov_or_Ter, 
           date_year_beeyear_lag) %>% 
  mutate(mean_Tm = mean(mean_Tm, na.rm=TRUE)) %>%
  mutate(mean_DwTm = mean(mean_DwTm, na.rm=TRUE)) %>%
  mutate(mean_D = mean(mean_D, na.rm=TRUE)) %>%
  mutate(mean_Tx = mean(mean_Tx, na.rm=TRUE)) %>%
  mutate(mean_DwTx = mean(mean_DwTx, na.rm=TRUE)) %>%
  mutate(mean_Tn = mean(mean_Tn, na.rm=TRUE)) %>%
  mutate(mean_DwTn = mean(mean_DwTn, na.rm=TRUE)) %>%
  mutate(mean_S = mean(mean_S, na.rm=TRUE)) %>%
  mutate(mean_DwS = mean(mean_DwS, na.rm=TRUE)) %>%
  mutate(`mean_S%N` = mean(`mean_S%N`, na.rm=TRUE)) %>%
  mutate(mean_P = mean(mean_P, na.rm=TRUE)) %>%
  mutate(`mean_P%N` = mean(`mean_P%N`, na.rm=TRUE)) %>%
  mutate(mean_S_G = mean(mean_S_G, na.rm=TRUE)) %>% 
  mutate(mean_Pd = mean(mean_Pd, na.rm=TRUE)) %>% 
  mutate(mean_BS = mean(mean_BS, na.rm=TRUE)) %>% 
  mutate(mean_DwBS = mean(mean_DwBS, na.rm=TRUE)) %>% 
  mutate(`mean_BS%` = mean(`mean_BS%`, na.rm=TRUE)) %>% 
  mutate(mean_HDD = mean(mean_HDD, na.rm=TRUE)) %>% 
  mutate(mean_CDD = mean(mean_CDD, na.rm=TRUE)) %>%
  slice(1) %>%
  ungroup() 

write_tsv(collector.df.mean.month.year, "tables/climate_data_adj.tsv")







