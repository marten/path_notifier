module PathNotifier
  module Models
    class Coordinate
      include Mongoid::Document
      include Mongoid::Spacial::Document

      field :uuid,       type: String
      field :timestamp,  type: DateTime
      field :altitude,   type: Integer
      field :speed,      type: Integer
      field :heading,    type: Integer
      field :h_accuracy, type: Integer              # Lower == more accuracy
      field :v_accuracy, type: Integer              # In my data, vertical is always 0, but store anyway
      field :location,   type: Array, spacial: true

      field :poi_scanned, type: Boolean, default: false

      belongs_to :poi, class_name: "PathNotifier::Models::POI"

      index :uuid,       unique: true
      index :timestamp
      index :h_accuracy
      index :v_accuracy
      spacial_index :location

      default_scope asc(:timestamp)

      def self.latest
        desc(:timestamp).first
      end
    end
  end
end
