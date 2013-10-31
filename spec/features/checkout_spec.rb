require "spec_helper"

feature "User wanting to lend money" do
  # Given I am a logged in user on /
  # when I click the button "Create a loan"
  # then I am sent to /notes/new
  #
  # Given I'm on /notes/new
  # when I have filled out all the information
  # and click the button "Checkout with dwolla"
  # then a note is created
  # and I should see /notes/:id

  given!(:lender) {create(:user)}
  given!(:borrower) {create(:user, name: "Pinco Pallino")}

  background do
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock :dwolla, {
      uid: lender.uid,
      provider: lender.provider,
      info: {
        name: lender.name,
        email: lender.email
      }
    }
  end

  scenario "creates a promissory note on lending round" do
    visit signin_path
    click_link "Create a loan"
    page.current_path.should == new_note_path
    fill_in "note_amount",     with: 6000
    fill_in "note_rate",       with: 11.0
    fill_in "note_term",       with: 36
    fill_in "note_start_date", with: "2013/10/27"

    select "Pinco Pallino", from: "note_borrower_attributes_user_id"

    click_button "Checkout with Dwolla!"
    page.current_path.should match /\/notes\//
    page.should have_content /review promissory note/i
    page.should have_content "The loan amount is for $6000"
    page.should have_content "The Interest Rate is for 11.0%"
    page.should have_content "It lasts for 36 months"
    page.should have_content "First Payment Date is October 27, 2013"
    page.should have_content "Pinco Pallino"
    page.should have_content lender.name
  end
end
