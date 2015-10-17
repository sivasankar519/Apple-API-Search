//
//  DataTableViewCell.m
//  AppleSearchAPI
//
//  Created by SIVASANKAR DEVABATHINI on 10/17/15.
//  Copyright (c) 2015 SIVASANKAR DEVABATHINI. All rights reserved.
//

#import "DataTableViewCell.h"
#import "DataManager.h"
@implementation DataTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setUpTableCell{
    [[DataManager sharedInstance] loadURLRequestWithURLString:self.imageURLString completionHandler:^(NSData *data) {
        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = [UIImage imageWithData:data];
                 [self setNeedsLayout];
            });
        }
    }];
    
}
@end
