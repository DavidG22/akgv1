class Image < ActiveRecord::Base
  belongs_to :imagable , :polymorphic=> true
  belongs_to :organization
  belongs_to :contact
  belongs_to :IndividualContact
  belongs_to :CompanyContact
  
  attr_accessible :imagable_id, :imagable_type, :image_content_type, :image_file_name, 
               :image_file_size, :image_updated_at, :organization, :imagable, :image
  
    
  has_attached_file :image, styles: { :icon => "50x50>", :thumb => "75x75>", :small => "150x150>", :medium => "200x200>" },
                      :path => ":rails_root/public/assets/images/:id/:styles_:basename.:extension",
                      :url => "/assets/images/:id/:styles_:basename.:extension"

end
