library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(dashboardthemes)
library(sparkline)
library(highcharter)
library(plotly)
library(shinyWidgets)
library(DT)
library(reactable)
library(shinycssloaders)
library(fs)


dataAtDate <- function(date1){
  evolution %>% filter(date==date1)
}

dataAtDateDistrict <- function(date1){
  zone_confirmes_dist %>% filter(date==date1)
}

source("getData.R")
max_date=max(evolution$date)
min_date=min(evolution$date)

##filtre


##fonction cas 

dailyplot <-function(datafun){
  plotly::plot_ly(data = datafun, stackgroup = 'one') %>%
   
    plotly::add_trace(x = ~ date,
                      y = ~ ACTIFS,
                      type = "scatter",
                      mode = "none",
                      fillcolor="orange",
                      name = "ACTIFS"
                     
                      ) %>%
    plotly::add_trace(x = ~ date,
                      y = ~ DECES,
                      name="DECES",
                      fillcolor="red",    mode="none") %>%
    plotly::add_trace(x = ~ date,
                      y = ~ GUERIS,
                      name="GUERIS",
                     # line = list(color = "blue"),
                      fillcolor="green",mode="none"
    ) %>%
    
    
   
    # plotly::add_annotations(x = as.Date("2020-03-01"),
    #                        y = 42716,
    #                        text = paste("# of GUERIS cases surpass", 
    #                                     "", 
    #                                     "the # of ACTIFS cases"),
    #                        xref = "x",
    #                        yref = "y",
    #                        arrowhead = 5,
    #                        arrowhead = 3,
    #                        arrowsize = 1,
    #                        showarrow = TRUE,
  #                        ax = -10,
  #                        ay = 90) %>%
  plotly::layout(title = "",
                 yaxis = list(title = "Nombre total de cas"),
                 xaxis = list(title = "Date"),
                 legend = list(x = 0.1, y = 0.9),
                 hovermode = "compare"
                 #fig_bgcolor= "rgb(0, 0, 0)", 
                 #plot_bgcolor= "rgb(0, 0, 0)",
                 #paper_bgcolor= "rgb(0, 0, 0)"
                 #height=650
                )
  
  
}
newCases <-function(datafun){
  plotly::plot_ly(data = datafun) %>%
    plotly::add_trace(x = ~ date,
                      y = ~ new_conf,
                      type = "scatter",
                      mode = "lines+markers",
                      name = "Nouveaux Cas",
                      line = list(color = "blue"),
                      marker = list(color = "blue")) %>%
    plotly::add_trace(x = ~ date,
                      y = ~ new_actif,
                      type = "scatter",
                      mode = "lines+markers",
                      name = "Variation des cas actifs",
                      line = list(color = "orange"),
                      marker = list(color = "orange")) %>%
    
    plotly::add_trace(x = ~ date,
                      y = ~ new_recov,
                      type = "scatter",
                      mode = "lines+markers",
                      name = "Nouvelles guérisons",
                      line = list(color = "green"),
                      marker = list(color = "green")) %>%
    plotly::add_trace(x = ~ date,
                      y = ~ new_death,
                      type = "scatter",
                      mode = 'lines+markers',
                      name = "Nouveaux décès",
                      line = list(color = "red"),
                      marker = list(color = "red")) %>%
    # plotly::add_annotations(x = as.Date("2020-03-01"),
    #                        y = 42716,
    #                        text = paste("# of GUERIS cases surpass", 
    #                                     "", 
    #                                     "the # of ACTIFS cases"),
    #                        xref = "x",
    #                        yref = "y",
    #                        arrowhead = 5,
    #                        arrowhead = 3,
    #                        arrowsize = 1,
    #                        showarrow = TRUE,
  #                        ax = -10,
  #                        ay = 90) %>%
  plotly::layout(title = "",
                 yaxis = list(title = "Nombre total de cas"),
                 xaxis = list(title = "Date"),
                 legend = list(x = 0.1, y = 0.9),
                 hovermode = "compare"
                 #fig_bgcolor= "rgb(0, 0, 0)", 
                 #plot_bgcolor= "rgb(0, 0, 0)",
                 #paper_bgcolor= "rgb(0, 0, 0)"
                 #height=650
  )
  
  
}


newcasaera <-function(datafun){
  plotly::plot_ly(data = datafun, stackgroup = 'one') %>%
    
    plotly::add_trace(x = ~ date,
                      y = ~ new_actif,
                      type = "scatter",
                      mode = "none",
                      fillcolor="orange",
                      name = "ACTIFS"
                      
    ) %>%
    plotly::add_trace(x = ~ date,
                      y = ~ new_death,
                      name="DECES",
                      fillcolor="red",    mode="none") %>%
    plotly::add_trace(x = ~ date,
                      y = ~ new_recov,
                      name="GUERIS",
                      # line = list(color = "blue"),
                      fillcolor="green",mode="none"
    ) %>%
    
    
    
    # plotly::add_annotations(x = as.Date("2020-03-01"),
    #                        y = 42716,
    #                        text = paste("# of GUERIS cases surpass", 
    #                                     "", 
    #                                     "the # of ACTIFS cases"),
    #                        xref = "x",
    #                        yref = "y",
    #                        arrowhead = 5,
  #                        arrowhead = 3,
  #                        arrowsize = 1,
  #                        showarrow = TRUE,
  #                        ax = -10,
  #                        ay = 90) %>%
  plotly::layout(title = "",
                 yaxis = list(title = "Nombre total de cas"),
                 xaxis = list(title = "Date"),
                 legend = list(x = 0.1, y = 0.9),
                 hovermode = "compare"
                 #fig_bgcolor= "rgb(0, 0, 0)", 
                 #plot_bgcolor= "rgb(0, 0, 0)",
                 #paper_bgcolor= "rgb(0, 0, 0)"
                 #height=650
  )
  
  
}


top_district <- function(data, couleur){
  data %>%
    
    ggplot(aes(x = reorder(district, value), y = value)) +
    geom_bar(stat = "identity",  fill= "blue") +
    
    scale_y_continuous(expand = c(0.1, 1)) +
    xlab("District" ) +
    ylab("Nombre de cas") + 
    coord_flip()+
  theme_classic() +
    theme(
      
      panel.background = element_rect(fill = "#252525",colour = NA),
      plot.background = element_rect(fill = "#252525",colour = NA), 
      panel.grid.major = element_blank(), panel.grid.minor = element_blank())  +
    geom_text(aes(label=value),hjust=1, size=5, color="Black")
  
}

make_color_pal <- function(colors, bias = 1) {
  get_color <- colorRamp(colors, bias = bias)
  function(x) rgb(get_color(x), maxColorValue = 255)
}

off_rating_color <- make_color_pal(c("#ff2700", "#f8fcf8", "#44ab43"), bias = 1.3)
def_rating_color <- make_color_pal(c("#ff2700", "#f8fcf8", "#44ab43"), bias = 0.6)
rating_column <- function(maxWidth = 55, ...) {
  colDef(maxWidth = maxWidth, align = "center", class = "number", ...)
}
#theme <- reactableTheme(color = "hsl(0, 0%, 90%)", backgroundColor = "hsl(0, 0%, 10%)", 
#                        borderColor = "hsl(0, 0%, 18%)", stripedColor = "hsl(0, 0%, 13%)", 
#                        headerStyle = list(`&:hover[aria-sort]` = list(backgroundColor = "hsl(0, 0%, 14%)")), 
#                        tableBodyStyle = list(color = "hsl(0, 0%, 75%)"), rowHighlightStyle = list(color = "hsl(0, 0%, 90%)", 
#                                                                                                   backgroundColor = "hsl(0, 0%, 14%)"), selectStyle = list(backgroundColor = "hsl(0, 0%, 20%)"), 
#                        inputStyle = list(backgroundColor = "hsl(0, 0%, 10%)", borderColor = "hsl(0, 0%, 21%)", 
#                                          `&:hover, &:focus` = list(borderColor = "hsl(0, 0%, 30%)")), 
#                        pageButtonHoverStyle = list(backgroundColor = "hsl(0, 0%, 20%)"), 
#                        pageButtonActiveStyle = list(backgroundColor = "hsl(0, 0%, 24%)"))

projSimple<-function(rawN, rawTime, inWindow=10){
  nn <- length(rawN)
  ss <- (nn-inWindow+1):nn
  x <- c(rawTime[ss], rawTime[nn]+1:inWindow)
  lnN <- log(rawN[ss])
  lnN[is.infinite(lnN)]<-NA
  tIn <- rawTime[ss]
  mFit <- lm(lnN~tIn)
  extFit <- predict(mFit, newdata = list(tIn = x), interval = "confidence")
  y <- exp(extFit)
  list(x=x, y=y)
}

projSimpleSlope<-function(rawN, rawTime, inWindow=10){
  nn <- length(rawN)
  ss <- (nn-inWindow+1):nn
  x <- c(rawTime[ss], rawTime[nn]+1:inWindow)
  lnN <- log(rawN[ss])
  lnN[is.infinite(lnN)]<-NA
  tIn <- rawTime[ss]
  mFit <- lm(lnN~tIn)
  coefficients(mFit)
}

doubTime <- function(cases, time, inWindow = 10){
  r <- projSimpleSlope(cases, time)[2]
  log(2)/r
}


# growth rate
growthRate <- function(cases, inWindow=10){
  nn <- length(cases)
  ss <- (nn - inWindow + 1):nn
  rate <- numeric(length(ss))
  rate[ss] <- (cases[ss] - cases[ss-1]) / cases[ss-1]
}

