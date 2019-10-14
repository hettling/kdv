library(shiny)
library(leaflet)
library(tmaptools)

##r_colors <- rgb(t(col2rgb(colors()) / 255))
##names(r_colors) <- colors()
vars <- c('a', 'b')

ui <- fluidPage(

    tags$head(
        ## Include our custom CSS
        includeCSS("styles.css")##,
      ##  includeScript("gomap.js")
    ),

    ##    tags$style(type = "text/css", "html, body {width:100%;height:200%}"),
##    tags$style(
##        HTML('
##             #input_date_control{opacity : 0;}
##             #sel_date:hover{opacity: 1;}')
##    ), 
    leafletOutput("mymap", height="95vh"),

    absolutePanel(        
        id = "controls", 
        ##class = "panel panel-default", 
        ##style = 'opacity: 1',
        fixed = TRUE, draggable = TRUE,
        top = 60, left = "auto", right = 20, bottom = "auto",
        width = 330, height = "auto",
        
        h2("Data Explorer"),
        
        selectInput("color", "Color", vars),
        selectInput("size", "Size", vars, selected = "adultpop"),
        conditionalPanel("input.color == 'superzip' || input.size == 'superzip'",
                                        # Only prompt for threshold when coloring or sizing by superzip
                         numericInput("threshold", "Selectivity threshold (admit rate less than)", 10)
                         ),
        
        plotOutput("histCentile", height = 200),
        plotOutput("scatterCollegeIncome", height = 250)#, 
        ##img(src="TCA_Logo_K (2).png", width = 150))
#       div(style = "margin: 0 auto;text-align: center;", 
#          HTML("</br> 
#              <a href=http://www.thirdcoastanalytics.com target=_blank>
#              <img style='width: 150px;' src='http://i.imgur.com/ZZkas87.png'/> </a>"))
#        http://imgur.com/kBhR1Q8
#        http://i.imgur.com/TfGZPss.png
#[Imgur](http://i.imgur.com/ZZkas87.png)
       #tags$a(href="www.rstudio.com", "Click here!")
)
    
#    absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
#                  draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
#                  width = 330, height = "auto",
#                  
#                  h2("Text here"),
#                  
#                  ##selectInput("color", "Color", vars),
#                  ##selectInput("size", "Size", vars, selected = "adultpop"),
#                  conditionalPanel("input.color == 'superzip' || input.size == 'superzip'",
#                                        # Only prompt for threshold when coloring or sizing by superzip
#                                   numericInput("threshold", "SuperZIP threshold (top n percentile)", 5)
#                                   )), 
#    
#
#    p()##,
    ##  actionButton("recalc", "New points")
)

server <- function(input, output, session) {

  output$mymap <- renderLeaflet({
      leaflet() %>%          
          addProviderTiles(providers$OpenStreetMap) %>%
          addMarkers(tab$lon, tab$lat, popup=paste(tab$actuele_naam_oko, "<br>",
                                                   tab$opvanglocatie_adres, "<br>",
                                                   tab$opvanglocatie_postcode, " ",
                                                   tab$opvanglocatie_woonplaats, "<br>",
                                                   "<a href=\"",tab$contact_website, "\">", tab$contact_website, "</a>"))
  })
}

if (! exists('tab')) {
    tab <- read.csv('../data/export_opendata_lrk.csv', header=T, sep=";")
    tab <- tab[1:10,]
    
    data <- geocode_OSM(paste(as.character(tab$opvanglocatie_adres),
                              as.character(tab$opvanglocatie_postcode),
                              as.character(tab$opvanglocatie_woonplaats)))
    
    tab$lat <- data$lat
    tab$lon <- data$lon
}

    
shinyApp(ui, server)

