load 'defaults.gp'
load 'colors-sequential-Gray.gp'
#load 'colors-qualitative-clusterd.gp'

mpl_top    = 0.1 #inch  outer top margin, title goes here
mpl_bot    = 0.8 #inch  outer bottom margin, x label goes here
mpl_left   = 0.2 #inch  outer left margin, y label goes here
mpl_right  = 0.4 #inch  outer right margin, y2 label goes here
mpl_height = 1 #inch  height of individual plots
mpl_width  = 1.5 #inch  width of individual plots
mpl_dx     = 0 #inch  inter-plot horizontal spacing
mpl_dy     = 0.1 #inch  inter-plot vertical spacing
mpl_ny     = 1 #number of rows
mpl_nx     = 2 #number of columns

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
set output "plots/microplot.tex"
set border
set tics nomirror

set style data histograms
set style histogram errorbars gap 1 lw 2

set offsets
set autoscale 
set style fill solid noborder

set key horiz maxrows 1 samplen 1 
set key out bot center
#set boxwidth 0.8

set ytics 50

set lmargin at screen left(1)
set rmargin at screen right(1)
#  set horizontal margins for third row (top)
set tmargin at screen top(1)
set bmargin at screen bot(1)

set xlabel 'Number of  blocks (base 2)' offset 8,0
set ylabel 'Latency ($\mu$s)'

#rectangle shade
#set style rect fc lt -1 fs solid 0.05 noborder back
#set obj rect from 3.64, graph 0 to 8, graph 1

#set label 2001 "Read" at 1,20
#set label 2002 "Write" at 5,40  
#set offset -0.4,-0.4,0,0

set multiplot

set title "Read" offset 0, -0.8
plot \
 "data/microbenchmarks.dat" every 1::0::3 using 2:3:4:xtic(1) t "ForestORAM" with histograms fill solid lc rgb "#d9d9d9",\
 '' every 1::0::3 using  5:6:7:xtic(1) notitle with histograms fill solid lc rgb "#252525"

set lmargin at screen left(2)
set rmargin at screen right(2)
#  set horizontal margins for third row (top)
set tmargin at screen top(1)
set bmargin at screen bot(1)
set key
#unset yaxis
#set border
#set tics
#unset ytics
#set y2tics 50
#set tics 
#unset ytics
#set y2tics 50

#unset ytics
#set y2tics 50
#set y2tics

set title "Write" offset 0, -0.8 
unset ytics
unset xlabel
unset ylabel
plot \
 "data/microbenchmarks.dat" every 1::0::3 using 2:3:4:xtic(1) notitle with histograms fill solid lc rgb "#d9d9d9",\
 '' every 1::0::3 using  5:6:7:xtic(1) t "PathORAM" with histograms fill solid lc rgb "#252525"



unset multiplot
