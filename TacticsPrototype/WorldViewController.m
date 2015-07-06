//
//  WorldViewController.m
//  TacticsPrototype
//
//  Created by Chris Meill on 6/22/15.
//  Copyright (c) 2015 Asgardian Games. All rights reserved.
//

#import "WorldViewController.h"
#import "PanelView.h"
#import "CharacterInfoPanel.h"
#import "CombatPreviewView.h"
#import "BlockDrawingView.h"

#import "WorldView.h"
#import "WorldState.h"
#import "WorldLevel.h"
#import "WorldObject.h"

#import "Character.h"
#import "CharacterClass.h"
#import "CharacterWorldOptions.h"
#import "CombatPreview.h"
#import "CombatModel.h"
#import "EnemyAI.h"

@interface WorldViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) WorldLevel *worldLevel;
@property (nonatomic, strong) WorldState *worldState;

@property (nonatomic, strong) UIScrollView *worldScrollView;
@property (nonatomic, strong) WorldView *worldView;

@property (nonatomic, strong) CharacterInfoPanel *characterInfoView;
@property (nonatomic, strong) CombatPreviewView *combatPreview;

@property (nonatomic, strong) PanelView *menuPanel;
@property (nonatomic, strong) UIButton *gridLinesButton;
@property (nonatomic, strong) UIButton *gridCoordsButton;

@property (nonatomic, strong) UIView *endTurnArrow;
@property (nonatomic, strong) UIView *endTurnView;

@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;

@end

@implementation WorldViewController

- (instancetype)initWithLevel:(WorldLevel *)level
{
    self = [super init];
    if (self) {
        self.worldLevel = level;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    self.view.clipsToBounds = YES;
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setupState];
    [self setupWorldView];
    [self setupMenuPanel];
    [self setupEndTurnButton];
    
    CharacterInfoPanel *panel = [[CharacterInfoPanel alloc] init];
    [panel updateForCharacter:nil];
    CGRect frame = panel.frame;
    frame.origin.x = CGRectGetWidth(self.view.bounds) - CGRectGetWidth(frame) - 5;
    frame.origin.y = 5;
    panel.frame = frame;
    [self.view addSubview:panel];
    self.characterInfoView = panel;
    
    CombatPreviewView *combatPreview = [[CombatPreviewView alloc] initWithFrame:self.view.bounds];
    combatPreview.hidden = YES;
    combatPreview.cancelBlock = ^void() {
        weakSelf.combatPreview.hidden = YES;
    };
    combatPreview.confirmBlock = ^void(CombatPreview *preview) {
        weakSelf.combatPreview.hidden = YES;
        [weakSelf performAttackWithCombatPreview:preview];
    };
    [self.view addSubview:combatPreview];
    self.combatPreview = combatPreview;
}

- (void)setupState
{
    self.worldState = [[WorldState alloc] initWithLevel:self.worldLevel];
    self.worldState.gridCoordsEnabled = NO;
    self.worldState.gridLinesEnabled = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self startPlayerTurn];
}

- (void)startPlayerTurn
{
    [self.worldState setupForNewTurn];
    [self resetSpriteActiveState];
    
    Character *dude = [self.worldState.playerCharacters firstObject];
    NSArray *path = @[[NSValue valueWithWorldPoint:dude.position]];
    CGRect visibleRect = [self.worldView visibleRectForMovementPath:path];
    [self scrollToRect:visibleRect completion:^{
        [self animateTurnTitle:@"turn-icon-human" completion:^{
            self.tapRecognizer.enabled = YES;
            self.endTurnArrow.hidden = NO;
        }];
    }];
}

- (void)startEnemyTurn
{
    [self.worldState setupForNewTurn];
    [self resetSpriteActiveState];
    self.tapRecognizer.enabled = NO;
    self.endTurnArrow.hidden = YES;
    [self hideEndTurnButtonAnimated:YES];
    
    [self animateTurnTitle:@"turn-icon-orc" completion:^{
        [self performNextActionFromAI:[self.worldState enemyAiForEnemyTurn]];
    }];
}

- (void)resetSpriteActiveState
{
    for (WorldObject *object in self.worldState.worldObjects) {
        [self.worldView updateSpriteForObject:object active:YES];
    }
}

- (void)animateTurnTitle:(NSString *)turnImageName completion:(void (^)())completionBlock
{
    CGRect imageRect = self.view.bounds;
    imageRect.size.height = 50;
    imageRect.origin.y = CGRectGetMidY(self.view.bounds) - CGRectGetHeight(imageRect)/2;
    imageRect.origin.x = CGRectGetMaxX(self.view.bounds);
    
    UIImageView *titleImage = [[UIImageView alloc] initWithFrame:imageRect];
    titleImage.backgroundColor = [UIColor clearColor];
    titleImage.contentMode = UIViewContentModeScaleAspectFit;
    titleImage.image = [UIImage imageNamed:turnImageName];
    [self.view addSubview:titleImage];
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect frame = imageRect;
        frame.origin.x = 0;
        titleImage.frame = frame;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseIn animations:^{
            CGRect frame = imageRect;
            frame.origin.x = -frame.size.width;
            titleImage.frame = frame;
        } completion:^(BOOL finished) {
            if (completionBlock) {
                completionBlock();
            }
        }];
    }];
}

- (void)scrollToRect:(CGRect)rect completion:(void (^)())completionBlock
{
    CGRect visibleRect = self.worldScrollView.bounds;
    if (CGRectContainsRect(visibleRect, rect)) {
        if (completionBlock) {
            completionBlock();
        }
    } else {
        CGFloat widthDiff = visibleRect.size.width - rect.size.width;
        CGFloat heightDiff = visibleRect.size.height - rect.size.height;
        CGRect scrollRect = CGRectInset(rect, -widthDiff/2, -heightDiff/2);
        scrollRect.origin.x = MAX(0, MIN(self.worldScrollView.contentSize.width - scrollRect.size.width, scrollRect.origin.x));
        scrollRect.origin.y = MAX(0, MIN(self.worldScrollView.contentSize.height - scrollRect.size.height, scrollRect.origin.y));
        [UIView animateWithDuration:0.3 animations:^{
            self.worldScrollView.bounds = scrollRect;
        } completion:^(BOOL finished) {
            if (completionBlock) {
                completionBlock();
            }
        }];
    }
}

- (NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

//----------------------------------------------------------------------------------
#pragma mark - World

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
    [worldView loadSpritesFromState:self.worldState];
    self.worldView = worldView;
    
    [self.worldScrollView addSubview:worldView];
    self.worldScrollView.contentSize = worldView.frame.size;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detectTap:)];
    tapRecognizer.numberOfTouchesRequired = 1;
    tapRecognizer.numberOfTapsRequired = 1;
    [self.worldView addGestureRecognizer:tapRecognizer];
    tapRecognizer.enabled = NO;
    self.tapRecognizer = tapRecognizer;
}

- (void)detectTap:(UITapGestureRecognizer *)tapRecognizer
{
    CGPoint location = [tapRecognizer locationInView:self.worldView];
    WorldPoint position = [self.worldView gridPositionForTouchLocatoin:location];
    
    if (self.worldState.characterWorldOptions &&
        self.worldState.characterWorldOptions.character.team == CharacterTeam_Player &&
        [self.worldState.characterWorldOptions containsPoint:position])
    {
        [self handleActionSelectionAtPosition:position];
    }
    
    else {
        [self handleObjectSelectionAtPosition:position];
    }
}

- (void)handleActionSelectionAtPosition:(WorldPoint)position
{
    CharacterWorldOptions *options = self.worldState.characterWorldOptions;
    CharacterMovementOption *moveOption = [options moveOptionAtPoint:position];
    if (moveOption) {
        [self handleMoveSelection:moveOption withCompletion:nil];
        return;
    }
    
    CharacterAttackOption *attackOption = [options attackOptionAtPoint:position];
    WorldObject *attackedObject = [self.worldState objectAtPosition:position];
    if (!attackedObject || ![attackedObject isKindOfClass:Character.class]) {
        if (![attackOption.moveOption isEqual:options.selectedMoveOption]) {
            [self handleMoveSelection:attackOption.moveOption withCompletion:nil];
        }
        return;
    }
    
    Character *target = (Character *)attackedObject;
    if (target.team == CharacterTeam_Enemy) {
        WorldPoint currentPosition = options.selectedMoveOption.position;
        int range = WorldPointRangeToPoint(currentPosition, target.position);
        CharacterClass *charClass = options.character.characterClass;
        if (range >= charClass.attackRangeMin && range <= charClass.attackRangeMax) {
            [self presentAttackOption:attackOption onTarget:target];
        }
        
        else {
            [self handleMoveSelection:attackOption.moveOption withCompletion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self presentAttackOption:attackOption onTarget:target];
                });
            }];
        }
    }
}

- (void)presentAttackOption:(CharacterAttackOption *)attack onTarget:(Character *)target
{
    CharacterWorldOptions *options = self.worldState.characterWorldOptions;
    int range = WorldPointRangeToPoint(attack.moveOption.position, attack.position);
    CombatPreview *preview = [[CombatPreview alloc] initWithPlayer:options.character andEnemy:target range:range];
    [self.combatPreview updateWithCombatPreview:preview];
    self.combatPreview.hidden = NO;
}

- (void)performAttackWithCombatPreview:(CombatPreview *)preview
{
    [self cleanupSelection];
    [self.worldView updateGridForState:self.worldState];
    
    CombatModel *combatModel = [CombatModel combatModelFromPreview:preview withFirstAttacker:preview.player];
    [self.worldState applyCombat:combatModel];
    [self.worldView animateCombat:combatModel completion:^(CombatModel *model) {
        [self.worldView updateSpriteForObject:combatModel.playerCharacter active:combatModel.playerCharacter.isActive];
        [self.worldView updateSpriteForObject:combatModel.enemyCharacter active:YES];
        [self doubleCheckActivePlayerCharacters];
    }];
}

- (void)doubleCheckActivePlayerCharacters
{
    for (Character *dude in self.worldState.playerCharacters) {
        if (dude.isActive) {
            if (![self.worldState characterHasActionOptions:dude]) {
                dude.isActive = NO;
                [self.worldView updateSpriteForObject:dude active:NO];
            }
        }
    }
    if (![self.worldState playerHasActiveCharacters]) {
        [self showEndTurnButton];
    }
}

- (void)handleMoveSelection:(CharacterMovementOption *)moveOption withCompletion:(void (^)())completionBlock
{
    CharacterWorldOptions *options = self.worldState.characterWorldOptions;

    // edge case: no available moves, essentially just a deselect
    if (options.moveOptions.count == 1) {
        [self cleanupSelection];
        [self.worldView updateGridForState:self.worldState];
        if (completionBlock) {
            completionBlock();
        }
    }
    
    // chose to commit the selected movement
    else if ([moveOption isEqual:options.selectedMoveOption]) {
        [self cleanupSelection];
        [self.worldView updateGridForState:self.worldState];
        if (completionBlock) {
            completionBlock();
        }
    }
    
    // chose a new move option
    else {
        NSArray *animationPath = moveOption.path;
        WorldPoint moveStart = [[options.selectedMoveOption.path lastObject] worldPointValue];
        if (!WorldPointEqualToPoint(moveStart, options.character.position)) {
            WorldPoint moveEnd = [[moveOption.path lastObject] worldPointValue];
            NSArray *optimalPath = [options pathFromPoint:moveStart toPoint:moveEnd];
            if (optimalPath) {
                animationPath = optimalPath;
            }
        }
        
        self.worldState.characterWorldOptions.selectedMoveOption = moveOption;
        self.worldScrollView.userInteractionEnabled = NO;
        
        [self.worldView animateMovementPath:animationPath withAnnotationPath:moveOption.path forObject:options.character completion:^{
            self.worldScrollView.userInteractionEnabled = YES;
            if (completionBlock) {
                completionBlock();
            }
        }];
    }
}

- (void)handleObjectSelectionAtPosition:(WorldPoint)position
{
    WorldObject *selectedObject = [self.worldState objectAtPosition:position];
    
    // check deselection
    if (self.worldState.selectedObject && (!selectedObject || [selectedObject.key isEqualToString:self.worldState.selectedObject.key])) {
        [self cleanupSelection];
        [self.worldView updateGridForState:self.worldState];
    }
    
    // check new selection
    else if (selectedObject && ![selectedObject.key isEqualToString:self.worldState.selectedObject.key])
    {
        [self cleanupSelection];
        
        self.worldState.selectedObject = selectedObject;
        if ([selectedObject isKindOfClass:Character.class]) {
            Character *dude = (Character *)selectedObject;
            [self.characterInfoView updateForCharacter:dude];
            
            if (dude.isActive) {
                CharacterWorldOptions *options = [[CharacterWorldOptions alloc] initWithCharacter:dude worldState:self.worldState];
                self.worldState.characterWorldOptions = options;
                if (dude.team == CharacterTeam_Player) {
                    [self hideEndTurnButtonAnimated:YES];
                }
            }
        } else {
            self.worldState.characterWorldOptions = nil;
        }
        
        [self.worldView updateGridForState:self.worldState];
    }
}

- (void)cleanupSelection
{
    if (self.worldState.selectedObject) {
        CharacterWorldOptions *options = self.worldState.characterWorldOptions;
        CharacterMovementOption *moveOption = options.selectedMoveOption;
        if (moveOption) {
            Character *character = options.character;
            character.position = moveOption.position;
            character.movesRemaining -= moveOption.path.count-1;
            [self doubleCheckActivePlayerCharacters];
        }
    }
    self.worldState.selectedObject = nil;
    self.worldState.characterWorldOptions = nil;
    [self.characterInfoView updateForCharacter:nil];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.worldView;
}

//----------------------------------------------------------------------------------
#pragma mark - Enemy Turn

- (void)performNextActionFromAI:(EnemyAI *)enemyAI
{
    EnemyAction *action = [enemyAI nextAction];
    if (!action) {
        [self startPlayerTurn];
        return;
    }
    
    if (!action.move) {
        [self performNextActionFromAI:enemyAI];
        return;
    }
    
    self.worldState.selectedObject = action.character;
    [self.worldView updateGridForState:self.worldState];
    
    CGRect pathRect = [self.worldView visibleRectForMovementPath:action.move.path];
    [self scrollToRect:pathRect completion:^{
        [self animateMoveFromAction:action forAI:enemyAI];
    }];
}

- (void)animateMoveFromAction:(EnemyAction *)action forAI:(EnemyAI *)enemyAI
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
        self.worldState.selectedObject = nil;
        [self.worldView updateGridForState:self.worldState];
        
        [self.worldView animateMovementPath:action.move.path forObject:action.character completion:^{
            action.character.position = action.move.position;
            action.character.movesRemaining -= action.move.path.count-1;

            if (action.attack) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                {
                    [self animateAttackFromAction:action forAI:enemyAI];
                });
            } else {
                action.character.isActive = NO;
                [self.worldView updateSpriteForObject:action.character active:NO];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
                {
                    [self performNextActionFromAI:enemyAI];
                });
            }
            
        }];
    });
}

- (void)animateAttackFromAction:(EnemyAction *)action forAI:(EnemyAI *)enemyAI
{
    CharacterAttackOption *attack = action.attack;
    int range = WorldPointRangeToPoint(attack.moveOption.position, attack.position);
    Character *player = (Character *)[self.worldState objectAtPosition:attack.position];
    CombatPreview *preview = [[CombatPreview alloc] initWithPlayer:player andEnemy:action.character range:range];
    CombatModel *combatModel = [CombatModel combatModelFromPreview:preview withFirstAttacker:preview.enemy];
    
    [self.worldState applyCombat:combatModel];
    [self.worldView animateCombat:combatModel completion:^(CombatModel *model) {
        [self.worldView updateSpriteForObject:combatModel.playerCharacter active:YES];
        [self.worldView updateSpriteForObject:combatModel.enemyCharacter active:combatModel.enemyCharacter.isActive];
        [self performNextActionFromAI:enemyAI];
    }];

}

//----------------------------------------------------------------------------------
#pragma mark - Menu

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
    NSString *title = self.worldState.gridLinesEnabled ? @"Hide Lines" : @"Show Lines";
    [linesButton setTitle:title forState:UIControlStateNormal];
    [linesButton addTarget:self action:@selector(touchedGridLinesButton) forControlEvents:UIControlEventTouchUpInside];
    [menuPanel addSubview:linesButton];
    self.gridLinesButton = linesButton;
    
    buttonFrame.origin.y += buttonFrame.size.height;
    UIButton *coordsButton = [[UIButton alloc] initWithFrame:buttonFrame];
    coordsButton.titleLabel.numberOfLines = 0;
    coordsButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    title = self.worldState.gridCoordsEnabled ? @"Hide Coords" : @"Show Coords";
    [coordsButton setTitle:title forState:UIControlStateNormal];
    [coordsButton addTarget:self action:@selector(touchedCoordsButton) forControlEvents:UIControlEventTouchUpInside];
    [menuPanel addSubview:coordsButton];
    self.gridCoordsButton = coordsButton;
    
    buttonFrame.origin.y += buttonFrame.size.height;
    UIButton *menuButton = [[UIButton alloc] initWithFrame:buttonFrame];
    menuButton.titleLabel.numberOfLines = 0;
    menuButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [menuButton setTitle:@"Main Menu" forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(touchedMainMenuButton) forControlEvents:UIControlEventTouchUpInside];
    [menuPanel addSubview:menuButton];
    
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

- (void)touchedMainMenuButton
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

//----------------------------------------------------------------------------------
#pragma mark - End Turn

- (void)setupEndTurnButton
{
    CGFloat shadowOffset = 3;
    CGFloat cornerRadius = 5;
    
    CGRect frame = (CGRect){CGPointZero, 150 + shadowOffset, 50 + shadowOffset};
    frame.origin.x = CGRectGetMaxX(self.view.bounds) - frame.size.width - 5;
    frame.origin.y = CGRectGetMaxY(self.view.bounds) - frame.size.height - 5;
    BlockDrawingView *bgView = [[BlockDrawingView alloc] initWithFrame:frame];
    bgView.backgroundColor = [UIColor clearColor];
    bgView.drawBlock = ^void(CGRect rect) {
        rect.size.width -= shadowOffset;
        rect.size.height -= shadowOffset;
        rect.origin.x += shadowOffset;
        rect.origin.y += shadowOffset;
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
        UIColor *shadowColor = [UIColor colorWithWhite:0 alpha:0.6];
        CGContextSetFillColorWithColor(context, shadowColor.CGColor);
        CGContextBeginPath(context);
        CGContextAddPath(context, shadowPath.CGPath);
        CGContextFillPath(context);
        
        CGContextRestoreGState(context);
    };
    [self.view addSubview:bgView];
    self.endTurnView = bgView;
    
    CGRect buttonFrame = bgView.bounds;
    buttonFrame.size.width -= shadowOffset;
    buttonFrame.size.height -= shadowOffset;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = buttonFrame;
    button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    [button setTitleColor:[UIColor colorWithWhite:1 alpha:0.9] forState:UIControlStateNormal];
    [button setTitle:@"End Turn" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(touchedEndTurnButton) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor colorWithRed:0.1 green:0.2 blue:1.0 alpha:1];
    button.layer.borderColor = [UIColor colorWithRed:0.58 green:0.62 blue:0.94 alpha:1].CGColor;
    button.layer.cornerRadius = cornerRadius;
    button.layer.borderWidth = 2;
    [bgView addSubview:button];
    
    CGRect arrowFrame = (CGRect){CGPointZero, 20, 50};
    arrowFrame.origin.x = CGRectGetMaxX(self.view.bounds) - arrowFrame.size.width;
    arrowFrame.origin.y = CGRectGetMaxY(self.view.bounds) - arrowFrame.size.height - 5;
    BlockDrawingView *arrowView = [[BlockDrawingView alloc] initWithFrame:arrowFrame];
    arrowView.backgroundColor = [UIColor clearColor];
    arrowView.drawBlock = ^void(CGRect rect) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        
        UIColor *borderColor = [UIColor colorWithWhite:0 alpha:0.3f];
        CGContextSetFillColorWithColor(context, borderColor.CGColor);

        CGFloat borderWidth = 2;
        CGRect top = rect;
        top.size.height = borderWidth;
        CGContextFillRect(context, top);
        
        CGRect left = rect;
        left.size.width = borderWidth;
        left.origin.y += borderWidth;
        left.size.height -= borderWidth*2;
        CGContextFillRect(context, left);
        
        CGRect bottom = rect;
        bottom.size.height = borderWidth;
        bottom.origin.y = CGRectGetMaxY(rect) - borderWidth;
        CGContextFillRect(context, bottom);
        
        CGRect inner = rect;
        inner.size.width -= borderWidth;
        inner.origin.x += borderWidth;
        inner.size.height -= borderWidth*2;
        inner.origin.y += borderWidth;
        UIColor *fillColor = [UIColor colorWithWhite:0 alpha:0.6f];
        CGContextSetFillColorWithColor(context, fillColor.CGColor);
        CGContextFillRect(context, inner);
        
        CGContextRestoreGState(context);
    };
    [self.view insertSubview:arrowView belowSubview:bgView];
    self.endTurnArrow = arrowView;
    
    UIButton *arrowButton = [[UIButton alloc] initWithFrame:arrowView.bounds];
    arrowButton.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    arrowButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    arrowButton.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    [arrowButton setImage:[UIImage imageNamed:@"menu-arrow"] forState:UIControlStateNormal];
    [arrowButton addTarget:self action:@selector(showEndTurnButton) forControlEvents:UIControlEventTouchUpInside];
    [arrowView addSubview:arrowButton];
    
    [self hideEndTurnButtonAnimated:NO];
}

- (void)showEndTurnButton
{
    CGAffineTransform inTransorm = CGAffineTransformMakeTranslation(0, 0);
    if (CGAffineTransformEqualToTransform(inTransorm, self.endTurnView.transform)) {
        return;
    }
    
    CGAffineTransform midTransform = CGAffineTransformMakeTranslation(-10, 0);
    CGAffineTransform arrowTransform = CGAffineTransformMakeTranslation(20, 0);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.endTurnView.transform = midTransform;
        self.endTurnArrow.transform = arrowTransform;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.05 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.endTurnView.transform = inTransorm;
        } completion:NULL];
    }];
}

- (void)hideEndTurnButtonAnimated:(BOOL)animated
{
    CGAffineTransform outTransorm = CGAffineTransformMakeTranslation(200, 0);
    if (CGAffineTransformEqualToTransform(outTransorm, self.endTurnView.transform)) {
        return;
    }
    
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            self.endTurnView.transform = outTransorm;
            self.endTurnArrow.transform = CGAffineTransformIdentity;
        }];
    } else {
        self.endTurnView.transform = outTransorm;
        self.endTurnArrow.transform = CGAffineTransformIdentity;
    }
}

- (void)touchedEndTurnButton
{
    [self cleanupSelection];
    [self.worldView updateGridForState:self.worldState];
    
    [self startEnemyTurn];
}

@end
