//
//  SetCardView.h
//  SuperSetCard
//
//  Created by Tatiana Kornilova on 2/17/13.
//  Copyright (c) 2013 Tatiana Kornilova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView

@property (strong, nonatomic) NSString *shape;
@property (nonatomic) int color;
@property (nonatomic) int shading;
@property (nonatomic) int rank;

@property (nonatomic) BOOL faceUp;

//-(void)pinch:(UIPinchGestureRecognizer *)gesture;
              
@end
