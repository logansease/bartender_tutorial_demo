require "spec_helper"

describe BartendersController do
  describe "routing" do

    it "routes to #index" do
      get("/bartenders").should route_to("bartenders#index")
    end

    it "routes to #new" do
      get("/bartenders/new").should route_to("bartenders#new")
    end

    it "routes to #show" do
      get("/bartenders/1").should route_to("bartenders#show", :id => "1")
    end

    it "routes to #edit" do
      get("/bartenders/1/edit").should route_to("bartenders#edit", :id => "1")
    end

    it "routes to #create" do
      post("/bartenders").should route_to("bartenders#create")
    end

    it "routes to #update" do
      put("/bartenders/1").should route_to("bartenders#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/bartenders/1").should route_to("bartenders#destroy", :id => "1")
    end

  end
end
