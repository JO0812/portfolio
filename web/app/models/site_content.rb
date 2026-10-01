# frozen_string_literal: true

# YAML-backed site content. Plain Ruby objects — no database required,
# which keeps local dev, tests, and the static export dependency-free.
module SiteContent
  CONTENT_DIR = Rails.root.join("config/content")

  Profile = Data.define(:name, :tagline, :description, :bio, :socials) do
    def self.load
      data = YAML.load_file(CONTENT_DIR.join("profile.yml"))
      new(
        name: data.fetch("name"),
        tagline: data.fetch("tagline"),
        description: data.fetch("description"),
        bio: data.fetch("bio"),
        socials: data.fetch("socials")
      )
    end
  end

  Job = Data.define(:company, :role, :location, :period, :summary, :highlights)
  School = Data.define(:school, :program, :period, :note)

  Experience = Data.define(:jobs, :education) do
    def self.load
      data = YAML.load_file(CONTENT_DIR.join("experience.yml"))
      new(
        jobs: data.fetch("jobs").map { |j| Job.new(**j.symbolize_keys) },
        education: data.fetch("education", []).map { |s| School.new(**s.symbolize_keys) }
      )
    end
  end
end
