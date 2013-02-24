//
//  SetCard.m
//  SetGame
//
//  Created by Tatiana Kornilova on 2/9/13.
//  Copyright (c) 2013 Tatiana Kornilova. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard
@synthesize shape=_shape;

-(int)match:(NSArray *)otherCards
{
    //  Match algorithm for Set
    //
    //  -  Conditions that must be satisfied:
    //  *  They all have the same number, or they have three different numbers.
    //  *  They all have the same symbol, or they have three different symbols.
    //  *  They all have the same shading, or they have three different shadings.
    //  *  They all have the same color, or they have three different colors.

    int score =0;
    int numMatches = 0;
    if ([otherCards count] ==3)
    {
        id otherCard1 = otherCards[0];
        id otherCard2 = otherCards[1];
        id otherCard3 = otherCards[2];
        
        if ([otherCard1 isKindOfClass:[SetCard class]] && [otherCard2 isKindOfClass:[SetCard class]] && [otherCard3 isKindOfClass:[SetCard class]])
        {
            SetCard *card1 = (SetCard *)otherCard1;
            SetCard *card2 = (SetCard *)otherCard2;
            SetCard *card3 = (SetCard *)otherCard3;
            //--------------------shape---------
            if ((![card1.shape isEqualToString:card2.shape] && ![card1.shape isEqualToString:card3.shape] && ![card2.shape isEqualToString:card3.shape]) || ( [card1.shape isEqualToString:card2.shape] && [card2.shape isEqualToString:card3.shape])){
                NSLog(@" shapes YES %@ %@ %@",card1.shape,card2.shape,card3.shape);
                numMatches ++;
                     } else {
                 NSLog(@" shapes NO%@ %@ %@",card1.shape,card2.shape,card3.shape);
                return score;
            }
            //--------------------color-----------
            if (((card1.color != card2.color) && (card1.color != card3.color)&& (card2.color != card3.color)) || ((card1.color == card2.color) && (card2.color == card3.color))) {
                 NSLog(@" colors YES %d %d %d",card1.color,card2.color,card3.color);
                numMatches ++;
             } else {
                   NSLog(@" colors NO %d %d %d",card1.color,card2.color,card3.color);
                return score;
            }
            //------------------------rank---------
            if (((card1.rank != card2.rank) && (card1.rank != card3.rank)&& (card2.rank != card3.rank)) || ((card1.rank == card2.rank) && (card2.rank == card3.rank)) ){
                  NSLog(@" ranks YES %d %d %d",card1.rank,card2.rank,card3.rank);
                numMatches ++;
            } else {
                NSLog(@" ranks NO %d %d %d",card1.rank,card2.rank,card3.rank);
                return score;
            }
            //----------------------shading---------
            if (((card1.shading != card2.shading) && (card1.shading != card3.shading)&& (card2.shading != card3.shading)) || ( (card1.shading == card2.shading) &&(card2.shading == card3.shading))){
                NSLog(@" shadings YES %d %d %d",card1.shading,card2.shading,card3.shading);
                numMatches ++;
             } else {
                 NSLog(@" shadings NO %d %d %d",card1.shading,card2.shading,card3.shading);
                return score;
            }
            switch (numMatches) {
                case 1:
                    score = 4;
                    break;
                case 2:
                    score = 2;
                    break;
                case 3:
                    score = 1;
                    break;
                case 4:
                    score = 3;
                    break;
            }
        }
    }
    return score;
}

- (NSString *)contents
{
    NSString *cardString = [@"" stringByPaddingToLength:self.rank withString: self.shape startingAtIndex:0];
    return cardString;
}


- (void)setShape:(NSString *)shape {
    if ([[SetCard validShapes] containsObject:shape]) {
        _shape =shape;
    }
}
- (NSString *)shape {
    return _shape ? _shape : @"diamond";
}


+ (NSArray *)validShapes
{
    static NSArray *validShapes =nil;
    if (!validShapes) validShapes = @[@"diamond",@"squiggle",@"oval"];
    return validShapes;
}


@end
