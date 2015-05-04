//
//  GameScene.m
//  sampleGame
//
//  Created by Katrina DeVaney on 4/24/15.
//  Copyright (c) 2015 Katrina DeVaney. All rights reserved.
//

#import "Abacus.h"
#import "GameScene.h"
#import "BeadData.h"

@implementation GameScene{
    NSMutableArray *_columnBeads; //stores all beads as SKSpriteNode objs
    
    //stores currentColumnValues
    int currentValue;
    int onesValue;
    int fiveValue;
    
    //stores how many moves player has made
    int moves;
    
    SKLabelNode *myLabel;
    

    NSMutableArray *positions; //stores original (all non-active) positions of beads
    NSMutableArray *posBools;  //if beads are active (being counted) or not
    
    Abacus *_abacus;
    NSMutableArray *_onesArray;
    
    NSMutableArray *_moves; //stores value of column at each move
}


-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    _abacus=[[Abacus alloc] init]; //need to do this for abacus rmbr
    
    
    myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    myLabel.text = @"Hello, World!";
    myLabel.fontSize = 35;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    
    [self addChild:myLabel];
    
    //intialize values, posBool array,, moves array
    onesValue = 0;
    fiveValue = 0;
    currentValue = 0;
    
    posBools = [[NSMutableArray alloc] init];
    posBools = [NSMutableArray arrayWithArray:@[@(0),@(0),@(0),@(0),@(0)]];
    
    _moves = [[NSMutableArray alloc] init];
    [_moves addObject:[NSNumber numberWithInt:0]]; //so first move can compare to the starting value of 0
    
    //Setup Abacus
    //First, set up divider
    SKSpriteNode *divider = [SKSpriteNode spriteNodeWithImageNamed:@"Divider"];
    divider.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    [self addChild:divider];
    
    //Setup beads
    _columnBeads = [[NSMutableArray alloc] init];
    positions = [[NSMutableArray alloc] init];
    
    
    //Setup five bead
    SKSpriteNode *fiveBead = [SKSpriteNode spriteNodeWithImageNamed:@"OrangeBead"];
    fiveBead.position = CGPointMake(500,500);
    // NSLog(@"bead position x:%f y:%f",bead.position.x, bead.position.y);
    [self addChild:fiveBead];
    _columnBeads[0] = fiveBead;
    fiveBead.name = [NSString stringWithFormat:@"%d", 5];
    positions[0] = [NSNumber numberWithFloat:fiveBead.position.y];
    
    //Setup ones beads
    for (int i = 1; i < 5; i++){
        SKSpriteNode *bead = [SKSpriteNode spriteNodeWithImageNamed:@"OrangeBead"];
        bead.name = [NSString stringWithFormat:@"%d", i];
        //myLabel.text = [NSString stringWithFormat:@"current value: %d", onesValue];
        int yvalue = 280-i*70;
        bead.position = CGPointMake(500,yvalue);
        //  NSLog(@"bead position x:%f y:%f",bead.position.x, bead.position.y);
        [self addChild:bead];
        _columnBeads[i] = bead;
        positions[i] = [NSNumber numberWithFloat:bead.position.y];
    }
}



-(NSNumber*)whichBeadMovedwithTouch:(UITouch *)touch{
    CGPoint touchLocation = [touch locationInNode:self];
    NSNumber* beadNumber;
    
    for (int i = 0; i < 5 ;i++) {
        SKSpriteNode *testbead = (SKSpriteNode*) _columnBeads[i];
        //Check if can be called with whichNodeTouched
        CGRect boundingBox =
        CGRectMake(testbead.position.x-testbead.size.width/2,
                   testbead.position.y-testbead.size.height/2,
                   testbead.frame.size.width,
                   testbead.frame.size.height);
    
        
        if (CGRectContainsPoint(boundingBox, touchLocation)) {
            beadNumber = [NSNumber numberWithInt:(i)];
            //to test:
            //each bead's name is which bead they are i.e. 5 or the 1st/2nd/3rd/4th ones bead
           // NSLog(@"touching bead: %@",testbead.name);
        }
    }
    return beadNumber;
}

//Problem: trying to create better method with NSAssert & output parameters that first checks a bead IS being touched.
//Example: http://www.raywenderlich.com/66877/how-to-make-a-game-like-candy-crush-part-1
//Look at "convertPoint:toColumn:row:" method.
//trying assert and output parameters
-(BOOL)whichBeadMovedwithTouch2:(UITouch *)touch{
   // NSParameterAssert(beadNumber);
    
    CGPoint touchLocation = [touch locationInNode:self];
    
     SKNode *node = [self nodeAtPoint:touchLocation];
    NSLog(@"node is: %@",node.name);
    //returns bead.name is bead touched
    //otherwise returns Null
    
    
    if ([[self nodeAtPoint:touchLocation] name]){
       // SKNode *node = [self nodeAtPoint:touchLocation];
        NSLog(@"yay");
     //   *beadNumber = [node.name integerValue] - 1;
        return YES;
    }
    
    else{
     //   *beadNumber = NSNotFound;
        return NO;
    }
    
    //what else?
    //bead should be own class and testing if typeOfClass is Bead
}

-(void)storePositionBits{
    //make posBools
    for(int i = 0; i < 5; i++){
        SKSpriteNode *testbead2 = (SKSpriteNode*) _columnBeads[i];
        CGFloat nY2 = (CGFloat) testbead2.position.y;
        float kl = [[positions objectAtIndex:i] floatValue];
        
        //bead is 0 if not activated (not being counted)
        if (nY2 == kl){
            posBools[i] = @(0);
        }
        //bead is 1 if activated (being counted)
        else {posBools[i] = @(1);};
    }
       // NSLog(@"posBOols: %@",posBools);
}

//Calculates onevalue, fivevalue, and total column value
-(NSNumber*)calculateBeadValues{

    //one-beads value
    onesValue = 0;
    for (int j = 1; j < 5; j++){
        if (posBools[j] == [NSNumber numberWithInt:1]){
            onesValue += 1;
        }
    }
    //NSLog(@"ones value is: %d", onesValue);
    
    //five-bead value
    fiveValue = 0;
    if (posBools[0] == [NSNumber numberWithInt:1]){
        fiveValue += 5;
    }
   // NSLog(@"five value is: %d", fiveValue);
    
    currentValue = fiveValue + onesValue;
    return @(currentValue);
}


-(void)moveBeads:(NSNumber*)beadTapped{

    //Which bead was tapped?
    int beadTappedIndex = beadTapped.intValue;
    
    
    //If five-bead tapped
    if (beadTappedIndex == 0){
       // NSLog(@"five bead tapped");
        //Subtract five bead, move up
        if (fiveValue == 5){
            [self moveBeadUp:@(0)];
        }
        
        //Add five bead, move down
        else {
            [self moveBeadDown:@(0)];
        }
    }
    
    //If any one-beads tapped
    else if (beadTappedIndex != 0){
        
        //What is the first (lowest index) bead that will toggled?
        int start = MIN(onesValue + 1, beadTappedIndex); //needs onesValue+1 because _columnBeads[0] is five-bead
      
        //How many beads will be toggled?
        int length = MAX(onesValue, beadTappedIndex) - MIN(onesValue, beadTappedIndex - 1);
       
        //test with:
        //for value = 4  to value = 2; length should be 2
        //l = max(4,3) - min (4, 2) = 4-2 = 2
        
        //for value = 0 to value = 4; length should be 4
        //l = max(0, 4) - min(0, 3) = 4-0 = 4
        
        //to test onesValue & beadTappedIndex:
        //NSLog(@"ones value %d to beadtappedIndex %d", onesValue, beadTappedIndex);
        //to test start and length of subArray:
        //NSLog(@"start: %d, length: %d", start, length);
        
        //Make array of all beads that will be toggled
        NSArray* slicedArray = [_columnBeads subarrayWithRange:NSMakeRange(start,length)];
        
        //note: cannot have negative length for subarray
        //tried with:
      //  NSArray* slicedArray = [_columnBeads subarrayWithRange:NSMakeRange(4, -1)];
        //does not work
        
        //to test slicedArray:
       // NSLog(@"sliced Array: %@", slicedArray);
        
        //Loop through slicedArray to toggle beads.
        for (int l = 0; l < slicedArray.count; l++){
            //toggle bead position
            [self toggleBeadPosition:(start + l)];//need index of bead in from _columnBeads array NOT from slicedArray
        }
    }
}

-(void)toggleBeadPosition:(int)beadIndex{
    
    //Which bead is it?
    SKSpriteNode *bead = (SKSpriteNode*) _columnBeads[beadIndex];
    
    //What is its current y-position?
    CGFloat currentYPos = (CGFloat) bead.position.y;
    
    //What is its default (inactive) y-position?
    float defaultYPos = [[positions objectAtIndex:beadIndex] floatValue];
    
    //if bead is in inactive (default) position > toggle to active position
    CGFloat newY;
    if (currentYPos == defaultYPos){
        currentYPos += 50;
        newY = (CGFloat)currentYPos;
    }
    //if bead is in active position > toggle to inactive (default) position
    else {
        newY = (CGFloat)defaultYPos;
    }
    
    //run action to move bead to new position
    SKAction *action = [SKAction moveToY:newY duration:0.2];
    [bead runAction:action];
}

//can combine into one method, take in input down/up
//or better yet, just toggle bead
-(void)moveBeadDown:(NSNumber*)beadIndex{
    SKSpriteNode *touchedBead = (SKSpriteNode*) _columnBeads[beadIndex.intValue];
    int currentYPos = touchedBead.position.y;
      currentYPos -= 50;
    CGFloat newY = (CGFloat)currentYPos;
    SKAction *action = [SKAction moveToY:newY duration:0.2];
    [touchedBead runAction:action];
}


-(void)moveBeadUp:(NSNumber*)beadIndex{
    SKSpriteNode *touchedBead = (SKSpriteNode*) _columnBeads[beadIndex.intValue];
    int currentYPos = touchedBead.position.y;
    currentYPos += 50;
    CGFloat newY = (CGFloat)currentYPos;
    SKAction *action = [SKAction moveToY:newY duration:0.2];
    [touchedBead runAction:action];
}

-(void)calculateColumnValue{
  //  NSLog(@"staring to calculate value");
    [self storePositionBits];
    currentValue = [self calculateBeadValues].intValue;
    NSLog(@"value is: %d with %d + %d", currentValue, fiveValue, onesValue);
    
    //store value of move
    [_moves addObject:[NSNumber numberWithInt:currentValue]];
    //increment moves by 1
    moves += 1;
    
    //log if discrepancy
    if (_moves.count != moves + 1){
    NSLog(@"Warning: moves are not equal, moveArray is %d, movesCounter is %d", _moves.count, moves);
    }
    NSLog(@"moveArray: %@", _moves);
    
    //What is the change in value comparing previous to current move/board?
    int prevValIndex = _moves.count - 2;
    int prevVal = [_moves[prevValIndex] intValue];
    //myLabel.text = [NSString stringWithFormat:@"change: %d", currentValue-prevVal];
    myLabel.text = [NSString stringWithFormat:@"value: %d", currentValue];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        
        //Check if bead tapped
        if ([self whichBeadMovedwithTouch2:touch]){
            
            //Move beads based on which beadTouched
            [self moveBeads:([self whichBeadMovedwithTouch:(touch)])];
            
            //What is the new value of the column?
            
            //   [self calculateColumnValue]; //when called by itself, always reports last (not current) move. it needs delay, see fix in next line.
            [self performSelector:@selector(calculateColumnValue) withObject:self afterDelay:0.4]; //needs delay because bead moving action takes 0.2 (should couple moveBeads action and this)
        }
        
    }
}



-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
