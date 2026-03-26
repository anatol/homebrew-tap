class Booklight < Formula
  desc "Lightweight macOS reading app for PDF and EPUB books"
  homepage "https://github.com/anatol/booklight"
  head "https://github.com/anatol/booklight.git", branch: "main"

  depends_on :xcode => ["16.0", :build]
  depends_on :macos

  def install
    # Build the macOS app using xcodebuild with ad-hoc signing
    # Mac Catalyst app: use "macOS" destination
    system "xcodebuild", "build",
           "-project", "Booklight.xcodeproj",
           "-scheme", "Booklight",
           "-configuration", "Release",
           "-derivedDataPath", buildpath/"build",
           "-destination", "generic/platform=macOS",
           "CODE_SIGN_IDENTITY=-",
           "CODE_SIGNING_ALLOWED=NO",
           "CODE_SIGNING_REQUIRED=NO"

    # Find and install the .app bundle directly to /Applications
    app = Dir[buildpath/"build/Build/Products/Release**/Booklight.app"].first
    prefix.install app
  end

  def caveats
    <<~EOS
      To make Booklight available in /Applications, run:
        ln -sf #{prefix}/Booklight.app /Applications/Booklight.app
    EOS
  end

  test do
    assert_predicate Pathname("/Applications/Booklight.app"), :exist?
  end
end
