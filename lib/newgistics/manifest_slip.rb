module Newgistics
  class ManifestSlip
    include Newgistics::Model

    attribute :actual_arrival_date, Timestamp, parser: TimeParsers.american_datetime
    attribute :actual_received_date, Timestamp, parser: TimeParsers.american_datetime
    attribute :carton_count, Integer
    attribute :created_date, Timestamp, parser: TimeParsers.american_datetime
    attribute :estimated_arrival_date, Date
    attribute :manifest_id, String
    attribute :manifest_name, String
    attribute :manifest_po, String
    attribute :notes, String
    attribute :pallet_count, Integer
    attribute :ship_date, Timestamp
    attribute :shipped_via, String
    attribute :status, String
    attribute :total_weight, Float
    attribute :tracking_no, String
    attribute :warehouse_id, String
    attribute :weight, Float

    alias_method :no_pallets, :pallet_count
    alias_method :no_pallets=, :pallet_count=
    alias_method :no_cartons, :carton_count
    alias_method :no_cartons=, :carton_count=
    alias_method :shipped_date, :ship_date
    alias_method :shipped_date=, :ship_date=
    alias_method :total_weight, :weight
    alias_method :total_weight=, :weight=

    def estimated_arrival_date=(date)
      date = parse_date(date) if should_parse_date?(date)
      super(date)
    end

    private

    def should_parse_date?(date)
      date.is_a?(String) && date =~ %r{[01]\d/[0123]\d/\d{4}}
    end

    def parse_date(date)
      Date.strptime(date, '%m/%d/%Y')
    rescue ArgumentError
      date
    end
  end
end
