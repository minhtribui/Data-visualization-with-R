library(shiny)
library(tidyverse)
library(plotly)
library(DT)

#####Import Data

dat<-read_csv(url("https://www.dropbox.com/s/uhfstf6g36ghxwp/cces_sample_coursera.csv?raw=1"))
dat<- dat %>% select(c("pid7","ideo5","newsint","gender","educ","CC18_308a","region"))
dat<-drop_na(dat)

#####Make your app

ui <- navbarPage(
  title="My Application",
  tabPanel("Page 1",
           sidebarLayout(sidebarPanel(sliderInput("i5",
                                  "Select Five Point Ideology (1=Very liberal, 5=Very conservative)",
                                  min = 1,
                                  max = 5,
                                   value = 3)),
            mainPanel(
              tabsetPanel(
                tabPanel("Tab1", plotOutput("plot1")), 
                tabPanel("Tab2", plotOutput("plot2")))))),
  
  tabPanel("Page 2",
           sidebarLayout(sidebarPanel(checkboxGroupInput("G",
                                            "Select Gender",
                                           c(1:2))),
           mainPanel(
             plotlyOutput("plot3")))),
  tabPanel("Page 3",
           sidebarLayout(sidebarPanel(selectInput("Region",
                                    "Select Region",
                                    c(1:4),
                                    multiple = TRUE)),
           mainPanel(
             dataTableOutput("regiondata"))))
)
server<-function(input,output){
  output$plot1 <- renderPlot({
    plot_dat<-filter(dat, ideo5 %in% input$i5)
    
    ggplot(plot_dat, aes(pid7)) + geom_bar()+
      xlab("7 Point Party ID, 1=Very D, 7=Very R") +
      ylab("Count") +
      lims(x = c(-0,8)) +
      scale_y_continuous(limits = c(0, 100), breaks = seq(0, 100, by = 25))
  })
  
  output$plot2 <- renderPlot({
    plot_dat<-filter(dat, ideo5 %in% input$i5)
    
    ggplot(plot_dat, aes(CC18_308a)) + geom_bar()+
      xlab("Trump Support") +
      ylab("count") +
      lims(x = c(0,5)) 
      
  })
  
  output$plot3 <- renderPlotly({
    dat %>%
      filter(gender %in% input$G) %>%
      ggplot(mapping = aes(x = educ, y = pid7)) +
      geom_jitter() +
      geom_smooth(method = lm) -> g
    ggplotly(g)
             
  })
  
  output$regiondata <- renderDataTable({
    dat %>% filter(region %in% input$Region)},
      options = list(columnDefs = list(list(targets = c(1:7),searchable = FALSE))))
  
} 

shinyApp(ui,server)