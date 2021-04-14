pageWithSidebar(
  headerPanel('Google Trends'),
  sidebarPanel(
    textInput('searchterm', 'Search Term', value = 'Klimawandel')
  ),
  mainPanel(
    plotOutput('plot')
  )
)