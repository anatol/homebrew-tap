class Pdfium < Formula
  desc "PDFium prebuilt binaries"
  homepage "https://github.com/bblanchon/pdfium-binaries"
  url "https://github.com/bblanchon/pdfium-binaries/releases/latest/download/pdfium-mac-arm64.tgz"
  version "latest"

  license "BSD-3-Clause"

  def install
    include.install Dir["include/*"]
    lib.install Dir["lib/*"]

    # pkg-config file
    (lib/"pkgconfig").mkpath
    (lib/"pkgconfig/pdfium.pc").write <<~EOS
      prefix=#{prefix}
      exec_prefix=${prefix}
      libdir=${exec_prefix}/lib
      includedir=${prefix}/include

      Name: pdfium
      Description: PDFium PDF rendering library
      Version: #{version}
      Libs: -L${libdir} -lpdfium
      Cflags: -I${includedir}
    EOS
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <fpdfview.h>
      int main() {
        FPDF_InitLibrary();
        FPDF_DestroyLibrary();
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-lpdfium", "-I#{include}", "-o", "test"
    system "./test"
  end
end
