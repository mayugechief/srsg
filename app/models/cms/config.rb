# encoding: utf-8
class Cms::Config
  cattr_reader(:default_values) do
    {
      ajax_layout: true,
      html_editor: "ckeditor"
    }
  end
end
