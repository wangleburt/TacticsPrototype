//
//  WorldViewController.m
//  TacticsPrototype
//
//  Created by Chris Meill on 6/22/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import "WorldViewController.h"
#import "WorldView.h"
#import "PanelView.h"

#import "WorldState.h"
#import "WorldLevel.h"

@interface WorldViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) WorldLevel *worldLevel;
@property (nonatomic, strong) WorldState *worldState;

@property (nonatomic, strong) UIScrollView *worldScrollView;
@property (nonatomic, strong) WorldView *worldView;

@property (nonatomic, strong) PanelView *menuPanel;
@property (nonatomic, strong) UIButton *gridLinesButton;
@property (nonatomic, strong) UIButton *gridCoordsButton;

@end

@implementation WorldViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setupState];
    [self setupWorldView];
    [self setupMenuPanel];
}

- (void)setupState
{
    self.worldLevel = [WorldLevel testLevel];
    
    self.worldState = [[WorldState alloc] initWithLevel:self.worldLevel];
    self.worldState.gridCoordsEnabled = YES;
    self.worldState.gridLinesEnabled = YES;
}

- (void)setupWorldView
{
    UIScrollView *worldScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    worldScrollView.backgroundColor = [UIColor clearColor];
    worldScrollView.bounces = NO;
    worldScrollView.bouncesZoom = NO;
    worldScrollView.minimumZoomScale = 0.5;
    worldScrollView.maximumZoomScale = 1.0;
    worldScrollView.delegate = self;
    [self.view addSubview:worldScrollView];
    self.worldScrollView = worldScrollView;
    
    WorldView *worldView = [[WorldView alloc] initWithLevel:self.worldLevel];
    [worldView updateGridForState:self.worldState];
    self.worldView = worldView;
    
    [self.worldScrollView addSubview:worldView];
    self.worldScrollView.contentSize = worldView.frame.size;
}

- (void)setupMenuPanel
{
    CGRect panelFrame = self.view.bounds;
    panelFrame.size.width = 75;
    PanelView *menuPanel = [[PanelView alloc] initWithFrame:panelFrame];
    [self.view addSubview:menuPanel];
    self.menuPanel = menuPanel;
    
    CGRect buttonFrame = menuPanel.bounds;
    buttonFrame.size.height = CGRectGetWidth(buttonFrame);
    UIButton *linesButton = [[UIButton alloc] initWithFrame:buttonFrame];
    linesButton.titleLabel.numberOfLines = 0;
    linesButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [linesButton setTitle:@"Hide Lines" forState:UIControlStateNormal];
    [linesButton addTarget:self action:@selector(touchedGridLinesButton) forControlEvents:UIControlEventTouchUpInside];
    [menuPanel addSubview:linesButton];
    self.gridLinesButton = linesButton;
    
    buttonFrame.origin.y += buttonFrame.size.height;
    UIButton *coordsButton = [[UIButton alloc] initWithFrame:buttonFrame];
    coordsButton.titleLabel.numberOfLines = 0;
    coordsButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [coordsButton setTitle:@"Hide Coords" forState:UIControlStateNormal];
    [coordsButton addTarget:self action:@selector(touchedCoordsButton) forControlEvents:UIControlEventTouchUpInside];
    [menuPanel addSubview:coordsButton];
    self.gridCoordsButton = coordsButton;
    
    [menuPanel setIsIn:NO animated:NO];
}

- (void)touchedCoordsButton
{
    self.worldState.gridCoordsEnabled = !self.worldState.gridCoordsEnabled;
    [self.worldView updateGridForState:self.worldState];

    NSString *title = self.worldState.gridCoordsEnabled ? @"Hide Coords" : @"Show Coords";
    [self.gridCoordsButton setTitle:title forState:UIControlStateNormal];
}

- (void)touchedGridLinesButton
{
    self.worldState.gridLinesEnabled = !self.worldState.gridLinesEnabled;
    [self.worldView updateGridForState:self.worldState];

    NSString *title = self.worldState.gridLinesEnabled ? @"Hide Lines" : @"Show Lines";
    [self.gridLinesButton setTitle:title forState:UIControlStateNormal];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.worldView;
}

@end
