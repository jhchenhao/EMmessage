//
//  LinkCell.m
//  EMMessage-demo
//
//  Created by jhtxch on 16/5/15.
//  Copyright © 2016年 jhtxch. All rights reserved.
//

#import "LinkCell.h"

@interface LinkCell ()
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *orderL;
@property (nonatomic, strong) UILabel *desL;
@property (nonatomic, strong) UILabel *priceL;
@property (nonatomic, strong) UIImageView *picImgV;


@end

@implementation LinkCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier model:(id<IMessageModel>)model
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier model:model];
    if (self) {
        self.bubbleView.imageView.hidden = YES;
        self.bubbleView.backgroundImageView.hidden = NO;
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
        [self.bubbleView.backgroundImageView addSubview:_titleL];
        _titleL.text = [model.message.ext objectForKey:@"title"];
//        _titleL.translatesAutoresizingMaskIntoConstraints = NO;
        _titleL.backgroundColor = [UIColor yellowColor];
        
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleL attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.bubbleView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleL attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:200]];
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleL attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.bubbleView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleL attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:100]];
        
        for (NSLayoutConstraint *layout in self.constraints) {
            if (layout.firstItem == self.bubbleView) {
                //                NSLog(@"%@",layout);
                [self removeConstraint:layout];
            }
        }
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bubbleView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_titleL attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bubbleView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_titleL attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        
        if (self.model.isSender) {
            [self updateSendLayoutConstraints];
        } else {
            [self updateRecvLayoutConstraints];
        }
        
        for (NSLayoutConstraint *layout in self.constraints) {
            if (layout.firstItem == self.bubbleView) {
                NSLog(@"%@",layout);
                
            }
        }
        
    }
    return self;
}


- (void)updateSendLayoutConstraints
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bubbleView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.avatarView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-EaseMessageCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bubbleView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.nameLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
}
- (void)updateRecvLayoutConstraints
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bubbleView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.avatarView attribute:NSLayoutAttributeRight multiplier:1.0 constant:EaseMessageCellPadding]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bubbleView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.nameLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
}


@end
