# Car Safety App 🚗👶

A comprehensive Flutter-based child safety application designed to prevent tragic incidents of children being left in vehicles. The app uses advanced location tracking, Bluetooth monitoring, and intelligent risk assessment to protect children's safety.

## Features

### 🛡️ Core Safety Features
- **Real-time Location Tracking**: GPS-based parking detection and distance monitoring
- **Bluetooth Integration**: Car connection monitoring for departure detection
- **Intelligent Risk Assessment**: Multi-layered algorithm for child presence detection
- **Multi-stage Alert System**: Progressive alerts from gentle reminders to emergency notifications
- **Emergency SMS Alerts**: Automatic notifications to emergency contacts with car details and location

### 👤 User Management
- **User Profiles**: Personal information and vehicle details
- **Child Profiles**: Age-based risk assessment for multiple children
- **Emergency Contacts**: Priority-based contact management with device integration
- **Customizable Settings**: Alert timeouts, distance thresholds, and sensitivity levels

### 📱 User Interface
- **Hebrew Localization**: Full RTL support and Hebrew interface
- **Intuitive Navigation**: Easy access to all features from the home screen
- **Real-time Status**: Visual indicators for monitoring and connection status
- **Settings Management**: Comprehensive configuration options

## Algorithm Logic

### Risk Detection System

The system identifies a risk situation when:

1. **The vehicle is in parking mode**
2. **The user has moved away from the car beyond the configured distance**
3. **There is a high probability that a child is in the car**, based on:
   - Number of children in the user profile
   - Previous trip patterns
   - Day and time (e.g., school hours)
   - User profile settings

### Alert System

The progressive alert system includes:

1. **Initial Alert** - "Did you forget a child in the car?"
   - Gentle safety check with configurable timeout
   - User can respond to confirm safety

2. **Secondary Alert** - Stronger alert if no response
   - More urgent warning with visual and audio emphasis
   - Shorter timeout for user response

3. **Emergency Alert** - SMS to contacts with car details and location
   - Automatic notification to all emergency contacts
   - Includes car model, color, license plate, and GPS location
   - Emergency service numbers provided

### Intelligence Features

- **Pattern Recognition**: Learns from historical trip data
- **Time-based Assessment**: Considers school hours and weekdays
- **Profile Sensitivity**: Adjustable risk thresholds (Normal, Strict, Custom)
- **Distance Monitoring**: Real-time tracking of user distance from parked car
- **Bluetooth Integration**: Uses car connection status as departure indicator

## Technical Architecture

### Services
- **LocationService**: GPS tracking, parking detection, geocoding
- **BluetoothService**: Device scanning, connection management, car pairing
- **DetectionService**: Risk assessment, alert coordination, pattern analysis
- **StorageService**: Local data persistence, settings management
- **NotificationService**: Alert delivery, SMS functionality

### Models
- **UserProfile**: Personal and vehicle information
- **ChildProfile**: Age-based child data
- **Trip**: Journey tracking with locations and events
- **EmergencyContact**: Priority-based contact management
- **AppSettings**: Configurable app parameters

### Screens
- **HomeScreen**: Main monitoring interface
- **ProfileScreen**: User and vehicle management
- **ContactsScreen**: Emergency contact configuration
- **SettingsScreen**: App configuration and permissions

## Dependencies

- `geolocator` & `geocoding`: Location services and address resolution
- `flutter_reactive_ble`: Bluetooth Low Energy operations
- `flutter_contacts`: Device contact integration
- `shared_preferences`: Local data storage
- `permission_handler`: Runtime permission management
- `flutter_local_notifications`: Alert notifications
- `flutter_sms`: SMS messaging capability
- `provider`: State management and dependency injection

## Getting Started

### Prerequisites
- Flutter SDK 3.0+
- Dart 3.0+
- iOS 12.0+ / Android API 21+

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd car_safety_app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Configure app icon:
   ```bash
   flutter pub run flutter_launcher_icons:main
   ```

4. Run the app:
   ```bash
   flutter run
   ```

### Permissions Required

- **Location**: Background location access for parking detection
- **Bluetooth**: Device scanning and connection management
- **Contacts**: Emergency contact integration
- **SMS**: Emergency alert messaging
- **Notifications**: Alert delivery

## Configuration

1. **User Profile**: Set up personal information and vehicle details
2. **Child Profiles**: Add children with ages for risk assessment
3. **Emergency Contacts**: Configure priority contacts for alerts
4. **Settings**: Adjust alert timeouts, distance thresholds, and sensitivity
5. **Bluetooth**: Pair with car's Bluetooth system

## Safety Considerations

- The app is designed as a safety aid, not a replacement for parental vigilance
- Multiple detection methods ensure reliability
- Progressive alert system prevents false alarms
- Emergency contacts receive detailed information for quick response
- All data is stored locally for privacy

## Support

For technical support or feature requests, please contact the development team.

---

**Remember: Technology is a tool to assist, but parental awareness and responsibility remain paramount in child safety.**
