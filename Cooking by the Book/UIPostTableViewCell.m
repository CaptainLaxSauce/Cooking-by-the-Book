//
//  UIPostTableViewCell.m
//  Cooking by the Book
//
//  Created by Jack Smith on 3/5/17.
//  Copyright © 2017 EthanJack. All rights reserved.
//

#import "UIPostTableViewCell.h"

@implementation UIPostTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        CGSize size = self.contentView.frame.size;
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(size.width / 3, size.height / 3, size.width / 3, size.height / 3)];
        [self.contentView addSubview: self.titleLabel];
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
