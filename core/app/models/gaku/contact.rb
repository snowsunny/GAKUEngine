module Gaku
  class Contact < ActiveRecord::Base

    belongs_to :contact_type
    belongs_to :contactable, polymorphic: true, counter_cache: true

    has_paper_trail on: [:update, :destroy],
                    meta: {
                            join_model: :join_model_name,
                            joined_resource_id: :joined_resource_id
                          }

    attr_accessible :data, :details, :contact_type_id,
                    :is_primary, :is_emergency

    validates_presence_of :data, :contact_type_id

    before_save :ensure_first_is_primary, on: :create
    before_save :remove_other_primary

    delegate :name, to: :contact_type, allow_nil: true

    def make_primary
      contacts.update_all({is_primary: false}, ['id != ?', id])
      update_attribute(:is_primary, true)

      if contactable.has_attribute?(:primary_contact)
        contactable.update_attribute(:primary_contact, contact_widget)
      end
    end

    def primary?
      is_primary
    end

    def join_model_name
      contactable_type
    end

    def joined_resource_id
      contactable_id
    end

    private

    def remove_other_primary
      contacts.update_all({is_primary: false}, ['id != ?', id]) if primary?
    end

    def ensure_first_is_primary
      if contactable.respond_to? :contacts
        self.is_primary = true if contacts.blank?
      end
    end

    def contact_widget
      contactable.contact_widget
    end

    def contacts
      contactable.contacts
    end

  end
end

