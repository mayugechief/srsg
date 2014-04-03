# coding: utf-8
module Fs
  class Prep
    Fs.include Fs::Local
    
    Cms::Page.addon "fs/files"
  end
end
