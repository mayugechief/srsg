# coding: utf-8
module Cms::Editor::Basic
  
  class EditCell < Cell::Rails
    include Cms::EditorFilter::Edit
  end
  
  class ViewCell < Cell::Rails
    include Cms::EditorFilter::View
  end
end