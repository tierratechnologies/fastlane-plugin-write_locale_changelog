require 'fastlane/action'
require_relative '../helper/write_locale_changelog_helper'

module Fastlane
  module Actions
    class WriteLocaleChangelogAction < Action
      def self.run(params)

        UI.verbose("path_to_meta_dir #{params[:path_to_meta_dir]}")

        UI.verbose("platform #{lane_context[SharedValues::PLATFORM_NAME]}")
        
        platform = lane_context[SharedValues::PLATFORM_NAME]

        UI.verbose("platform tests ios == ios #{platform == :ios}")

        path_to_meta_locales_dir = platform == :ios ? params[:path_to_meta_dir] : File.join(params[:path_to_meta_dir], "android")
        locales = params[:locales]
        changelog = params[:changelog_contents]
        build_number = params[:build_number]

        
        UI.verbose("path_to_meta_locales_dir #{path_to_meta_locales_dir}")
        UI.verbose("locales #{locales}")
        UI.verbose("changelog #{changelog}")
        UI.verbose("buildnumber #{build_number}")

        
        if Dir.exists?(path_to_meta_locales_dir) then

          if locales.empty? == false then
            
            # loop over list of locales
            locales.each do |locale|

              # check path e.g. path_to_meta_locales_dir.join(locale, 'changelogs')
              locale_dir_name = File.absolute_path(File.join(path_to_meta_locales_dir, locale))
              UI.verbose("local_dir_name #{locale_dir_name}")

              if platform == :android then

                changelogs_dir_name = File.join(locale_dir_name, 'changelogs')
                UI.verbose("local_dir_name #{changelogs_dir_name}")

                # check locale directory exists
                if Dir.exist?(locale_dir_name) == false then

                  # create it
                  Dir.mkdir(locale_dir_name, 0777) 
                  
                  # create the corresponding changelogs dir
                  Dir.mkdir(changelogs_dir_name, 0777)

                end

                file_name = File.join(changelogs_dir_name, "#{build_number}.txt")
                UI.verbose("locale file_name #{file_name}")

                File.open(file_name, "w") { |file| file.write(changelog)}
               
              elsif platform == :ios then
                
                  # check locale directory exists
                if Dir.exist?(locale_dir_name) == false then

                  # create it
                  Dir.mkdir(locale_dir_name, 0777) 

                end

                file_name = File.join(locale_dir_name, "release_notes.txt")
                UI.verbose("locale file_name #{file_name}")

                File.open(file_name, "w") { |file| file.write(changelog)}

              else
                UI.error('Unsupported platform')
              end

            end

          else
            UI.error!('No locales found in params')
          end
        else
          UI.error("No metadata directory found for #{platform}" )
        end
      end

      def self.description
        "creates a new changelog file for the given build and locale"
      end

      def self.authors
        ["gmcdowell"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "as above"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :build_number,
                                  # env_name: "CHANGELOG_CONTENT",
                               description: "the build number used to name the changelog file e.g. {build_number}.txt",
                                  optional: false,
                                      type: String),

          FastlaneCore::ConfigItem.new(key: :changelog_contents,
                                  # env_name: "CHANGELOG_CONTENT",
                               description: "the contents to be written to a changelog file",
                                  optional: false,
                                      type: String),

          FastlaneCore::ConfigItem.new(key: :locales,
                                # env_name: "CHANGELOG_CONTENT",
                              description: "a list of locales e.g. ['en-AU', 'en-GB'] for which a changelog is to be created",
                                optional: false,
                                    type: Array),

            FastlaneCore::ConfigItem.new(key: :path_to_meta_dir,
                                # env_name: "CHANGELOG_CONTENT",
                              description: "an absolute path to the {Flutter project}/android/fastlane/metadata",
                                optional: false,
                                    type: String),
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        [:android, :ios].include?(platform)
        # true
      end
    end
  end
end
