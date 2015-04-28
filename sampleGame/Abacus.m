//
//  Abacus.m
//  katrinadevaney
//
//  Created by Katrina DeVaney on 7/21/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Abacus.h"
//#import "MainScene.h"

@implementation Abacus

////////////////////////////////////////////////////////////////
//abacus logic:////////////////////////////////////////////////
////////////////////////////////////////////////////////////////

-(NSMutableArray*)nsintTovalueArray: (NSString*)intAmount {
    //create digit & grid array for a NSString amount
    NSMutableArray *intDigitArray;
    intDigitArray=[self makeDigitArray:intAmount];
    
    //digit array>>GridArray
    NSMutableArray *amountGridArray;
    amountGridArray=[self valueArray:(intDigitArray)];
    // NSLog(@"amountGridArray: %@", amountGridArray);
    return amountGridArray;
}

//move beads
-(void)moveBeads:(NSMutableArray*)gridArray withMove: (int)x andy: (int)y {
    
    //check if there is a bead at that location
    if (gridArray[x][y]==[NSNumber numberWithInt:1]) {
        
        //for five beads
        if (y == 0) {
            gridArray[x][1]=[NSNumber numberWithInt:1];
            //           NSLog(@"gridArrayafterMove: %@", gridArray);
        }
        if (y == 1) {
            gridArray[x][0]=[NSNumber numberWithInt:1];
            //         NSLog(@"gridArrayafterMove: %@", gridArray);
        }
        
        
        //for one beads
        int zeroyval = 0;//just to initalize
        if ( y >= 2) {
            //find zero index in gA[x][2:6]
            for (int i=2;i<7;i++) {
                if (gridArray[x][i]==[NSNumber numberWithInt:0])
                {
                    zeroyval=i;
                    break;
                }
            }
            //check whether zeroyval<>y //wouldnt have to repeat code if you assign max min
            if (zeroyval > y){
                for (int index = y; index < zeroyval+1; index++){ //no way to get range in arrays?!?!?
                    gridArray[x][index]=[NSNumber numberWithInt:1];
                    // NSLog(@"gridArrayafterMove: %@", gridArray);
                }
            }
            if (y > zeroyval){
                for (int index = zeroyval; index < y+1;index++){
                    gridArray[x][index]=[NSNumber numberWithInt:1];
                    //   NSLog(@"gridArrayafterMove: %@", gridArray);
                    
                }
                
            }
            
        }
    }
    gridArray[x][y]=[NSNumber numberWithInt:0];//put in very end. if you think about it, whereever you touched now becomes 0/empty.
    // NSLog(@"gridArrayafterMove: %@", gridArray);
}


//calculates value of given abacus
-(int)abacusValue: (NSMutableArray*)gridArray {
    int total=0;
    
    for (int i = 0; i <[gridArray count]; i++) { //count gives you # of cols; how to get rows? MYSTERY.
        if (gridArray[i][1]==[NSNumber numberWithInt:1]) {
            total = total + 5*(pow(10,[gridArray count]-(i+1)));//is that right?
        }
        
        
        if (gridArray[i][2]==[NSNumber numberWithInt:1]) {
            total = total + 1*(pow(10,[gridArray count]-(i+1)));
            int multi=1;
            for (int k = 3; k < 6; k++) {
                int val=[gridArray[i][k] intValue];
                multi=multi*val;
                if (multi==1) {
                    total = total + 1*(pow(10,[gridArray count]-(i+1)));
                }
            }
        }
        // NSLog(@"what's the total?: %d", total);
    }
    return total;
}

//creates a digit array from number entered as string
-(NSMutableArray*)makeDigitArray: (NSString*)tmpstr{
    NSMutableArray *tmpdigitArray = [[NSMutableArray alloc] init];
    for (int index = 0; index < [tmpstr length]; index++)
    {
        NSString *tmpCharacter = [tmpstr substringWithRange:NSMakeRange(index, 1)];
        //   NSLog(@"%@", tmpCharacter);
        
        [tmpdigitArray addObject:tmpCharacter];
    }
    //  NSLog(@"tmpdigitArray: %@", tmpdigitArray);
    //    [self valueArray:tmpdigitArray]; //creates a valueArray based on digits //here for easy testing
    return tmpdigitArray;
}


//MODIFIED to create an array of the beads that should be colored
//creates an array for a given number
-(NSMutableArray*)valueArray: (NSMutableArray*)digitArray {
    //make 2d gridarray
    NSMutableArray *gridArray = [[NSMutableArray alloc] init];
    NSMutableArray *_colorArray = [[NSMutableArray alloc] init];
    NSMutableArray *gridandcolorArray = [[NSMutableArray alloc] init];
    
    for (int a=0; a<[digitArray count]; a++) {
        gridArray[a] = [NSMutableArray array];
        _colorArray[a]= [NSMutableArray array];
    }
    //  NSLog(@"gridArray: %@", gridArray);
    // NSLog(@"size of gA: %lu", (unsigned long)[gridArray count]);
    
    for (int b=0; b<[digitArray count]; b++) {
        for (int r=0;r<7;r++) {
            gridArray[b][r]=[NSNumber numberWithInt:0];
            _colorArray[b][r]=[NSNumber numberWithInt:0];
        }
        //  NSLog(@"gridArray: %@", gridArray);
    }
    //goes thru each digit, starting with smallest digit
    for (int i=0; i<[digitArray count]; i++) {
        //store digit in temporary var so can manipulate easily
        
        NSInteger temp=[digitArray[i] integerValue]; //change this to taking in an integer
        
        //if greater than five, want five bead activated
        if (temp>=5) {
            gridArray[i][1]=[NSNumber numberWithInt:1];
            _colorArray[i][1]=[NSNumber numberWithInt:1];
            temp=temp-5;
        }
        //default for five bead if not used
        else {
            gridArray[i][0]=[NSNumber numberWithInt:1];
        }
        //have number of ones beads activated
        if (temp>=0) {
            
            for (int j=2;j<2+temp;j++){
                gridArray[i][j]=[NSNumber numberWithInt:1];
                _colorArray[i][j]=[NSNumber numberWithInt:1];
            }
            //left over ones beads
            for(int k=3+temp;k<7;k++){
                gridArray[i][k]=[NSNumber numberWithInt:1];
            }
        }
    }
    //  NSLog(@"gridArray: %@", gridArray);
    //  NSLog(@"size of gA: %lu", (unsigned long)[gridArray count]);
    
    gridandcolorArray[0]=gridArray;
    gridandcolorArray[1]=_colorArray;
    return gridandcolorArray;
    //NSLog(@"gridandcolor array:%@",gridandcolorArray);
}

@end
