# Setup -------------------------------------------------------------------

library(ggplot2)
library(ggmap)
library(RgoogleMaps)

# Define the map extents --------------------------------------------------

limit_latitude = c(37.777, 37.845)
limit_longitude = c(-75.55, -75.457)
limit_boundingbox = c(min(limit_longitude), min(limit_latitude), max(limit_longitude), max(limit_latitude))

s1 = 37.778
s2 = -75.550
limit_latitude = c(s1, s1+0.0003)
limit_longitude = c(s2, s2+0.0004)
limit_boundingbox = c(min(limit_longitude), min(limit_latitude), max(limit_longitude), max(limit_latitude))



# Get The Tiles -----------------------------------------------------------

z = 19
londelt = (2.0*360.0) / (2^z)
latdelt = (2.0*180.0) / (2^z)
s1 = 37.84  # 37.84
s2 = -76.480   # -75.480
s1 = 38.889468
s2 = -77.03524

limit_latitude = c(s1, s1 + 1 * latdelt)
limit_longitude = c(s2, s2 + 3 * londelt)
limit_boundingbox = c(min(limit_longitude), min(limit_latitude), max(limit_longitude), max(limit_latitude))

trim = 0
z = 19
londelt = (2.0*360.0) / (2^z)
latdelt = (2.0*180.0) / (2^z)
lonsteps = seq(min(limit_longitude), max(limit_longitude), by = londelt)
latsteps = seq(min(limit_latitude), max(limit_latitude), by = latdelt)
tiles = list()
for(i in 1:(length(lonsteps)-1)) {
  for(j in 1:(length(latsteps)-1)) {
    cat(sprintf('i = %i\tj = %i\n', i, j))
    lat = mean(c(latsteps[j], latsteps[j+1]))
    lon = mean(c(lonsteps[i], lonsteps[i+1]))
    bb = c(lonsteps[i], latsteps[j], lonsteps[i+1], latsteps[j+1])
    cat(bb)
    cat('\n')
    cat('\n')
    ret = get_map(location = c(lon, lat), zoom = z, maptype = 'satellite', source = 'google', scale = 1, urlonly = FALSE)
#    ret = get_map(location = bb, zoom = z, maptype = 'satellite', source = 'google', scale = 1)
    tiles[[i + ((j-1)*(length(latsteps)-1))]] = ret
  }
}


# Strip the copywright ----------------------------------------------------

center = c(lon, lat)
zoom = 19
size = c(640, 640)
size = size * 2
ll <- XY2LatLon(
  list(lat = center[2], lon = center[1], zoom = zoom),
  -size[1]/2 + 0.5,
  -size[2]/2 - 0.5
)
ll

# Break 1 -----------------------------------------------------------------

# determine bounding box
bbs <- ldply(tiles, function(x) attr(x, "bb"))    

bigbb <- data.frame(
  ll.lat = min(bbs$ll.lat),
  ll.lon = min(bbs$ll.lon),
  ur.lat = max(bbs$ur.lat),
  ur.lon = max(bbs$ur.lon)
)

# determine positions of tile in slate (aggregate)  
order <- as.numeric( arrange(cbind(.id = row.names(bbs), bbs), desc(ll.lat), ll.lon)$.id )
tiles <- tiles[order]
tiles <- lapply(tiles, as.matrix) # essential for cbind/rbind to work properly!

# split tiles, then squeeze together from top and bottom
# and then squeeze together from left and right
nrows <- length( unique(bbs$ll.lat) )
ncols <- length( unique(bbs$ll.lon) )    
tiles <- split(tiles, rep(1:nrows, each = ncols))
tiles <- lapply(tiles, function(x) Reduce(cbind, x))
tiles <- Reduce(rbind, tiles)

tiles <- as.raster(tiles)
class(tiles) <- c("ggmap", "raster")
attr(tiles, "bb") <- bigbb

tiles
ggmap(tiles)

# Bkear 3 -----------------------------------------------------------------



t2 = ggmap(mymaps[[1]])
t2
b = as.raster(g)

dim(g)
grid.raster(g)


final = mymaps[[1]]
for(i = 2:length(mymaps)) {
  
}

ggmap(mymaps[[2]])


# GoogleMaps proj4 String: +proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +wktext  +no_defs

# Download the Map data ---------------------------------------------------

lat = 39.864849;
lon = 32.733805;
center = c(lat, lon);
MyMap <- GetMap(center, size=c(640,640), destfile="HU_Test.png", zoom = 12, maptype="satellite", RETURNIMAGE = TRUE, GRAYSCALE = FALSE, NEWMAP = TRUE, SCALE = 2, verbose = 1);
latlow = MyMap$BBOX$ll[1]
lathigh = MyMap$BBOX$ur[1]
lats = c(latlow, lathigh)
latDist = diff(lats)
lonlow = MyMap$BBOX$ll[2]
lonhigh = MyMap$BBOX$ur[2]
lons = c(lonlow, lonhigh)
lonDist = diff(lons)
cat(sprintf('Lat: %f -> %f\t%f\n', latlow, lathigh, latDist))
cat(sprintf('Lon: %f -> %f\t%f\n', lonlow, lonhigh, lonDist))


# break -------------------------------------------------------------------


s1 = 37.84
s2 = -75.480
limit_latitude = c(s1, s1+0.0003)
limit_longitude = c(s2, s2+0.0004)
limit_boundingbox = c(min(limit_longitude), min(limit_latitude), max(limit_longitude), max(limit_latitude))

ret = get_map(location = limit_boundingbox, zoom = 19, maptype = 'satellite', source = 'google', scale = 2)
bb = attr(ret, 'bb')
cat(sprintf('Lat: %f -> %f\t%f\n', bb$ll.lat, bb$ur.lat, bb$ur.lat - bb$ll.lat))
cat(sprintf('Lat: %f -> %f\t%f\n', bb$ll.lon, bb$ur.lon, bb$ur.lon - bb$ll.lon))
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