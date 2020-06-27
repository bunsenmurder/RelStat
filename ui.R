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
                      fluidRow(column(width = 12,
                                      box(title = "Metropolitan Area Map", width = NULL, solidHeader = TRUE, status = "primary",
                                          leafletOutput("usa_map"#, height = "500"
                                                        ),
                                          tags$div(id="cite", 'Source: ', tags$em(''), '2016 BEA Regional Price Parity & Real Personal Income')),
                                      box(title = "Controls",width = NULL, solidHeader = TRUE, status = "warning", 
                                          sliderInput("cp_cat", "Cash Potential", min = 1, max = 7, value=(c(1,7))), 
                                          selectInput("ds_cat", "Popularity", c("Categories"=""), multiple = TRUE),
                                          selectInput("input_state_cc", "State", c("States"=""),selected = "Florida", multiple = TRUE),
                                          helpText(p("Cash Potential measures income potential accounting for living expenses(rent, food, etc.) in a city from lowest to highest."),
                                                   p("Popularity measures how desirable it is to live in a city based on average cost of rent.")))
                                      ))
                          ),
                    tabItem(
                      tabName = "c_det",
                      fluidRow(column(width = 12,                      
                                      box(title = "Weather Graphs", width = NULL, plotOutput("tempPlot"), solidHeader = TRUE, status = "primary"),
                                      box(title = "Controls", width = NULL, solidHeader = TRUE, status = "warning",
                                          selectInput("states", "State", state_list, selectize = FALSE),
                                          selectInput("cities", "City", c("All cities"=""), selectize = FALSE),
                                          selectInput("temp_vars", "Temprature Measures", c("Average" = "TEMP", "Hottest" = "MAX", "Coldest" = "MIN", "Heat Index" = "HI"),selected = "TEMP", selectize = FALSE),
                                          tags$div(tags$b("Natural Disasters")),
                                          tags$p(""),
                                          tableOutput('disTbl'),
                                          helpText(
                                            p("The values on the graph highlight a selected citites temprature ranking compared to other cities."),
                                            p("Heat index measures the humidity relative to the temprature.")))
                                      ))
                      ))
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
  #                   helpText(p("Cash Potential measures income potential accounting for living expenses(rent, food, etc.) in a city from lowest to highest.")),
  #                   
  #                   selectInput("ds_cat", "Popularity", c("Categories"=""), multiple = TRUE),
  #                   helpText(p("Popularity measures how desirable it is to live in a city based on average cost of rent.")),
  #                   
  #                   selectInput("input_state_cc", "State", c("States"=""),selected = "Florida", multiple = TRUE)),
  #                 mainPanel(leafletOutput("usa_map", height = "700"),
  #                           tags$div(id="cite", 'Sourced from ', tags$em(''), 
  #                                    'Buereau of Economic Analysis: 2016 Regional Price Parity by MSA & 2016 Real Personal Income by MSA (MSA=Metropolitan Statistical Area)'))
  #                 )),
  #   
  #   ## City Details Section of the Application
    # tabPanel("Climate",
    #   sidebarLayout(position = "left",
    #     sidebarPanel("Options",
    #       selectInput("states", "State", state_list),
    #       selectInput("cities", "City", c("All cities"="")),
    #       selectInput("temp_vars", "Temprature Measures", c("Average" = "TEMP", "Hottest" = "MAX", "Coldest" = "MIN", "Heat Index" = "HI"),selected = "TEMP"),
    #       tags$div(tags$b("Natural Disasters")),
    #       tags$p(""),
    #       tableOutput('disTbl'),
    #       helpText(
    #         p("The arrows on the graph highlights a selected citites temprature values compared to other cities."),
    #         p("Heat index measures the humidity relative to the temprature."))),
    #     mainPanel(plotOutput("tempPlot"))
    #     ))
  #   )
