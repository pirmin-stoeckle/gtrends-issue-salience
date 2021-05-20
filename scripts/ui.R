pageWithSidebar(
  headerPanel('Google Trends'),
  sidebarPanel(
    textInput('searchterm', 'Google Search Term', value = 'Klimawandel'),
    selectInput('issue_choice', 'MIP Issue', choices = unique(mip_scaled_long$issue))
  ),
  mainPanel(
    plotOutput('plot1'),
    plotlyOutput('plot2')
  )
)