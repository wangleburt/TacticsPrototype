//
//  GridOverlayView.m
//  TacticsPrototype
//
//  Created by Chris Meill on 6/22/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import "GridOverlayView.h"
#import "GridOverlayDisplay.h"

@interface GridOverlayView ()

@property (nonatomic) CGSize gridDimensions;
@property (nonatomic) CGFloat unitSize;

@property (nonatomic, strong) GridOverlayDisplay *display;

@end

@implementation GridOverlayView

- (instancetype)initWithGridDimensions:(CGSize)gridDimensions unitSize:(CGFloat)unitSize
{
    CGRect frame = (CGRect){CGPointZero, gridDimensions.width*unitSize, gridDimensions.height*unitSize};
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        self.gridDimensions = gridDimensions;
        self.unitSize = unitSize;
    }
    return self;
}

- (void)updateViewForDisplay:(GridOverlayDisplay *)display
{
    self.display = display;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextClearRect(context, self.bounds);
    
    if (self.display.showGridLines) {
        [self drawGridLinesInContext:context];
    }
    
    [self drawOverlayTilesInContext:context];
    
    if (self.display.showCoordinates) {
        [self drawDebugCoordinatesInContext:context];
    }
    
    CGContextRestoreGState(context);
}

- (void)drawGridLinesInContext:(CGContextRef)context
{
    CGContextBeginPath(context);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 0.5);
    
    for (int i=0; i<=self.gridDimensions.height; i++) {
        CGContextMoveToPoint(context, 0, i*self.unitSize);
        CGContextAddLineToPoint(context, self.gridDimensions.width*self.unitSize, i*self.unitSize);
    }
    for (int i=0; i<=self.gridDimensions.width; i++) {
        CGContextMoveToPoint(context, i*self.unitSize, 0);
        CGContextAddLineToPoint(context, i*self.unitSize, self.gridDimensions.height*self.unitSize);
    }
    CGContextStrokePath(context);
}

- (void)drawOverlayTilesInContext:(CGContextRef)context
{
    for (int col=0; col<self.gridDimensions.width; col++) {
        for (int row=0; row<self.gridDimensions.height; row++) {
            GridOverlayTileDisplay *tile = self.display[col][row];
            if (tile.gradientColors != nil) {
                
                CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
                CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, tile.gradientColors, NULL, 2);
                CGColorSpaceRelease(baseSpace), baseSpace = NULL;
                
                CGContextRef context = UIGraphicsGetCurrentContext();
                
                CGContextSaveGState(context);
                CGFloat size = self.unitSize;
                CGRect rect = (CGRect){col*size, row*size, size, size};
                rect = CGRectInset(rect, 2, 2);
                CGContextAddRect(context, rect);
                CGContextClip(context);
                
                CGPoint startPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
                CGPoint endPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
                
                CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
                CGGradientRelease(gradient), gradient = NULL;
                
                CGContextRestoreGState(context);
            }
        }
    }
}

- (void)drawDebugCoordinatesInContext:(CGContextRef)context
{
    CGFloat fontSize = 7;
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:fontSize];
    NSDictionary *fillAttrs = @{
        NSForegroundColorAttributeName: [UIColor whiteColor],
        NSFontAttributeName: font
    };
    NSDictionary *borderAttrs = @{
        NSForegroundColorAttributeName: [UIColor blackColor],
        NSFontAttributeName: font
    };
    CGContextSetLineWidth(context, fontSize/5);
    
    for (int col=0; col<self.gridDimensions.width; col++) {
        for (int row=0; row<self.gridDimensions.height; row++) {
            NSString *coords = [NSString stringWithFormat:@"[%i %i]", col, row];
            CGPoint point = (CGPoint){col*self.unitSize + 3, (row+1)*self.unitSize-10};
            
            // Draw outlined text.
            CGContextSetTextDrawingMode(context, kCGTextStroke);
            [coords drawAtPoint:point withAttributes:borderAttrs];
            
            // Draw filled text.
            CGContextSetTextDrawingMode(context, kCGTextFill);
            [coords drawAtPoint:point withAttributes:fillAttrs];
        }
    }
    
    
}

@end
