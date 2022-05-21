library(shiny)
library(tidyverse)

#####Import Data

###setwd("D:/Statistics/R/R data/test/shiny/Assignment")
dat<-read_csv("cces_sample_coursera.csv")

dat<- dat %>% select(c("pid7","ideo5"))
dat<-drop_na(dat)

ui <- fluidPage(
  
  # Application title
  titlePanel(""),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      sliderInput("i5",
                  "Select Five Point Ideology (1=Very liberal, 5=Very conservative)",
                  min = 1,
                  max = 5,
                  value = 3)
    ),
    mainPanel(
      plotOutput("p7")
    )
  )
)

  

server<-function(input,output){
  output$p7 <- renderPlot({
    plot_dat<-filter(dat, ideo5 %in% input$i5)
    
    ggplot(plot_dat, aes(pid7)) + geom_bar()+
      xlab("7 Point Party ID, 1=Very D, 7=Very R") +
      ylab("Count") +
      lims(x = c(-0.5,8)) +
      scale_y_continuous(limits = c(0, 125), breaks = seq(0, 125, by = 25))
            })
} 

shinyApp(ui = ui,server = server)
