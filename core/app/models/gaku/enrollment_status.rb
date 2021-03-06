module Gaku
  class EnrollmentStatus < ActiveRecord::Base

    has_many :students

    translates :name

    attr_accessible :code, :name, :is_active, :immutable

    validates :code, presence: true

    before_create :set_name

    def set_name
      self.name = code if name.nil?
    end

    def to_s
      name
    end

  end
end
