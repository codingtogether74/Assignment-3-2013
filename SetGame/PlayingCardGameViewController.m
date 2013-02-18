//
//  PlayingCardGameViewController.m
//  SetGame
//
//  Created by Tatiana Kornilova on 2/15/13.
//  Copyright (c) 2013 Tatiana Kornilova. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "PlayingCardCollectionViewCell.h"

@implementation PlayingCardGameViewController


- (void) updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card

{
    if ([cell isKindOfClass:[PlayingCardCollectionViewCell class]]) {
        PlayingCardView *playingCardView = ((PlayingCardCollectionViewCell *)cell).playingCardView;
        if ([card isKindOfClass:[PlayingCard class]]) {
            PlayingCard *playingCard =(PlayingCard *)card;
            playingCardView.rank = playingCard.rank;
            playingCardView.suit = playingCard.suit;
            playingCardView.faceUp = playingCard.faceUp;
            playingCardView.alpha = playingCard.isUnplayable ? 0.3 : 1.0;
            
        }
    }
}

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}
- (NSUInteger) startingCardCount
{
    return 20;
}
- (NSAttributedString *)cardAttributedContents:(Card *)card forFaceUp:(BOOL)isFaceUp
{
    NSDictionary *cardAttributes = @{};
    NSString *textToDisplay = (isFaceUp) ? card.contents: @" ";
    NSAttributedString *cardContents = [[NSAttributedString alloc] initWithString:textToDisplay attributes:cardAttributes];
    return cardContents;
}


- (NSString *)textForSingleCard
{
    Card *card = [self.game.matchedCards lastObject];
    return [NSString stringWithFormat:@"flipped %@",(card.isFaceUp) ? @"up!" : @"back!"];
}


@end
