# load packages
library(shinydashboard)
library(gtrendsR)
library(tidyverse)
library(ggthemes)
library(plotly)


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