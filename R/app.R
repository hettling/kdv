library(shiny)
library(leaflet)

##r_colors <- rgb(t(col2rgb(colors()) / 255))
##names(r_colors) <- colors()

ui <- fluidPage(
    tags$style(type = "text/css", "html, body {width:100%;height:200%}"),
    leafletOutput("mymap", height="95vh"),

    absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                  draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                  width = 330, height = "auto",
                  
                  h2("Text here"),
                  
                  ##selectInput("color", "Color", vars),
                  ##selectInput("size", "Size", vars, selected = "adultpop"),
                  conditionalPanel("input.color == 'superzip' || input.size == 'superzip'",
                                        # Only prompt for threshold when coloring or sizing by superzip
                                   numericInput("threshold", "SuperZIP threshold (top n percentile)", 5)
                                   )), 


    p()##,
    ##  actionButton("recalc", "New points")
)

server <- function(input, output, session) {

  output$mymap <- renderLeaflet({
      leaflet() %>%          
          addProviderTiles(providers$OpenStreetMap) %>%
          addMarkers(tab$lon, tab$lat, popup=paste(tab$actuele_naam_oko, "<br>",
                                                   tab$opvanglocatie_adres, "<br>",
                                                   tab$opvanglocatie_postcode, " ",
                                                   tab$opvanglocatie_woonplaats))
  })
}

if (FALSE) {
tab <- read.csv('../data/export_opendata_lrk.csv', header=T, sep=";")
tab <- tab[1:10,]

data <- geocode_OSM(paste(as.character(tab$opvanglocatie_adres),
                  as.character(tab$opvanglocatie_postcode),
                  as.character(tab$opvanglocatie_woonplaats)))

tab$lat <- data$lat
tab$lon <- data$lon
}

    
shinyApp(ui, server)

