//
//  PanelView.m
//  TacticsPrototype
//
//  Created by Chris Meill on 6/22/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import "PanelView.h"

@interface PanelView ()

@property (nonatomic) BOOL isIn;
@property (nonatomic) BOOL animating;

@property (nonatomic) UIButton *arrowButton;

@end

@implementation PanelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        CGRect buttonFrame = self.bounds;
        buttonFrame.size.height = 35;
        buttonFrame.origin.y = CGRectGetMaxY(self.bounds) - buttonFrame.size.height - 5;
        UIButton *arrowButton = [[UIButton alloc] initWithFrame:buttonFrame];
        arrowButton.contentEdgeInsets = UIEdgeInsetsMake(20, 0, 0, 0);
        arrowButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [arrowButton setImage:[UIImage imageNamed:@"menu-arrow"] forState:UIControlStateNormal];
        [arrowButton addTarget:self action:@selector(touchedArrow) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:arrowButton];
        self.arrowButton = arrowButton;
        
        self.isIn = YES;
        self.arrowButton.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    UIColor *borderColor = [UIColor colorWithWhite:0 alpha:0.3f];
    CGContextSetFillColorWithColor(context, borderColor.CGColor);

    CGFloat borderWidth = 2;
    CGRect top = self.bounds;
    top.size.height = borderWidth;
    CGContextFillRect(context, top);
    
    CGRect left = self.bounds;
    left.size.width = borderWidth;
    left.origin.y += borderWidth;
    left.size.height -= borderWidth*2;
    CGContextFillRect(context, left);
    
    CGRect right = self.bounds;
    right.size.width = borderWidth;
    right.origin.x = CGRectGetMaxX(self.bounds) - borderWidth;
    right.origin.y += borderWidth;
    right.size.height -= borderWidth*2;
    CGContextFillRect(context, right);
    
    CGRect bottom = self.bounds;
    bottom.size.height = borderWidth;
    bottom.origin.y = CGRectGetMaxY(self.bounds) - borderWidth;
    CGContextFillRect(context, bottom);
    
    UIColor *fillColor = [UIColor colorWithWhite:0 alpha:0.6f];
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextFillRect(context, CGRectInset(self.bounds, borderWidth, borderWidth));
    
    CGContextRestoreGState(context);
}

- (void)touchedArrow
{
    if (!self.animating) {
        [self setIsIn:!self.isIn animated:YES];
    }
}

- (void)setIsIn:(BOOL)isIn animated:(BOOL)animated
{
    if (self.animating || isIn == self.isIn) {
        return;
    }
    
    CGRect frame = self.frame;
    frame.origin.y = isIn ? 0 : -CGRectGetHeight(self.frame) + 30;
    
    CGFloat arrowAngle = isIn ? M_PI : 0;
    CGAffineTransform arrowTransform = CGAffineTransformMakeRotation(arrowAngle);
    
    void (^animationBlock)() = ^void() {
        self.frame = frame;
        self.arrowButton.imageView.transform = arrowTransform;
    };
    
    if (animated) {
        self.animating = YES;
        [UIView animateWithDuration:0.3 animations:animationBlock
            completion:^(BOOL finished)
        {
            self.animating = NO;
            self.isIn = isIn;
        }];
    }
    
    else {
        animationBlock();
        self.isIn = isIn;
    }
}

@end
