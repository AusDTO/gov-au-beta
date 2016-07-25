# Expects to be on a page with a Name and Body field, a single button and redirect to
# somewhere displaying the content
RSpec.shared_examples 'robust to XSS' do
  it 'strip the script tags' do
    # FIXME: Really, we should test all of the fields in the content type
    # Right now when we create a revision we can only change body & name (DD 20160625)
    fill_in('Name', with: 'Good Name<script>alert()</script>')
    fill_in('Body', with: 'Good Content<script>alert()</script>')
    fill_in('Short summary', with: 'Good summary<script>alert()</script>')
    click_button('')
    within('article') do
      expect(page).not_to have_css('script', text: 'alert', visible: false)
      expect(page).to have_content('Good Name')
      expect(page).to have_content('Good Content')
      # TODO: include summary and other fields
    end
  end
end
