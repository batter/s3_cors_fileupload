require 'spec_helper'

feature 'Uploads' do
  background { visit source_files_path }

  describe 'GET #index' do
    scenario { page.should have_selector('h2', text: 'Upload file(s)') }

    scenario :s3_cors_fileupload_form_tag do
      within('form#fileupload') do
        page.should have_selector('div.fileupload-buttonbar')
        page.should have_selector('table#upload_files')
        page.should have_selector('input[type=file]#file')
      end
    end

    scenario "Attaching files", js: true do
      within('form#fileupload') do
        within('table#upload_files tbody.files') do
          page.should_not have_selector('tr')
          page.text.should be_blank
        end
        attach_file('file', File.expand_path('../../support/dummy.pdf', __FILE__))
        # After a file is attached, it should get added to the table#upload_files to be uploaded
        within('table#upload_files tbody.files') do
          page.should have_selector('tr.template-upload')
          within('tr.template-upload') do
            page.should have_selector('td', text: 'dummy.pdf')
            page.should have_selector('td', text: '7.84 KB')
            page.should have_selector('td', text: 'Start')
            page.should have_selector('td', text: 'Cancel')
          end
        end
      end
    end
  end
end
