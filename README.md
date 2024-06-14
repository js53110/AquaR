# AquaQ App

AquaQ is a app designed exclusively for iOS devices as a part of IoT project at Faculty of Engineering and Computing, Zagreb, providing users with access to monitor busy and available toilets and showers. This README file will guide you through the process of setting up and running the AquaQ app on your iOS device using Xcode.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Installation](#installation)
3. [Usage](#usage)
4. [Features](#features)
5. [Troubleshooting](#troubleshooting)
6. [Contributing](#contributing)

## Prerequisites

Before you begin, ensure you have met the following requirements:
- A Mac running macOS.
- Xcode installed on your Mac.
- An iOS device running iOS 14.0 or later.
- A USB cable to connect your iOS device to your Mac.
- An Apple ID configured in Xcode.

## Installation

To install AquaQ on your iOS device using Xcode, follow these steps:

1. **Clone the Repository**:
   - Open Terminal on your Mac.
   - Clone the AquaQ repository using the following command:
     ```sh
     git clone https://github.com/js53110/AquaR.git
     ```
   - Navigate to the project directory:
     ```sh
     cd AquaR
     ```

2. **Open the Project in Xcode**:
   - Launch Xcode on your Mac.
   - Click on "File" > "Open" and navigate to the AquaQ project directory.
   - Open the `AquaQ.xcodeproj` file.

3. **Configure the Project**:
   - Select your target device from the device list at the top of the Xcode window.
   - Ensure that your Apple ID is configured under Xcode preferences. Go to `Xcode` > `Preferences` > `Accounts` and add your Apple ID if it's not already added.

4. **Build and Run the Project**:
   - Connect your iOS device to your Mac using a USB cable.
   - In Xcode, click the build button (play icon) to compile and run the app on your connected device.
   - If prompted, authorize the device and trust the developer.

## Usage

Upon launching the AquaQ app for the first time, follow these steps:

1. **Enter consumer token**:
   - Fill in the required details.

2. **Log In**:
   - Enter your credentials and tap "Log In".

3. **Set Up Your Profile**:
   - Provide necessary information about your location and water sources.

4. **Monitor Toilets and Showers availability**:
   - Use the dashboard to view real-time data on water quality parameters.

5. **Reserve a shower**:
   - Set up alerts for specific water quality thresholds.

## Features

- **Real-Time Monitoring**: Get up-to-date information on toilets and showers availability.
- **Reservations**: Create reservation when you need to have a shower.

## Contributing

Contributions are welcome! Please follow these steps to contribute:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/your-feature`).
3. Make your changes and commit them (`git commit -m 'Add some feature'`).
4. Push to the branch (`git push origin feature/your-feature`).
5. Open a pull request.

---

Thank you for using AquaQ!
