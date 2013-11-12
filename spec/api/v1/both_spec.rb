# describe behavior for both authenticated and unauthenticated users here
require "spec_helper"
require "pry"

include AuthenticationHelper
include ApiHelpers

describe "API" do
  it "accepts .json extension in the URL too" do
    get "#{api_url}.json"

    expect(response.status).to eq(200)
  end
end

