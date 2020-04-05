load 'defaults.gp'
load 'colors-sequential-Gray.gp'
#load 'colors-qualitative-clusterd.gp'

mpl_top    = 0 #inch  outer top margin, title goes here
mpl_bot    = 0 #inch  outer bottom margin, x label goes here
mpl_left   = 0 #inch  outer left margin, y label goes here
mpl_right  = 0 #inch  outer right margin, y2 label goes here
mpl_height = 2.4 #inch  height of individual plots
mpl_width  = 3.6 #inch  width of individual plots
mpl_dx     = 0 #inch  inter-plot horizontal spacing
mpl_dy     = 0 #inch  inter-plot vertical spacing
mpl_ny     = 1 #number of rows
mpl_nx     = 1 #number of columns

baseline_name = "PathORAM"
system_name = "CODBS"

baseline_color = HKS44_100
system_color = HKS65_100

marker_1 = 6
marker_2 = 2
marker_3 = 8
marker_4 = 5

line_style = 1
line_width = 5
point_size = 1.5

# calculate full dimensions
# The maximum column width of a acm paper is around 3.2 inches. The values have
# to be updated to fit according to the paper column width.

xsize = mpl_left+mpl_right+(mpl_width*mpl_nx)+(mpl_nx-1)*mpl_dx
ysize = mpl_top+mpl_bot+(mpl_ny*mpl_height)+(mpl_ny-1)*mpl_dy

print xsize
print ysize
unset label 200
unset label 100

# placement functions
#   rows are numbered from bottom to top
bot(n) = (mpl_bot+(n-1)*mpl_height+(n-1)*mpl_dy)/ysize
top(n)  = 1-((mpl_top+(mpl_ny-n)*(mpl_height+mpl_dy))/ysize)

#   columns are numbered from left to right
left(n) = (mpl_left+(n-1)*mpl_width+(n-1)*mpl_dx)/xsize
right(n)  = 1-((mpl_right+(mpl_nx-n)*(mpl_width+mpl_dx))/xsize)

set terminal epslatex color dl 2.0  size xsize,ysize

#set grid xtics lc rgb "#636363"

set encoding iso_8859_1
set output "plots/breakdown.tex"
set border 2 back
set tics nomirror

set style data histograms
set style histogram rowstacked

set offsets
set autoscale 
set style fill pattern noborder

#set style rectangle fs solid noborder
set yrange[0:1] 
set key invert reverse top Left outside samplen 0.8 width -3.2 
set auto x

set boxwidth 0.8
set offset -0.4,-0.4,0,0

plot 'data/breakdown.dat' using 2:xtic(1) title "T-File" with histograms fill pattern 5 lc rgb "#252525",\
	'' using 3 title "T-Stash" with histograms fill pattern 2 lc rgb "#252525",\
	'' using 6 title "I-File L1" with histograms fill pattern 5 lc rgb "#969696",\
	'' using 7 title "I-Stash L1"with histograms fill pattern 2 lc rgb "#969696",\
	'' using 4 title "I-File L2"with histograms fill pattern 5 lc rgb "#d9d9d9",\
	'' using 5 title "I-Stash L2"with histograms fill pattern 2 lc rgb "#d9d9d9",\
	'' using 8 title "PRF" with histograms fill solid lc  rgb "#252525",



#plot "data/breakdown.dat"




