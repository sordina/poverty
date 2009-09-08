#!/usr/bin/ruby

require 'RMagick'

fl = Dir['*.png']

i = Magick::ImageList.new fl.shift
fl.each do |imn|
	i.read imn
end
i.each do |frame|
	if ARGV[0] == "small"
		frame.change_geometry("150x100") do |cols, rows, img|
	        	img.resize!(cols, rows)
		end
	end
	frame.delay=10
	print '.'
	$stdout.flush
end
if ARGV[0] == "small"
	i.write("animated_sequence_small.gif")
else
        i.write("animated_sequence.gif")
end
