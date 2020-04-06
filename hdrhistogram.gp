load 'defaults.gp'
#load 'colors-sequential-Gray.gp'
load 'colors-qualitative-clusterd.gp'

mpl_top    = 0.2 #inch  outer top margin, title goes here
mpl_bot    = 0.4 #inch  outer bottom margin, x label goes here
mpl_left   = 0.4 #inch  outer left margin, y label goes here
mpl_right  = 0.3 #inch  outer right margin, y2 label goes here
mpl_height = 0.9 #inch  height of individual plots
mpl_width  = 2.4 #inch  width of individual plots
mpl_dx     = 0.45 #inch  inter-plot horizontal spacing
mpl_dy     = 0.7 #inch  inter-plot vertical spacing
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
line_width = 4
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

set grid xtics lc rgb "#636363"

set encoding iso_8859_1
set output "plots/hdrhistogram.tex"
set border 3 back
set tics nomirror


set offsets
set autoscale 
set size 1,1

set style rectangle fs solid noborder
set key 

set xrange[0.9:1]
set xtics 0.05
set ytics 200
#set xtics 0.005

#-----------------------------------------------
#  set horizontal margins for first column
set lmargin at screen left(1)
set rmargin at screen right(1)
#  set horizontal margins for third row (top)
set tmargin at screen top(1)
set bmargin at screen bot(1)
#set title "Forest ORAM" offset 0, -0.8
set xlabel 'Time (seconds)'
set ylabel 'Latency (ms)'

plot "data/histogram_baseline.hgrm" u 2:($1*0.01) with lines title baseline_name lw line_width,\
	"data/histogram_ois.hgrm" u 2:($1*0.001) with lines title system_name lw line_width






