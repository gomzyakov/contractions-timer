//
//  SettingsCell.m
//  Contractions
//
//  Created by Alexander Gomzyakov on 20.04.14.
//  Copyright (c) 2014 Alexander Gomzyakov. All rights reserved.
//

#import "SettingsCell.h"

@interface SettingsCell ()

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *labelTitle;

@end

@implementation SettingsCell

- (id)initWithText:(NSString *)text iconNamed:(NSString *)iconName reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self __makeView];

        UIImage *icon = [UIImage imageNamed:iconName];
        self.iconImageView.image = icon;

        self.labelTitle.text = text;
    }
    return self;
}

- (void)awakeFromNib
{
	[super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Make View

- (void)__makeView
{
    [self __createIconView];
    [self __createTitleLabel];

    [self addConstraints];
}

- (void)__createIconView
{
    UIImageView *photoView = [[UIImageView alloc] init];
    photoView.contentMode = UIViewContentModeScaleAspectFit;

    photoView.translatesAutoresizingMaskIntoConstraints = NO;

    self.iconImageView = photoView;
    [self.contentView addSubview:self.iconImageView];
}

- (void)__createTitleLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor blackColor];
    label.font      = self.textLabel.font;

    label.translatesAutoresizingMaskIntoConstraints = NO;

    self.labelTitle = label;
    [self.contentView addSubview:self.labelTitle];
}

#pragma mark - Constraints

- (void)addConstraints
{
    [self __constraintIconView];
    [self __constraintTextLabel];
}

- (void)__constraintIconView
{
    const CGFloat kOffset = 8.0f;

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.iconImageView
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.contentView
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1.0f
                                                      constant:2*kOffset]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.iconImageView
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.contentView
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0f
                                                      constant:0.0]];

    const CGFloat kIconSize = 24.0;

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.iconImageView
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0f
                                                      constant:kIconSize]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.iconImageView
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0f
                                                      constant:kIconSize]];
}

- (void)__constraintTextLabel
{
    const CGFloat kOffset = 8.0f;

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.labelTitle
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.iconImageView
                                                     attribute:NSLayoutAttributeTrailing
                                                    multiplier:1.0f
                                                      constant:1.5*kOffset]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.labelTitle
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.contentView
                                                     attribute:NSLayoutAttributeTrailing
                                                    multiplier:1.0f
                                                      constant:-kOffset]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.labelTitle
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.contentView
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0f
                                                      constant:0.0]];
}

@end
