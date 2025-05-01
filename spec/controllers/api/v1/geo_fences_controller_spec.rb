require 'rails_helper'

RSpec.describe Api::V1::GeoFencesController, type: :controller do
  let(:user) { create(:user) }
  let!(:geo_fence) { create(:geo_fence, user: user) }

  before(:each) do
    request.headers["Authorization"] = "Bearer #{user.sessions.create.token}"
  end

  describe "Index" do
    it "returns a list of geo_fences" do
      get :index
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(1)
    end
  end

  describe "Show" do
    context "when the geo_fence exists" do
      it "returns the geo_fence" do
        get :show, params: { id: geo_fence.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["_id"]).to eq(geo_fence.id.to_s)
      end
    end

    context "when the geo_fence does not exist" do
      it "returns a 404 status" do
        get :show, params: { id: "9999" }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)["mssg"]).to eq("GeoFence not found")
      end
    end
  end

  describe "Create" do
    let(:valid_params) do
      {
        geo_fence: {
          name: "Test GeoFence",
          description: "Test description",
          area_geojson: {
            "coordinates": [
              [
                [
                  98.67039510744497,
                  3.598934100831031
                ],
                [
                  98.67039510744497,
                  3.5961691121116393
                ],
                [
                  98.673092328453,
                  3.5961691121116393
                ],
                [
                  98.673092328453,
                  3.598934100831031
                ],
                [
                  98.67039510744497,
                  3.598934100831031
                ]
              ]
            ],
            "type": "Polygon"
          },
          is_enabled: true
        }
      }
    end

    context "with valid parameters" do
      it "creates a new geo_fence" do
        post :create, params: valid_params
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)["name"]).to eq("Test GeoFence")
      end
    end

    context "with invalid parameters" do
      it "returns a 422 status" do
        post :create, params: { geo_fence: { name: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["mssg"]).not_to be_nil
      end
    end
  end

  describe "Update" do
    let(:update_params) { { id: geo_fence.id, geo_fence: { name: "Updated Name" } } }

    context "with valid parameters" do
      it "updates the geo_fence" do
        put :update, params: update_params
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["name"]).to eq("Updated Name")
      end
    end

    context "with invalid parameters" do
      it "updates the geo_fence" do
        update_params[:geo_fence][:name] = ""
        put :update, params: update_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["mssg"]).not_to be_nil
      end
    end
  end

  describe "Destroy" do
    it "disables the geo_fence" do
      delete :destroy,  params: { id: geo_fence.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["mssg"]).to eq("GeoFence deleted")
      expect(geo_fence.reload.is_enabled).to eq(false)
    end

    it "cannot disables the geo_fence" do
      geo_fence.name = ""
      geo_fence.save(validate: false)
      delete :destroy,  params: { id: geo_fence.id }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["mssg"]).not_to be_nil
      expect(geo_fence.reload.is_enabled).to eq(true)
    end
  end
end
