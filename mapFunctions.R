# Setup -------------------------------------------------------------------

library(ggplot2)
library(ggmap)


# Define the map extents --------------------------------------------------

limit_latitude = c(37.777, 37.845)
limit_longitude = c(-75.55, -75.457)
limit_boundingbox = c(min(limit_longitude), min(limit_latitude), max(limit_longitude), max(limit_latitude))

# Download the Map data ---------------------------------------------------

ret = get_map(location = limit_boundingbox, zoom = 12, maptype = 'satellite', source = 'google')
ggmap(ret)

#Map from URL : http://maps.googleapis.com/maps/api/staticmap?center=37.811,-75.5035&zoom=12&size=%20640x640&scale=%202&maptype=satellite&sensor=false
#Google Maps API Terms of Service : http://developers.google.com/maps/terms



# Extra Code from SO ------------------------------------------------------

library(ggmap)
library(maptools)
shapefile <- readShapeSpatial('MunicipalBoundaries_polys.shp', proj4string = CRS("+proj=lcc +lat_1=34.33333333333334 +lat_2=36.16666666666666 +lat_0=33.75 +lon_0=-79 +x_0=609601.2199999997 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=us-ft +no_defs"))
shp <- spTransform(shapefile, CRS("+proj=longlat +datum=WGS84"))
data <- fortify(shp)

nc <- get_map("North Carolina", zoom = 6, maptype = 'terrain')
ncmap <- ggmap(nc,  extent = "device")
ncmap +
  geom_polygon(aes(x = long, y = lat, group = group), data = data,
               colour = 'grey', fill = 'black', alpha = .4, size = .1)