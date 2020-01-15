source('data_explorer.R')
library(ggplot2)
library(ggrepel)
library(maps)

server <- function(input, output, session) {
  # Allow for filtering datapoints on the map in the future. Adjust so that is filters based on vectors.
  dataUS <- reactive ({
    if(input$pick_df == "TRUE"){
      if(is.null(input$input_state_cc)){
        df_BEA_usCol %>% filter(City.Category %in% input$cityc)
      } else {
        df_BEA_usCol %>% filter(City.Category %in% input$cityc & State %in% input$input_state_cc)
      }
    } else {
      if(is.null(input$input_state_cc)){
        df_usCol_1 %>% filter(City.Category %in% input$cityc)
      } else {
        df_usCol_1 %>% filter(City.Category %in% input$cityc & State %in% input$input_state_cc)
      }
    }
  })
  #Output the leaflet Map.
  output$usa_map <- renderLeaflet({
    data1 <- dataUS()
    cat_colors <- colorFactor(palette = c('blue','red','green','blueviolet', 'orange', 'black', 'darkgoldenrod4', 'yellow', 'gray48','magenta', 'cyan'),domain = data1$City.Category) 
    map <- leaflet(data = map("state", fill = TRUE, plot = FALSE)) %>% 
      addProviderTiles(providers$CartoDB.Positron) %>% 
      addPolygons(fillColor = topo.colors(10, alpha = NULL), stroke = FALSE) %>% 
      addCircles(lng = ~lng, lat = ~lat, data = data1,radius = 2e4,color = ~cat_colors(City.Category), popup = paste("City: ", data1$City, "<br>",
                                                                    "Cost of Living Index: ", data1$Cost.of.Living.Plus.Rent.Index,"<br>",
                                                                    "Average Salary: ", data1$Avg.Salary, "<br>",
                                                                    "Local Purchasing Power: ", data1$Local.Purchasing.Power, "<br>",
                                                                    "City Category: ", data1$City.Category))
  })
  observe({
    if(input$pick_df == "TRUE"){
      states_per_cat <- if (is.null(input$cityc)) character(0) else {
        df_BEA_usCol %>% filter(City.Category %in% input$cityc) %>% 
          `$`('State') %>%
          sort() %>% 
          unique()}
    } else{
      states_per_cat <- if (is.null(input$cityc)) character(0) else {
        df_usCol_1 %>% filter(City.Category %in% input$cityc) %>% 
          `$`('State') %>%
          sort() %>% 
          unique()}
    }
    updateSelectInput(session, "input_state_cc", choices = states_per_cat, selected = isolate(input$input_state_cc))
  })
  observe({
    if(input$pick_df == "TRUE"){
      df_usCol <- df_BEA_usCol
    } else if (input$pick_df == "FALSE"){
      df_usCol <- df_usCol_1
    }
    ccat_list <- df_usCol %>% `$`('City.Category') %>% unique() %>% as.character()
    updateSelectInput(session, "cityc", choices = ccat_list)
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
  city_bea_df <- reactive({
    df_BEA_usCol %>% filter(City %in% input$cities & State %in% input$states)
  })
  city_nbeo_df <- reactive({
    df_usCol_1 %>% filter(City %in% input$cities & State %in% input$states)
  })
  x <- reactive({
    if(input$temp_vars == "TEMP"){
      geom_text_repel(data = city_cli_df(), inherit.aes = FALSE, aes(x = Season, y = TEMP, label = TEMP),  min.segment.length = unit(0.2, 'lines'), nudge_x = -.22)
    } else if(input$temp_vars == "MAX"){
      geom_text_repel(data = city_cli_df(), inherit.aes = FALSE, aes(x = Season, y = MAX, label = MAX),  min.segment.length = unit(0.2, 'lines'), nudge_x = -.22)
    } else {
      geom_text_repel(data = city_cli_df(), inherit.aes = FALSE, aes(x = Season, y = MIN, label = MIN),  min.segment.length = unit(0.2, 'lines'), nudge_x = -.22)
    }
  })
  output$tempPlot <- renderPlot({
    l1 <- x() 
    ggplot(data = climate14_18, aes(x = Season)) +
      geom_point(aes_string(y = input$temp_vars, colour = input$temp_vars),size = 1) + 
      scale_colour_gradient2(low="#2E7DD2", mid = "#FAFF00", high="#FF5700", midpoint = 60) +
      labs(x = "Seasons", y = "Temperatures") + 
      theme(axis.title.y = element_text(size = rel(1.5))) + 
      theme(axis.title.x = element_text(size = rel(1.5))) + 
      theme(axis.text.y = element_text(size = rel(1.5))) + 
      theme(axis.text.x = element_text(size = rel(1.5))) + 
      theme(legend.text = element_text(size = rel(1.2))) + 
      theme(legend.title = element_text(size = rel(1.2))) + l1
  }, height = 420, width = 600)
  output$hiPlot <- renderPlot({
    ggplot(data = climate14_18, aes(x = Season, y = HI, colour = HI)) +
      geom_point(size = 1) + 
      scale_colour_gradient2(low="#2E7DD2", high="#FF5700") +
      labs(x = "Seasons", y = "Heat Index") + 
      geom_text_repel(data = city_cli_df(), inherit.aes = FALSE, aes(x = Season, y = HI, label = HI),  min.segment.length = unit(0.2, 'lines'), nudge_x = -.22) +
      theme(axis.title.y = element_text(size = rel(1.5))) + 
      theme(axis.title.x = element_text(size = rel(1.5))) +
      theme(axis.text.y = element_text(size = rel(1.5))) + 
      theme(axis.text.x = element_text(size = rel(1.5))) +
      theme(legend.text = element_text(size = rel(1.2))) + 
      theme(legend.title = element_text(size = rel(1.2)))
  }, height = 420, width = 600)
  #Data Explorer
  de_server(input, output, session)
  }
  
