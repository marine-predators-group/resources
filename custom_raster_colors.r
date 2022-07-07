#=========================
## the base R approach

# set color breaks and levels, i.e. tell R how to "map" the colors to your values
raster.breaks <- seq(10, 30, length.out=201) # define your color limits, probably leave the length.out as is
raster.mid <- raster.breaks[1:(length(raster.breaks)-1)] # define the midpoints of each color so R knows how to "map" the colors to your plotted values
raster.col <- cmocean::cmocean('thermal')(length(raster.breaks)-1) # define custom color palette with cmocean

# make the plot
image(r, xlim=xl, ylim=yl,
      col=sst.col, breaks=sst.breaks, xlab='', ylab='', axes=F,
      main='my raster')
# note, there is almost certainly a way to do custom color palettes with plot() but I always just use the above

#=========================
## the ggplot approach

# convert your raster, r, into a data frame
df_map <- rasterToPoints(r) %>% as.data.frame()
colnames(df_map) <- c("rows", "cols", "value")    

# grab a world map to use as a reference
map.world <- map_data(map = "world")
map.world <- map.world %>% filter(long <= 180)

p1 <- df_map %>% 
  ggplot() + 
  geom_tile(aes(x = rows, y = cols, fill = value), color=NA) + # ggplot uses "tile" when plotting rasters (usually)
  scale_fill_gradientn("# of observations", colours = cmocean::cmocean('haline')(100)) + # name your color gradient and use custom color palette from cmocean
  coord_fixed(xlim=xl, ylim=yl, ratio=1.3) + # adjusting x/y limits
  xlab('') + ylab('') + 
  geom_map(data=map.world, map=map.world, aes(map_id=region), fill="darkgrey", color="darkgrey") + # add the world map
  theme_bw(base_size = 10) + theme(panel.grid=element_blank(), panel.border = element_blank()) # some aesthetic stuff
