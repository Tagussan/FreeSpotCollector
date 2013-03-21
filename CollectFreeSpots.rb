# -*- encoding: utf-8 -*-
require 'open-uri/cached'
require 'nokogiri'
require 'uri'
require 'pp'

doc = Nokogiri::HTML(open("http://www.freespot.com/gmap/freespot.html?lng=136.96394153509&lat=35.04413495557&zoom=15&category=_all&import=23aichi.xml"))
xmlLocation = Hash.new

#searching xml locations
doc.xpath('/html/body/select/option').each do |prefecture|
	next if prefecture.text == "--都道府県--"
	prefecture['value'] =~ /import=(.+.xml)$/
	xmlLocation[prefecture.text] = $1
end
xmlLocation.each do |prefecture,xmlName|
	puts "now searching #{prefecture}"
	output = File.open("./FreeSpots/#{xmlName}","w")
	freeSpotXML = Nokogiri::HTML(open("http://www.freespot.com/gmap/xml/#{xmlName}"))
	freeSpotXML.css('ksgmap mapdata item').each do |spot|
		output.puts spot.to_s
	end
	output.close
end
puts "done"
