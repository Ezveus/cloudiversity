require_dependency "user"
Dir.glob("#{Rails.root}/app/models/*.rb").sort.each { |file| require_dependency file }
