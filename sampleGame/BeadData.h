//
//  BeadData.h
//  sampleGame
//
//  Created by Katrina DeVaney on 4/25/15.
//  Copyright (c) 2015 Katrina DeVaney. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeadData : NSObject

//made this foundation class as a wrapper for bead
//alternative1: subclass bead into custom object
//alternative2: use userData property??
//but that seems to be for client/user data
//http://stackoverflow.com/questions/22245859/how-to-add-client-data-to-sknode-skspritenode

@property NSString *name;
@property BOOL activated;

@end
