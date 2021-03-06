module Gaku
  class ProgramLevel < ActiveRecord::Base
    belongs_to :program
    belongs_to :level

    attr_accessible :program_id, :level_id

    validates_presence_of :level_id

    def to_s
      name
    end
  end
end
