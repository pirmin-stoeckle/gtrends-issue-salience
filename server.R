# load packages
library(gtrendsR)
library(tidyverse)
library(ggthemes)
library(plotly)

# load MIP Data (if data does not already exist, run "get-mip-data.R")
load(file=paste0(getwd(),"/data/MIP-Data.RData"))


shinyServer(function(input, output) {
  
  dataInput_GTrends <- reactive({
    # gtrends data 
    gtrends(keyword = c(input$searchterm), geo = "DE", time = "2004-01-01 2021-03-11")$interest_over_time %>% 
      mutate(date2 = format(as.Date(date), "%Y-%m"))
    #gtrends(keyword = "Klimawandel", geo = "DE", time = "2004-01-01 2021-03-11")$interest_over_time
  })
  
  dataInput_MIP <- reactive({
     # MIP data
    mip_scaled_long <- mip_scaled_long %>% 
      filter(issue == input$issue_choice)
   })
  
  output$plot1 <- renderPlot({  
    gtrends <- dataInput_GTrends()
    gtrends$hits <- as.numeric(ifelse(gtrends$hits == "<1", "0", gtrends$hits))
    mip_scaled_long <- dataInput_MIP()
    ggplot(data=gtrends, aes(x=date, y=hits, color="navy")) +
      geom_line() +
      geom_line(data=mip_scaled_long, aes(x=date, y=index, color="green")) +
      theme_minimal()
  })
  output$plot2 <- renderPlotly({
    gtrends <- dataInput_GTrends()
    gtrends$hits <- as.numeric(ifelse(gtrends$hits == "<1", "0", gtrends$hits))
    mip_scaled_long <- dataInput_MIP()
    
    plot_ly(mip_scaled_long, 
            x = ~date, 
            y = ~index, 
            type = 'scatter', 
            mode = 'lines',
            name = "MIP index") %>% 
      add_lines(x = ~gtrends$date,
                y = ~gtrends$hits,
                name = "Google Trends index") %>% 
      layout(xaxis = list(title = ""),
             legend = list(orientation = 'h'))
  })
  
  
  # correlation
  dataInput_correlation <- reactive({
    merge <- dataInput_MIP() %>% 
      mutate(date2 = format(as.Date(date), "%Y-%m")) %>% 
      inner_join(dataInput_GTrends(), by = "date2")
  })
  
  output$correlationBox <- renderInfoBox({
    infoBox(
      "R squared", round(summary(lm(index ~ hits, data = dataInput_correlation()))$r.squared, 2), icon = icon("calculator")
    )
  })
  
}
)