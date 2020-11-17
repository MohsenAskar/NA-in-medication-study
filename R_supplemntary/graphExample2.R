# igraph + ggraph example

library(dplyr)
library(ggraph)
library(igraph)

# Define constants
DO_THIS_LAYOUTS  = c('grid','star','circle','gem', 'dh', 'graphopt', 'mds', 'fr', 'kk', 'drl', 'lgl')
COLOR_VECTOR_SEX = c("#01C0DB", "#EF35AE")
COLOR_VECTOR_BMI = c("#FFFFBF", "#ABDDA4", "#FDAE61", "#D7191C")

# Read the data
frienshipTable = read.csv("friendship.csv", fileEncoding = "UTF-8", stringsAsFactors = FALSE)
patientsTable  = read.csv("patients.csv",   fileEncoding = "UTF-8", stringsAsFactors = FALSE)
# -- Sort the categories
patientsTable$BMICategorical = factor(patientsTable$BMICategorical, levels = c("Underweight", "Healthy",   "Overweight", "Obese"))

# Create the graph object
myGraph = graph_from_data_frame(frienshipTable,  vertices = patientsTable, directed = T)

# Plot the graph
# -- Select the variables you want to plot by variable index
highlightVariable = grep("^Sex$",            colnames(patientsTable))
rimVariable       = grep("^BMICategorical$", colnames(patientsTable))
sizeVariable      = grep("^BMI$",            colnames(patientsTable))
highlighColumn    = patientsTable[,highlightVariable]  # Sex Index
rimColumn         = patientsTable[,rimVariable]        # Rim Index
sizeColumn        = patientsTable[,sizeVariable]/5     # BMI Index
                                                       # Size is adjusted by 1/5
                                                       # to avoid giant nodes
# -- Set the title, colors, and so on...
colorVectorHighlight  = COLOR_VECTOR_SEX
colorVectorRim        = COLOR_VECTOR_BMI
plotSubtitle          = "Men and Women as nodes, size as BMI"
plotCaption           = "Source: Random data"
myVariables           = colnames(patientsTable)
highlitedName         = myVariables[highlightVariable]
rimName               = myVariables[rimVariable]
  
# -- Select the edges alpha values (friendship strength)
edgesStrength = frienshipTable$value

# -- Do one plot per layout, all with the same data
totalLayouts = length(DO_THIS_LAYOUTS)
for (i in 1:totalLayouts) {
    
    # Define the title and image name
    plotTitle = paste("Example of graph with ", DO_THIS_LAYOUTS[i], " layout", sep = '')
    plotFile  = paste("examplePlot_",DO_THIS_LAYOUTS[i],".png", sep = '')
    
    # Create the plot object
    myPlot = ggraph(myGraph, layout = DO_THIS_LAYOUTS[i])
    
    # Start adding layers to the plot
    myPlot = myPlot +
      # Plot the edges
      geom_edge_link0(edge_alpha = edgesStrength) +
      # Plot the nodes
      geom_node_point(aes(fill  = highlighColumn, color = rimColumn), size = sizeColumn, stroke = 3, shape = 21) +
      scale_fill_manual(values  = colorVectorHighlight) +
      scale_color_manual(values = colorVectorRim) +
      # Remove the background default lines and grey panel
      theme(panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            panel.background = element_blank(),
            axis.line        = element_blank(),
            axis.text.x      = element_blank(),
            axis.text.y      = element_blank(),
            axis.ticks       = element_blank()) +
      # Create titles and subtitles
      labs(title    = plotTitle,
           subtitle = plotSubtitle,
           caption  = plotCaption,
           color    = "Rim variable",
           fill     = "Fill variable")
    
    # Save the image into disk
    ggsave(plotFile, width = 8)    
}
