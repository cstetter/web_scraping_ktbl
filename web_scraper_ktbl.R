# install.packages("RSelenium")
# install.packages("rvest")
# install.packages("tidyverse")

library("RSelenium")
library("rvest")
library("tidyverse")

anbausystem <- c("Direktsaat"="[2]",
                 "wendend, Kreiseleggensaat"="[3]",
                 "wendend, gezogene Saatbettbereitung, Saat"="[4]")

schlaggroesse <- c("1 ha"="[2]",
                 "2 ha"="[3]",
                 "5 ha"="[4]",
                 "10 ha"="[5]",
                 "20 ha"="[6]",
                 "40 ha"="[7]",
                 "80 ha"="[8]")

ertragsniveau <- c("hoch, mittlerer Boden"="[2]",
                   "mittel, leichter Boden"="[3]",
                   "mittel, mittlerer Boden"="[4]",
                   "mittel, schwerer Boden"="[5]",
                   "niedrig, leichter Boden"="[6]",
                   "niedrig, mittlerer Boden"="[7]")

mechanisierung <- c("45 kW"="[2]",
                 "67 kW"="[3]",
                 "83 kW"="[4]",
                 "102 kW"="[5]",
                 "120 kW"="[6]",
                 "200 kW"="[7]",
                 "230 kW"="[8]")

entfernung <- c("1 km"="[2]",
                "2 km"="[3]",
                "3 km"="[4]",
                "4 km"="[5]",
                "5 km"="[6]",
                "10 km"="[7]",
                "15 km"="[8]")


rD <- rsDriver(browser="firefox", port=as.integer(sample(1:10000, 1)), verbose=F)
remDr <- rD[["client"]]


retrieve_ktbl <- function(Anbausystem=1, 
                     Schlaggroesse=1, 
                     Ertragsniveau=1,
                     Mechanisierung=1,
                     Entfernung=1){
 
remDr$navigate("https://daten.ktbl.de/dslkrpflanze/postHv.html#Ergebnis")


# Anwendung starten
remDr$findElements(using = "xpath", value='/html/body/div/div[3]/div/div[3]/div[2]/a')[[1]]$clickElement()


# Getreide auswÃ¤hlen
remDr$findElements(using = "xpath", 
                   value='/html/body/div[2]/div[3]/div[2]/div[2]/table/tbody/tr[1]/td/table/tbody/tr[2]/td/form/table/tbody/tr[2]/td[1]/input')[[1]]$clickElement()

# Auswahl bestÃ¤tigen
remDr$findElements(using = "xpath", 
                   value='/html/body/div[2]/div[3]/div[2]/div[2]/table/tbody/tr[1]/td/table/tbody/tr[2]/td/form/table/tbody/tr[7]/td/input')[[1]]$clickElement()



prod_verfahren <- paste0("/html/body/div[2]/div[3]/div[2]/div[2]/table/tbody/",
                         "tr[3]/td[1]/table/tbody/tr[2]/td/form[",
                         1:3, "]/select/option")


# Wirtschaftsart: konventionell/integriert
remDr$findElements(using = "xpath", 
                   value=paste0(prod_verfahren[1],
                                '[2]'))[[1]]$clickElement()


# Kulturpflanze: Weizen
remDr$findElements(using = "xpath", 
                   value=paste0(prod_verfahren[2], 
                                '[8]'))[[1]]$clickElement()


# Anbausystem
anbausystem <- c("Direktsaat"="[2]",
                 "wendend, Kreiseleggensaat"="[3]",
                 "wendend, gezogene Saatbettbereitung, Saat"="[4]")


remDr$findElements(using = "xpath", 
                   value= paste0(prod_verfahren[3], 
                                 anbausystem[Anbausystem]))[[1]]$clickElement()


## Spezifikation
spezifikation <- paste0('/html/body/div[2]/div[3]/div[2]/div[2]/table/tbody/',
                        'tr[3]/td[3]/table/tbody/tr[2]/td/table/tbody/tr[', 
                        1:4,']/td[2]/form/select/option')

names(spezifikation) <- c("schlaggroesse",
                          "ertragsniveau",
                          "mechanisierung",
                          "entfernung")

# Schlaggröße
schlaggroesse <- c("1 ha"="[2]",
                 "2 ha"="[3]",
                 "5 ha"="[4]",
                 "10 ha"="[5]",
                 "20 ha"="[6]",
                 "40 ha"="[7]",
                 "80 ha"="[8]")

remDr$findElements(using = "xpath", 
                   value= paste0(spezifikation["schlaggroesse"], 
                                 schlaggroesse[Schlaggroesse]))[[1]]$clickElement()


# Ertragsniveau
ertragsniveau <- c("hoch, mittlerer Boden"="[2]",
                   "mittel, leichter Boden"="[3]",
                   "mittel, mittlerer Boden"="[4]",
                   "mittel, schwerer Boden"="[5]",
                   "niedrig, leichter Boden"="[6]",
                   "niedrig, mittlerer Boden"="[7]")


remDr$findElements(using = "xpath", 
                   value= paste0(spezifikation["ertragsniveau"], 
                                 ertragsniveau[Ertragsniveau]))[[1]]$clickElement()


# Mechanisierung
mechanisierung <- c("45 kW"="[2]",
                 "67 kW"="[3]",
                 "83 kW"="[4]",
                 "102 kW"="[5]",
                 "120 kW"="[6]",
                 "200 kW"="[7]",
                 "230 kW"="[8]")

remDr$findElements(using = "xpath", 
                   value= paste0(spezifikation["mechanisierung"], 
                                 mechanisierung[Mechanisierung]))[[1]]$clickElement()


# entfernung
entfernung <- c("1 km"="[2]",
                "2 km"="[3]",
                "3 km"="[4]",
                "4 km"="[5]",
                "5 km"="[6]",
                "10 km"="[7]",
                "15 km"="[8]")

remDr$findElements(using = "xpath", 
                   value= paste0(spezifikation["entfernung"], 
                                 entfernung[Entfernung]))[[1]]$clickElement()

Sys.sleep(2) # give the page time to fully load
html <- remDr$getPageSource()[[1]]

# Extract tables
result <-lapply(1:7, function (i) 
 read_html(html) %>% # parse HTML
  # html_nodes("[class='tabelleOhneWidth']") %>% 
  html_nodes(xpath=paste0('/html/body/div[2]/div[3]/div[3]/div[2]/div/div[',i,']/table')) %>% 
  html_table(trim = T, convert = T, header = T) %>%
  .[[1]] 
)

names(result) <- c("leistung_kosten", 
                   "stueckleistung_kosten", 
                   "arbeitsvorgaenge", 
                   "energie", 
                   "betriebsstoffe_lohn_zins",
                   "maschinen",
                   "naehrstoffe")

return(result)
}

# parse_number(signals)



 
 

