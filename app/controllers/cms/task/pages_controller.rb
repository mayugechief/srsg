# coding: utf-8
class Cms::Task::PagesController < ApplicationController
  include Cms::ReleaseFilter::Page
  
  private
    def set_site
      @cur_site = SS::Site.find_by host: ENV["site"]
    end
    
  public
    def generate
      set_site
      return puts "Site is unselected." unless @cur_site
      return puts "config.cms.serve_static_pages is false" unless SS.config.cms.serve_static_pages
      
      puts "Generate pages"
      
      Cms::Page.site(@cur_site).public.each do |page|
        puts "  write  #{page.url}"
        generate_page page
      end
    end
    
    def generate_file(page)
      @cur_site = page.site
      generate_page page
    end
    
    def remove
      set_site
      return puts "Site is unselected." unless @cur_site
      
      puts "Remove pages"
      
      Cms::Page.site(@cur_site).each do |page|
        puts "  remove  #{page.url}"
        Fs.rm_rf page.path
      end
    end
end
