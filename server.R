
options(shiny.maxRequestSize = 30*1024^2)
shinyServer(function(input, output) {      ###default input
  
  Dataset <- reactive({                    #### any data that comes to server goes through reactive, important, made shiny possible, reactive works for processing
    
    if (is.null(input$file1)) {   # locate 'file1' from ui.R
      
                  return(NULL) } else{
      
      Data <- readLines(input$file1$datapath)
      Data  =  str_replace_all(Data, "<.*?>", "")
      #rownames(Data) = Data[,1]
      #Data1 = Data[,2:ncol(Data)]
      return(Data)
      
      
    }
  })
  
  Dataset2 <- reactive({                    #### any data that comes to server goes through reactive, important, made shiny possible, reactive works for processing
    
    if (is.null(input$file2)) {   # locate 'file2' from ui.R
      
      return(NULL) } else{
        
        model = udpipe_load_model(input$file2$datapath)
        
        return(model)
        
        
      }
  })
  
annotat1 = reactive({              #render works for processing
  
  x <- udpipe_annotate(Dataset2(), x = Dataset()) #%>% as.data.frame() %>% head()
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
                          
                          #str(all_cooc)
                          #head(all_cooc)
                          wordnetwork <- head(all_cooc,100)
                          wordnetwork <- igraph::graph_from_data_frame(wordnetwork) # needs edgelist in first 2 colms.
                          
                          ggraph(wordnetwork, layout = "fr") +  
                            
                            geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +  
                            geom_node_text(aes(label = name), col = "darkgreen", size = 4) +
                            
                            theme_graph(base_family = "Arial Narrow") +  
                            theme(legend.position = "none") +
                            
                            labs(title = "Cooccurrences within 3 words distance")
                          #return(all_cooc)
  
                        })
  
})