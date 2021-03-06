module Gaku
  class ProgramSyllabus < ActiveRecord::Base

    belongs_to :program
    belongs_to :syllabus
    belongs_to :level

    attr_accessible :program_id, :syllabus_id, :level_id

    validates_presence_of :syllabus_id

  end
end
