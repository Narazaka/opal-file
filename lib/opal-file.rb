unless RUBY_ENGINE == "opal"
  require "opal"
  Opal.append_path File.expand_path("..", __FILE__).untaint
end

require "opal-file/version"

require "opal-file_test"
require "opal-file/stat"

if RUBY_ENGINE == "opal"
  require "native"

  class File
    class << self
      def method_missing(name, *args)
        FileTest.public_send(name, *args)
      end

      def atime(filename)
        File::Stat.new(filename).atime
      end

      def birthtime(filename)
        File::Stat.new(filename).birthtime
      end

      def chmod(mode, *filename)
        handle_errno do
          filename.each do |f|
            fs.JS.chmodSync(f, mode)
          end
        end
      end

      def chown(owner, group, *filename)
        handle_errno do
          filename.each do |f|
            fs.JS.chownSync(f, owner, group)
          end
        end
      end

      def unlink(*filename)
        handle_errno do
          filename.each do |f|
            fs.JS.unlinkSync(f.to_s)
          end
        end
      end

      alias delete unlink

      # overwrites Opal corelib/file method
      def directory?(filename)
        FileTest.directory?(filename)
      end

      # overwrites Opal corelib/file method
      def exist?(filename)
        FileTest.exist?(filename)
      end

      # overwrites Opal corelib/file method
      def exists?(filename)
        FileTest.exists?(filename)
      end

      def fnmatch?(pattern, path, flags = 0)
        raise NotImplementedError
      end

      alias fnmatch fnmatch?

      def ftype(filename)
        File.lstat(filename).ftype
      end

      def lchmod(mode, *filename)
        handle_errno do
          filename.each do |f|
            fs.JS.lchmodSync(f, mode)
          end
        end
      end

      def lchown(owner, group, *filename)
        handle_errno do
          filename.each do |f|
            fs.JS.lchownSync(f, owner, group)
          end
        end
      end

      def link(old, new)
        handle_errno do
          fs.JS.linkSync(old, new)
        end
      end

      def lstat(filename)
        File::Stat.from_lstat(filename)
      end

      def mkfifo(file_name, mode = 0666)
        raise NotImplementedError
      end

      def path(filename)
        # TODO: fd
        filename
      end

      def readlink(filename)
        handle_errno do
          fs.JS.readlinkSync(filename)
        end
      end

      # TODO: not raise
      alias realdirpath realpath

      def rename(from, to)
        handle_errno do
          fs.JS.renameSync(from, to)
        end
      end

      def stat(filename)
        File::Stat.new(filename)
      end

      def symlink(old, new)
        handle_errno do
          fs.JS.symlinkSync(old, new)
        end
      end

      def truncate(path, length)
        handle_errno do
          fs.JS.truncateSync(path, length)
        end
      end

      def umask(umask = nil)
        raise NotImplementedError
      end

      def utime(atime, mtime, *filename)
        handle_errno do
          filename.each do |f|
            fs.JS.utimesSync(f, atime.to_i, mtime.to_i) # TODO: s ? ms ?
          end
        end
      end

      # IO

      def read(filename, options)
        fs.JS.readFileSync(filename, { encoding: "utf8" }.to_n)
      end

      def write(filename, content)
        fs.JS.writeFileSync(filename, content.to_s)
      end

      private

        def fs
          @fs ||= `require("fs")`
        end

        def handle_errno
          e = nil
          `try { return #{yield} } catch (#{e}) { #{raise Class.const_get("Errno::#{e.JS[:code]}")} }`
        end
    end
  end
end
