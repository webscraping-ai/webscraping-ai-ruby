require "cgi"
require "uri"

module WebScrapingAI
  # Faraday-compatible params encoder that follows the conventions used by
  # the WebScraping.AI OpenAPI spec:
  #
  #   * Hash values are encoded as deepObject/explode: `key[subkey]=value`
  #     (used for `headers` and `fields`).
  #   * Array values are encoded as form/explode: `key=v1&key=v2`
  #     (used for `selectors`).
  #   * Booleans serialize as the strings `"true"`/`"false"`.
  #   * `nil` values are dropped entirely (both top level and inside hashes).
  module QueryEncoder
    module_function

    def encode(params)
      return nil if params.nil?
      return "" if params.empty?

      pairs = []
      params.each do |key, value|
        next if value.nil?

        encode_pair(key.to_s, value, pairs)
      end
      pairs.join("&")
    end

    def decode(query)
      return nil if query.nil?

      URI.decode_www_form(query)
    end

    class << self
      private

      def encode_pair(key, value, pairs)
        case value
        when Hash
          value.each do |sub_key, sub_value|
            next if sub_value.nil?

            pairs << "#{escape(key)}[#{escape(sub_key.to_s)}]=#{escape(stringify(sub_value))}"
          end
        when Array
          value.each do |element|
            next if element.nil?

            pairs << "#{escape(key)}=#{escape(stringify(element))}"
          end
        else
          pairs << "#{escape(key)}=#{escape(stringify(value))}"
        end
      end

      def stringify(value)
        case value
        when true then "true"
        when false then "false"
        else value.to_s
        end
      end

      # Use %20 for spaces (not +) so that the encoder output matches
      # what Faraday actually sends on the wire — Faraday's URI normalization
      # rewrites + to %20 anyway, and matching it here keeps tests deterministic.
      def escape(string)
        CGI.escape(string).gsub("+", "%20")
      end
    end
  end
end
