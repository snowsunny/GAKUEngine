module Gaku
  class Courses::SemesterCoursesController < GakuController

    load_and_authorize_resource :course, class: Gaku::Course
    # load_and_authorize_resource :semester, :through => :class_group, :class => Gaku::Semester

    inherit_resources
    respond_to :js, :html
    belongs_to :course, parent_class: Gaku::Course

    before_filter :count, only: [:create, :destroy]
    before_filter :load_data

    private

    def count
      course = Course.find(params[:course_id])
      @count = course.semesters.count
    end

    def load_data
      @semesters = Semester.all.collect { |s| [s.to_s, s.id] }
    end

  end
end
