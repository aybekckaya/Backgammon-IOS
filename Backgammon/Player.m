//
//  Player.m
//  Backgammon
//
//  Created by aybek can kaya on 15/06/15.
//  Copyright (c) 2015 aybek can kaya. All rights reserved.
//

#import "Player.h"

@implementation Player

-(id)initWithPlayerColor:(colorType)typeCL playerName:(NSString *)playerName
{
    if(self = [super init])
    {
        typeOfPlayerColor = typeCL;
        self.playerName = playerName;
        
    }
    
    return self;
}

-(id)initWithPlayerDictionary:(NSDictionary *)dctPlayer
{
    if(self = [super init])
    {
        self.playerName = dctPlayer[PLAYER_NAME_KEY];
        typeOfPlayerColor = [dctPlayer[PLAYER_COLOR_KEY] intValue];
    }
    
    return self;
}

-(colorType) typeColor
{
    return typeOfPlayerColor;
}


-(NSDictionary *)toDictionary
{
    NSDictionary *playerDictionary = @{PLAYER_NAME_KEY : self.playerName , PLAYER_COLOR_KEY : [NSNumber numberWithInt:typeOfPlayerColor]};
    return playerDictionary;
}

@end
