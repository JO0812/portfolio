# frozen_string_literal: true

namespace :static do
  desc "Render all pages to static HTML in dist/ for Cloudflare deployment"
  task export: :environment do
    dist = Rails.root.join("dist")
    FileUtils.rm_rf(dist)
    FileUtils.mkdir_p(dist)

    Rake::Task["assets:precompile"].invoke

    # Integration requests carry a synthetic host; don't let host
    # authorization reject them regardless of RAILS_ENV.
    Rails.application.config.hosts.clear

    session = ActionDispatch::Integration::Session.new(Rails.application)
    { "/" => "index.html" }.each do |path, file|
      session.get(path)
      raise "GET #{path} failed with status #{session.status}" unless session.status == 200

      target = dist.join(file)
      FileUtils.mkdir_p(target.dirname)
      target.write(session.response.body)
      puts "wrote #{target}"
    end

    FileUtils.cp_r(Rails.root.join("public/assets"), dist.join("assets"))
    Dir[Rails.root.join("public/*")].each do |entry|
      next if File.basename(entry) == "assets"

      FileUtils.cp_r(entry, dist.join(File.basename(entry)))
    end

    puts "static export complete: #{dist}"
  end
end
