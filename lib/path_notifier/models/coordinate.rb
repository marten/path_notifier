module PathNotifier
  module Models
    class Coordinate
      include Mongoid::Document
      include Mongoid::Spacial::Document

      field :timestamp, type: DateTime
      field :location,  type: Array, spacial: true

      spacial_index :location
      index :timestamp
    end
  end
end