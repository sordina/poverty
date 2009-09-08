#!/bin/sh
mencoder mf://"*.png" -mf w=600:h=300:fps=30:type=png -ovc lavc -lavcopts vcodec=mpeg4:mbd=2:trell:vbitrate=5000000 -oac copy -o output.avi
