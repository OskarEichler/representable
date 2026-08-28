# frozen_string_literal: true

module Representable
  module Hash
    module AllowSymbols
      private

      def filter_wrap_for(data, *args)
        super(Conversion.stringify_keys(data), *args)
      end

      def update_properties_from(data, *args)
        super(Conversion.stringify_keys(data), *args)
      end
    end

    module Conversion
      def self.stringify_keys(hash)
        result = {}
        hash.keys.each do |key|
          result[key.to_s] = hash[key]
        end
        result
      end
    end
  end
end
