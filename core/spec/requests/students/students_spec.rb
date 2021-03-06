require 'spec_helper'

describe 'Students' do

  as_admin

  let(:student) { create(:student, name: 'John', surname: 'Doe') }
  let(:student2) { create(:student, name: 'Susumu', surname: 'Yokota') }
  let(:student3) { create(:student, name: 'Johny', surname: 'Bravo') }

  before :all do
    set_resource "student"
  end

  context "existing" do
    before do
      student
      student2
      student3
      visit gaku.students_path
    end

    it "lists" do
      size_of(table_rows).should eq 4
      page.should have_content "#{student.name}"
      page.should have_content "#{student.surname}"
      page.should have_content "#{student2.name}"
      page.should have_content "#{student2.surname}"
      page.should have_content "#{student3.name}"
      page.should have_content "#{student3.surname}"
    end

    it 'chooses students', js: true do
      find(:css, "input#student-#{student.id}").set(true)
      wait_until_visible '#students-checked-div'

      within('#students-checked-div') do
        page.should have_content 'Chosen students(1)'
        click_link 'Show'
        wait_until_visible '#chosen-table'
        page.should have_content "#{student.name}"
        page.should have_button 'Enroll to class'
        page.should have_button 'Enroll to course'
        click_link 'Hide'
        wait_until_invisible '#chosen-table'
      end
    end

    it "has autocomplete while searching", js: true do
      size_of(table_rows).should eq 4

      fill_in 'q_name_cont', with: "J"
      wait_for_ajax

      size_of(table_rows).should eq 3
      within(table) do
        page.should have_content "John"
        page.should have_content "Johny"
      end

      fill_in 'q_surname_cont', with: "B"
      wait_for_ajax

      size_of(table_rows).should eq 2
      within(table) do
        page.should have_content "Johny"
        page.should have_content "Bravo"
      end
    end


    it 'deletes', js: true do
      visit gaku.edit_student_path(student2)
      student_count = Gaku::Student.count
      page.should have_content "#{student2.name}"

      expect do
        click '#delete-student-link'
        within(modal) { click_on "Delete" }
        accept_alert
        wait_until { flash_destroyed? }
      end.to change(Gaku::Student, :count).by -1

      page.should_not have_content "#{student2.name}"
      within(count_div) { page.should_not have_content 'Students list(#{student_count - 1})' }
      current_path.should eq gaku.students_path
    end

  end

  context "new", js: true do
    before do
      visit gaku.students_path
      click new_link
      wait_until_visible submit
    end

    it "creates and shows" do
      expect do
        fill_in "student_name", with: "John"
        fill_in "student_surname", with: "Doe"
        click_button "submit-student-button"
        wait_until_invisible form
      end.to change(Gaku::Student, :count).by 1

      page.should have_content "John"
      within(count_div) { page.should have_content 'Students list(1)' }
      flash_created?
    end

    it {has_validations?}

    it 'cancels creating', cancel: true do
      ensure_cancel_creating_is_working
    end
  end

end
