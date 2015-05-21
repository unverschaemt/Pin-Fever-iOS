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
The Pin Fever Server is written in Javascript and with the help of [nodejs](https://nodejs.org/).
We implement Push Notifications for iOS and Android aswell as User Management and a full featured API to run the turn-based game. Further documentation concerning the server side can be found in the official server repository: [Pin Fever Server](https://github.com/unverschaemt/Pin-Fever-Server).


#####Client Code
The client is written completely in Objective-C. Further documentation on the code will follow.


##Contact
Concerning this repo you should contact David Ehlen, iOS Developer of Pin Fever.

E-Mail: [david@unverschaemt.net](mailto://david@unverschaemt.net).

##License
© Copyright 2015 David Ehlen
