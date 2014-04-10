class HtmlEditorInput < Formtastic::Inputs::TextInput
  def upload_enabled?
    ActiveAdmin::Editor.configuration.s3_configured?
  end

  def policy
    ActiveAdmin::Editor::Policy.new
  end

  def wrapper_html_options
    return super unless upload_enabled?
    super.merge( :data => {
      :policy => policy.to_json,
    }.merge(aws_configuration))
  end

  def to_html
    html = '<div class="wrap">'
    html << builder.text_area(method, input_html_options)
    html << '</div>'
    html << '<div style="clear: both"></div>'
    input_wrapping do
      label_html << html.html_safe
    end
  end

  private

  def aws_configuration
    config = {}
    [:aws_access_key_id, :s3_bucket, :storage_dir].each do |option|
      config[option] = ActiveAdmin::Editor.configuration.send(option)
    end
    config
  end
end
