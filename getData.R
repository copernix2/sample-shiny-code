  library(RCurl)
  library(readr)
  library(dplyr)
  
  coronavirus <- read_delim("data/evolution.csv",  ";", escape_double = FALSE, locale = locale(), trim_ws = TRUE)
  
  test <- read_delim("data/test.csv", ";", escape_double = FALSE, 
                     trim_ws = TRUE)
  test$date <- as.Date(test$date, format="%d %B %Y")
  
  
  downloadGithubData <- function() {
    ## Confirmés globales 
    download.file(
      url      = "https://raw.githubusercontent.com/senegalouvert/COVID-19/master/data/zone_confirmes.csv",
      destfile = "data/zone_confirmes.csv"
    )
    
    
  }
  
  
  updateData <- function() {
    if (!dir_exists("data")) {
      dir.create('data')
      downloadGithubData()
    } else if ((!file.exists("data/zone_confirmes.csv")) || (as.double(Sys.time() - file_info("data/zone_confirmes.csv")$change_time, units = "hours") > 8)) {
      downloadGithubData()
    }
  }
  
  # Update with start of aapp
  updateData()
  
  
  
  
  
  
  
  
  
  
  

  zone_confirmes <- read_csv("data/zone_confirmes.csv")
 


  #zone_confirmes <- zone_confirmes %>% bind_rows(manquant)
  zone_confirmes$DATE <- as.Date(zone_confirmes$DATE)
  
  zone_confirmes <- zone_confirmes %>% tidyr::gather("district", "cas", -DATE) %>% filter(!is.na(cas))
  
  reg_dist <- read_csv("data/reg_dist.csv")
  zone_confirmes <- zone_confirmes %>% full_join(reg_dist) %>% rename(date=DATE)
  zone_confirmes_dist <- zone_confirmes
  zone_confirmes <- zone_confirmes %>% filter(!is.na(cas) & !is.na(region))
  
  zone_confirmes <-  zone_confirmes %>%
    group_by(`hc-key`, region, date) %>% summarise(cas=sum(cas, na.rm = T)) %>% ungroup()
  sca=zone_confirmes %>% filter(cas==max(cas))
  sca$`hc-key`="ff"#sca$cas=600
  zone_confirmes <-  zone_confirmes %>% filter(!is.na(date) & !is.na(`hc-key`))
  
  zone_confirmes <- zone_confirmes %>% mutate(cas=ifelse(cas==0,NA, cas))
  
  
  data_evol <- zone_confirmes_dist %>% group_by(district) %>% arrange(date, .by_group=T) %>% 
    mutate(new_case=cas- lag(cas, 1, default = 0))%>% summarise(totcas=sum(new_case, na.rm = T),
                                                                evol=list(new_case)
                                                                ) %>% mutate(pourcen=totcas/sum(totcas, na.rm = T)) %>% 
    filter(totcas>0)

  
  
 
  ##Nouveau cas 
  
  evolution <- coronavirus %>% mutate(date=as.Date(date, format="%d/%m/%y")) %>% 
    arrange(date) %>% 
    mutate(new_conf=CONFIRMES - lag(CONFIRMES, 1, default = 0),
           new_recov= GUERIS - lag(GUERIS, 1, default = 0),
           new_death =DECES- lag(DECES, 1, default = 0),
           new_actif=ACTIFS- lag(ACTIFS, 1, default = 0),
           taux_death=DECES*100/CONFIRMES,
           taux_gueri=GUERIS*100/CONFIRMES

          ) %>% ungroup()
  
 