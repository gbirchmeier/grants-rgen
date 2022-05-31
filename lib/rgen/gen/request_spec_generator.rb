require 'active_support/inflector'

class Rgen::Gen::RequestSpecGenerator

  def generate_file(model, destination)
    fullpath = File.join(destination, model.name.pluralize.underscore + '_spec.rb')
    File.write(fullpath, generate_file_content(model))
    fullpath
  end

  private

  def generate_file_content(model)
    rva = []
    rva << "require 'rails_helper'"
    rva << ''
    rva << "RSpec.describe \"#{model.name.pluralize}\", type: :request do"
    rva << "  describe 'GET #{model.name.underscore.pluralize}/' do"
    rva << '    it \'empty table\' do'
    rva << "      get '/#{model.name.underscore.pluralize}'"
    rva << '      expect(response).to have_http_status(:ok) #200'
    rva << '      expect(response.body).to eq \'[]\''
    rva << '    end'
    rva << ''
    rva << '    it \'not empty\' do'
    rva << "      FactoryBot.create(:#{model.name.underscore})"
    rva << ''
    rva << "      get '/#{model.name.underscore.pluralize}'"
    rva << '      expect(response).to have_http_status(:ok) #200'
    rva << ''
    rva << '      # TODO: complete this'
    rva << '      # arr = JSON.parse(response.body) # you might use this'
    rva << '      # set up expected/actual'
    rva << '      # expect(actual).to eq expected'
    rva << '    end'
    rva << '  end'
    rva << ''
    rva << "  describe 'GET #{model.name.underscore.pluralize}/:id' do"
    rva << "    it 'gets a #{model.name.underscore}' do"
    rva << "      foo = FactoryBot.create(:#{model.name.underscore})"
    rva << "      get \"/#{model.name.underscore.pluralize}/" + '#{foo.id}"'
    rva << '      expect(response).to have_http_status(:ok) #200'
    rva << '      # TODO: check response content'
    rva << '    end'
    rva << ''
    rva << '    it \'resource not found\' do'
    rva << "      invalid_id = (#{model.name}.maximum(:id) || 0) + 1"
    rva << "      get \"/#{model.name.underscore.pluralize}/" + '#{invalid_id}"'
    rva << '      expect(response).to have_http_status(:not_found) #404'
    rva << '    end'
    rva << '  end'
    rva << ''
    rva << "  describe 'POST #{model.name.underscore.pluralize}/' do"
    rva << '    # TODO fill in'
    rva << '  end'
    rva << 'end'

    rva.join("\n") + "\n"
  end
end
