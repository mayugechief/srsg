# coding: utf-8
module Category::Editor::Nodes
  
  class EditCell < Cell::Rails
    include Cms::EditorFilter::Edit
  end
  
  class ViewCell < Cell::Rails
    include Cms::EditorFilter::View
  end
end