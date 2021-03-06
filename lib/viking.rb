require "lock_jar"

LockJar.load

module Viking

  java_import java.net.URI
  java_import org.apache.hadoop.conf.Configuration
  java_import org.apache.hadoop.fs.FileSystem
  java_import org.apache.hadoop.fs.Path
  java_import org.apache.hadoop.fs.permission.FsPermission
  java_import org.apache.hadoop.hdfs.DistributedFileSystem
  java_import org.apache.hadoop.security.UserGroupInformation

  DEFAULT_BUFFER_SIZE = 4096

  def self.get_username
    username     = Java::java.lang.System.getProperty("HADOOP_USER_NAME") || UserGroupInformation.getCurrentUser().getShortUserName()
  end

  def self.configure(config)
    path         = URI.new(config[:path])
    conf         = Configuration.new

    @buffer_size = config[:buffer_size]
    @client      = FileSystem.newInstance(path, conf, get_username)
  end

  def self.client
    @client ||= begin
      conf = Configuration.new
      conf.set("hadoop.job.ugi", get_username)
      FileSystem.get_local(conf)
    end
  end

  def self.buffer_size
    @buffer_size || DEFAULT_BUFFER_SIZE
  end
end

require "viking/version"
require 'viking/file'
require 'viking/dir'
require 'viking/fileutilz'
