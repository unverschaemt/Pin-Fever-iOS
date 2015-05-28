//
//  Constants.h
//  PinFever
//
//  Created by David Ehlen on 05.05.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#define kAPIEndpointHost @"http://87.106.19.69:8080"

#define kAPILoginEndpoint (kAPIEndpointHost @"/auth/login")
#define kAPIRegisterEndpoint (kAPIEndpointHost @"/auth/register")
#define kAPIFriendsEndpoint  (kAPIEndpointHost @"/players/me/friends")
#define kAPIDeleteFriendsEndpoint (kAPIEndpointHost @"/players/me/removefriend/")
#define kAPIAddFriendsEndpoint (kAPIEndpointHost @"/players/me/addfriend/")
#define kAPISearchUsersEndpoint (kAPIEndpointHost @"/players/search/")

#define kErrorKey @"err"
#define kDataKey @"data"
#define kTokenKey @"token"
#define kFriendKey @"friends"
#define kPlayerKey @"players"

#define kIdKey @"_id"
#define kDisplayName @"displayName"
#define kEmailKey @"email"
#define kLevelKey @"level"

#define kKeychainKey @"PinFeverKeychain"

#define kAPIAuthToken @"api-auth-token"

#define kFriendsFilename @"friends.pinfever"