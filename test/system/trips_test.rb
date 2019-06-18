require "application_system_test_case"

class TripsTest < ApplicationSystemTestCase
  setup do
    @trip = trips(:one)
  end

  test "visiting the index" do
    visit trips_url
    assert_selector "h1", text: "Trips"
  end

  test "creating a Trip" do
    visit trips_url
    click_on "New Trip"

    fill_in "End lat", with: @trip.end_lat
    fill_in "End lng", with: @trip.end_lng
    fill_in "Remarks", with: @trip.remarks
    fill_in "Start lat", with: @trip.start_lat
    fill_in "Start lng", with: @trip.start_lng
    click_on "Create Trip"

    assert_text "Trip was successfully created"
    click_on "Back"
  end

  test "updating a Trip" do
    visit trips_url
    click_on "Edit", match: :first

    fill_in "End lat", with: @trip.end_lat
    fill_in "End lng", with: @trip.end_lng
    fill_in "Remarks", with: @trip.remarks
    fill_in "Start lat", with: @trip.start_lat
    fill_in "Start lng", with: @trip.start_lng
    click_on "Update Trip"

    assert_text "Trip was successfully updated"
    click_on "Back"
  end

  test "destroying a Trip" do
    visit trips_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Trip was successfully destroyed"
  end
end
