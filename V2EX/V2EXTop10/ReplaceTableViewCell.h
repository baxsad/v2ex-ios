//
//  ReplaceTableViewCell.h
//  V2EXTop10
//
//  Created by iURCoder on 9/30/15.
//  Copyright © 2015 NYB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReplaceTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *avatar;
@property (nonatomic, weak) IBOutlet UILabel *uName;
@property (nonatomic, weak) IBOutlet UILabel *createdDate;
@property (nonatomic, weak) IBOutlet UILabel *replayContent;

@end
