namespace :brakeman do

  desc "Run Brakeman"
  task :run, :output_file do |t, args|
    require 'brakeman'
    
    if !args[:output_file]
      args[:output_file] = "log/security_scan.html"
    end  
    
    Brakeman.run :app_path => ".", :output_file => args[:output_file], :print_report => true
  end
end
