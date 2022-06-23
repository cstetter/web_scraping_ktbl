source("web_scraper_ktbl.R")

combo <- expand.grid(names(anbausystem),
                     names(schlaggroesse),
                     names(ertragsniveau),
                     names(mechanisierung),
                     names(entfernung))

colnames(combo) <- c("anbausystem",
                     "schlaggroesse",
                     "ertragsniveau",
                     "mechanisierung",
                     "entfernung")


result_list <- lapply(1:50, function(i)
 retrieve_ktbl(Anbausystem = combo[i,"anbausystem"], 
               Schlaggroesse = combo[i,"schlaggroesse"] , 
               Ertragsniveau = combo[i,"ertragsniveau"] , 
               Mechanisierung = combo[i,"mechanisierung"],
               Entfernung = combo[i,"entfernung"])
)

names(result_list) <- apply(combo[1:50,], 1, paste, collapse=";")

saveRDS(result_list, "test_results_first_50_combos.rds")
