shinyServer( function(input, output){
 #"choose one date"
 output$sliderTime <- renderUI({
   sliderInput(
     "timeSlider",
     label      = "Choose a date",
     min        = as.Date("2020-04-01"),
     max        = max(evolution$date),
     value      = max(zone_confirmes$date),
     width      = "95%",
     timeFormat = "%d.%m.%Y",
     animate    = animationOptions())
 })
 output$update <- renderText({
   as.character(format(max_date,"%d %B %Y"))
 })
 
 output$signe <- renderText({
    if (dataAtDate(max_date)$new_actif[1]>0){
       icone="fa fa-caret-up"
    }else{
       icone="fa fa-caret-down"
    }
    icone
 })
 ### reactivity----
 
 data <- eventReactive(input$timeSlider,{
   dataAtDate(input$timeSlider)
 })
 
 geo_zone <- eventReactive(input$timeSlider,{
   
   
   zone_confirmes %>% 
     filter(date == input$timeSlider) 
   
   
 })
 
 
### Stat global ----
 
output$totconf <- renderUI({
  descriptionBlock(
    number = span(paste0("+",format(dataAtDate(max_date)$new_conf, big.mark = ",")), style="font-size:18px;"), 
    number_color = "red", 
    number_icon = "fa fa-caret-up",
    header = span(format(dataAtDate(max_date)$CONFIRMES, big.mark = ","), style="font-size:35px;;"), 
    text = span("TOTAL CAS", style="font-weight: bold; color:#2171B5;"), 
    right_border = TRUE,
    margin_bottom = FALSE
  )
})
 
 output$totactifs <- renderUI({
 
   descriptionBlock(
     number = span(paste0(ifelse(dataAtDate(max_date)$new_actif>0, "+",""),format(sum(dataAtDate(max_date)$new_actif), big.mark = ",")), style="font-size:18px;"), 
     number_color = "orange", 
     number_icon = ifelse(dataAtDate(max_date)$new_actif>0, "fa fa-caret-up","fa fa-caret-down"),
     header = span(format(sum(dataAtDate(max_date)$ACTIFS), big.mark = ","), style="font-size:35px;;"), 
     text = span("CAS ACTIFS", style="font-weight: bold; color:orange;"), 
     right_border = TRUE,
     margin_bottom = FALSE
   )
 })
 
 output$totrecov <- renderUI({
   descriptionBlock(
     number = span(paste0("+",format(sum(dataAtDate(max_date)$new_recov), big.mark = ",")), style="font-size:18px;"), 
     number_color = "green", 
     number_icon = "fa fa-caret-up",
     header = span(format(sum(dataAtDate(max_date)$GUERIS, na.rm = T), big.mark = ","), style="font-size:35px;;"), 
     text = span("TOTAL GUERIS", style="font-weight: bold; color:green;"), 
     right_border = TRUE,
     margin_bottom = FALSE
   )
 })
 
 output$totdeath <- renderUI({
   descriptionBlock(
     number = span(paste0("+",format(sum(dataAtDate(max_date)$new_death), big.mark = ",")), style="font-size:18px; color:#E31A1C;"), 
     number_color = "red", 
     number_icon = "fa fa-caret-up",
     header = span(format(sum(dataAtDate(max_date)$DECES, na.rm = T), big.mark = ","), style="font-size:35px;;"), 
     text = span("TOTAL DECES", style="font-weight: bold; color:#E31A1C;"), 
     right_border = TRUE,
     margin_bottom = FALSE
   )
 })
 
 
 ###Cartographie ----
 output$carte_dyna <- renderHighchart({
   datav <- geo_zone() 
   stops= data.frame(q = seq(0.01,1,0.01),
                     c =viridis::magma(100, direction = -1))
   #c = c("#FFFFCC", "#FEB24C", "#FD8D3C", "#800026")
   stops <- list_parse2(stops) 
   if(input$timeSlider ==max(zone_confirmes$date)) {
     
     hcmap("countries/sn/sn-all", data = datav, value = "cas",
           joinBy = c("hc-key", "hc-key"), name = "Cas ",color="red",
           dataLabels = list(enabled = TRUE, format = '{point.region} <br> {point.value}'), download_map_data = T,
           borderColor = "red", borderWidth = 0.1,
           tooltip = list(valueDecimals = 0, valueSuffix = " Cas confirmé(s)")) %>% hc_credits(enabled=T, text="A partir des communiqués du MSAS") %>%
       hc_colorAxis(stops=stops)
   }else{
     
     
     hcmap("countries/sn/sn-all", data = datav, value = "cas",
           joinBy = c("hc-key", "hc-key"), name = "Cas ",color="red",
           dataLabels = list(enabled = TRUE, format = '{point.region}<br> {point.value}'), download_map_data = F,
           borderColor = "red", borderWidth = 0.1,
           tooltip = list(valueDecimals = 0, valueSuffix = " Cas confirmé(s)")) %>% hc_credits(enabled=T, text="A partir des communiqués du MSAS") %>% 
       hc_colorAxis(stops=stops)
     #hc_colorAxis(minColor="#FEE0D2", maxColor="#A50F15")
   }
 })
 
 textvv <- eventReactive(input$timeSlider, {
   paste0(" : ",format(input$timeSlider,"%d %B %Y"))
   
 })
 output$text1 <- renderText( textvv())
 output$reg_dyna <-  renderPlot({
   geo_zone2() %>% arrange(desc(cas)) %>% filter(`hc-key`!="ff" & !is.na(cas)) %>% ggplot(aes(x=reorder(region,cas), y=cas))+
     geom_bar(fill="#A50F15", stat = 'identity')+ theme_minimal() +coord_flip()+
     xlab("régions")+
     geom_text(aes(label=cas),hjust=-0.1, size=5)
   # ggtitle(format(textvv(),"%d %B %Y"))
   #○theme(title = paste0("situation à la date du ", input$timeSlider))
 })
 
 output$totcase <- renderText({
   paste0(" : ", format(sum(geo_zone()$cas, na.rm = TRUE)-600, big.mark = " "))
 })
  # 

 
 
  
   ### Trends -------
   output$plotdaily <- renderPlotly({
     
       dailyplot(evolution)
     
   })
   
   output$newcases <- renderPlotly({
    
     newCases(evolution)
     
   })
   
   # output$graph_taux <- renderPlot({
   #   displayCountry() %>% filter(CONFIRMES>=150) %>% 
   #     ggplot(aes(x=taux_gueri, y=taux_death, label=`Country/Region`))+
   #     geom_point()+
   #     geom_text(aes(color=factor(class)), size=4)+ 
   #     scale_colour_manual(values=c("orange", "red", "blue","green"), name="Legend")+
   #     theme_bw() +
   #     theme(legend.position="bottom",
   #       panel.background = element_rect(fill = "black",colour = NA),
   #       plot.background = element_rect(fill = "black",colour = NA), 
   #       panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
   #       legend.text = element_text( size = 12)
   #     ) 
   # }) 
   
  
   output$casebycountry <- renderReactable({
     
     
  
     reactable(data_evol %>% select(district, totcas, pourcen, evol), 
  
               pagination = T, showPageInfo = T, 
  
               highlight = TRUE,  searchable = TRUE,defaultSorted ="totcas",
  
               showPageSizeOptions = TRUE, fullWidth = F,
  
               
  
       columns = list(
         district=colDef("District Sanitaire"),
         totcas=colDef("Nombre de cas total", defaultSortOrder = "desc"),
         pourcen=colDef("Pourcentage", format = colFormat(percent = TRUE, digits = 1)),
         evol = colDef(name= "Evolution des nouveaux cas", 
                       cell = function(values) {
           sparkline(values, chartRangeMin = 0, chartRangeMax = max(data_evol$new_case, na.rm = T))
         })
       ),
  
     theme = theme)
  
   }) 
    
 
output$top_conf <- renderPlot({
  
  data <- dataAtDateDistrict(input$timeSlider)
 
  top_district(head(data %>% arrange(desc(cas)) %>% rename(value=cas),10), "#2171B5")
 
  
  
 })

output$suivi_tot <- renderUI({
 # data <- dataAtDateDistrict(input$sliderTime)
  tags$table(
    tags$tr(
      tags$td("Date"),tags$td(textOutput("text1"))
    ),
    tags$tr(
      tags$td("Total cas confirmés"),tags$td(textOutput("totcase"))
    )
  )
})
  output$prevision <-  renderPlot({
    yA <- evolution$CONFIRMES
    dates <- evolution$date
    timed <- format(round(doubTime(yA, dates),2), big.mark = ",")
    lDat <- projSimple(yA, dates)
    yMax <- max(c(lDat$y[,"fit"], yA), na.rm = TRUE)
    yTxt <- "Cas confirmés"
    plot(yA~dates, 
         xlim = c(min(dates), max(lDat$x)),
         ylim = c(0, yMax),
         pch = 19, 
         bty = "u", 
         xlab = "Date", 
         ylab = yTxt,
         main=paste0("Temps de doublement ", timed, " jours en moyenne"))
    axis(side = 4)
    lines(lDat$y[, "fit"]~lDat$x)
    lines(lDat$y[, "lwr"]~lDat$x, lty = 2)
    lines(lDat$y[, "upr"]~lDat$x, lty = 2)
  })
  
})

