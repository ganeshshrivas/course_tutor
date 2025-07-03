require 'rails_helper'

RSpec.describe "Courses API", type: :request do
  let(:headers) do
    {
      'Authorization' => basic_auth_header,
      'Content-Type' => 'application/json'
    }
  end

  def basic_auth_header
    credentials = "#{ENV['API_USERNAME'] || 'ASSIGNMENT'}:#{ENV['API_PASSWORD'] || 'ProMobi'}"
    'Basic ' + Base64.strict_encode64(credentials)
  end

  describe "POST /api/v1/courses" do
    let(:valid_params) do
      {
        course: {
          name: "Mathes",
          tutors_attributes: [
            { name: "test1" },
            { name: "test2" }
          ]
        }
      }
    end

    let(:invalid_params) do
      {
        course: {
          name: "Mathes",
          tutors_attributes: [
            { name: "test1" },
            { name: "" }
          ]
        }
      }
    end

    it "creates a course with tutors" do
      post "/api/v1/courses", params: valid_params.to_json, headers: headers

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["name"]).to eq("Mathes")
      expect(json["tutor_count"]).to eq(2)
      expect(json["tutors"].map { |t| t["name"] }).to include("test1", "test2")
    end

    it "returns validation errors for duplicate course" do
      # Create the first course manually
      create(:course, name: "Mathes")

      post "/api/v1/courses", params: valid_params.to_json, headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(JSON.parse(response.body)).to have_key("errors")
      expect(json["errors"]).to include("Course name is already taken")
    end

    it "returns errors for invalid input" do
      post "/api/v1/courses", params: { course: { name: "" } }.to_json, headers: headers

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to have_key("errors")
    end

    it "returns errors when course is valid and tutor is invalid" do
      post "/api/v1/courses", params: invalid_params.to_json, headers: headers

      json = JSON.parse(response.body)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to have_key("errors")
      expect(json["errors"]).to include("Tutors name can't be blank")
    end
  end

  describe "GET /api/v1/courses" do
    before do
      @course = create(:course, name: "Chemistry")
      create(:tutor, name: "John", course: @course)
    end

    it "returns all courses with tutors" do
      get "/api/v1/courses", headers: headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.size).to eq(1)
      expect(json.first["name"]).to eq("Chemistry")
      expect(json.first["tutor_count"]).to eq(1)
      expect(json.first["tutors"].first["name"]).to eq("John")
    end
  end
end
