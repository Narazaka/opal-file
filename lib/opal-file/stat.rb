require "opal-errno"

if RUBY_ENGINE == "opal"
  require "corelib/error"
  require "native"

  class File
    class Stat
      class << self
        def from_lstat(path)
          File::Stat.new(File::Stat.lstat_sync(path))
        end

        def stat_sync(file)
          e = nil
          `try { return require("fs").statSync(file) } catch(#{e}) { #{raise Class.const_get("Errno::#{e.JS[:code]}")} }`
        end

        def lstat_sync(file)
          e = nil
          `try { return require("fs").lstatSync(file) } catch (#{e}) { #{raise Class.const_get("Errno::#{e.JS[:code]}")} }`
        end
      end

      def initialize(path)
        if `typeof path === "string"`
          @stat = File::Stat.stat_sync(path)
          raise Class.const_get("Errno::#{@stat}") if `typeof this.stat === "string"`
        else
          @stat = path
        end
      end

      def atime
        ms_to_time @stat.JS[:atimeMs]
      end

      def birthtime
        ms_to_time @stat.JS[:birthtimeMs]
      end

      def blksize
        @stat.JS[:blksize]
      end

      def blockdev?
        @stat.JS.isBlockDevice()
      end

      def blocks
        @stat.JS[:blocks]
      end

      def chardev?
        @stat.JS.isCharacterDevice()
      end

      def ctime
        ms_to_time @stat.JS[:ctimeMs]
      end

      def dev
        @stat.JS[:dev]
      end

      def dev_major
        raise NotImplementedError
      end

      def dev_minor
        raise NotImplementedError
      end

      def directory?
        @stat.JS.isDirectory()
      end

      def executable?
        raise NotImplementedError
      end

      def executable_real?
        raise NotImplementedError
      end

      def file?
        @stat.JS.isFile()
      end

      def ftype
        if file? then "file"
        elsif directory? then "directory"
        elsif chardev? then "characterSpecial"
        elsif blockdev? then "blockSpecial"
        elsif pipe? then "fifo"
        elsif symlink? then "link"
        elsif socket? then "socket"
        else "unknown"
        end
      end

      def gid
        @stat.JS[:gid]
      end

      def grpowned?
        raise NotImplementedError
      end

      def ino
        @stat.JS[:ino]
      end

      def mode
        @stat.JS[:mode]
      end

      def mtime
        ms_to_time @stat.JS[:mtimeMs]
      end

      def nlink
        @stat.JS[:nlink]
      end

      def owned?
        raise NotImplementedError
      end

      def pipe?
        @stat.JS.isFIFO()
      end

      def rdev
        @stat.JS[:rdev]
      end

      def rdev_major
        raise NotImplementedError
      end

      def rdev_minor
        raise NotImplementedError
      end

      def readable?
        raise NotImplementedError
      end

      def readable_real?
        raise NotImplementedError
      end

      def setgid?
        raise NotImplementedError
      end

      def setuid?
        raise NotImplementedError
      end

      def size
        @stat.JS[:size]
      end

      def size?
        _size = size
        _size == 0 ? nil : _size
      end

      def socket?
        @stat.JS.isSocket()
      end

      def sticky?
        mode & 0001000;
      end

      def symlink?
        @stat.JS.isSymbolicLink()
      end

      def uid
        @stat.JS[:uid]
      end

      def world_readable?
        raise NotImplementedError
      end

      def world_writable?
        raise NotImplementedError
      end

      def writable?
        raise NotImplementedError
      end

      def writable_real?
        raise NotImplementedError
      end

      def zero?
        size == 0
      end

      private

        def ms_to_time(ms)
          Time.at((ms / 1000).to_i, (ms % 1000) * 1000)
        end
    end
  end
end
