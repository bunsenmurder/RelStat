ui <- fluidPage(
  navbarPage("RelocationStation", id="nav",
    ## Map Section of the Application
    tabPanel("Map", 
      div(class = "outer",
        tags$head(
          includeCSS("themes.css")
        ),
        leafletOutput("usa_map", height = "700"),
        absolutePanel(id = "control", class = "panel panel-default", 
                      fixed = FALSE, draggable = TRUE, 
                      top = "auto", left = "auto", 
                      right = "auto", bottom = "400",
                      width = 140, height = 250,
                      checkboxInput("pick_df","Use BEA instead?", value = TRUE),
                      selectInput("cityc", "City.Category", c("Categories"=""), multiple = TRUE),
                      selectInput("input_state_cc", "State", c("States"=""), multiple = TRUE)
        ),
        absolutePanel(id = "control", draggable = TRUE, 
                      top = "auto", left = "auto", 
                      right = "auto", bottom = "110",
                      width = 140, height = 250,
                      helpText(p("Boxes can move!"),
                      p("Uncheck box to use numbeo data; values measured with diffrent scale."),
                      p("DS = Desirability"),
                      p("CP = Cash Potential"))
                      )
      ),
      tags$div(id="cite", 'Source: ', tags$em(''), ' Cost Of Living by numbeo.com and Regional Price Parity & Real Personal Income by bea.com.'
      )
    ),
    
    ## City Details Section of the Application
    tabPanel("City Details",
      sidebarLayout(position = "left",
        #fluid = TRUE,
        sidebarPanel("Options",
          selectInput("states", "State", state_list),
          selectInput("cities", "City", c("All cities"="")),
          selectInput("temp_vars", "Temprature Measures", 
            c("Avg Tempratures" = "TEMP", "Max Tempratures" = "MAX", "Min Tempratures" = "MIN"),selected = "TEMP"),
          helpText(p("The graphs show a distribution of values for all cities."), 
                   p("When a city is selected, arrows on the graphs point out the city."), 
                   p("The top graph are temprature values, while the bottom graph is the heat index of cities."), 
                   p("Heat index measures the humidity relative to the temprature."))
        ),
        mainPanel(
          column(10, plotOutput("tempPlot")), 
          column(10, plotOutput("hiPlot"))
        )
      )
    ),
    
    
    ## Data Explorer Section 
    ## Authored by Natalie Brum
    tabPanel("Data Explorer", #Start coding for UI below this comment!
             sidebarLayout(
               sidebarPanel(
                 selectInput("Natural_Disasters","Pick a Natural Disaster",
                             c("Blizzards" = "Blizzards", 
                               "Earthquakes" = "Earthquakes", 
                               "Hurricanes" = "Hurricanes", 
                               "Ice Storms" = "Ice_Storms", 
                               "Thunderstorms" = "Thunderstorms", 
                               "Tornadoes" = "Tornadoes", 
                               "Tsunamis" = "Tsunamis", 
                               "Volcanoes" = "Volcanoes"), multiple = TRUE),
                 helpText(p("Select a Natural Disaster to see which states have them, 
                            and select other tabs to explore data sets used within this app."))
               ),
               mainPanel(
                 tabsetPanel(type = "tab",
                             tabPanel("Natural Disasters Data Set", tableOutput("df_natDis")),
                             tabPanel("Numbeo Data Set", tableOutput("df_usCol_1")),
                             tabPanel("BEA Data Set", tableOutput("df_BEA_usCol")),
                             tabPanel("Weather Data Set", tableOutput("climate14_18"))
                             
                 )
               )
             )
    )
  )
)
