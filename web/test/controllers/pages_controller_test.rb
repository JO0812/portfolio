require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "nav carries home, the socials, and the booking CTA" do
    get root_path
    assert_response :success
    assert_select "nav a.nav-brand", "Home"
    assert_select 'nav a[href="https://www.linkedin.com/in/joaquin-bonilla/"]', "Linkedin"
    assert_select 'nav a[href="https://github.com/JO0812"]', "Github"
    assert_select 'nav a.nav-cta[href="https://cal.com/jo-is-here"]', "Let's talk"
  end

  test "home renders the profile" do
    get root_path
    assert_response :success
    assert_select "h1.page-title", "Joaquin Bonilla"
    assert_includes response.body, "BICE VIDA"
  end

  test "head declares the cat favicons" do
    get root_path
    assert_response :success
    assert_select 'link[rel="icon"][href="/favicon.ico"]'
    assert_select 'link[rel="icon"][type="image/svg+xml"][href="/cat-favicon.svg"]'
    assert_select 'link[rel="icon"][type="image/png"][sizes="32x32"]'
    assert_select 'link[rel="apple-touch-icon"][href="/cat-favicon-180.png"]'
  end

  test "home declares utf-8 at the top of head" do
    get root_path
    assert_response :success
    # Without this, non-ascii bytes (arrows, en-dashes, accented names)
    # render as mojibake. Browsers only honor it within the first 1024 bytes.
    assert_operator response.body.index('<meta charset="utf-8">') || Float::INFINITY, :<, 1024
  end

  test "home renders the work section" do
    get root_path
    assert_response :success
    body = response.body
    assert_includes body, 'id="work"'
    assert_includes body, "Backend Developer"
    assert_includes body, "Jul 2023 – Jul 2026"
    assert_includes body, "Universidad Técnica Federico Santa María"
    assert_operator body.index('class="bio"'), :<, body.index('id="work"'),
      "work section must come after the bio"
  end

  test "home carries no copied kavin.me copy" do
    get root_path
    assert_response :success
    [ "Kavin", "Waterloo", "Replicas", "Helicone", "Arcturus", "LiveCode247", "Typewind" ].each do |word|
      assert_not_includes response.body, word, "home leaks copied copy: #{word}"
    end
  end

  test "there is no standalone work page" do
    get "/work"
    assert_response :not_found
  end
end
