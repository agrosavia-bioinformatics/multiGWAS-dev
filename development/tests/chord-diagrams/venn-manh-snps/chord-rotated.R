library(circlize)
set.seed(999)
mat = matrix(sample(18, 18), 3, 6)
rownames(mat) = paste0("Start", 1:3)
colnames(mat) = paste0("End", 1:6)


chordDiagram(mat, grid.col = grid.col, annotationTrack = "grid", 
    preAllocateTracks = list(track.height = max(strwidth(unlist(dimnames(mat))))))
# we go back to the first track and customize sector labels
circos.track(track.index = 1, panel.fun = function(x, y) {
    circos.text(CELL_META$xcenter, CELL_META$ylim[1], CELL_META$sector.index, 
        facing = "clockwise", niceFacing = TRUE, adj = c(0, 0.5))
}, bg.border = NA) # here set bg.border to NA is important


#grid.col <- setNames(rainbow(length(unlist(dimnames(mat)))), union(rownames(mat), colnames(mat)))
#par(mar = c(0, 0, 0, 0), mfrow = c(1, 2))


# original image
#chordDiagram(mat, grid.col = grid.col) 

# now, the image with rotated labels
#chordDiagram(mat, annotationTrack = "grid", preAllocateTracks = 1, grid.col = grid.col)
#circos.trackPlotRegion(track.index = 1, panel.fun = function(x, y) {
  #xlim = get.cell.meta.data("xlim")
  #ylim = get.cell.meta.data("ylim")
  #sector.name = get.cell.meta.data("sector.index")
  #circos.text(mean(xlim), ylim[1] + .1, sector.name, facing = "clockwise", niceFacing = TRUE, adj = c(0, 0.5))
  #circos.axis(h = "top", labels.cex = 0.5, major.tick.percentage = 0.2, sector.index = sector.name, track.index = 2)
#}, bg.border = NA)
