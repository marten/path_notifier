require 'latitude_importer'

describe 'Google Latitude history importer' do
  it 'parses a history file' do
    import = LatitudeImporter.new("spec/data/history-02-20-2012.kml")
    import.coordinates.should have(191).items
  end

  it 'parses timestamps' do
    import = LatitudeImporter.new("spec/data/history-02-20-2012.kml")
    timestamp = Time.new(2012, 03, 10, 15, 01, 41)
    import.parse_timestamp("2012-03-10T06:01:40.564-08:00").should == timestamp
  end

  it 'parses coordinates' do
    import = LatitudeImporter.new("spec/data/history-02-20-2012.kml")
    coord = {long: 6.541059, lat: 53.22818, alt: 0}
    import.parse_coord("6.541059 53.22818 0").should == coord
  end
end
