ui <-
  dashboardPage(dashboardHeader(title = "RelocationStation"),
                dashboardSidebar(
                  sidebarMenu(
                    menuItem("Map", tabName = "map", icon = icon("globe")),
                    menuItem("Climate", tabName = "c_det", icon = icon("wind"))
                  )
                ),
                dashboardBody(
                  tabItems(
                    tabItem(
                      tabName = "map",
                      box(title = "City Map",
                          leafletOutput("usa_map", height = "700")
                          #width = "100%",
                          #height = "100%",
                          ),
                      box(title = "Cash Pot", sliderInput("cp_cat", "Cash Potential", min = 1, max = 7, value=(c(1,7))), 
                          selectInput("ds_cat", "Popularity", c("Categories"=""), multiple = TRUE),
                          selectInput("input_state_cc", "State", c("States"=""),selected = "Florida", multiple = TRUE))
                          ),
                    tabItem(
                      tabName = "c_det",
                      #plotOutput
                      #box(title = "Weather Graph",plotOutput("tempPlot")),
                      #box(title = "Weather Graph",ggiraphOutput("tempPlot")),
                      box(title = "Weather Graphs",plotOutput("tempPlot")),
                      box(title = "Controls", 
                          selectInput("states", "State", state_list),
                          selectInput("cities", "City", c("All cities"="")),
                          selectInput("temp_vars", "Temprature Measures", c("Average" = "TEMP", "Hottest" = "MAX", "Coldest" = "MIN", "Heat Index" = "HI"),selected = "TEMP"),
                          tableOutput('disTbl')
                          )
                    )
                    )
                  ),
                skin = "blue"
                )
  # navbarPage("RelocationStation", id="nav",
  #   ## Map Section of the Application
  #   tabPanel("Map", 
  #   sidebarLayout(position = "left",
  #                 sidebarPanel(
  #                   helpText(p("Click any city to see more details!")),
  #                   sliderInput("cp_cat", "Cash Potential", min = 1, max = 7, value=(c(1,7))),
  #                   helpText(p("Measures income potential in a city from lowest to highest. Based on average living expenses and average income.")),
  #                   
  #                   selectInput("ds_cat", "Popularity", c("Categories"=""), multiple = TRUE),
  #                   helpText(p("Measures how desirable it is to live in a city. Based on cost of rent.")),
  #                   
  #                   selectInput("input_state_cc", "State", c("States"=""),selected = "Florida", multiple = TRUE)),
  #                 mainPanel(leafletOutput("usa_map", height = "700"),
  #                           tags$div(id="cite", 'Sourced from ', tags$em(''), 
  #                                    'Buereau of Economic Analysis: 2016 Regional Price Parity by MSA & 2016 Real Personal Income by MSA (MSA=Metropolitan Statistical Area)'))
  #                 )),
  #   
  #   ## City Details Section of the Application
  #   tabPanel("Climate",
  #     sidebarLayout(position = "left",
  #       sidebarPanel("Options",
  #         selectInput("states", "State", state_list),
  #         selectInput("cities", "City", c("All cities"="")),
  #         selectInput("temp_vars", "Temprature Measures", c("Average" = "TEMP", "Hottest" = "MAX", "Coldest" = "MIN", "Heat Index" = "HI"),selected = "TEMP"),
  #         tags$div(tags$b("Natural Disasters")),
  #         tags$p(""),
  #         tableOutput('disTbl'),
  #         helpText(
  #           p("The arrows on the graph highlights a selected citites temprature values compared to other cities."), 
  #           p("Heat index measures the humidity relative to the temprature."))),
  #       mainPanel(plotOutput("tempPlot"))
  #       ))
  #   )
