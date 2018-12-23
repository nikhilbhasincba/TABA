
options(shiny.maxRequestSize = 30*1024^2)
shinyServer(function(input, output) {      ###default input
  
  Dataset <- reactive({                    
    
                      if (is.null(input$file1)) {   
      
                                 return(NULL) } else{
                                          Data <- readLines(input$file1$datapath,encoding = 'UTF-8')
                                          Data  =  str_replace_all(Data, "<.*?>", "")
                                          return(Data)
  
                                                    }
                     })
  
  Dataset2 <- reactive({                    
    
                       if (is.null(input$file2)) {   
      
                                   return(NULL) } else{
                                              
                                              model = udpipe_load_model(input$file2$datapath)
                                              return(model)
        
                                                      }
                      })
  
annotat1 = reactive({              
  
                      x <- udpipe_annotate(Dataset2(), x = Dataset()) 
                      x <- as.data.frame(x)
                      return(x)
  
                   })


output$plot1 = renderDataTable({
  
                                all_nouns = annotat1() %>% subset(., xpos %in% input$check) 
                                return(all_nouns)
  
                              })


output$cooc = renderPlot({
                          all_cooc =  cooccurrence(

                                                    x = subset(annotat1(), xpos %in% input$check),term = "lemma",group = c("paragraph_id", "sentence_id"))
                                                    wordnetwork <- head(all_cooc,20)
                                                    wordnetwork <- igraph::graph_from_data_frame(wordnetwork)
                                                
                                                  ggraph(wordnetwork, layout = "fr") +
                                                        geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +
                                                        geom_node_text(aes(label = name), col = "darkblue", size = 10) +
                                                        theme_graph(base_family = "Arial") +
                                                        theme(legend.position = "centre") +
                                                        labs(title = "Cooccurrences plot")
                                                
                        })
  
})