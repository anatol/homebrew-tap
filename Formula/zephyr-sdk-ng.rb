class ZephyrSdkNg < Formula
  desc "Zephyr SDK (toolchain, host tools, and debug utilities)"
  homepage "https://github.com/zephyrproject-rtos/sdk-ng"
  license "Apache-2.0"
  version "1.0.1"

  url "https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v#{version}/zephyr-sdk-#{version}_macos-aarch64_llvm.tar.xz"
  sha256 "b4def16627864925d35971d611ead3efe880890f8a8d1f5732444a977d58ff9a"

  depends_on "cmake"
  depends_on "ninja"

  def install
    # Install SDK into libexec (standard for large bundles)
    libexec.install Dir["*"]

    cd libexec do
      # Run Zephyr SDK setup script (installs toolchains + host tools)
      # -- -y = non-interactive
      system "./setup.sh", "-t", "all"
    end

    # Export environment helper
    (bin/"zephyr-sdk-env").write <<~EOS
      #!/bin/bash
      export ZEPHYR_SDK_INSTALL_DIR="#{libexec}"
      export PATH="#{libexec}/arm-zephyr-eabi/bin:#{libexec}/xtensa-espressif_esp32_zephyr-elf/bin:$PATH"
      echo "Zephyr SDK environment set."
    EOS

    chmod 0755, bin/"zephyr-sdk-env"
  end

  def caveats
    <<~EOS
      Zephyr SDK installed to:
        #{libexec}

      You need to export:
        export ZEPHYR_SDK_INSTALL_DIR=#{libexec}

      Or run:
        zephyr-sdk-env

      Then use it with west:
        west build -b <board> <app>
    EOS
  end

  test do
    assert_predicate libexec, :exist?
  end
end
