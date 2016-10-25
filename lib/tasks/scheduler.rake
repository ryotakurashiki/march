namespace :scheduler do
  task :wakeup_dyno => :environment do
    sh "curl -l http://otolog.net"
  end
end
