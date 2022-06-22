install.packages("RSelenium")
install.packages("rvest")
install.packages("tidyverse")


rD <- rsDriver(browser="firefox", port=as.integer(sample(1:10000, 1)), verbose=F)
remDr <- rD[["client"]]


test_fcn <- function(Anbausystem=1){
remDr$navigate("https://daten.ktbl.de/dslkrpflanze/postHv.html#Ergebnis")


# Anwendung starten
remDr$findElements(using = "xpath", value='/html/body/div/div[3]/div/div[3]/div[2]/a')[[1]]$clickElement()


# Getreide auswählen
remDr$findElements(using = "xpath", 
                   value='/html/body/div[2]/div[3]/div[2]/div[2]/table/tbody/tr[1]/td/table/tbody/tr[2]/td/form/table/tbody/tr[2]/td[1]/input')[[1]]$clickElement()

# Auswahl bestätigen
remDr$findElements(using = "xpath", 
                   value='/html/body/div[2]/div[3]/div[2]/div[2]/table/tbody/tr[1]/td/table/tbody/tr[2]/td/form/table/tbody/tr[7]/td/input')[[1]]$clickElement()

# Wirtschaftsart: konventionell/integriert
remDr$findElements(using = "xpath", 
                   value='/html/body/div[2]/div[3]/div[2]/div[2]/table/tbody/tr[3]/td[1]/table/tbody/tr[2]/td/form[1]/select/option[2]')[[1]]$clickElement()


# Kulturpflanze
remDr$findElements(using = "xpath", 
                   value='/html/body/div[2]/div[3]/div[2]/div[2]/table/tbody/tr[3]/td[1]/table/tbody/tr[2]/td/form[2]/select/option[8]')[[1]]$clickElement()


# Anbausystem
anbausystem <- c("Direktsaat"="[2]",
                 "wendend, Kreiseleggensaat"="[3]",
                 "wendend, gezogene Saatbettbereitung, Saat"="[4]")

prod_verfahren <- paste0("/html/body/div[2]/div[3]/div[2]/div[2]/table/tbody/",
                         "tr[3]/td[1]/table/tbody/tr[2]/td/form[",
                         1:3, "]/select/option")



remDr$findElements(using = "xpath", 
                   value= paste0(prod_verfahren[3], 
                                 anbausystem[Anbausystem]))[[1]]$clickElement()

# Extract tables
result <-lapply(1:7, function (i) 
 read_html(html) %>% # parse HTML
  # html_nodes("[class='tabelleOhneWidth']") %>% 
  html_nodes(xpath=paste0('/html/body/div[2]/div[3]/div[3]/div[2]/div/div[',i,']/table')) %>% 
  html_table(trim = T, convert = T, header = T) %>%
  .[[1]] 
)

return(result)
}

parse_number(signals)
