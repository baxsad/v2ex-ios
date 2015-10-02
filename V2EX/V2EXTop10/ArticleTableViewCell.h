//
//  ArticleTableViewCell.h
//  V2EXTop10
//
//  Created by iURCoder on 9/24/15.
//  Copyright © 2015 NYB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleTableViewCell : UITableViewCell

@property (nonatomic , weak) IBOutlet UIImageView *userAvatar;

@property (nonatomic , weak) IBOutlet UILabel *articleTitltLable;

@property (nonatomic , strong) IBOutlet UILabel *createdLable;

@property (nonatomic , strong) IBOutlet UILabel *userName;

@property (nonatomic , strong) IBOutlet UILabel *nodeName;
@end
