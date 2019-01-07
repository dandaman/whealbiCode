library(tidyverse)

library(RDS)

library(phytools)
library(evobiR)
library(countrycode)
library(RColorBrewer)
library(geosphere)
library(ggplot2)
library(ggmap)
library(maps)
library(mapdata)
library(data.table)


whealbi_hexaploid_tree=read.tree("Taestivum.allGenes.noUNKorigin.nwk")









whealbi_hexaploid_tree<-root(whealbi_hexaploid_tree,node=439,resolve.root=FALSE,edgelabel=TRUE)


#Let's first cross some list files to extract the data we want

# Load the correspondances of the ww identifiers and variety name
ww_id=read.csv("../monophyly_permutation/Sup_487samples.csv",header=TRUE,sep="\t",na.strings=c("","NA"))  
rnames <- ww_id[,1]
rnames <- gsub("\\-","",rnames)
rownames(ww_id) <- rnames
ww_id$code.whealbi <- gsub("\\-","",ww_id$Whealbi.serial.number)
ww_id<-as.data.table(ww_id) # I'll use it as data.table too later



selected_487_ww<-as.character(ww_id$code.whealbi)
#selected_435_ww<-as.character(ww_id[ww_id$Group %in% c("I","II","III","IV"),code.whealbi]) # Incomplete
selected_435_ww<-as.character(ww_id[ww_id$Genome %in% c("BAD"),code.whealbi]) 

##Load countries information

# Load the correspondances of the ww identifiers and variety name
#countries=read.csv("Whealbi_Wheat_final_garden_141013.csv",header=TRUE,sep="\t",na.strings=c("","NA"))
countries=fread("Whealbi_Wheat_final_garden_141013.csv",header=TRUE,sep="\t",na.strings=c("","NA"))  
countries$`Whealbi serial number` <- gsub("\\-","",countries$`Whealbi serial number`)
countries<-as.data.table(countries[`Whealbi serial number` %in% selected_435_ww,list(`Whealbi serial number`,`Country of origin`)])
colnames(countries)<-c("code.whealbi","country.of.origin")
ww_id<-merge(countries,ww_id,by="code.whealbi")

# Save the country names that follow the names standard in world.cities
data(world.cities)
world.cities<-as.data.table(world.cities)
ww_id$country<-c("")
ww_id[ww_id$country.of.origin %in% world.cities$country.etc]$country<-ww_id[ww_id$country.of.origin %in% world.cities$country.etc]$country.of.origin

# Look for country names that don't follow the names standard in world.cities
ww_id[!ww_id$country.of.origin %in% world.cities$country.etc]$country.of.origin

# Manually fix those ## ww_id[country==""]$country.of.origin
ww_id[country.of.origin == "United Kingdom"]$country<-c("UK")
ww_id[country.of.origin == "United Kingdom ?"]$country<-c("UK")
ww_id[country.of.origin == "USSR"]$country<-c("Russia")
ww_id[country.of.origin == "former Soviet Union"]$country<-c("Russia")
ww_id[country.of.origin == "Denmark?"]$country<-c("Denmark")
ww_id[country.of.origin == "Tunesia"]$country<-c("Tunisia")
ww_id[country.of.origin == "Czechia"]$country<-c("Czech Republic")
ww_id[country.of.origin == "Yugoslavia"]$country<-c("Serbia")
ww_id[country.of.origin == "The Netherlands"]$country<-c("Netherlands")
ww_id[country.of.origin == "Turkmenia"]$country<-c("Turkmenistan")
ww_id[country.of.origin == "Kenia"]$country<-c("Kenya")
ww_id[country.of.origin == "Democratic People's Republic of Korea (North Korea)"]$country<-c("North Korea")
ww_id[country.of.origin == "South Korea"]$country<-c("South Korea")
ww_id[country.of.origin == "Korea"]$country<-c("South Korea")

ww_id[country.of.origin == "DE/F/DK"]$country<-c("Germany")
ww_id[country.of.origin == "DE/DK"]$country<-c("Germany")
ww_id[country.of.origin == "DE/CZ/PL"]$country<-c("Czech Republic")
ww_id[country.of.origin == "F/PL"]$country<-c("Poland")

ww_id[country.of.origin == "unknown"]$country<-c("NA")
ww_id[country.of.origin == "NA"]$country<-c("NA")
ww_id[country.of.origin == ""]$country<-c("NA")

ww_id[Continent == "na"]$country<-c("NA")

unique(ww_id[,c("country","Continent")])

#Country to continent

world <- maps::map("world", ".", exact = FALSE, plot = FALSE, fill = TRUE) %>% fortify() # Alternative solution

all_countries <- data.frame(country=c(sort(unique(world$region))))
all_countries <- as.data.table(all_countries)

# Remove ambiguous territories : Some values that will not matched unambiguously in countrycode
all_countries<-all_countries[!country %in% c("Antarctica","Ascension Island","Azores","Barbuda","Bonaire","Canary Islands","Chagos Archipelago","Cocos Islands","French Southern and Antarctic Lands","Grenadines","Heard Island","Kosovo","Madeira Islands","Micronesia","Saba","Saint Martin","Siachen Glacier","Sint Eustatius","South Georgia","South Sandwich Islands","Virgin Islands")]

x<-all_countries # We need this two lines because...
all_countries<-as.data.frame(x) # ...countrycode needs a data.frame only
all_countries$continent <- factor(countrycode(sourcevar = all_countries[, "country"],
                                   origin = "country.name",
                                   destination = "continent"))
all_countries <- as.data.table(all_countries)  # Now we convert it back to data.table 

# Manually add removed ambiguous territories
x<-data.frame(country=c("Antarctica","Ascension Island","Azores","Barbuda","Bonaire","Canary Islands","Chagos Archipelago","Cocos Islands","French Southern and Antarctic Lands","Grenadines","Heard Island","Kosovo","Madeira Islands","Micronesia","Saba","Saint Martin","Siachen Glacier","Sint Eustatius","South Georgia","South Sandwich Islands","Virgin Islands"))
x$continent<-c("")
x<-as.data.table(x)
x[country=="Antarctica"]$continent<-c("Antartica")
x[country %in% c("Ascension Island","Barbuda","Bonaire","Grenadines","Saba","Saint Martin","Sint Eustatius","South Georgia","South Sandwich Islands","Virgin Islands")]$continent<-c("Americas")
x[country %in% c("Azores","Canary Islands","Madeira Islands","Kosovo")]$continent<-c("Europe")
x[country %in% c("Chagos Archipelago")]$continent<-c("Asia")
x[country %in% c("Cocos Islands","French Southern and Antarctic Lands","Heard Island","Micronesia")]$continent<-c("Asia")

all_countries <- rbind(all_countries,x)

# Fix Russia colour for our map
all_countries[country=="Russia"]$continent<-c("Asia")

all_countries$cont_colour<-c("")
all_countries[continent=="Asia"]$cont_colour<-c("#f2ffe6")
all_countries[continent=="Africa"]$cont_colour<-c("#fff7e6")
all_countries[continent=="Europe"]$cont_colour<-c("#99ccff")
all_countries[continent=="Americas"]$cont_colour<-c("#ffe6e6")
all_countries[continent=="Oceania"]$cont_colour<-c("#ffe6f2")

# Add the Fertile Crescent
all_countries[country %in% c("Israel","Syria","Lebanon","Jordan","Palestine","Iraq","Turkey","Iran")]$continent<-c("Fertile Crescent")
all_countries[continent=="Fertile Crescent"]$cont_colour<-c("#ff0000")

#Assign colours to the regions

x<-c("Fertile Crescent","Central Asia","Eastern Asia","Indian Peninsula","Northern Asia",
     "Central Europe","Southern Europe","Western Europe",
     "North America","South America",
     "Northern Africa","Subsaharan Africa",
     "Oceania",
     "UNK",
     "SPELTA",
     "SPHAEROCOCCUM")
region_col=data.table(region=c(x),colour=c("#FFFFFF"),id=1:length(x))


region_col[region=="Fertile Crescent"]$colour<-c("#006d2c")
region_col[region=="Central Asia"]$colour<-c("#52be80")
region_col[region=="Eastern Asia"]$colour<-c("#66c2a4")
region_col[region=="Indian Peninsula"]$colour<-c("#2ca25f")
region_col[region=="Northern Asia"]$colour<-c("#00838f")

region_col[region=="Central Europe"]$colour<-c("#2196f3")
region_col[region=="Southern Europe"]$colour<-c("#2171b5")
region_col[region=="Western Europe"]$colour<-c("#08519c")

region_col[region=="North America"]$colour<-c("#de2d26")
region_col[region=="South America"]$colour<-c("#fb6a4a")

region_col[region=="Northern Africa"]$colour<-c("#ec7014")
region_col[region=="Subsaharan Africa"]$colour<-c("#fd8d3c")

region_col[region=="Oceania"]$colour<-c("#ff3399")

region_col[region=="UNK"]$colour<-c("#252525")
region_col[region=="SPELTA"]$colour<-c("#636363")
region_col[region=="SPHAEROCOCCUM"]$colour<-c("#969696")


##Assign all world countries to a region 

all_regions <- data.frame(country=c(sort(unique(world$region))))
all_regions <- as.data.table(all_regions)

country_to_region=read.csv("countries_to_regions.csv",header=FALSE,sep="\t",na.strings=c("","NA"))  
colnames(country_to_region)<-c("index","country","region")
country_to_region<-as.data.table(country_to_region)
country_to_region$region<-as.character(country_to_region$region)

country_to_region[region=="1"]$region="Fertile Crescent"
country_to_region[region=="2"]$region="Central Asia"
country_to_region[region=="3"]$region="Eastern Asia"
country_to_region[region=="4"]$region="Indian Peninsula"

country_to_region[region=="5"]$region="Central Europe"
country_to_region[region=="6"]$region="Northern Asia"
country_to_region[region=="7"]$region="Southern Europe"
country_to_region[region=="8"]$region="Western Europe"

country_to_region[region=="9"]$region="North America"
country_to_region[region=="10"]$region="South America"

country_to_region[region=="11"]$region="Northern Africa"
country_to_region[region=="12"]$region="Subsaharan Africa"

country_to_region[region=="13"]$region="Oceania"


all_countries<-merge(all_countries,country_to_region,by="country")
all_countries$reg_colour<-c("")
all_countries[region=="Fertile Crescent"]$reg_colour<-region_col[region=="Fertile Crescent"]$colour
all_countries[region=="Central Asia"]$reg_colour<-region_col[region=="Central Asia"]$colour
all_countries[region=="Eastern Asia"]$reg_colour<-region_col[region=="Eastern Asia"]$colour
all_countries[region=="Indian Peninsula"]$reg_colour<-region_col[region=="Indian Peninsula"]$colour

all_countries[region=="Central Europe"]$reg_colour<-region_col[region=="Central Europe"]$colour
all_countries[region=="Northern Asia"]$reg_colour<-region_col[region=="Northern Asia"]$colour
all_countries[region=="Southern Europe"]$reg_colour<-region_col[region=="Southern Europe"]$colour
all_countries[region=="Western Europe"]$reg_colour<-region_col[region=="Western Europe"]$colour

all_countries[region=="North America"]$reg_colour<-region_col[region=="North America"]$colour
all_countries[region=="South America"]$reg_colour<-region_col[region=="South America"]$colour

all_countries[region=="Northern Africa"]$reg_colour<-region_col[region=="Northern Africa"]$colour
all_countries[region=="Subsaharan Africa"]$reg_colour<-region_col[region=="Subsaharan Africa"]$colour

all_countries[region=="Oceania"]$reg_colour<-region_col[region=="Oceania"]$colour



#Simplify country.map to a single country by region (From which the citie is choosen)

country<-ww_id$country
count_col<-as.data.table(unique(ww_id$country))
colnames(count_col)<-c("country")
count_col=as.data.table(count_col[!country=="NA"]) # Remove NA
count_col$"colour"<-c("")
count_col$"region"<-c("")
for (i in unique(country)){
  if (i!="NA"){
    count_col[country==i]$region=all_countries[country==i]$region
    count_col[country==i]$colour=all_countries[country==i]$reg_colour
  }
}

count_col$country.map.simple<-c("")
count_col[region=="Fertile Crescent"]$country.map.simple<-c("Iraq")
count_col[region=="Central Asia"]$country.map.simple<-c("Afghanistan")
count_col[region=="Eastern Asia"]$country.map.simple<-c("China")
count_col[region=="Indian Peninsula"]$country.map.simple<-c("India")

count_col[region=="Central Europe"]$country.map.simple<-c("Slovakia")
count_col[region=="Northern Asia"]$country.map.simple<-c("Russia")
count_col[region=="Southern Europe"]$country.map.simple<-c("Spain")
count_col[region=="Western Europe"]$country.map.simple<-c("France")

count_col[region=="North America"]$country.map.simple<-c("USA")
count_col[region=="South America"]$country.map.simple<-c("Brazil")

count_col[region=="Northern Africa"]$country.map.simple<-c("Algeria")
count_col[region=="Subsaharan Africa"]$country.map.simple<-c("Congo Democratic Republic")

count_col[region=="Oceania"]$country.map.simple<-c("Australia")

#Define cities to draw arrows
world.cities<-as.data.table(world.cities)
cities<-c("Saint Louis","Manaus","Getafe","Boulogne-Billancourt","Kosice","Chengdu","Chhindwara","Alice Springs","Tamanrasat","Kisangani","Baghdad","Kabul","Kotlas")
cities<-as.data.frame(world.cities[name %in% cities,c("name","country.etc","long","lat")])
cities<-as.data.table(cities)

#Extract a connections table by nodes from pd$count

connections = NA
FNAME = "map.connections.csv"
if( file.exists( FNAME ) ){
	connections = read.csv( FNAME )
	connections = as.data.table( connections )
}else{

	pd <- readRDS("ancestral_simul.Region.10000.pd.object")
	#mtrees <- readRDS("ancestral_simul.Region.10000.mtrees.object")
	
	
	connections<-merge(unique(count_col$country.map.simple), unique(count_col$country.map.simple)) %>% as.data.frame()
	connections$links=0
	connections<-as.data.table(connections)
	
	for (i in colnames(pd$count)){
	  l<-unlist(str_split(i, ","))
	  r<-unique(count_col[region==l[1]]$country.map.simple)
	  s<-unique(count_col[region==l[2]]$country.map.simple)
	  connections[x %in% r & y %in% s]$links=sum(pd$count[,i])/sum(pd$count[,"N"])*100
	}
	
	# We need to 'simplify' connections because currently we don't have a phylogeny direction to draw the arrows
	connections$simple.links=connections$links  # To keep original links count
	connections$sum.links=0
	x<-unique(c(unique(as.character(connections$x)),unique(as.character(connections$y))))
	y<-x
	for (i in x){
	  for (j in y){
	    if (i==j){
	       y<-y[!y %in% i]
	    }
	    connections[x==i & y==j]$sum.links<-sum(connections[x==i & y==j]$simple.links+connections[x==j & y==i]$simple.links)
	  }
	}
	connections$links=connections$sum.links # Because onwards the script uses connections$links

	write.csv(connections,FNAME)
}

plot_my_connection=function( dep_lon, dep_lat, arr_lon, arr_lat, ...){
	inter <- gcIntermediate(c(dep_lon, dep_lat), c(arr_lon, arr_lat), n=50, addStartEnd=TRUE, breakAtDateLine=F)             
	inter=data.frame(inter)
	diff_of_lon=abs(dep_lon) + abs(arr_lon)
	if(diff_of_lon > 180){
		lines(subset(inter, lon>=0), ...)
		lines(subset(inter, lon<0), ...)
	}else{
		lines(inter, ...)
	}
}

# Generate all pairs coordinates
connections$long1=0
connections$lat1=0
connections$long2=0
connections$lat2=0
for(i in sort(unique(c(as.character(connections[links!=0 & x!=y]$x),as.character(connections[links!=0 & x!=y]$y))))){
  connections[x==i]$long1=cities[country.etc==i]$long
  connections[x==i]$lat1=cities[country.etc==i]$lat
  
  connections[y==i]$long2=cities[country.etc==i]$long
  connections[y==i]$lat2=cities[country.etc==i]$lat
}
all_pairs=connections[links!=0 & x!=y,c("x","y","long1","long2","lat1","lat2","links")] %>% as.data.frame() %>% as.data.table()




## Colour regions map
pdf("figures/world_map.pdf")

par(mar=c(0,0,0,0))
maps::map('world',col="#bfbfbf", fill=TRUE, bg="white", lwd=0.5,mar=rep(0,4),border=1, resolution=0 )

# Add a light colour to the continents
for (i in all_countries$country){
  if (i!="NA" & i!="Antarctica" & i!="Siachen Glacier"){
    r<-maps::map("world",regions=i,plot=FALSE,fill=TRUE)
    maps::map(r,col=all_countries[country==i]$reg_colour,fill=TRUE,add=TRUE,border=1) # Border 0 = white lines, 2= red, 3= green, 4=blue
  }
}


# Plot all lines
for(i in 1:nrow(all_pairs)){
  l=as.numeric(connections[x==all_pairs$x[i] & y==all_pairs$y[i]]$links)
  lin_col="#000000"
  
  # Normalize
  #lin_width=(log(all_pairs$links[i]))

  ## finding a threshold corresonding to at least 1 transition in each simulation
  ##> sum(pd$count[,"N"])
  ##[1] 1667196
  ##> mean(pd$count[,"N"])
  ##[1] 166.7196
  ##> 100 / mean(pd$count[,"N"])
  ##[1] 0.5998095
  ##> log( 100 / mean(pd$count[,"N"]) )
  ##[1] -0.5111432
  ##> hist(log(all_pairs$links))

  #lin_width=max(0, log( all_pairs$links[i] ) ) ## for supp
  lin_width=  log( all_pairs$links[i] )  + 0.5111432 ## for main

  if( lin_width >= 0 ){
 	print(lin_width)
 	lin_width = log(2.6) ## forcing some arbitrary value
  #hist(log(all_pairs$links)/log(10))
  
  
  # Change lines color according to 'origin'
  if (unique(count_col[country.map.simple==all_pairs$x[i]]$region)=="Fertile Crescent" |
      unique(count_col[country.map.simple==all_pairs$y[i]]$region)=="Fertile Crescent" ){lin_col="#00ff00"}
  
  # Comment this conditional to have all connections map
  #if (unique(count_col[country.map.simple==all_pairs$x[i]]$region)=="Fertile Crescent" |
  #    unique(count_col[country.map.simple==all_pairs$y[i]]$region)=="Fertile Crescent" |
  #    unique(count_col[country.map.simple==all_pairs$x[i]]$region)=="Western Europe" |
  #    unique(count_col[country.map.simple==all_pairs$y[i]]$region)=="Western Europe" |
  #    unique(count_col[country.map.simple==all_pairs$x[i]]$region)=="Northern Asia" |
  #    unique(count_col[country.map.simple==all_pairs$y[i]]$region)=="Northern Asia" ){
      plot_my_connection(all_pairs$long1[i], all_pairs$lat1[i], all_pairs$long2[i], all_pairs$lat2[i], col=lin_col, lwd=lin_width)
  #}
  }
}

dev.off()

