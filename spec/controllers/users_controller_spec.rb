require 'spec_helper'

describe UsersController do

  describe "GET 'show'" do
    it "returns http success" do
      get 'show'
      response.should be_success
    end
  end

  describe "GET 'current'" do
    it "returns http success" do
      get 'current'
      response.should be_success
    end
  end

end
