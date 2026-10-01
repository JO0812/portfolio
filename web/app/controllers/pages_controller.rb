# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    @profile = SiteContent::Profile.load
    @experience = SiteContent::Experience.load
  end
end
