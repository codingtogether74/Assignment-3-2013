//
//  SetCardView.m
//  SuperSetCard
//
//  Created by Tatiana Kornilova on 2/17/13.
//  Copyright (c) 2013 Tatiana Kornilova. All rights reserved.
// Code from  Marko Kuljanski
//  https://github.com/Kulja/Matchismo

#import "SetCardView.h"

@implementation SetCardView

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:12.0];
    [roundedRect addClip]; //prevents filling corners, i.e. sharp corners not included in roundedRect
    
    if (self.faceUp) {
        [[UIColor colorWithRed: 0.0 green:0.2 blue:0.4 alpha:0.1] setFill];
        UIRectFill(self.bounds);
    } else {
        [[UIColor whiteColor] setFill];
        UIRectFill(self.bounds);
    }
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    [self drawCards];
}
#define SYMBOL_SCALE_X 2
#define SYMBOL_SCALE_Y 7
#define SIZE_OF_OVAL_CURVE 10
#define DIAMOND_ARM_SCALE 0.8
#define Y_OFFSET_FOR_NUMBER_2 2.7
#define Y_OFFSET_FOR_NUMBER_3 1.7

- (void)drawCards
{
    if ([self.shape isEqualToString:@"diamond"]) {
        [self drawDiamond];
    } else if ([self.shape isEqualToString:@"squiggle"]) {
        [self drawSquiggle];
    } else if ([self.shape isEqualToString:@"oval"]) {
        [self drawOval];
    }
}



- (void)drawSquiggle
{
    CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGPoint start = CGPointMake(middle.x + (middle.x / SYMBOL_SCALE_X), middle.y - (middle.y / SYMBOL_SCALE_Y));
    UIBezierPath *path = [[UIBezierPath alloc] init];
    path.lineWidth =5; // ?????
    [path moveToPoint:start];
    [path addQuadCurveToPoint:CGPointMake(start.x, middle.y + (middle.y / SYMBOL_SCALE_Y)) controlPoint:CGPointMake(start.x + SIZE_OF_OVAL_CURVE, middle.y)];
    [path addCurveToPoint:CGPointMake(middle.x - (middle.x / SYMBOL_SCALE_X), middle.y + (middle.y / SYMBOL_SCALE_Y)) controlPoint1:CGPointMake(middle.x, middle.y + (middle.y / SYMBOL_SCALE_Y) + (middle.y / SYMBOL_SCALE_Y)) controlPoint2:CGPointMake(middle.x, middle.y)];
    [path addQuadCurveToPoint:CGPointMake(middle.x - (middle.x / SYMBOL_SCALE_X), start.y) controlPoint:CGPointMake(middle.x - (middle.x / SYMBOL_SCALE_X) - SIZE_OF_OVAL_CURVE, middle.y)];
    [path addCurveToPoint:CGPointMake(start.x, start.y) controlPoint1:CGPointMake(middle.x, middle.y - (middle.y / SYMBOL_SCALE_Y) - (middle.y / SYMBOL_SCALE_Y)) controlPoint2:CGPointMake(middle.x, middle.y)];
  //----------------------------
      path.lineWidth =3; // ?????
      [path closePath];
     [self drawAttributesFor:path];
}

- (void)drawOval
{
    CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGPoint start = CGPointMake(middle.x + (middle.x / SYMBOL_SCALE_X), middle.y - (middle.y / SYMBOL_SCALE_Y));
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:start];
    [path addQuadCurveToPoint:CGPointMake(start.x, middle.y + (middle.y / SYMBOL_SCALE_Y)) controlPoint:CGPointMake(start.x + SIZE_OF_OVAL_CURVE, middle.y)];
    [path addLineToPoint:CGPointMake(middle.x - (middle.x / SYMBOL_SCALE_X), middle.y + (middle.y / SYMBOL_SCALE_Y))];
    [path addQuadCurveToPoint:CGPointMake(middle.x - (middle.x / SYMBOL_SCALE_X), start.y) controlPoint:CGPointMake(middle.x - (middle.x / SYMBOL_SCALE_X) - SIZE_OF_OVAL_CURVE, middle.y)];
    path.lineWidth =3; // ?????
    [path closePath];
    
    [self drawAttributesFor:path];
}

- (void)drawDiamond
{
    CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGPoint start = CGPointMake(middle.x, middle.y - (middle.y / SYMBOL_SCALE_Y));
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:start];
    [path addLineToPoint:CGPointMake(middle.x + (middle.x / (SYMBOL_SCALE_X * DIAMOND_ARM_SCALE)), middle.y)];
    [path addLineToPoint:CGPointMake(middle.x, middle.y + (middle.y / SYMBOL_SCALE_Y))];
    [path addLineToPoint:CGPointMake(middle.x - (middle.x / (SYMBOL_SCALE_X * DIAMOND_ARM_SCALE)), middle.y)];
    path.lineWidth =3; // ?????
    [path closePath];
    
    [self drawAttributesFor:path];
}

- (void)pushContextAndRotateUpSideDown
{
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
//    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI/2);
}
-(void)popContext
{
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

- (void)drawAttributesFor:(UIBezierPath *)path
{
    ///------------------
    NSArray *colorPallette = @[[UIColor redColor],[UIColor greenColor],[UIColor purpleColor]];
    NSArray *alphaPallette = @[@0,@0.3,@1.0];
    UIColor *cardOutlineColor = colorPallette[self.color-1];
    UIColor *cardColor = [cardOutlineColor colorWithAlphaComponent:(CGFloat)[alphaPallette[self.shading-1] floatValue]];
    //-------------
    [cardOutlineColor setStroke];
    [cardColor setFill];
    if (self.rank == 2) {
        CGFloat yOffset = self.bounds.size.height/2/Y_OFFSET_FOR_NUMBER_2;
        
        CGAffineTransform transform = CGAffineTransformMakeTranslation(0, -yOffset);
        [path applyTransform:transform];
        
        [path stroke];
        [path fill];
        
        transform = CGAffineTransformMakeTranslation(0, yOffset * 2);
        [path applyTransform:transform];
        [path stroke];
        [path fill];
    } else if (self.rank == 3) {
        CGFloat yOffset = self.bounds.size.height/2/Y_OFFSET_FOR_NUMBER_3;
        
        CGAffineTransform transform = CGAffineTransformMakeTranslation(0, -yOffset);
        [path applyTransform:transform];
        [path stroke];
        [path fill];
        
        transform = CGAffineTransformMakeTranslation(0, yOffset);
        [path applyTransform:transform];
        [path stroke];
        [path fill];
        transform = CGAffineTransformMakeTranslation(0, yOffset);
        [path applyTransform:transform];
        [path stroke];
        [path fill];
    } else {
        
       [path stroke];
        [path fill];
    }
}

- (void)setShape:(NSString *)shape
    
{
    _shape = shape;
    [self setNeedsDisplay];
}

- (void)setRank:(int)rank
{
    _rank =rank;
    [self setNeedsDisplay];
}

- (void)setColor:(int)color
{
    _color =color;
    [self setNeedsDisplay];
}

- (void)setShading:(int)shading
{
    _shading =shading;
    [self setNeedsDisplay];
}

-(void) setFaceUp:(BOOL)faceUp
{
    _faceUp =faceUp;
    [self setNeedsDisplay];
}

#pragma mark - Iitialization
- (void)setup
{
    // do initializaion here
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    [self setup];
    return self;
}
@end
