library(shiny)
library(leaflet)

##r_colors <- rgb(t(col2rgb(colors()) / 255))
##names(r_colors) <- colors()

ui <- fluidPage(
    ##    tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
    leafletOutput("mymap"),
    p()##,
    ##  actionButton("recalc", "New points")
)

server <- function(input, output, session) {

  points <- eventReactive(input$recalc, {
    cbind(rnorm(40) * 2 + 13, rnorm(40) + 48)
  }, ignoreNULL = FALSE)

  output$mymap <- renderLeaflet({
      leaflet() %>%
          addTiles() %>%  # Add default OpenStreetMap map tiles
          addMarkers(lng=174.768, lat=-36.852, popup="The birthplace of R")
      ##    leaflet() %>%
      ##      addProviderTiles(providers$Stamen.TonerLite,
      ##        options = providerTileOptions(noWrap = TRUE)
      ##      ) %>%
      ##      addMarkers(data = points())
  })
}

shinyApp(ui, server)

