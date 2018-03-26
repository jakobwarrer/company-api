# server.rb
require 'sinatra'
require "sinatra/namespace"
require "sinatra/cors"

require 'mongoid'


set :allow_origin, "*"
set :allow_methods, "GET,HEAD,POST,DELETE,OPTIONS"
set :allow_headers, "content-type,if-modified-since"
set :expose_headers, "location,link"

# MongoDB
Mongoid.load!("mongoid.config", :development)

# Company model
class Company
  include Mongoid::Document

  field :cvr, type: Integer
  field :company_name, type: String
  field :address, type: String
  field :city, type: String
  field :country, type: String
  field :phone_number, type: Integer

  validates :cvr, presence: true
  validates :company_name, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :country, presence: true
  validates :phone_number, presence: false

  index({ cvr: 1 }, { unique: true, name: "cvr_index" })
  index({ company_name: 'text' })

  scope :cvr, -> (cvr) { where(cvr: cvr) }
  scope :company_name, -> (company_name) { where(company_name: /^#{company_name}/) }
  scope :address, -> (address) { where(address: /^#{address}/) }
  scope :city, -> (city) { where(city: /^#{city}/) }
  scope :country, -> (country) { where(country: /^#{country}/) }
  scope :phone_number, -> (phone_number) { where(phone_number: /^#{phone_number}/) }

end


class CompanySerializer

  def initialize(company)
    @company = company
  end

  def as_json(*)
    data = {
      id: @company.id.to_s,
      cvr: @company.cvr,
      company_name: @company.company_name,
      address: @company.address,
      city: @company.city,
      country: @company.country,
      phone_number: @company.phone_number,
    }
    data[:errors] = @company.errors if @company.errors.any?
    data
  end

end


# Start Endpoints
get '/' do
  'Hi, i am a company api'
end

namespace '/api/v1' do

  before do
    content_type 'application/json'
  end

  helpers do
    def base_url
      @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
    end

    def json_params
      begin
        JSON.parse(request.body.read)
      rescue
        halt 400, { message: 'Invalid JSON' }.to_json
      end
    end

    def company
      @company ||= Company.where(id: params[:id]).first
    end

    def halt_if_not_found!
      halt(404, { message: 'Company Not Found'}.to_json) unless company
    end

    def serialize(company)
      CompanySerializer.new(company).to_json
    end
  end

  #Search all companies
  get '/companies' do
    companies = Company.all

    [:cvr, :company_name, :address, :city, :address, :phone_number].each do |filter|
      companies = companies.send(filter, params[filter]) if params[filter]
    end

    companies.map { |company| CompanySerializer.new(company) }.to_json
  end

  #Get company by ID
  get '/companies/:id' do |id|
    halt_if_not_found!
    serialize(company)
  end

  #Create new company
  post '/companies' do
    begin
      company = Company.new(json_params)
      halt 422, serialize(company) unless company.save
      response.headers['Location'] = "#{base_url}/api/v1/companies/#{company.id}"
      status 201
  end

  #Edit company
  patch '/companies/:id' do |id|
    halt_if_not_found!
    halt 422, serialize(company) unless company.update_attributes(json_params)
    serialize(company)
  end

  #Delete company
  delete '/companies/:id' do |id|
    company.destroy if company
    status 204
  end
  
end
