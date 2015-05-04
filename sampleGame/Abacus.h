//
//  Abacus.h
//  sampleGame
//
//  Created by Katrina DeVaney on 4/25/15.
//  Copyright (c) 2015 Katrina DeVaney. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Abacus : NSObject
-(NSMutableArray*)nsintTovalueArray: (NSString*)intAmount;
-(int)abacusValue: (NSMutableArray*)gridArray;
-(void)moveBeads:(NSMutableArray*)gridArray withMove: (int)x andy: (int)y;
-(NSMutableArray*)makeDigitArray: (NSString*)tmpstr;
-(NSMutableArray*)valueArray: (NSMutableArray*)digitArray;
@end
