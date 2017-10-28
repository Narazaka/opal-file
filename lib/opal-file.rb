unless RUBY_ENGINE == "opal"
  require "opal"
  Opal.append_path File.expand_path("..", __FILE__).untaint
end

require "opal-file/version"

if RUBY_ENGINE == "opal"
  require "native"

  class File
    class << self
      def read(filename, options)
        _fs.JS.readFileSync(filename, { encoding: "utf8" }.to_n)
      end

      def write(filename, content)
        _fs.JS.writeFileSync(filename, content.to_s)
      end

      def unlink(*filename)
        filename.each do |f|
          _fs.JS.unlinkSync(f.to_s)
        end
      end

      private

        def _fs
          @_fs ||= `require("fs")`
        end
    end
  end
end
