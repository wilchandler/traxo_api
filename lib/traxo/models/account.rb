module Traxo

  class Account < Traxo::BaseModel
    ATTRIBUTES = [:id, :member_id, :status, :name, :program_name,
                  :classification, :home_page_url, :password_url, 
                  :membership_url, :contact_url, :phone, :account_id,
                  :last_access, :last_harvest_status, :image_url,
                  :icon_image_url, :loyalty_status, :loyalty_level,
                  :loyalty_points, :loyalty_image_url, :auto_login
    ]

    ATTRIBUTES.each { |attr| class_eval { attr_reader "#{attr}" } }

    def initialize(args = {})
      super(args, ATTRIBUTES)
    end
  end
end