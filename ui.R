# load packages
library(shinydashboard)
library(gtrendsR)
library(tidyverse)
library(ggthemes)
library(plotly)

# load MIP Data (if data does not already exist, run "get-mip-data.R")
load(file=paste0(getwd(),"/data/MIP-Data.RData"))

getwd()
shinyUI(
dashboardPage(
  dashboardHeader(title = 'Google Trends'),
  dashboardSidebar(
    selectInput('issue_choice', 'MIP Issue', choices = unique(mip_scaled_long$issue)),
    textInput('searchterm', 'Google Search Term', value = 'Klimawandel')
  ),
  dashboardBody(
    fluidRow(
      box(width = 12, plotlyOutput('plot2')),
      infoBoxOutput("correlationBox")
    )
  )
)
)

# pageWithSidebar(
#   headerPanel('Google Trends'),
#   sidebarPanel(
#     textInput('searchterm', 'Google Search Term', value = 'Klimawandel'),
#     selectInput('issue_choice', 'MIP Issue', choices = unique(mip_scaled_long$issue))
#   ),
#   mainPanel(
#     #plotOutput('plot1'),
#     plotlyOutput('plot2')
#   )
# )