# load packages
library(gtrendsR)
library(tidyverse)
library(ggthemes)
library(plotly)

# get MIP-data for Germany from Forschungsgruppe Wahlen
src <- "https://www.forschungsgruppe.de/Umfragen/Politbarometer/Langzeitentwicklung_-_Themen_im_Ueberblick/Politik_II/9_Probleme_1_1.xlsx"
lcl <- paste0(getwd(), "/data/", basename(src))

# prepare folder for data, if not already done
if (!dir.exists(paste0(getwd(), "/data"))) {
  dir.create(paste0(getwd(), "/data"))
}

if (!file.exists(lcl)) {
  download.file(url = src, destfile = lcl, mode = "wb")
}

# read into R
mip <- readxl::read_excel(lcl, skip = 7, col_types = c("date", rep("numeric", 6)))
head(mip)

names(mip)[1] <- "date"

issues <- names(mip)[-1]


mip_scaled <- mip[,1]

for (issue in 2:(length(issues)+1)) {
  mip_scaled[,issue] <- mip[,issue] / max(mip[,issue], na.rm = T)*100
}


mip_scaled_long <- pivot_longer(mip_scaled, cols = -date, names_to = "issue", values_to = "index")



# Google Trends
timeframe <- "2004-01-01 2021-03-11"
country <- "DE"

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