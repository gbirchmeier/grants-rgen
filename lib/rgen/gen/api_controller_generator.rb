require 'active_support/inflector'

class Rgen::Gen::ApiControllerGenerator

  def generate_file(model, destination)
    fullpath = File.join(destination, model.name.pluralize.underscore + '_controller.rb')
    File.write(fullpath, generate_file_content(model))
    fullpath
  end

  private

  def generate_file_content(model)
    rva = []
    rva << '# frozen_string_literal: true'
    rva << "class #{model.name.pluralize}Controller < ApiController"
    rva << '  def index'
    rva << "    render json: #{model.name}.all"
    rva << '  end'
    rva << ''
    rva << '  def show'
    rva << '    begin'
    rva << "      render json: #{model.name}.find(params[:id]), status: :ok #200"
    rva << '    rescue ActiveRecord::RecordNotFound => e'
    rva << '      render json: { error: \'Record not found\' }, status: :not_found #404'
    rva << '    end'
    rva << '  end'
    rva << ''
    rva << '  def create'
    rva << "    @#{model.name.downcase} = #{model.name}.new(#{model.name.downcase}_params)"
    rva << "    if @#{model.name.downcase}.save"
    rva << "      render json: @#{model.name.downcase}, status: :created #201"
    rva << '    else'
    rva << '      render json: {'
    rva << '        error: \'Invalid parameters\','
    rva << "        details: @#{model.name.downcase}.errors.full_messages"
    rva << '      }, status: :bad_request # 400'
    rva << '    end'
    rva << '  end'
    rva << ''
    rva << '  private'
    rva << ''
    rva << "  def #{model.name.downcase}_params"
    rva << "    params.require(:#{model.name.downcase}).permit("

    # TODO add belongs_to ids
    
    attribute_names = model.attributes.collect(&:name)
    attribute_names.each do |attname|
      endchar = (attname == attribute_names.last) ? ')' : ','
      rva << "      :#{attname}#{endchar}"
    end
    rva << '  end'
    rva << 'end'
    rva.join("\n") + "\n"
  end
end
