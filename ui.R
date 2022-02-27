dashboardPagePlus(
  dashboardHeader(title = " Covid19: Tableau de Bord Sénégal", titleWidth = 300 ),
  dashboardSidebar(sidebarMenu( menuItem( "Vue d'ensemble", tabName = 'dashboard', icon = icon('dashboard'), selected = T),
                    menuItem( "Tendances", tabName = 'trends', icon = icon('bar-chart-o'), 
                                                           menuSubItem("Bilan Journalière", tabName = "subitem1"),
                              menuSubItem("Nouveau Cas", tabName = "newcas"),
                              menuSubItem("Situation par districts", tabName = "countrytab"),
                              menuSubItem("Prévisions", tabName = "recov_vs"), startExpanded = T 
                             
                              ),
                    menuItem( "A propos", tabName = 'about', icon =icon('question-circle') ),
                    br(),
                    br()
                 
                    )
                    ),
  dashboardBody(
    ###Evolution des des cas 
    
    shinyDashboardThemes(
      theme = "grey_dark"
    ),
    includeCSS("www/style2.css"),
    tabItems(
      ## 3.1 Main dashboard ----------------------------------------------------------
    tabItem( tabName = 'dashboard',
    tags$table(
      
      tags$tr(
        tags$td("Dernière mise à jour : "),tags$td(textOutput("update"))
      )
    ),
    #fluidRow(, ),
    fluidRow(
      column(
        width = 3,
        uiOutput("totconf") %>% withSpinner(color="#0dc5c1", type = 6)
        
      ),
      column(
        width = 3,
        uiOutput("totactifs") %>% withSpinner(color="#0dc5c1", type = 6)
      ),
      column(
        width = 3,
        uiOutput("totrecov") %>% withSpinner(color="#0dc5c1", type = 6)
      ),
      column(
        width = 3,
        uiOutput("totdeath") %>% withSpinner(color="#0dc5c1", type = 6)
        
        )),
   
    box(
      title = "Map",
      width = 12,
      #icon = "fa fa-chart",
      status = "info", 
      background="black",
      footer = span("STATINFO-Sénégal, statinfo@stat-info.org, Johns Hopkins University Data", style="color: black"),
      fluidRow( 
             div(uiOutput("sliderTime"), align="center")),
    
      highchartOutput("carte_dyna", height = 900) %>% withSpinner(color="#0dc5c1", type = 6)
     
      
      #absolutePanel(br(),div(uiOutput("suivi_tot"), style="background: none; height: 50px;"),  top = 150, left = 10 )
      
    )
    
    
  ),
  tabItem(tabName = 'subitem1', 
          box(width = 12, "Evolution du bilan journalier",
              

              plotlyOutput("plotdaily") %>% withSpinner(color="#0dc5c1", type = 6)
          )
        ),
  tabItem(tabName = 'newcas',
          box(width = 12, "Evolution des nouveaux cas",
              
              plotlyOutput("newcases") %>% withSpinner(color="#0dc5c1", type = 6)
          )
  ),
  tabItem(tabName = 'countrytab',
          box(width = 12, 
              
              reactableOutput("casebycountry") %>% withSpinner(color="#0dc5c1", type = 6)
          )
  ),
  tabItem(tabName = 'recov_vs',
          box("Prévisions", width = 12, 
              #selectInput("pays", "Country", choices = organisation, multiple = T, selectize = T),
              plotOutput("prevision") %>% withSpinner(color="#0dc5c1", type = 6)
          )
  ),
  tabItem(tabName = 'about',
          fluidRow(
            column(4,widgetUserBox(
              title = "STATINFO",
              subtitle = "Statistique & Informatique",
              
              type = 2,
              width = 12,
              src = "statinfo.jpeg",
              color = "grey",
              #closable = TRUE,
              "STATINFO is a structure specialized in the production and analysis of statistical information that gives you an operational recovery of your data through our skills, our advice and training. The STATINFO force is gaining project management capability investigation from start to finish but also processing and analyzing your data with integrity and safely for a real valuation of statistical information than simple descriptive treatments. We offer high added value services.",
              rightSidebarMenu(
                rightSidebarMenuItem(
                  icon = menuIcon(
                    name = "calendar",
                    color = "blue"
                  ),
                  info = menuInfo(
                    title = "Creation",
                    description = "2013"
                  )
                ),
                rightSidebarMenuItem(
                  icon = menuIcon(
                    name = "map-marked-alt",
                    color = "yellow"
                  ),
                  info = menuInfo(
                    title = "Adress",
                    description = "Cité Aliou SOW (Dakar-Senegal)"
                  )
                ),
                rightSidebarMenuItem(
                  icon = menuIcon(
                    name = "phone-square",
                    color = "red"
                  ),
                  info = menuInfo(
                    title = "Phone number",
                    description = "+221 78 122 23 23"
                  )
                ),
                rightSidebarMenuItem(
                  icon = menuIcon(
                    name = "envelope",
                    color = "aqua"
                  ),
                  info = menuInfo(
                    title = "Email",
                    description = "statinfo@stat-info.org"
                  )
                ),
                rightSidebarMenuItem(
                  icon = menuIcon(
                    name = "internet-explorer",
                    color = "green"
                  ),
                  info = menuInfo(
                    title = "Web",
                    description = "stat-info.org"
                  )
                )
              ),
              box("follow us",
                width = NULL,
                #title = ,
                status = NULL,
                socialButton(
                  url = "https://web.facebook.com/statinfosenegal",
                  type = "facebook"
                ),
                socialButton(
                  url = "https://www.linkedin.com/company/statinfo-senegal/?viewAsMember=true",
                  type = "linkedin"
                )
              )
            )
                   
                     ),
            column(8,
              box(width = 12, status = "primary",title ="Our services", 
                  rightSidebarMenu(
                    
                    rightSidebarMenuItem(
                      icon = menuIcon(
                        name = "search-location",
                        color = "grey"
                      ),
                      info = menuInfo(
                        title = "Market Research",
                        description ="Analysis and quantification of a market, Evaluation of market shares
                        Assessment of product penetration,    Competitive analysis"
                      )
                    ),
                    rightSidebarMenuItem(
                      icon = menuIcon(
                        name = "tasks",
                        color = "grey"
                      ),
                      info = menuInfo(
                        title = "Project evaluation",
                        description = "Ex-ante evaluation, Intermediate or mid-term evaluation,Final evaluation,Ex-post evaluation / impact"
                      )
                    ),
                    
                    rightSidebarMenuItem(
                      icon = menuIcon(
                        name = "wpforms",
                        color = "grey"
                      ),
                      info = menuInfo(
                        title = "Quantitatve / Qualitative Survey",
                        description = "Study of awareness / motivations / opinions,
Customer Satisfaction Survey,
                        Internal employee satisfaction survey,
                        Media research: channel audience,
                        Evaluation of an advertising campaign "
                      )
                    ),
                    
                    rightSidebarMenuItem(
                      icon = menuIcon(
                        name = "sitemap",
                        color = "grey"
                      ),
                      info = menuInfo(
                        title = "Design of digitized data collection system",
                        description = "ODK,
CsPro,
Commcare,
Kobo ToolBox,
SurveyCTO,
EnKeto, 
SurveyMonkey,
EpiCollet,
LimeSurvey"
                      )
                    )


                  )
                  ), 
              box(width = 12, title = "Our training courses",status = "primary",
                  fluidRow(
                   
                           column(3, img(src="excel.png", class="image_ref"),h6("Microsoft Excel")),
                           column(3, img(src="r.png", class="image_ref"),h6("R/RStudio")),
                                  column(3, img(src="stata.jpeg", class="image_ref"),h6("STATA")),
                                         column(3, img(src="spss.png", class="image_ref"), h6("SPSS"))
                                                
                  ),
                  fluidRow(
                    
                    column(3, img(src="cs.png", class="image_ref"),h6("CSPro")),
                    column(3, img(src="cc.png", class="image_ref"),h6("CommCare")),
                    column(3, img(src="odk.png", class="image_ref"),h6("ODK")),
                    column(3, img(src="qgis.png", class="image_ref"), h6("QGIS"))
                    
                  )),
              box(width = 12, title = "References",status = "primary",
                 
                  
                  box(
                    
                    
                    width = NULL,
                    userList(
                     userListItem(
                        src = "plan.jpg", 
                        user_name =span("Plan International", style="color:white") 
                        #description = "Evaluatiion SHOW Project"
                        
                      ),
                      userListItem(
                        src = 'ipar.jpeg', 
                        user_name =span("IPAR", style="color:white")                        # description = "28.04.2018"
                      ),
                      
                      userListItem(
                        src = "pil.jpeg", 
                        user_name =span("Philantropy Idvisors", style="color:white") 
                      ),
                      userListItem(
                        src = "intra.png", 
                        user_name =span("IntraHealth", style="color:white") 
                      ),
                      userListItem(
                        src ="tci.png", 
                        user_name =span("The Challenge Initiative", style="color:white") 
                      ),
                      userListItem(
                        src = "ifc.jpeg", 
                        user_name =span("International Finance Corporation", style="color:white") 
                      ),
                      
                      userListItem(
                        src = "rti.png", 
                        user_name =span("RTI International", style="color:white") 
                      ),
                      userListItem(
                        src = "esea.png", 
                        user_name =span("ESEA (UCAD)", style="color:white") 
                      )
                     
                     
                      
                    )
                  )
                  )
            )
          )
          
  )
  ) # dashbord 
  )
)