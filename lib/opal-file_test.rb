require "opal-file/stat"

if RUBY_ENGINE == "opal"
  require "native"

  module FileTest
    class << self
      def method_missing(name, file)
        File.lstat(file).public_send(name)
      rescue SystemCallError
        false
      end

      def empty?(file)
        zero?(file)
      end

      def exist?(file)
        `require("fs")`.existsSync(file)
      end

      alias exists? exist?

      def identical?(file1, file2)
        raise NotImplementedError
      end

      def size(file)
        File.lstat(file).size
      end

      def size?(file)
        size(file)
      rescue SystemCallError
        nil
      end
    end
  end
end
