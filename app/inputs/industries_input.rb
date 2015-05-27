class IndustriesInput < Formtastic::Inputs::SelectInput

  # The following methods are overwritten to manipulate this statement from
  # the superclass:
  #builder.select(input_name, collection, input_options, input_html_options)

  def input_name
    :industry
  end

  def input_html_options
    super.merge(:name => "industry", :id => 'industry')
  end
end
