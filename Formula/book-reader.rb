class BookReader < Formula
  desc "Lightweight macOS reading app for PDF and EPUB books"
  homepage "https://github.com/anatol/book-reader-app"
  head "https://github.com/anatol/book-reader-app.git", branch: "main"

  depends_on :xcode => ["16.0", :build]
  depends_on :macos

  def install
    # Build the macOS app using xcodebuild with ad-hoc signing
    # Mac Catalyst app: use "macOS" destination
    system "xcodebuild", "build",
           "-project", "BookReader.xcodeproj",
           "-scheme", "BookReader",
           "-configuration", "Release",
           "-derivedDataPath", buildpath/"build",
           "-destination", "generic/platform=macOS",
           "CODE_SIGN_IDENTITY=-",
           "CODE_SIGNING_ALLOWED=NO",
           "CODE_SIGNING_REQUIRED=NO"

    # Find and install the .app bundle directly to /Applications
    app = Dir[buildpath/"build/Build/Products/Release**/BookReader.app"].first
    prefix.install app
  end

  def caveats
    <<~EOS
      To make BookReader available in /Applications, run:
        ln -sf #{prefix}/BookReader.app /Applications/BookReader.app
    EOS
  end

  test do
    assert_predicate Pathname("/Applications/BookReader.app"), :exist?
  end
end
