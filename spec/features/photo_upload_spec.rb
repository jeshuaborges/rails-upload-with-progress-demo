require 'spec_helper'
require 'capybara/rails'

describe 'photo upload' do
  it 'uploads files', js: true do
    # This is a terrible test
    path = Rails.root.join('spec/fixtures/world-bar.jpeg')

    visit '/photos/new'
    attach_file('fileupload', path)

    page.should have_content('Upload finished.')
  end
end
