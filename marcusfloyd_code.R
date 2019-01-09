# Prior to loading packages, use install.packages() function, to have the following packages available. 
# Load the following packages, using library().
library(network)
library(networkDynamic)
library(ndtv)
library(animation)
library(readxl)
library(tibble)

# Import USA Military Colleges dataset from excel. Assign as USA_Military_colleges
USA_Military_Colleges <- read_excel("~/USA Military Colleges.xlsx")

# View USA_Military_Colleges dataset
View(USA_Military_Colleges)

# Make the dataset turn into a network object. Assign as Pro
Pro <- network(USA_Military_Colleges)

# Plot Pro, to discover the shape.
plot(Pro)

# Adapted from Katherine Ognyanova. www.kateto.net

# Create two data.frames that will use 0 to 60 timeslot, with nodes and edges. This is going to be a minute video.
# vn will be the data.frame, to provide continuous movement, within the nodes. 
# en will be the data.frame, to provide individual movement, within the edges. 
vn <- data.frame(genesis=0, crowning=60, n.credentials=1:17)
en <- data.frame(genesis=1:16, crowning=60, 
                 Top=as.matrix(Pro, matrix.type = "edgelist")[,1],
                 Bottom=as.matrix(Pro, matrix.type="edgelist")[,2])

#Assign the networkDynamic object into a variable called Pro2. Using dataframe "en", as a data.frame of spells, mainly for edge timing. Using dataframe "vn", as a data.frame of spells, for nodes timing.                
Pro2 <- networkDynamic(base.net=Pro, edge.spells=en, vertex.spells=vn)

# Use filmstrip() command to display several frames within each network extract of Pro2. Labels will not be displayed. 
filmstrip(Pro2, displaylabels=F)

# The function compute.animation(), shows the stages within each interval of the networkDynamic object. This is also applied with the "Graphviz" layout algorithm. 
# The slice.par will give the parameters for the movement that will be given of the network visualization. Start of the renderd3.movie will start at the 0, and end at 60. The interval will be given half a second (time betweeen the layouts). The aggregate.dur is the given period of the layout, which is set at 1. The rule of displaying the elements, are active at any given point of the animation. 
compute.animation(Pro2, animation.mode = "Graphviz",
                  slice.par = list(start=0, end=60, interval=0.5,
                                   aggregate.dur=1, rule='any'))

# Use the render.d3movie() command, to play the network visualization. Extra details in this code, includes color for the vertex, edges, and background. The slice function will be current time slice with the network, and make calculations for the slice.FOr the edge movement, "Years" are being calculated. The color code chart for R, is the reference for the color.  
render.d3movie(Pro2, usearrows = T, filename = "marcusfloyd.html",
                displaylabels = F, label=Pro %v% "size",
                bg="#212121", vertex.border="#FFA500",
                vertex.cex = function(slice){ degree(slice)/2.5 },
                vertex.col = Pro2 %v% "col",
                edge.lwd = (Pro2 %e% "Years")/4,
                edge.col = '#55555599', output.mode = 'HTML')


        
        