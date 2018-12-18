#---------------------------------------------------------------------#
#                       Project Shiny App                             #
#---------------------------------------------------------------------#


library("shiny")

shinyUI(
  fluidPage(
  
    titlePanel("co-occurrences plot"),
  
    sidebarLayout( 
      
      sidebarPanel(  
        
              fileInput("file1","Upload data(any text file)"),
              
              fileInput("file2","Upload udipipe model"),
              checkboxGroupInput("check","Select list of xpos",
                                  c("Adjective" = "JJ",
                                    "Noun" = "NN",
                                    "Proper Noun" = "NNP",
                                    "Adverb" = "RB",
                                    "Verb" = "VB"
                                    ),selected = c("JJ","NN","NNP")                                
                                 )
                 
                  ),   # end of sidebar panel
    
    
    mainPanel(
      
      tabsetPanel(type = "tabs",
                  
                      tabPanel("Overview",
                               h4(p("Data input")),
                               p("This app supports only .txt data file",align="justify"),
                               p("Please refer to the link below for sample csv file."),
                               a(href="https://github.com/nikhilbhasincba/TABA/blob/master/nokia.txt"
                                 ,"Sample data input file"),   
                               br(),
                               h4('How to use this App'),
                               p('To use this app, click on', 
                                 span(strong("Upload data(any text file)")),
                                 'and upload the text file.'),
                               p('Next, click on', 
                                 span(strong("Upload udipipe model")),
                                 'and upload the model')
                               ),
                      tabPanel("Filter", 
                                   dataTableOutput('plot1')),
                      
                      tabPanel("co occurence",
                               plotOutput('cooc'))
        
      ) # end of tabsetPanel
          )# end of main panel
            ) # end of sidebarLayout
              )  # end if fluidPage
                ) # end of UI