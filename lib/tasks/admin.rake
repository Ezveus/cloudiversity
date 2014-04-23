namespace :admin do
    desc "Export the entire application"
    task export: :environment do
        system "bundle package"
        Dir.chdir "C:\\" do
            archive = "ruby-windows-cloudiversity.zip"
            system("rm Ruby200\\#{archive}") if File.exists? archive
            system "7za a #{archive} Ruby200"
            system "mv #{archive} Ruby200"
        end
    end
end
