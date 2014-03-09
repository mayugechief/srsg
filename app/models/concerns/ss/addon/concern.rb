# coding: utf-8
module SS::Addon::Concern
  def self.extended(mod)
    mod.extend SS::Translation
  end
  
  def addon_name
    SS::Addon::Name.new(self)
  end
end
