namespace :cloudi do
    namespace :fix do
        desc "Finish to apply the migration adding handles to classes and disciplines."
        task :handles => :environment do
            SchoolClass.all.each do |klass|
                if klass.handle.nil? or klass.handle.empty?
                    klass.generate_handle!
                    klass.save!

                    puts "Updated class #{klass.name}"
                end
            end

            Discipline.all.each do |discipline|
                if discipline.handle.nil? or discipline.handle.empty?
                    discipline.generate_handle!
                    discipline.save!

                    puts "Updated discipline #{discipline.name}"
                end
            end
        end
    end
end
