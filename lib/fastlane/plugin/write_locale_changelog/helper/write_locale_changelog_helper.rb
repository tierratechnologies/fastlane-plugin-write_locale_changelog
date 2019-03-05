require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class WriteLocaleChangelogHelper
      # class methods that you define here become available in your action
      # as `Helper::WriteLocaleChangelogHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the write_locale_changelog plugin helper!")
      end
    end
  end
end
