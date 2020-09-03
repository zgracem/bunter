# frozen_string_literal: true

require "active_support"
require "active_support/core_ext/object/blank"
require "forwardable"
require "json"
require "pathname"
require "plist"
require "securerandom"
require "symbolized"
require "tempfile"
require "yaml"
require "zip"

require_relative "bunter/version"
require_relative "bunter/collection"
require_relative "bunter/snippet"

module Bunter
  # @param filename [String]
  # @param contents [String]
  # @return [Array<(String,Tempfile)>] an array containing the original value of
  #   `filename` and the corresponding temporary file
  def self.create_tempfile(filename, contents)
    basename, extname = filename.split(".", 2)
    extname.prepend(".")

    tempfile_ = Tempfile.new([basename, extname])
    tempfile_.write(contents)
    tempfile_.rewind

    [filename, tempfile_]
  end
end
