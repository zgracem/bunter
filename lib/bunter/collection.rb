# frozen_string_literal: true

module Bunter
  # A collection of {Snippet}s.
  class Collection
    extend Forwardable

    ARRAY_METHODS = %i[each map map! length size << append push clear first last]
    private_constant :ARRAY_METHODS

    # @return [String] the name of the collection
    attr_accessor :name
    # @return [String, nil] path to an icon representing the collection
    attr_accessor :image
    # @return [String] a keyword required before all snippets to trigger expansion
    attr_accessor :prefix
    # @return [String] a keyword required after all snippets to trigger expansion
    attr_accessor :suffix
    # @return [Array<Bunter::Snippet>] the snippets in the collection
    attr_accessor :snippets

    # @!method size
    #   @return [Integer] the number of snippets in the collection
    delegate({ ARRAY_METHODS => :snippets })

    class << self
      # @param path [String] path to YAML file
      # @return [Bunter::Collection]
      def from_yaml_file(path)
        yaml_file = Pathname(path)
        yaml_data = YAML.safe_load(yaml_file.read,
          symbolize_names: true,
          permitted_classes: [Symbol]
        )

        if yaml_data[:image]
          img_file = Pathname(yaml_data[:image])
          yaml_data[:image] = (yaml_file.dirname / img_file).to_s if img_file.relative?
        end

        new(**yaml_data)
      end

      # @param path [String] path to .alfredsnippets file
      # @return [Bunter::Collection]
      def from_snippets_file(path)
        info = default_info
        snip_file = Pathname(path)
        info[:name] = snip_file.basename(".alfredsnippets").to_s

        Zip::File.open(snip_file) do |zip_file|
          if (plist_file = zip_file.find_entry("info.plist"))
            plist_info = Plist.parse_xml(plist_file.get_input_stream.read)

            info.merge!(
              prefix: plist_info["snippetkeywordprefix"],
              suffix: plist_info["snippetkeywordsuffix"]
            )
          end

          info[:image] = "icon.png" if zip_file.find_entry("icon.png")

          zip_file.glob("*.json").each do |jf|
            if (json = JSON.parse(jf.get_input_stream.read).to_symbolized_hash)
              snip = json[:alfredsnippet]
              info[:snippets] << Snippet.new(snip).to_h
            end
          end

          new(**info.compact)
        end
      end

      # @return [Hash]
      def default_info
        {
          name:     "My Collection",
          image:    nil,
          prefix:   "",
          suffix:   "",
          snippets: []
        }
      end
    end

    # @param name [String, nil]
    # @param image [#to_s, nil]
    # @param prefix [String, nil]
    # @param suffix [String, nil]
    # @param snippets [Array<Bunter::Snippet>, nil]
    def initialize(**info)
      info = Collection.default_info.merge(info)

      @name     = info[:name]
      @image    = info[:image]&.to_s
      @prefix   = info[:prefix]
      @suffix   = info[:suffix]
      @snippets = info[:snippets].map { |s| Snippet.new(s) }.sort_by(&:name)
    end

    # @return [Hash{String=>Object}]
    def to_h
      # rubocop:disable Style/StringHashKeys
      {
        "name"     => name,
        "image"    => image,
        "prefix"   => prefix,
        "suffix"   => suffix,
        "snippets" => snippets.map(&:to_h)
      }
        .compact
        .keep_if { |_k, v| v.present? }
    end

    # @return [Hash{Symbol=>Object}]
    def to_symbolized_hash
      to_h.to_symbolized_hash
    end

    # @return [String]
    def to_json
      to_h.to_json
    end

    # @return [String]
    def to_yaml
      to_h.to_yaml
    end

    # Write the snippets file to disk.
    # @param dir [String] (~/Desktop) output directory
    # @param base [String] basename of the snippets file; will have the
    #   extension ".alfredsnippets" appended; defaults to {#name}
    # @return [String] the full path to the snippets file
    def to_snippets_file(dir: "#{Dir.home}/Desktop", base: name)
      snip_file = "#{dir}/#{filename(base)}"

      Zip::File.open(snip_file, Zip::File::CREATE) do |zip_file|
        zip_contents.each { |entry, src| zip_file.add(entry, src) }
      end

      return snip_file
    end

    # @return [String]
    def inspect
      %(#<#{self.class.name}:"#{name}" (#{size} snippets)>)
    end

    private

    def filename(base = name)
      base.delete(File::SEPARATOR).tr(" ", "_").concat(".alfredsnippets")
    end

    def zip_contents
      contents_ = []

      contents_.push(dump_info_plist)
      contents_.push(dump_image)
      contents_.push(*dump_snippets)

      contents_.compact
    end

    # @return [Array<Array<(String,Tempfile)>>]
    def dump_snippets
      snippets.map { |s| s.send(:to_temp_file) }
    end

    # @return [Array<(String,Pathname)>, nil]
    def dump_image
      img_file = Pathname(image)
      return unless image && img_file.exist?

      ["icon.png", img_file]
    end

    # @return [Array<(String,Tempfile)>, nil]
    def dump_info_plist
      Bunter.create_tempfile("info.plist", affixes.to_plist) if affixes?
    end

    def affixes?
      affixes.values.any?(&:present?)
    end

    def affixes
      {
        snippetkeywordprefix: prefix,
        snippetkeywordsuffix: suffix
      }
    end
  end
end
