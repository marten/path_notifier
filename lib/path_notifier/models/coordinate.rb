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
      field :h_accuracy, type: Integer
      field :v_accuracy, type: Integer
      field :location,   type: Array, spacial: true

      index :uuid,       unique: true
      index :timestamp
      spacial_index :location

      def self.latest
        desc(:timestamp).first
      end
    end
  end
end
