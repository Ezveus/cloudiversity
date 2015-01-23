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

            Period.all.each do |period|
                if period.handle.nil? or period.handle.empty?
                    period.generate_handle!
                    period.save!

                    puts "Updated period #{period.name}"
                end
            end
        end
    end

    namespace :admin do
        desc "Creates a new administrator if no one exists"
        task :create => :environment do
            if Admin.count > 0
                $stderr.puts "An administrator already exists."
                puts "Connect as administrator to create a new administrator."
                next # return does not works in rake tasks, next does
            end

            puts "Creating a new Administrator."
            puts "Please enter the informations about this administrator below:", ""

            # Initialize a HighLine object for easy input
            i = HighLine.new

            # Get the information about the user
            u = User.new(
                # Spaces as last character indicate to HighLine not to put a new line
                login: i.ask("Login: "),
                first_name: i.ask("First name: "),
                last_name: i.ask("Last name: "),
                email: i.ask("E-mail address: ")
            )

            puts "", "Enter the account password."
            puts "Nothing will be echoed to terminal."
            password = i.ask("Password: ") { |o| o.echo = false }
            password_confirmation = i.ask("Confirmation (type password again): ") { |o| o.echo = false }

            if password != password_confirmation
                $stderr.puts "Password mismatch"
                next
            end

            u.password = password
            puts ""

            if u.save
                a = Admin.create(user: u)
                puts "Administrator \"#{u.login}\" successfully created."
            else
                $stderr.puts "Unable to create administrator:"
                $stderr.puts u.errors.full_messages.map { |m| " - #{m}" }.join("\n")
            end
        end
    end
end
