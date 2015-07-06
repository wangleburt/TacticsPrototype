//
//  LevelSetupViewController.m
//  TacticsPrototype
//
//  Created by Chris Meill on 7/6/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import "LevelSetupViewController.h"
#import "WorldViewController.h"

#import "WorldLevel.h"

@interface LevelSetupViewController ()

@property (nonatomic, strong) UISlider *widthSlider;
@property (nonatomic, strong) UILabel *widthLabel;

@property (nonatomic, strong) UISlider *heightSlider;
@property (nonatomic, strong) UILabel *heightLabel;

@property (nonatomic, strong) UISlider *playersSlider;
@property (nonatomic, strong) UILabel *playersLabel;

@property (nonatomic, strong) UISlider *enemiesSlider;
@property (nonatomic, strong) UILabel *enemiesLabel;

@end

@implementation LevelSetupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect sliderFrame = (CGRect){20, 30, 0, 10};
    sliderFrame.size.width = (self.view.bounds.size.width - sliderFrame.origin.x*3)/2;
    
    UISlider *slider = [[UISlider alloc] initWithFrame:sliderFrame];
    [slider addTarget:self action:@selector(sliderUpdated:) forControlEvents:UIControlEventValueChanged];
    [slider setBackgroundColor:[UIColor clearColor]];
    slider.minimumValue = 5.0;
    slider.maximumValue = 32.0;
    slider.continuous = YES;
    slider.value = 32.0;
    [self.view addSubview:slider];
    self.widthSlider = slider;
    
    CGRect labelFrame = CGRectOffset(sliderFrame, 0, 25);
    labelFrame.size.height = 20;
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    self.widthLabel = label;
    
    sliderFrame.origin.x = CGRectGetMidX(self.view.bounds) + sliderFrame.origin.x/2;
    slider = [[UISlider alloc] initWithFrame:sliderFrame];
    [slider addTarget:self action:@selector(sliderUpdated:) forControlEvents:UIControlEventValueChanged];
    [slider setBackgroundColor:[UIColor clearColor]];
    slider.minimumValue = 5.0;
    slider.maximumValue = 16.0;
    slider.continuous = YES;
    slider.value = 16.0;
    [self.view addSubview:slider];
    self.heightSlider = slider;
    
    labelFrame.origin.x = sliderFrame.origin.x;
    label = [[UILabel alloc] initWithFrame:labelFrame];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    self.heightLabel = label;
    
    sliderFrame = CGRectOffset(self.widthSlider.frame, 0, 100);
    slider = [[UISlider alloc] initWithFrame:sliderFrame];
    [slider addTarget:self action:@selector(sliderUpdated:) forControlEvents:UIControlEventValueChanged];
    [slider setBackgroundColor:[UIColor clearColor]];
    slider.minimumValue = 1.0;
    slider.maximumValue = 24.0;
    slider.continuous = YES;
    slider.value = 5.0;
    [self.view addSubview:slider];
    self.playersSlider = slider;
    
    labelFrame = CGRectOffset(self.widthLabel.frame, 0, 100);
    label = [[UILabel alloc] initWithFrame:labelFrame];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    self.playersLabel = label;
    
    sliderFrame = CGRectOffset(self.heightSlider.frame, 0, 100);
    slider = [[UISlider alloc] initWithFrame:sliderFrame];
    [slider addTarget:self action:@selector(sliderUpdated:) forControlEvents:UIControlEventValueChanged];
    [slider setBackgroundColor:[UIColor clearColor]];
    slider.minimumValue = 1.0;
    slider.maximumValue = 100.0;
    slider.continuous = YES;
    slider.value = 5.0;
    [self.view addSubview:slider];
    self.enemiesSlider = slider;
    
    labelFrame = CGRectOffset(self.heightLabel.frame, 0, 100);
    label = [[UILabel alloc] initWithFrame:labelFrame];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    self.enemiesLabel = label;
    
    [self sliderUpdated:self.widthSlider];
    [self sliderUpdated:self.heightSlider];
    [self sliderUpdated:self.playersSlider];
    [self sliderUpdated:self.enemiesSlider];
    
    CGRect buttonFrame = (CGRect){0, 300, 150, 50};
    buttonFrame.origin.x = CGRectGetMidX(self.view.bounds) - buttonFrame.size.width/2;
    UIButton *loadButton = [[UIButton alloc] initWithFrame:buttonFrame];
    loadButton.backgroundColor = [UIColor blueColor];
    [loadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loadButton.layer.cornerRadius = 5;
    [loadButton setTitle:@"Load Level" forState:UIControlStateNormal];
    [loadButton addTarget:self action:@selector(touchedLoadLevel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loadButton];
}

- (void)sliderUpdated:(UISlider *)slider
{
    if (slider == self.widthSlider) {
        self.widthLabel.text = [NSString stringWithFormat:@"Map Width: %.0f", floorf(slider.value)];
    } else if (slider == self.heightSlider) {
        self.heightLabel.text = [NSString stringWithFormat:@"Map Height: %.0f", floorf(slider.value)];
    } else if (slider == self.playersSlider) {
        self.playersLabel.text = [NSString stringWithFormat:@"Humans: %.0f", floorf(slider.value)];
    } else if (slider == self.enemiesSlider) {
        self.enemiesLabel.text = [NSString stringWithFormat:@"Orcs: %.0f", floorf(slider.value)];
    }
}

- (void)touchedLoadLevel
{
    CGSize size = (CGSize){floorf(self.widthSlider.value), floorf(self.heightSlider.value)};
    int numPlayers = floorf(self.playersSlider.value);
    int numEnemies = floorf(self.enemiesSlider.value);
    
    WorldLevel *level = [WorldLevel levelWithDimensions:size numPlayers:numPlayers numEnemies:numEnemies];

    WorldViewController *worldVC = [[WorldViewController alloc] initWithLevel:level];
    [self presentViewController:worldVC animated:YES completion:NULL];
}

@end
