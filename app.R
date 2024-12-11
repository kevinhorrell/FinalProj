
#Shiny App with star data
library(shiny)
library(tidyverse)
library(DT)

load('appdata.RData')


# Define UI for application that creates a geom_point chart
ui <- fluidPage(
  
  titlePanel("Diagram of The Stars in Our Sky"),
  
  h4("This app allows your to view data about stars based on their size, magnitude, temperature, and spectral class."),
  h4("You can click on a star and see it's metadata."),
  
  #Sidebar layout
  sidebarLayout(
  
    sidebarPanel(
    
    #Star Type
    checkboxGroupInput(
      inputId = "star_type",
      label = "Type of Star",
      choiceNames = list("Brown Dwarf", "Red Dwarf", "White Dwarf", "Main Sequence", "Supergiant", "Hypergiant", "unknown"),
      choiceValues = list("Brown Dwarf", "Red Dwarf", "White Dwarf", "Main Sequence", "Supergiant", "Hypergiant", "unknown"),
      selected = c("Brown Dwarf", "Red Dwarf", "White Dwarf", "Main Sequence", "Supergiant", "Hypergiant", "unknown"),
    ),
  
    #Star Letter Class
    checkboxGroupInput(
      inputId = "spectral_class",
      label = "Spectral Class",
      choiceNames = list('O', 'B', 'A', 'F', 'G', 'K', 'M'),
      choiceValues = list('O', 'B', 'A', 'F', 'G', 'K', 'M'),
      selected = c('O', 'B', 'A', 'F', 'G', 'K', 'M'),
    ),
    
    #Temperature
    sliderInput(
      inputId = "temp_K",
      label = "Temperature (K)",
      min = 1900,
      max = 40000,
      value = c(1900, 40000)
    ),
    
    #Magnitude
    sliderInput(
      inputId = "absmag_M",
      label = "Absolute Magnitude",
      min = -12,
      max = 20.1,
      value = c(-12, 20.1)
    )
  ),

    mainPanel(
      plotOutput("distPlot", click = "plot_click"),
      DTOutput("star_details")
    )

  )

)  

#Define the Server
server <- function(input, output) {
  
  stars_react <- reactive({
    stars_final %>%
      filter(temp_K >= input$temp_K[1] & temp_K <= input$temp_K[2]) %>%
      filter(star_type %in% input$star_type) %>%
      filter(absmag_M >= input$absmag_M[1] & absmag_M <= input$absmag_M[2]) %>%
      filter(spectral_class %in% input$spectral_class)

  })
  
  output$distPlot <- renderPlot({
    ggplot(stars_react()) +
      geom_point(aes(x = temp_K, y = absmag_M, fill = star_color, size = radius), shape = 23, alpha = 0.5) +
      scale_fill_manual(values = colors, name = "Star Type") +
      scale_y_reverse() +
      scale_x_reverse() +
      coord_cartesian(
        xlim = c(41000, 1500),
        ylim = c(21, -12)) +
      xlab("Temperature (K)") +
      ylab("Absolute Magnitude") +
      theme_dark() +
      theme(legend.position = "right")

  })

  output$star_details <- renderDataTable({
    req(input$plot_click)
    
    nearPoints(stars_react(), input$plot_click, 
               xvar = "temp_K", 
               yvar = "absmag_M")
  }, options = list(pageLength = 5))
  
}
  
# Run the application 
shinyApp(ui = ui, server = server)
