module Newgistics
  class Manifest
    include Newgistics::Model

    attribute :manifest_slip, ManifestSlip
    attribute :contents, Array[ManifestItem], default: []

    attribute :errors, Array[String], default: []
    attribute :warnings, Array[String], default: []

    def id
      manifest_slip&.manifest_id
    end

    def id=(id)
      self.manifest_slip ||= ManifestSlip.new
      manifest_slip.manifest_id = id
    end

    def save
      Requests::PostManifest.new(self).perform
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
  end
end
