#source('data_explorer.R')
library(ggplot2)
library(ggrepel)
library(maps)
library(tidyr)

server <- function(input, output, session) {
  # Allow for filtering datapoints on the map in the future. Adjust so that is filters based on vectors.
  dataUS <- reactive ({
    if(!is.null(input$ds_cat) & is.null(input$input_state_cc)){
      df_BEA_usCol %>% filter(Cash.Potential %in% c(input$cp_cat[1]:input$cp_cat[2]) & Desirability %in% input$ds_cat)
    }
    else if(!is.null(input$ds_cat) & !is.null(input$input_state_cc)){
      df_BEA_usCol %>% filter(Cash.Potential %in% c(input$cp_cat[1]:input$cp_cat[2]) & Desirability %in% input$ds_cat & State %in% input$input_state_cc)
    }
    else if(is.null(input$ds_cat) & !is.null(input$input_state_cc)){
      df_BEA_usCol %>% filter(Cash.Potential %in% c(input$cp_cat[1]:input$cp_cat[2]) & State %in% input$input_state_cc)
    }
    else {df_BEA_usCol %>% filter(Cash.Potential %in% c(input$cp_cat[1]:input$cp_cat[2]))}
  })
  #Output the leaflet Map.
  output$usa_map <- renderLeaflet({
    #data1 <- dataUS()
    map <- leaflet(data = map("state", fill = TRUE, plot = FALSE)) %>% 
      addProviderTiles(providers$CartoDB.Positron) %>% 
      addPolygons(fillColor = topo.colors(10, alpha = NULL), stroke = FALSE)
  })
  
  observe({
    data1 <- dataUS()
    cat_colors <- colorFactor(palette = c('blue','red','green','blueviolet', 'orange', 'black', 'darkgoldenrod4', 'yellow', 'gray48','magenta', 'cyan'),domain = data1$City.Category) 
    leafletProxy("usa_map") %>% 
      clearShapes() %>%
      addCircles(lng = ~lng, 
                 lat = ~lat, 
                 data = data1, 
                 radius = 2e4,
                 color = ~cat_colors(City.Category), 
                 popup = paste("City: ", data1$City, "<br>",
                               "Cost of Living Index: ", data1$Cost.of.Living.Plus.Rent.Index,"<br>",
                               "Average Salary: ", data1$Avg.Salary, "<br>",
                               "Local Purchasing Power: ", data1$Local.Purchasing.Power, "<br>",
                               "Cash Potential: ", data1$Cash.Potential, "<br>",
                               "Popularity: ", data1$Desirability, "<br>"
                               #"City Category: ", data1$City.Category
                               ))
  })
  
  ds_list <- df_BEA_usCol %>% `$`('Desirability') %>% sort() %>% unique() %>% as.character()
  updateSelectInput(session, "ds_cat", choices = ds_list)
  
  observe({
    #if(is.null(input$input_state_cc)){
      states_per_cat <- 
      if(!is.null(input$ds_cat)){
        df_BEA_usCol %>% filter(Cash.Potential %in% c(input$cp_cat[1]:input$cp_cat[2]) & Desirability %in% input$ds_cat) %>% 
          `$`('State') %>%
          sort() %>% 
          unique()}
      else{
        df_BEA_usCol %>% filter(Cash.Potential %in% c(input$cp_cat[1]:input$cp_cat[2])) %>% 
          `$`('State') %>%
          sort() %>% 
          unique()}
      updateSelectInput(session, "input_state_cc", choices = states_per_cat)
  })
  
  #City Details
  observe({
    city_list <- if (is.null(input$states)) character(0) else {
      df_usCol_1 %>% filter(State == input$states) %>% 
        `$`('City') %>%
        sort()
    }
    #Isolate prevents selected from auto picking the first choice City.
    updateSelectInput(session, "cities", choices = city_list)
  })
  city_cli_df <- reactive({
    climate14_18 %>% filter(City %in% input$cities & State %in% input$states)
  })
  x <- reactive({
    if(input$temp_vars == "TEMP"){
      geom_text_repel(data = city_cli_df(), inherit.aes = FALSE, aes(x = Season, y = TEMP, label = TEMP),  min.segment.length = unit(0.2, 'lines'), nudge_x = -.22)
    } else if(input$temp_vars == "MAX"){
      geom_text_repel(data = city_cli_df(), inherit.aes = FALSE, aes(x = Season, y = MAX, label = MAX),  min.segment.length = unit(0.2, 'lines'), nudge_x = -.22)
    } else if(input$temp_vars == "MIN"){
      geom_text_repel(data = city_cli_df(), inherit.aes = FALSE, aes(x = Season, y = MIN, label = MIN),  min.segment.length = unit(0.2, 'lines'), nudge_x = -.22)
    } else{
      geom_text_repel(data = city_cli_df(), inherit.aes = FALSE, aes(x = Season, y = HI, label = HI),  min.segment.length = unit(0.2, 'lines'), nudge_x = -.22)
    }
  })
  #renderPlot
  
  output$tempPlot <- renderPlot({
    l1 <- x()
    if(input$temp_vars == "TEMP" | input$temp_vars == "MAX" | input$temp_vars == "MIN"){y_lab <- "Temprature"} else{y_lab <- "Heat Index"}
    ggplot(data = climate14_18, aes(x = Season)) +
      geom_point(aes_string(y = input$temp_vars, colour = input$temp_vars),size = 1) +
      scale_colour_gradient2(low="#2E7DD2", mid = "#FAFF00", high="#FF5700", midpoint = 60) +
      labs(x = "Seasons", y = y_lab) +
      theme(axis.title.y = element_text(size = rel(1.5))) +
      theme(axis.title.x = element_text(size = rel(1.5))) +
      theme(axis.text.y = element_text(size = rel(1.5))) +
      theme(axis.text.x = element_text(size = rel(1.5))) +
      theme(legend.text = element_text(size = rel(1.2))) +
      theme(legend.title = element_text(size = rel(1.2))) + l1
  }#, height = 420, width = 600
  )
  
  output$disTbl <- renderTable({
    df_natDis %>% filter(Abbreviation == input$states) %>% select(-c(1,2)) %>% 
      pivot_longer(everything(), names_to="Disaster") %>% filter(value=="Yes") %>% select("Disaster")
    }, colnames = FALSE, striped = TRUE, width = "100%")
  #Data Explorer
  #de_server(input, output, session)
  #de_cols = colnames(df_natDis)[-c(1,2)]
  #updateSelectInput(session, "Natural_Disasters", choices = de_cols, selected = de_cols)
  }
  
