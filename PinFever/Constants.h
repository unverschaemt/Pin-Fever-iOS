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
#define kAPIPlayerEndpoint (kAPIEndpointHost @"/players/me")
#define kAPISomePlayerEndpoint (kAPIEndpointHost @"/players/")
#define kAPISetPlayerEndpoint (kAPIEndpointHost @"/players/me/set")
#define kAPIUploadAvatarEndpoint (kAPIEndpointHost @"/players/me/avatarupload")
#define kAPIDownloadAvatarEndpoint (kAPIEndpointHost @"/players/me/img.jpeg")
#define kAPIFindAutoGameEndpoint (kAPIEndpointHost @"/turnbasedmatch/findauto")
#define kAPICreateGameEndpoint (kAPIEndpointHost @"/turnbasedmatch/create")
#define kErrorKey @"err"
#define kDataKey @"data"
#define kTokenKey @"token"
#define kFriendKey @"friends"
#define kPlayersKey @"players"
#define kPlayerKey @"player"
#define kAutoGame @"autoGame"

#define kIdKey @"_id"
#define kDisplayName @"displayName"
#define kEmailKey @"email"
#define kLevelKey @"level"
#define kStateKey @"state"
#define kModeKey @"mode"
#define kMatchIdKey @"matchId"
#define kParticipantsKey @"participants"
#define kNumberOfPlayersKey @"numberOfPlayers"
#define kMinLevelKey @"numberOfPlayers"
#define kCreatedKey @"created"
#define kTurnsKey @"turns"
#define kTurnBasedMatchKey @"TurnBasedMatch"

#define kKeychainKey @"PinFeverKeychain"

#define kAPIAuthToken @"api-auth-token"

#define kFriendsFilename @"friends.pinfever"
#define kPlayerFilename @"player.pinfever"