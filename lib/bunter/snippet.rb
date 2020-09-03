# frozen_string_literal: true

module Bunter
  # A single snippet.
  class Snippet
    # @return [String] the phrase to which the snippet expands
    attr_accessor :snippet
    alias_method :phrase, :snippet

    # @return [String] the shortcut from which the snippet expands
    attr_accessor :keyword
    alias_method :shortcut, :keyword

    # @return [String] the name of the snippet
    attr_accessor :name

    # @return [String] the snippet's unique identifier
    attr_reader :uuid
    alias_method :uid, :uuid

    # @return [Boolean] whether the snippet should automatically expand
    attr_reader :auto_expand
    alias auto_expand? auto_expand

    # @param snippet_data [Snippet, Hash] while Snippets are typically
    #   initialized with a Hash, {#new} also accepts a Snippet and transparently
    #   returns it
    # @option snippet_data :snippet [String]
    # @option snippet_data :keyword [String]
    # @option snippet_data :name [String]
    # @option snippet_data :auto_expand [Boolean, nil] defaults to `true`
    # @option snippet_data :uuid [String, nil] auto-generates if not provided
    def initialize(snippet_data)
      info = snippet_data.to_symbolized_hash

      @snippet = info[:snippet] || info[:phrase]
      @keyword = info[:keyword] || info[:shortcut]
      @auto_expand =
        if info.key?(:auto_expand)
          !!info[:auto_expand]
        elsif info.key?(:dontautoexpand)
          !(!!info[:dontautoexpand])
        else
          true
        end
      @uuid = info[:uuid] || info[:uid] || SecureRandom.uuid.upcase
      @name = info[:name] || @snippet
    end

    # @param new_val [Boolean] set whether the snippet should automatically expand
    # @return [self]
    def auto_expand=(new_val)
      @auto_expand = !!new_val
      self
    end

    # @return [String]
    def to_s
      snippet
    end

    # @return [String]
    def inspect
      %(#<#{self.class.name}:0x#{uuid.scan(/\h+/).first.downcase}…: "#{name}" (‘#{keyword}’ → “#{snippet}”)>)
    end

    # @return [Hash{String=>Object}]
    def to_h
      hsh_ = {
        "snippet"     => snippet,
        "name"        => name,
        "keyword"     => keyword,
        "auto_expand" => auto_expand,
        "uuid"        => uuid
      }
      hsh_["dontautoexpand"] = true unless auto_expand?
      hsh_
    end

    # @return [Hash{Symbol=>Object}]
    def to_symbolized_hash
      to_h.to_symbolized_hash
    end

    # @return [String] the snippet as JSON
    def to_json
      { alfredsnippet: to_h }.to_json
    end

    # @return [String] the snippet as YAML
    def to_yaml
      to_h.to_yaml
    end

    private

    # @return (see Bunter.create_tempfile)
    def to_temp_file
      Bunter.create_tempfile(filename, to_json)
    end

    # @return [String] the name of the snippet's JSON file
    def filename
      "#{name.delete(File::SEPARATOR)} [#{uuid}].json"
    end
  end
end
