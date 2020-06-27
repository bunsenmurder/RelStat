# Authored by Natalie Brum
library(DT)
de_server <- function(input, output, session){
  #output$df_usCol_1 <- renderTable({
  #  df_usCol_1
  #})
  output$df_natDis <- renderTable({
    df_natDis[,c("States", input$Natural_Disasters)]
  })
  output$df_BEA_usCol <- renderTable({
    df_BEA_usCol
  })
  output$climate14_18 <- renderTable({
    climate14_18
  })
}
