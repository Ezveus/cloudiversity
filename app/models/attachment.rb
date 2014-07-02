class Attachment < ActiveRecord::Base
    PermittedParams = [ :id, :file, :_destroy ]
    belongs_to :attachable, polymorphic: true
    mount_uploader :file, FileUploader
end
