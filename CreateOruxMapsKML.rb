# -*- coding: utf-8 -*-
require 'fileutils'
require 'nokogiri'
Dir.glob("./FreeSpots/*.xml").each do |file|
	kml = Nokogiri::XML(open("./BaseKML.kml"))
	folder = kml.css('Folder')[0]
	file =~ /(.+)\/(.+?).xml/
	prefecture = $2
	puts "processing #{$2}"
	xml = Nokogiri::HTML(open(file),nil,'UTF-8')
	xml.css('item').each do |ap|
		inner_html=<<"EOXML"
<Placemark>
<name><![CDATA[#{ap['name']}]]></name>
<description><![CDATA[#{ap['address']}]]></description>
<Point>
<altitudeMode>clampToGround</altitudeMode>
<coordinates>#{ap['lng']},#{ap['lat']},0.0</coordinates>
</Point>
<styleUrl>#gv_waypoint</styleUrl>
</Placemark>
EOXML
		placemark = Nokogiri::XML::DocumentFragment.parse(inner_html)
		folder.add_child(placemark.to_xml(:encoding => 'UTF-8'))
	end
	File.open("./FreeSpotsForOruxMapsKML/#{prefecture}.kml", 'w') {|f|
 		f.puts kml.to_xml
	}
end
