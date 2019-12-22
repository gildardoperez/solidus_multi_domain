# frozen_string_literal: true

require 'spec_helper'

RSpec.describe "Store promotion rule", js: true do
  stub_authorization!

  let!(:store) { create(:store, name: "Real fake doors") }
  let!(:promotion) { create(:promotion) }

  it "Can add a store rule to a promotion" do
    visit spree.edit_admin_promotion_path(promotion)

    select "Store", from: "promotion_rule_type"

    within("#rules_container") { click_button "Add" }

    select2_search store.name, from: "Choose Stores"

    within("#rules_container") { click_button "Update" }
    expect(page).to have_content('successfully updated')
  end
end
