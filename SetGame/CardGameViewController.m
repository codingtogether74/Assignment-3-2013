//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Tatiana Kornilova on 1/29/13.
//  Copyright (c) 2013 Tatiana Kornilova. All rights reserved.
//

#import "CardGameViewController.h"


@interface CardGameViewController () <UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipResult;
@property (weak, nonatomic) IBOutlet UISlider *timeSlider;
@property (weak, nonatomic) IBOutlet UILabel *sliderMaxLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic, strong) NSMutableArray *flipsHistory;
@property(nonatomic) int flipCount;
@property (nonatomic) float sliderValue;
@property (nonatomic) float sliderMaxValue;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;

@end

@implementation CardGameViewController

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
   return [self.game cardsInPlay];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayingCard" forIndexPath:indexPath];
    Card *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell usingCard:card];
    return cell;
}

- (void) updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
{
   // abstract
}

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.startingCardCount
                                                          usingDeck:[self createDeck]
                                                       andGameLevel:self.gameLevel];
    return _game;
}

- (Deck *)createDeck
{
    //Abstract method
    return nil;
}

-(int)gameLevel
{
    if(!_gameLevel || _gameLevel <2 ) _gameLevel =2;
    return _gameLevel;
}
 - (BOOL)deleteMatchedCards
{
    if(!_deleteMatchedCards) _deleteMatchedCards =NO;
    return _deleteMatchedCards; 
}
- (void)deleteCardsFromCollection
{
    if (self.deleteMatchedCards) {
        if (self.game.matchedCards>0 && [self.game.flipResult isEqualToString:@"Matched"]) {
            NSMutableArray *indexPathsOfMatchedCards = [NSMutableArray array];

            NSIndexSet *indexes=[self.game getIndexesForMatchedCards:self.game.matchedCards];
            [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                [indexPathsOfMatchedCards addObject:[NSIndexPath indexPathForItem:idx inSection:0]];
            }];
            [self.game deleteCardsAtIndexes:indexes];
            [self.cardCollectionView performBatchUpdates:^{
                [self.cardCollectionView
				 deleteItemsAtIndexPaths:indexPathsOfMatchedCards];
            } completion:nil];
        }
        
    }
}

- (NSMutableArray *) flipsHistory
{
    if (!_flipsHistory) _flipsHistory = [[NSMutableArray alloc] init];
    return _flipsHistory;
}

#define MAX_SLIDER 50.0f
#define INC_SLIDER 20.0f


- (NSAttributedString *)cardAttributedContents:(Card *)card forFaceUp:(BOOL)isFaceUp
{
    // Abstract method that returns card contents in an AttributedString
    return nil; 
}

- (NSString *)textForSingleCard
{
    // Abstract method to obtain message for a sigle card
    return nil;
}

-(void)updateUI
{
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell usingCard:card];
    }

    self.flipsLabel.text = [NSString stringWithFormat:@"Cards: %d",[self.game cardsInPlay]];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    [self updateFlipResult];
    [self.timeSlider setValue: self.sliderValue animated:YES];
    self.flipResult.alpha = 1.0;

    [self.timeSlider setMaximumValue:self.sliderMaxValue];
    [self.timeSlider setMinimumValue:0.0f];
    self.sliderMaxLabel.text = [NSString stringWithFormat:@"%d",(int)ceilf(self.sliderMaxValue)];
    self.sliderMaxValue += (self.sliderMaxValue>self.flipCount) ? 0.0f : INC_SLIDER;
  
}

-(NSString *)textForFlipResult{
    NSString *text=@"";
    if (self.game.matchedCards )
    {
        if ([self.game.matchedCards count]>0){
            if ([self.game.flipResult isEqualToString:@"Matched"]) {
                text =  [NSString stringWithFormat:@"%@ %d points bonus", self.game.flipResult,self.game.flipPoints];
            }else if ([self.game.flipResult isEqualToString:@"don't match"]) {
                text =  [NSString stringWithFormat:@"%@ !! penalty %d points", self.game.flipResult,self.game.flipPoints];
            }
            else
                {
                    text = [self textForSingleCard];
                    if (self.game.flipPoints !=0 ) {
                          text =  [NSString stringWithFormat:@"%@ ! penalty %d points",[self textForSingleCard],  self.game.flipPoints];
                    } else {
                          text = [NSString stringWithFormat:@"%@ ",[self textForSingleCard]];
                }
            }
        }
    }
    
    return text;
}


-(NSMutableAttributedString *)attributedStringForFlipResult{
    NSMutableAttributedString *cardsMatched = [[NSMutableAttributedString alloc] init];
    NSAttributedString *space = [[NSAttributedString alloc] initWithString:@" "];
    
    for (Card *card in self.game.matchedCards) {
        [cardsMatched appendAttributedString:[self cardAttributedContents:card forFaceUp:YES]];
        [cardsMatched appendAttributedString:space];
    }
    return cardsMatched;
}

-(void)updateFlipResult
{
    if (self.game.matchedCards) {
        NSMutableAttributedString *cardsMatched = [self attributedStringForFlipResult];
        NSString *text=[self textForFlipResult];
        [cardsMatched appendAttributedString:[[NSAttributedString alloc] initWithString:text]];
        self.flipResult.attributedText = cardsMatched;
    } else
        self.flipResult.attributedText = [[NSAttributedString alloc] initWithString:@"Play game!"];
}


-(void) setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Cards: %d",0];
}

- (IBAction)flipCard:(UITapGestureRecognizer *)gesture
{
    CGPoint tapLocation =[gesture locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
    if (indexPath) {
        [self.game flipCardAtIndex:indexPath.item];
        self.flipCount++;
        [self deleteCardsFromCollection];
        self.sliderValue++;
    }
    [self updateUI];
    [self.flipsHistory addObject:self.flipResult.attributedText];
}

- (IBAction)pressDeal:(UIButton *)sender
{
    self.game = nil;
    self.flipCount =0;
    self.sliderValue=0;
    self.sliderMaxValue =MAX_SLIDER;
    [self updateUI];
}
#define NUMBER_ADD_CARDS 3

- (IBAction)addCards:(id)sender
{
    NSMutableArray *indexPathsOfInsertedCards = [NSMutableArray array];
    [self.game addCards:NUMBER_ADD_CARDS usingDeck:[self createDeck]];
    NSIndexSet *indexes=self.game.indexesOfInsertedCards;
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [indexPathsOfInsertedCards addObject:[NSIndexPath indexPathForItem:idx inSection:0]];
    }];
    [self.cardCollectionView performBatchUpdates:^{
        [self.cardCollectionView insertItemsAtIndexPaths:indexPathsOfInsertedCards];
    } completion:nil];
    [self.cardCollectionView scrollToItemAtIndexPath:[indexPathsOfInsertedCards lastObject] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
    self.flipsLabel.text = [NSString stringWithFormat:@"Cards: %d",[self.game cardsInPlay]];
   
}

-(float)sliderMaxValue
{
    if(!_sliderMaxValue ) _sliderMaxValue =MAX_SLIDER;
    self.sliderMaxLabel.text = [NSString stringWithFormat:@"%D",(int)ceilf(MAX_SLIDER)];
    return _sliderMaxValue;
}

- (IBAction)timeChanged:(UISlider *)sender
{
    int selectedIndex = (int) sender.value;
    
    if (selectedIndex < 0 || (selectedIndex > self.flipCount - 1)) return;
    
    self.flipResult.alpha = (selectedIndex < self.flipCount-1) ? 0.5 : 1.0;
    self.flipResult.attributedText =[self.flipsHistory objectAtIndex: selectedIndex]; ;
    
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.flipsLabel.text = [NSString stringWithFormat:@"Cards: %d",[self.game cardsInPlay]];
}
@end
