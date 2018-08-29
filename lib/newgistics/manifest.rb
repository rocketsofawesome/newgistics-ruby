module Newgistics
  class Manifest
    include Virtus.model

    attribute :id, String
    attribute :manifest_po, String
    attribute :manifest_name, String
    attribute :warehouse_id, String
    attribute :status, String
    attribute :ship_date, Date
    attribute :shipped_via, String
    attribute :tracking_no, String
    attribute :created_date, Timestamp
    attribute :estimated_arrival_date, Date
    attribute :pallet_count, Integer
    attribute :carton_count, Integer
    attribute :weight, Float
    attribute :notes, String
    attribute :contents, Array[ManifestItem], default: []

    attribute :errors, Array[String], default: []
    attribute :warnings, Array[String], default: []

    def save
      Requests::PostManifest.new(self).perform
      errors.empty?
    end
  end
end
