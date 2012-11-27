require 'spec_helper'
require 'capybara/rails'

describe 'photo upload' do
  it 'uploads files', js: true do
    visit '/photos/new'
    attach_file('fileupload', Rails.root.join('spec/fixtures/world-bar.jpeg'))
    page.should have_content('Upload finished.')
  end
end
