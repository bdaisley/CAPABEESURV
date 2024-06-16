
require(dplyr)
require(readr)
require(stringr)
require(reshape2)

#setwd("~/GITHUB/ABXBEESURV")
suppressWarnings(dir.create("capa_surveys"))
suppressWarnings(dir.create("tables"))
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# 1) Download Annual Colony Loss Reports from CAPA: https://capabees.com/capa-statement-on-honey-bees/
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# 2015
download.file("https://capabees.com/shared/2015/07/2015-CAPA-Statement-on-Colony-Losses-July-16-Final-16-30.pdf",
              destfile=paste("capa_surveys/CAPA-Statement-on-Colony-Losses-2015.pdf", sep=""), mode="wb")
# 2016
download.file("https://capabees.com/shared/2015/07/2016-CAPA-Statement-on-Colony-Losses-July-19.pdf",
              destfile=paste("capa_surveys/CAPA-Statement-on-Colony-Losses-2016.pdf", sep=""), mode="wb")
# 2017
download.file("https://capabees.com/shared/2016/07/2017-CAPA-Statement-on-Colony-Losses-r.pdf",
              destfile=paste("capa_surveys/CAPA-Statement-on-Colony-Losses-2017.pdf", sep=""), mode="wb")
# 2019
download.file("https://capabees.com/shared/2017-2018-CAPA-Statement-on-Colony-Losses-Final-July-19.pdf",
              destfile=paste("capa_surveys/CAPA-Statement-on-Colony-Losses-2018.pdf", sep=""), mode="wb")
# 2019
download.file("https://capabees.com/shared/2018-2019-CAPA-Statement-on-Colony-Losses.pdf",
              destfile=paste("capa_surveys/CAPA-Statement-on-Colony-Losses-2019.pdf", sep=""), mode="wb")
# 2020
download.file("https://capabees.com/shared/CAPA-Statement-on-Colony-Losses-FV.pdf",
              destfile=paste("capa_surveys/CAPA-Statement-on-Colony-Losses-2020.pdf", sep=""), mode="wb")
# 2021
download.file("https://capabees.com/shared/CAPA-Statement-on-Colony-Losses-2020-2021.pdf",
              destfile=paste("capa_surveys/CAPA-Statement-on-Colony-Losses-2021.pdf", sep=""), mode="wb")
# 2022
download.file("https://capabees.com/shared/CAPA-Statement-on-Colony-Losses-2021-2022-FV.pdf",
              destfile=paste("capa_surveys/CAPA-Statement-on-Colony-Losses-2022.pdf", sep=""), mode="wb")
# 2023
download.file("https://capabees.com/shared/CAPA-Statement-on-Colony-Losses-2022-2023_final.pdf",
              destfile=paste("capa_surveys/CAPA-Statement-on-Colony-Losses-2023.pdf", sep=""), mode="wb")

