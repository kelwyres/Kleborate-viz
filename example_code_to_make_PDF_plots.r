 # code to make the plot - to be called in the app or in an output PDF file
 SThist_reactive <- reactive({
	ggplot()
 })

 # render the plot in the app - this object name needs to be positioned in the layout
 output$SThist <- renderPlot ({
 	print(SThist_reactive())
 })
 
 # create an output PDF file and render the plot - this object name needs to be positioned in the layout
 output$STdist_plot_download <- downloadHandler(
 	filename = function() {"ST_distribution.pdf"}, #default filenmae
 	content = function(file) {
 		pdf(file, width = 10, height = 6)
 		print(SThist_reactive())
 		dev.off()
 	}
 )
 
 # position this download button somehwere in the layout
 downloadButton(outputId = "STdist_plot_download", label = "Download the plot")
 
 
 resScoreBarBySpecies_plot_download
 virScoreBarBySpecies_plot_download
 
 
 ### to download data table
 
 # in ui:
 downloadButton("downloadData", "Download")
 
 # in server:
 
   output$downloadData <- downloadHandler(
    filename = function() {
      paste(input$dataset, ".csv", sep = "")
    },
    content = function(file) {
      write.csv(datasetInput(), file, row.names = FALSE)
    }
  )