//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Tatiana Kornilova on 1/30/13.
//  Copyright (c) 2013 Tatiana Kornilova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Deck.h"

@interface CardMatchingGame : NSObject

// designated initializer
- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck andGameLevel:(int) gameLevel;

- (void)flipCardAtIndex:(NSInteger)index;
- (Card *)cardAtIndex:(NSInteger)index;
- (NSIndexSet *)getIndexesForMatchedCards:(NSArray *)cards;
- (NSArray *)getSelectedCards;
- (void)deleteCardsAtIndexes:(NSIndexSet *)indexes;
- (void)addCards:(NSUInteger)cardsNumber usingDeck:(Deck *)deck;
- (NSUInteger)cardsInPlay;



@property (readonly,nonatomic) int score;
@property (nonatomic) int gameLevel;
@property (readonly,nonatomic) NSString *flipResult;
@property (readonly,nonatomic) NSArray *matchedCards;
@property (readonly,nonatomic) int flipPoints;
@property (readonly,nonatomic) NSIndexSet *indexesOfInsertedCards;


@end
