//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Tatiana Kornilova on 1/29/13.
//  Copyright (c) 2013 Tatiana Kornilova. All rights reserved.
//  I took many ideas from Juan Catalan
//  https://github.com/jcatalan007/Matchismo_hw2

#import <UIKit/UIKit.h>
#import "CardMatchingGame.h"
#import "Deck.h"

@interface CardGameViewController : UIViewController
@property (strong,nonatomic) CardMatchingGame *game;
@property (nonatomic) int gameLevel;
@property (nonatomic) BOOL deleteMatchedCards;

// Abstract methods to implement when subclassing
- (NSAttributedString *)cardAttributedContents:(Card *)card forFaceUp:(BOOL)isFaceUp;
- (NSString *)textForSingleCard;
- (Deck *)createDeck;



@property (nonatomic)NSUInteger startingCardCount;  //abstract
- (void) updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card; //abstract
- (void)addCardImageToView:(UIView *)view forCard:(Card *)card inRect:(CGRect)rect; //abstract

@end
