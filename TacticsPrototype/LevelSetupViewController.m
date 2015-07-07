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

@interface PresetPickerButton : UIButton

@property (nonatomic) LevelPreset preset;
@property (nonatomic) float maxWidth;
@property (nonatomic) float maxHeight;

@property (nonatomic) BOOL isSelectedPreset;

@end

@interface LevelSetupViewController ()

@property (nonatomic, strong) NSArray *presetButtons;
@property (nonatomic) LevelPreset currentPreset;

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
    
    CGRect presetFrame = (CGRect){0, 20, 100, 80};
    PresetPickerButton *riversButton = [[PresetPickerButton alloc] initWithFrame:presetFrame];
    [riversButton setImage:[UIImage imageNamed:@"map-rivers"] forState:UIControlStateNormal];
    [riversButton addTarget:self action:@selector(touchedPresetButton:) forControlEvents:UIControlEventTouchUpInside];
    riversButton.preset = LevelPreset_Rivers;
    riversButton.maxWidth = 32;
    riversButton.maxHeight = 16;
    [self.view addSubview:riversButton];
    
    PresetPickerButton *plainsButton = [[PresetPickerButton alloc] initWithFrame:presetFrame];
    [plainsButton setImage:[UIImage imageNamed:@"map-plains"] forState:UIControlStateNormal];
    [plainsButton addTarget:self action:@selector(touchedPresetButton:) forControlEvents:UIControlEventTouchUpInside];
    plainsButton.preset = LevelPreset_Plains;
    plainsButton.maxWidth = 29;
    plainsButton.maxHeight = 20;
    [self.view addSubview:plainsButton];
    
    PresetPickerButton *valleyButton = [[PresetPickerButton alloc] initWithFrame:presetFrame];
    [valleyButton setImage:[UIImage imageNamed:@"map-valley"] forState:UIControlStateNormal];
    [valleyButton addTarget:self action:@selector(touchedPresetButton:) forControlEvents:UIControlEventTouchUpInside];
    valleyButton.preset = LevelPreset_Valley;
    valleyButton.maxWidth = 28;
    valleyButton.maxHeight = 16;
    [self.view addSubview:valleyButton];
    
    PresetPickerButton *crossButton = [[PresetPickerButton alloc] initWithFrame:presetFrame];
    [crossButton setImage:[UIImage imageNamed:@"map-cross"] forState:UIControlStateNormal];
    [crossButton addTarget:self action:@selector(touchedPresetButton:) forControlEvents:UIControlEventTouchUpInside];
    crossButton.preset = LevelPreset_Cross;
    crossButton.maxWidth = 22;
    crossButton.maxHeight = 26;
    [self.view addSubview:crossButton];
    
    self.presetButtons = @[riversButton, plainsButton, valleyButton, crossButton];
    
    CGFloat presetSpacing = 20;
    CGFloat presetWidth = presetFrame.size.width*self.presetButtons.count;
    presetWidth += presetSpacing * (self.presetButtons.count - 1);
    CGFloat presetStartX = CGRectGetMidX(self.view.bounds) - presetWidth/2;
    for (int i=0; i<self.presetButtons.count; i++) {
        presetFrame.origin.x = presetStartX + i*(presetSpacing + presetFrame.size.width);
        [self.presetButtons[i] setFrame:presetFrame];
        [self.presetButtons[i] setIsSelectedPreset:NO];
    }
    
    CGRect sliderFrame = (CGRect){20, 130, 0, 10};
    sliderFrame.size.width = (self.view.bounds.size.width - sliderFrame.origin.x*3)/2;
    
    UISlider *slider = [[UISlider alloc] initWithFrame:sliderFrame];
    [slider addTarget:self action:@selector(sliderUpdated:) forControlEvents:UIControlEventValueChanged];
    [slider setBackgroundColor:[UIColor clearColor]];
    slider.minimumValue = 5.0;
    slider.maximumValue = 29.0;
    slider.continuous = YES;
    slider.value = 29.0;
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
    slider.maximumValue = 20.0;
    slider.continuous = YES;
    slider.value = 20.0;
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
    
    [self touchedPresetButton:riversButton];
    
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

- (void)touchedPresetButton:(PresetPickerButton *)presetButton
{
    self.currentPreset = presetButton.preset;
    if (self.widthSlider.value > presetButton.maxWidth) {
        self.widthSlider.value = presetButton.maxWidth;
        [self sliderUpdated:self.widthSlider];
    }
    self.widthSlider.maximumValue = presetButton.maxWidth;
    
    if (self.heightSlider.value > presetButton.maxHeight) {
        self.heightSlider.value = presetButton.maxHeight;
        [self sliderUpdated:self.heightSlider];
    }
    self.heightSlider.maximumValue = presetButton.maxHeight;
    
    for (PresetPickerButton *button in self.presetButtons) {
        button.isSelectedPreset = (button == presetButton);
    }
}

- (void)touchedLoadLevel
{
    CGSize size = (CGSize){floorf(self.widthSlider.value), floorf(self.heightSlider.value)};
    int numPlayers = floorf(self.playersSlider.value);
    int numEnemies = floorf(self.enemiesSlider.value);
    
    WorldLevel *level = [WorldLevel levelWithDimensions:size numPlayers:numPlayers numEnemies:numEnemies levelPreset:self.currentPreset];

    WorldViewController *worldVC = [[WorldViewController alloc] initWithLevel:level];
    [self presentViewController:worldVC animated:YES completion:NULL];
}

@end

@implementation PresetPickerButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        
        self.layer.borderWidth = 3;
        self.layer.cornerRadius = 5;
    }
    return self;
}

- (void)setIsSelectedPreset:(BOOL)isSelectedPreset
{
    _isSelectedPreset = isSelectedPreset;
    if (isSelectedPreset) {
        self.layer.borderColor = [UIColor blackColor].CGColor;
    } else {
        self.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

@end
