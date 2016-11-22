//
//  MVCastMemberTableViewCell.m
//  MovieApp
//
//  Created by Clay Jones on 11/21/16.
//  Copyright © 2016 ClayJones. All rights reserved.
//

#import "MVCastMemberTableViewCell.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "MVConstants.h"

@implementation MVCastMemberTableViewCell {
    UIImageView *_profileImageView;
    UILabel *_characterLabel;
    UILabel *_nameLabel;
}

@synthesize castMember = _castMember;

-(void)setCastMember:(MVCastMember *)castMember {
    _castMember = castMember;
    
    [_characterLabel setText: [NSString stringWithFormat:@"as %@", _castMember.character]];
    [_characterLabel sizeToFit];
    
    [_nameLabel setText:_castMember.name];
    [_nameLabel sizeToFit];
    
    NSString *urlString = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w500%@", _castMember.profilePath];
    [_profileImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"missing_cast"]];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        _profileImageView = [[UIImageView alloc] init];
        [_profileImageView setBackgroundColor:[UIColor grayColor]];
        [_profileImageView setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:_profileImageView];
        
        _characterLabel = [[UILabel alloc] init];
        [_characterLabel setFont:[UIFont fontWithName:MV_REGULAR_FONT_NAME size:12.0]];
        [_characterLabel setTextColor:[UIColor lightGrayColor]];
        [self addSubview:_characterLabel];
        
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setFont:[UIFont fontWithName:MV_BOLD_FONT_NAME size:14.0]];
        [_nameLabel setTextColor:[UIColor darkGrayColor]];
        [self addSubview:_nameLabel];
    }
    return self;
}

-(void)layoutSubviews {
    [_profileImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.mas_equalTo(20);
        make.width.height.mas_equalTo(self.frame.size.height * .7);
    }];
    
    [_profileImageView.layer setCornerRadius:self.frame.size.height * .35];
    [_profileImageView.layer setMasksToBounds:YES];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_centerY).with.offset(-3);
        make.left.equalTo(_profileImageView.mas_right).with.offset(20);
    }];
    
    [_characterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_centerY).with.offset(3);
        make.left.equalTo(_nameLabel);
    }];
}

@end
