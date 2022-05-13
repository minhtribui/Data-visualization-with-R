library(shiny)

# Define UI for dataset viewer app ----
ui <- fluidPage(
  
  # App title ----
  titlePanel(""),

    # Sidebar layout with a input and output definitions ----
  sidebarLayout(
    # Sidebar panel for inputs ----
    sidebarPanel(
      h4(strong("Text box"), align = "center"),
      # Input: Selector for choosing dataset ----
      textInput(inputId = "Name",
                label = "Your name:",
                value = "Nguyen Van A"),
      numericInput(inputId = "Age",
                  label = "Year of birth:", min = 1800, max = 2022,
                  value = "1992"),
      radioButtons(inputId= "Gender",
                   label = "Gender",
                   c("Female", "Male")),
      textInput(inputId = "Yearevent",
                label = "Year events:",
                value = "Cold War declared over, Finland applies for EC membership and Denmark win Euro 92"),
      checkboxGroupInput(inputId = "Character",
                         label = "Your personal qualities:",
                         choices =  
                           list("Confidence","Creativity","Enthusiasm","Flexibility", "Honesty", "Humility", "Initiative", "Loyalty")),
      textInput(inputId = "Job",
                label = "Job/School:",
                value = "Researcher"),
      textInput(inputId = "Location",
                label = "School/ Company name:",
                value = "ABC company"),
      textInput(inputId = "detailjob",
                label = "Detail about job/school:",
                value = "My company specializes in testing services including human, and terrestrial diseases. It is a demanding job as there is a wide variety of tasks I have to complete each day including organizing meeting with my colleagues, conducting experiments, preparing reports for daily activities and so on. My typical workday starts at 8A.M and ends around 5pm. At the beginning of the day, I check my emails and answer them. Then, I make a list of important things that I have to do and spend the rest of the day doing my daily tasks such as setting up experiments, collecting data about new clients and writing reports. After I get off, I usually hangout with my friends and its always a blast. We would like to grab a couple of drinks or maybe a bite to eat if we’re feeling up to do so. It’s a great way to unwind and chill."),
      sliderInput(inputId = "Member",
                  label = "Number of family members:", min = 1, max = 8,
                  value = 3),
      textInput(inputId = "Family",
                label = "Detail about family members:",
                value = "I live with my parents, my elder sister and my younger brother. My dad is forty-six years old. He is a driver but he is now retiring. After retiring, he helps my mother with her café. My father often wakes up so early to water his trees. He has a hobby of growing plants at home. My dad is a humorous and sociable person, so he is always loved by the neighbors. He is also a kind person who always likes to help people. I love my dad so much because of his kindness, careness and love. My mother is thirty-eight years old. She is a housewife, but also runs a small coffee shop. Like my father, my mom often wakes up soon to go the the café. My mother is a good person in many ways, she knows how to do business and take care of her family well. My mother is the most beautiful and guaranteed woman that I have ever seen. Although sometimes a bit strict, she always does the best for me. I am very grateful that she gave me up and loved me very much. Another person in my family is my elder sister. She is eighteen years old. My sister is a fairly timid and little speaker. She always put up with me and my brother. She often leads me to go to the movies. My sister helps me a lot with my hard exercises. She also plays with me everytime she is free. She loves me so much and I love her too. The last member of my family is my younger brother. He is two years old. When my mother gave birth to my brother, I felt extremely surprised. But then, I like him too much. Because he is only two years old, he is small and very lovely. I like to play with him when I do not have any homework. I will always love my younger brother. Although my family is crowded, everyone has always helped and loved each other. Family is an indispensable thing in my life. Wherever I go or whatever I am, I will always respect and protect my family.")
     ),
      
      # Main panel for displaying outputs ----
      
      mainPanel(
        tabsetPanel(type = "tabs",
            tabPanel("Introduction",
                h2(strong("Introduce about yourself"), align = "center"),
                textOutput("selected_var"),
                br(textOutput("selected_family"))),
            tabPanel("Summary",
                tableOutput("values")))
                )
  )
)

# Define server logic to summarize and view selected dataset ----
server <- function(input, output){
  output$selected_var <- renderText({ 
    paste("My name is", input$Name, ", I was born in ", input$Age, ". That is the year with numerous events:", input$Yearevent, 
            ". Currently, I am a", input$Job, "at", input$Location, ".", input$detailjob)}) 
    
  output$selected_family <- renderText({
    paste("My family has", input$Member, " people.", input$Family) })
  
  
  sliderValues <- reactive({
    data.frame(
      Name = c("Name",
               "Year of birth",
               "Gender",
               "Year events",
               "Personal qualities",
               "Job",
               "Company name",
               "Family member"),
      Value = as.character(c(input$Name,
                             input$Age,
                             input$Gender,
                             input$Yearevent,
                             paste(input$Character, collapse = "; "),
                             input$Job,
                             input$Location,
                             input$Member)),
      stringsAsFactors = FALSE) })
  
  output$values <- renderTable({
        sliderValues()  
      })
}  

shinyApp(ui = ui, server = server)

