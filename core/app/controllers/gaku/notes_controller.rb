module Gaku
  class NotesController < GakuController

    load_and_authorize_resource :note, class: Gaku::Note

    before_filter :notable
    inherit_resources
    respond_to :js, :html

    def new
      @note = @notable.notes.new
      new!
    end

    def create
      @note = @notable.notes.new(params[:note])
      create!
    end

    protected

    def collection
      @notes = @notable.notes
    end

    private

    def notable_klasses
      [
        Gaku::Student,
        Gaku::Teacher,
        Gaku::LessonPlan,
        Gaku::Syllabus,
        Gaku::ClassGroup,
        Gaku::Course,
        Gaku::Exam
      ]
    end

    def notable
      unnamespaced_klass = ''
      klass = notable_klasses.detect do |c|
        unnamespaced_klass = c.to_s.split('::')
        params["#{unnamespaced_klass[1].underscore}_id"]
      end

      @notable = klass.find(params["#{unnamespaced_klass[1].underscore}_id"])
      @notable_resource = get_resource_name @notable
    end

  end
end
