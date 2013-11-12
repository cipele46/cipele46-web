# encoding: utf-8
include AdSteps
include SessionSteps

feature "Ads" do
  scenario "validations", :sunspot_matchers => true do
    create_categories
    create_cities

    sign_in
    visit new_ad_path

    should_be_required :title
    should_be_required :description
    should_be_required :phone

    should_not_be_required :email
    should_not_be_required :image
  end

  scenario "guest: creating" do
    visit new_ad_path
    expect_to_see("moraš se prijaviti")
  end

  scenario "guest: contacting advertiser", :js => true  do
    ad = create_ad

    visit ad_path(ad)
    expect_to_see("Pošalji upit")
    find('#posalji_upit_button').click
    find('#posalji_button').visible?.should be_true
  end

  scenario "user: creating", :sunspot_matchers => true do
    create_categories
    create_cities

    sign_in
    visit new_ad_path

    fill_in_ad_details
    expect{ submit_ad }.to change{ Ad.count }.by(1)

    expect_to_see_details_for Ad.last
  end

  scenario "guest: editing",:sunspot_matchers => true do
    ad = create_ad

    visit edit_ad_path(ad)

    expect_to_see("moraš se prijaviti")
  end

  scenario "user: editing", :sunspot_matchers => true do
    current_user = sign_in

    ad = create_ad(:user => current_user)

    visit ad_path(ad)
    find("#edit-ad").click
    current_path.should eq(edit_ad_path(ad))

    fill_in_ad_details(:title => "Look mum, I can change the title!")

    submit_ad

    expect_to_see_details_for ad.reload
  end

  scenario "user: closing", :sunspot_matchers => true, :js => true do
    pending "find out why this is failing when the whole suite is ran"
    # current_user = sign_in
    # ad = create_ad(:user => current_user)

    # visit ad_path(ad)

    # expect { find("#close-ad").click }.to change { ad.reload.status }.from(Ad.status[:active]).to(Ad.status[:closed])
  end

  scenario "user: removing", :sunspot_matchers => true, :js => true do
    current_user = sign_in
    ad = create_ad(:user => current_user)

    visit ad_path(ad)

    expect { find("#delete-ad").click }.to change { Ad.count }.by(-1)
  end
end
