module Fastlane
  module Actions
    module SharedValues
      SVG_GENERATOR_CUSTOM_VALUE = :SVG_GENERATOR_CUSTOM_VALUE
    end

    class SvgGeneratorAction < Action
      def self.run(params)
        # fastlane will take care of reading in the parameter and fetching the environment variable:
        #UI.message("Parameter API Token: #{params[:api_token]}")
        
        projects = []
        if params[:project_name]
          projects = [params[:project_name]]
        else
          configs_path = "Configs/*"
          Dir[configs_path].each do |dir_name|
              splits = dir_name.strip.split('/')
              split = splits[splits.count - 1]
              projects.push(split)
          end
        end
        puts "configsArray: #{projects}"

        # Define the path to the SVG directory
        svg_directory_path = 'fastlane/svg/' # Path to the SVG directory
        
        # Get all SVG templates from the directory
        svg_templates = self.get_svg_templates(svg_directory_path)

        #Iterate through each project and generate resources
        projects.each do |project|
          # Paths to each color JSON file for the project
          json_files = {
            iconLightEnd: "Your_project/Resources/Assets/#{project}.xcassets/Color/iconLightEnd.colorset/Contents.json",
            iconLightStart: "Your_project/Resources/Assets/#{project}.xcassets/Color/iconLightStart.colorset/Contents.json",
            iconDarkEnd: "Your_project/Resources/Assets/#{project}.xcassets/Color/iconDarkEnd.colorset/Contents.json",
            iconDarkStart: "Your_project/Resources/Assets/#{project}.xcassets/Color/iconDarkStart.colorset/Contents.json"
          }

          # Extract hex colors for the project
          hex_colors = {}
          json_files.each do |key, file_path|
            if File.exist?(file_path)
              hex_colors[key] = convert_color_to_hex(file_path)
            else
              puts "Warning: File not found for #{key} in project #{project}: #{file_path}"
              next
            end
          end

          # Skip if not all colors are available
          if hex_colors.keys.size < 4
            puts "Skipping project #{project} due to missing colors."
            next
          end

          # Create a directory for the modified SVGs for this project
          project_output_directory = "Your_project/Resources/Assets/#{project}.xcassets"

          # Iterate through each SVG template and generate the modified version
          svg_templates.each do |svg_template|
            create_and_modify_svg(svg_template, project_output_directory, hex_colors)
          end

          puts "Resources for project #{project} have been generated and stored in #{project_output_directory}."
        end


      end


      # Function to convert color from JSON file to hex
      def self.convert_color_to_hex(file_path)
        file_content = File.read(file_path)
        json_data = JSON.parse(file_content)
        
        color = json_data["colors"].first["color"]["components"]
        red = color["red"].to_i(16)
        green = color["green"].to_i(16)
        blue = color["blue"].to_i(16)
        
        format("#%02X%02X%02X", red, green, blue)
      end

      # Function to create and modify SVG files
      def self.create_and_modify_svg(svg_template_path, output_directory, hex_colors)
        # Extract the base name of the SVG template to use in the folder name
        svg_base_name = File.basename(svg_template_path, '.svg')
        new_folder_name = "#{svg_base_name}.imageset"

        # Create the folder for the modified SVG
        folder_path = File.join(output_directory, new_folder_name)
        FileUtils.mkdir_p(folder_path) unless Dir.exist?(folder_path)

        # Define the path for the new SVG file
        new_svg_file_path = File.join(folder_path, "#{svg_base_name}.svg")

        # Read the contents of the SVG template file
        svg_content = File.read(svg_template_path)
        
        # Replace each placeholder with the corresponding hex color
        replacements = {
          "iconLightEnd" => hex_colors[:iconLightEnd],
          "iconLightStart" => hex_colors[:iconLightStart],
          "iconDarkEnd" => hex_colors[:iconDarkEnd],
          "iconDarkStart" => hex_colors[:iconDarkStart]
        }

        replacements.each do |placeholder, color|
          svg_content.gsub!(placeholder, color)
        end
        
        # Write the modified content to the new SVG file
        File.open(new_svg_file_path, 'w') do |file|
          file.write(svg_content)
        end

        # Create the Contents.json file for the imageset folder
        create_contents_json(folder_path, "#{svg_base_name}.svg")
      end

      # Function to create the Contents.json file
      def self.create_contents_json(folder_path, svg_filename)
        contents_json = {
          "images" => [
            {
              "filename" => svg_filename,
              "idiom" => "universal"
            }
          ],
          "info" => {
            "author" => "xcode",
            "version" => 1
          },
          "properties" => {
            "preserves-vector-representation" => true
          }
        }

        # Write the Contents.json file
        contents_file_path = File.join(folder_path, 'Contents.json')
        File.open(contents_file_path, 'w') do |file|
          file.write(JSON.pretty_generate(contents_json))
        end
      end

      # Function to get all SVG templates from a directory
      def self.get_svg_templates(directory_path)
        Dir.glob(File.join(directory_path, '*.svg'))
      end




      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        'A short description with <= 80 characters of what this action does'
      end

      def self.details
        # Optional:
        # this is your chance to provide a more detailed description of this action
        'You can use this action to do cool things...'
      end

      def self.available_options
        # Define all options your action supports.

        # Below a few examples
        [
          FastlaneCore::ConfigItem.new(key: :project_name,
                                       # The name of the environment variable
                                       env_name: 'FL_SVG_GENERATOR_PROJECT_NAME',
                                       # a short description of this parameter
                                       description: 'Project name for SvgGeneratorAction',
                                       optional: true
                                       ),
          FastlaneCore::ConfigItem.new(key: :development,
                                       env_name: 'FL_SVG_GENERATOR_DEVELOPMENT',
                                       description: 'Create a development certificate instead of a distribution one',
                                       # true: verifies the input is a string, false: every kind of value
                                       is_string: false,
                                       # the default value if the user didn't provide one
                                       default_value: false)
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['SVG_GENERATOR_CUSTOM_VALUE', 'A description of what this value contains']
        ]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ['Your GitHub/Twitter Name']
      end

      def self.is_supported?(platform)
        # you can do things like
        #
        #  true
        #
        #  platform == :ios
        #
        #  [:ios, :mac].include?(platform)
        #

        platform == :ios
      end
    end
  end
end
