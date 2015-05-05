#Pin-Fever-iOS

Pin Fever is a turn based geography quiz built with love by members of Unverschämt ([unverschaemt.net](http://unverschaemt.net)).

##Availability
Pin Fever will be available soon for Android (Google Play Store) and iOS (Apple App Store).

Further documentation on the Android client can be found at: [Pin Fever Android](https://github.com/unverschaemt/Pin-Fever-Android).

##Documentation
Instructions how to setup and use this application will be documented here. More detailed information will be documented on Unverschämt [Confluence Server](http://server.unverschaemt.net:8000).

#####Install Cocoapods
This project uses Cocoapods to manage all dependencies used in the app.
You can find a guide here how to install [Cocoapods Guide](https://cocoapods.org/).


#####Run 
```
git clone https://github.com/unverschaemt/Pin-Fever-iOS.git
cd Pin-Fever-iOS
pod install
open PinFever.xcworkspace 
```

#####Server
Pin Fever makes use of the [Google Play Game Services](https://developers.google.com/games/services/).
This service is used to implement the communication between Android and iOS clients and to maintain a stable infrastructure for the turn-based game.

A Getting Started Guide concerning this service can be found here: [Getting Started](https://developers.google.com/games/services/ios/quickstart).

#####Client Code
The client is written completely in Objective-C. Further documentation on the code will follow.


##Contact
Concerning this repo you should contact David Ehlen, iOS Developer of Pin Fever.

E-Mail: [david@unverschaemt.net](mailto://david@unverschaemt.net).

##License
© Copyright 2015 David Ehlen