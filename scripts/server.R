

#plot
# output$plot1 <- ggplot() +
#   geom_line(data=mip_scaled, aes(x=date, y=get(issues[4]), color="green")) +
#   geom_line(data=gtrends, aes(x=date, y=hits, color="navy")) +
#   labs(x = "",
#        y = "Index")+
#   scale_color_identity(name = "Data source",
#                        breaks = c("green", "navy"),
#                        labels = c(paste("MIP: ", issues[4]), paste("GTrends: ", input$searchterm)),
#                        guide = "legend")+
#   theme(legend.position = "bottom")




timeframe <- "2004-01-01 2021-03-11"
country <- "DE"

function(input, output) {
  
  dataInput_GTrends <- reactive({
    # gtrends data 
    gtrends(keyword = c(input$searchterm), geo = "DE", time = "2004-01-01 2021-03-11")$interest_over_time
  })
  
  dataInput_MIP <- reactive({
    # MIP data
    mip_scaled
  })
  
  output$plot <- renderPlot({  
    gtrends <- dataInput_GTrends()
    mip_scaled <- dataInput_MIP()
    ggplot() +
      geom_line(data=gtrends, aes(x=date, y=hits, color="navy")) +
      geom_line(data=mip_scaled, aes(x=date, y=get("Bildung"), color="green")) 
  })
}