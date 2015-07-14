//
//  Player.h
//  Backgammon
//
//  Created by aybek can kaya on 15/06/15.
//  Copyright (c) 2015 aybek can kaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

#define PLAYER_NAME_KEY @"playerName"
#define PLAYER_COLOR_KEY @"playerColor"

@interface Player : NSObject
{
    colorType typeOfPlayerColor;
}

@property(nonatomic,strong) NSString *playerName ;
@property(nonatomic,readonly) colorType typeColor;

// dynamics
//@property(nonatomic) int numberOfFlunks;
//@property(nonatomic) BOOL canCollectFlakes;


-(id)initWithPlayerColor:(colorType) typeCL playerName:(NSString *)playerName;

-(id)initWithPlayerDictionary:(NSDictionary *)dctPlayer;

-(NSDictionary *)toDictionary;

@end
