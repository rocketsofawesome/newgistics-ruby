module Newgistics
  class Manifest
    include Newgistics::Model

    attribute :manifest_slip, ManifestSlip
    attribute :contents, Array[ManifestItem], default: []

    attribute :errors, Array[String], default: []
    attribute :warnings, Array[String], default: []

    def id
      read_slip_attribute(:manifest_id)
    end

    def id=(id)
      write_slip_attribute(:manifest_id, id)
    end

    def status
      read_slip_attribute(:status)
    end

    def status=(status)
      write_slip_attribute(:status, status)
    end

    def save
      Requests::PostManifest.new(self).perform
      errors.empty?
    end

    def cancel
      Requests::CancelManifest.new(self).perform
      errors.empty?
    end

    def self.where(conditions)
      Query.build(
        endpoint: '/manifests.aspx',
        model_class: self
      ).where(conditions)
    end

    def self.element_selector
      'manifest'
    end

    private

    def read_slip_attribute(attribute)
      manifest_slip&.send(attribute)
    end

    def write_slip_attribute(attribute, value)
      self.manifest_slip ||= ManifestSlip.new
      manifest_slip.send("#{attribute}=", value)
    end
  end
end
