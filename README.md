# saas-svg-generator
**Fastlane SVG Generator for Xcode SaaS Projects**

## Overview
Managing SVG assets across multiple SaaS projects with unique color and size requirements can be challenging. This project provides a Ruby script using Fastlane to automate the generation and replacement of shared SVG assets, making it easier to keep all projects up-to-date.

## Features
- **Automated SVG generation** for each Xcode project.
- **Centralized management** of shared icons with color customization.
- **Supports dynamic resizing** to adapt to project-specific needs.

## Folder Structure
```plaintext
Fastlane/
├── actions/
│   └── svg_generator.rb    # Main Ruby script for SVG generation
├── svg/                    # Folder containing base SVG assets
└── Fastfile                # Fastlane configuration file
```

## Prerequisites
- **Ruby**: Ensure Ruby is installed on your system.
- **Fastlane**: Install Fastlane in your Xcode project.

## Installation
1. Clone this repository into your Xcode project’s `Fastlane` folder:
   ```bash
   git clone https://github.com/hojatdelfan/saas-svg-generator.git

2. Place your SVG resources in the svg folder.
3. Set up your color configurations:

   - In the `Color` folder, add your custom colors based on your project needs. You should include the following files:

     - `iconDarkEnd.colorset`
     - `iconDarkStart.colorset`
     - `iconLightEnd.colorset`
     - `iconLightStart.colorset`

   - Each of these `.colorset` files should be customized to fit your desired color scheme.

3. Modify the `Fastfile` as needed to run the `svg_generator` script.

## Usage
To generate and replace SVG assets, run the following Fastlane command:
```bash
fastlane generate_svg
```

## Customization
- **Icon Colors**: Customize colors by editing the SVG files directly.
- **Dynamic Sizing**: Modify `svg_generator.rb` to adjust icon sizes based on project requirements.

## Example Output
Here’s an example of what the generated SVG files might look like:

## Contributing
Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create a new branch (`feature/YourFeature`).
3. Commit your changes.
4. Push the branch and create a pull request.


## License
This project is licensed under the MIT License - see the [LICENSE](https://github.com/hojatdelfan/saas-svg-generator/blob/main/LICENSE) file for details.


  

