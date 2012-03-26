require 'nokogiri'
require 'date'

class LatitudeImporter
  def initialize(filename)
    @filename = filename
    @document = Nokogiri::XML(File.read(@filename))
  end

  def coordinates
    coords = []
    last_timestamp = nil
    tracks = @document.xpath("//gx:Track")
    tracks.each do |track|
      track.children.each do |child|
        case child.name
        when "when"
          last_timestamp = parse_timestamp(child.text)
        when "coord"
          coords << {when:  last_timestamp,
                     coord: parse_coord(child.text)}
        end
      end
    end
    coords
  end

  def parse_timestamp(str)
    DateTime.xmlschema(str.dup).to_time.round.utc
  end

  def parse_coord(str)
    tmp = str.split(" ")
    {long: tmp[0].to_f, lat: tmp[1].to_f, alt: tmp[2].to_f}
  end
end