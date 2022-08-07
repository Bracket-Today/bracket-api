# frozen_string_literal: true

module ShortCodeService
  # Suggest a short code that is 6 characters long, checks uniqueness and
  # excludes non-word characters.
  class Suggest
    include Service

    # @param check_method [Method]
    #   Method that returns a boolean to check if suggested code is already
    #   used. Defaults to SecureCode.find_by_code.
    def initialize check_method: nil
      @check_method = check_method || ShortCode.method(:find_by_code)
    end

    # @return [String] Suggested code.
    def call
      code = nil

      while code.nil?
        try_code = SecureRandom.urlsafe_base64[0..5]
        next if try_code =~ /\W/
        next if try_code =~ /_/
        next if @check_method.call(try_code)
        code = try_code
      end

      return code
    end
  end
end
