//
//  DetailViewController.m
//  V2EXTop10
//
//  Created by iURCoder on 9/25/15.
//  Copyright © 2015 NYB. All rights reserved.
//

#import "DetailViewController.h"
#import "LISTObject.h"
#import "ReplaceObject.h"
#import "UIImageView+WebCache.h"
#import "ASIFormDataRequest.h"
#import "ASIDownloadCache.h"
#import "Reachability.h"
#import "SBJsonParser.h"
#import "V2DataManager.h"
#import "ReplaceTableViewCell.h"

@interface DetailViewController ()<ASIHTTPRequestDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    IBOutlet UITableView *detailTable;
    
    UIView      *headerView;
    
    UILabel     *artTitle;
    
    UIImageView *userAvatar;
    
    UILabel     *userName;
    
    UILabel     *replaceCount;
    
    UILabel     *nodeName;
    
    UILabel     *timeLable;
    
    UILabel     *bottomLine;
    
    NSString    *content;
    
    UITextView  *articleLable;
    
    NSArray     *replayDataArray;
    
    CGFloat     cellContentWith;
}
@end

@implementation DetailViewController

- (void)initTable{
    
    detailTable.delegate = self;
    detailTable.dataSource = self;
    
    headerView.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), bottomLine.frame.origin.y+2);
    headerView.backgroundColor = [UIColor whiteColor];

    
    
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *leftButt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)] ;
    [leftButt setBackgroundImage:[UIImage imageNamed:@"circle-left"] forState:UIControlStateNormal];
    [leftButt addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButt];
    self.navigationItem.leftBarButtonItem = leftItem ;
    
    
    cellContentWith = [UIScreen mainScreen].bounds.size.width - 69;
    
    self.title = @"主题内容";
    
    headerView = [[UIView alloc] init];
    headerView.clipsToBounds = YES;
    
    NSString *dataString   = self.info.articleTitle;
    UIFont *dataFont       = [UIFont systemFontOfSize:14];
    CGSize titleSize       = [dataString boundingRectWithSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds)-54, 400) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:dataFont} context:nil].size;
    
    artTitle               = [[UILabel alloc] init];
    artTitle.textColor     = [UIColor colorWithRed:79.0/255.0 green:79.0/255.0 blue:79.0/255.0 alpha:1];
    artTitle.font          = dataFont;
    artTitle.numberOfLines = 0;
    artTitle.frame         = CGRectMake(8, 10, titleSize.width, titleSize.height);
    artTitle.text          = self.info.articleTitle;
    [headerView addSubview:artTitle];
   
    userAvatar                      = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds)-38, 8, 30, 30)];
    userAvatar.backgroundColor      = [UIColor clearColor];
    userAvatar.layer.cornerRadius   = 3;
    userAvatar.layer.masksToBounds  = YES;
    [userAvatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http:%@",self.info.userAvatar]] placeholderImage:[UIImage imageNamed:@"avatar_plasehoder"]];
    [headerView addSubview:userAvatar];
    
    
    CGFloat uTagX   = artTitle.frame.size.height<17?artTitle.frame.size.height+30:artTitle.frame.size.height+13;
    UILabel *uTag   = [[UILabel alloc] initWithFrame:CGRectMake(8, uTagX, 20, 20)];
    uTag.text       = @"By";
    uTag.font       = [UIFont systemFontOfSize:13];
    uTag.textColor  = [UIColor grayColor];
    [headerView addSubview:uTag];
    
    userName = [[UILabel alloc] init];
    UIFont *nameFont = [UIFont boldSystemFontOfSize:12];
    CGSize nameSize = [self.info.userName boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:nameFont} context:nil].size;
    userName.font = nameFont;
    userName.numberOfLines = 0;
    userName.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1];
    userName.frame = CGRectMake(28, uTag.frame.origin.y, nameSize.width, 20);
    userName.text = self.info.userName;
    [headerView addSubview:userName];
    
    
    replaceCount = [[UILabel alloc] init];
    UIFont *countFont = [UIFont systemFontOfSize:13];
    CGSize countSize = [[NSString stringWithFormat:@"%@ 回复",self.info.replayCount] boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:countFont} context:nil].size;
    replaceCount.font = countFont;
    replaceCount.numberOfLines = 0;
    replaceCount.textColor = [UIColor grayColor];
    replaceCount.frame = CGRectMake(userName.frame.origin.x+userName.frame.size.width+8, uTag.frame.origin.y, countSize.width, 20);
    replaceCount.text = [NSString stringWithFormat:@"%@ 回复",self.info.replayCount];
    [headerView addSubview:replaceCount];
    
    
    nodeName = [[UILabel alloc] init];
    UIFont *nodeFont = [UIFont systemFontOfSize:13];
    CGSize nodeSize = [self.info.nodeName boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:nodeFont} context:nil].size;
    nodeName.font = nameFont;
    nodeName.numberOfLines = 0;
    nodeName.textColor = [UIColor whiteColor];
    nodeName.backgroundColor = [UIColor lightGrayColor];
    nodeName.textAlignment = NSTextAlignmentCenter;
    nodeName.layer.cornerRadius = 3;
    nodeName.layer.masksToBounds = YES;
    nodeName.frame = CGRectMake(replaceCount.frame.origin.x+replaceCount.frame.size.width+8, uTag.frame.origin.y, nodeSize.width+4, 20);
    nodeName.text = self.info.nodeName;
    [headerView addSubview:nodeName];
    
    timeLable = [[UILabel alloc] init];
    
    bottomLine = [[UILabel alloc] init];
    bottomLine.frame = CGRectMake(8, uTag.frame.origin.y+26, CGRectGetWidth([UIScreen mainScreen].bounds)-16, 0.5);
    bottomLine.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1];
    [headerView addSubview:bottomLine];
    
    
    NSArray *artUrlArr = [self.info.replayUrl componentsSeparatedByString:@"#"];
    NSArray *artIDArr = [artUrlArr[0] componentsSeparatedByString:@"/t/"];

    
    
    articleLable = [[UITextView alloc] init];
    
    [headerView addSubview:articleLable];
    
    
    [self initTable];
    
    [[V2DataManager shareManager] getArticleReplayListWithPID:[artIDArr objectAtIndex:1]
                                                      Success:^(NSArray *listArray) {
                                                          
                                                          replayDataArray = listArray;
                                                          [detailTable reloadData];
                                                          
                                                      }
                                                      failure:^(NSError *error) {
                                                          
                                                          NSLog(@"error");
                                                          
                                                      }];
    
    [[V2DataManager shareManager] getArticleContentWithPID:[artIDArr objectAtIndex:1]
                                                   Success:^(NSArray *contentArr) {
                                                       
                                                       
                                                       content = contentArr[0];
                                                       
                                                       UIFont *countFont = [UIFont systemFontOfSize:14];
                                                       CGSize countSize = [content boundingRectWithSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds)-16, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:countFont} context:nil].size;
                                                       articleLable.font = countFont;
                                                       articleLable.editable = NO;
                                                       articleLable.scrollEnabled = NO;
                                                       articleLable.textColor = [UIColor grayColor];
                                                       articleLable.frame = CGRectMake(8, userName.frame.origin.y+33, CGRectGetWidth([UIScreen mainScreen].bounds)-16, countSize.height+40);
                                                       articleLable.text = content;
                                                       headerView.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), articleLable.frame.origin.y+articleLable.frame.size.height);
                                                       
                                                       NSString *createdTime =contentArr[1];
                                                       
                                                       UIFont *timeFont = [UIFont systemFontOfSize:13];
                                                       CGSize timeSize = [createdTime boundingRectWithSize:CGSizeMake(350, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:timeFont} context:nil].size;
                                                       timeLable.font = timeFont;
                                                       timeLable.numberOfLines = 0;
                                                       
                                                       timeLable.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1];
                                                       timeLable.frame = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds)-timeSize.width-8, nodeName.frame.origin.y, timeSize.width, 20);
                                                       timeLable.text = createdTime;
                                                       [headerView addSubview:timeLable];
                                                       
                                                       
                                                       
                                                       [detailTable reloadData];
                                                       
                                                       
                                                       
                                                   }
                                                   failure:^(NSError *error) {
                                                       
                                                       // error
                                                       
                                                   }];
}



#pragma mark ASIHttpRequestDelegate




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ReplaceObject *obj = [replayDataArray objectAtIndex:indexPath.row];
    UIFont *countFont  = [UIFont systemFontOfSize:14];
    CGSize countSize   = [obj.replayContent boundingRectWithSize:CGSizeMake(cellContentWith, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:countFont} context:nil].size;
    
    return countSize.height + 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return headerView.frame.size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return replayDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    ReplaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        NSArray *cellArr = [[NSBundle mainBundle] loadNibNamed:@"ReplaceTableViewCell" owner:self options:nil];
        cell = [cellArr objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    ReplaceObject *replay = [replayDataArray objectAtIndex:indexPath.row];
    
    cell.uName.text = [NSString stringWithFormat:@"@%@",replay.memberName];
    cell.createdDate.text = [self timesTamp:replay.replayDate];
    
    UIFont *countFont = [UIFont systemFontOfSize:14];
    CGSize countSize = [replay.replayContent boundingRectWithSize:CGSizeMake(cellContentWith, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:countFont} context:nil].size;
    UILabel *contentLable = [[UILabel alloc] initWithFrame:CGRectMake(58, 40, cellContentWith-8, countSize.height)];
    contentLable.font = [UIFont systemFontOfSize:14];
    contentLable.text = replay.replayContent;
    contentLable.numberOfLines = 0;
    contentLable.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1];
    [cell.contentView addSubview:contentLable];
    
    cell.avatar.layer.cornerRadius = 3;
    cell.avatar.layer.masksToBounds = YES;
    [cell.avatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http:%@",replay.memberAvatar]] placeholderImage:[UIImage imageNamed:@"avatar_plasehoder"]];
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - check networking

- ( BOOL )hasNetWorking
{
    
    
    
    
    Reachability *reacha = [Reachability reachabilityWithHostName:@"https://v2ex.com"];
    
    switch (reacha.currentReachabilityStatus) {
        case kNotReachable:
        {
            return NO;
        }
            break;
        case kReachableViaWiFi:
        {
            return YES;
        }
            break;
        case kReachableViaWWAN:
        {
            return YES;
        }
            break;
            
        default:
            return YES;
            break;
    }
    
    
    
    
    
}

#pragma mark 时间转换

-(NSString *)timesTamp:(NSString *)time
{
    
    NSString *time1970=[NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    long nowDate=[time1970 longLongValue];
    long YDate=[time longLongValue];
    
    
    NSDateFormatter *formeter=[[NSDateFormatter alloc] init];
    [formeter setDateFormat:@"MM-dd HH:mm:ss"];
    
    
    int cha=(int)(nowDate-YDate);
    
    if (cha<60) {
        return @"刚刚";
    }else if(cha<60*60){
        NSString *str=[NSString stringWithFormat:@"%i分钟前",cha/60];
        return str;
    }else if(cha<60*60*24){
        NSString *str=[NSString stringWithFormat:@"%i小时前",cha/(60*60)];
        return str;
    }else if(cha<60*60*24*3){
        NSString *str=[NSString stringWithFormat:@"%i天前",cha/(60*60*24)];
        return str;
    }else{
        NSDate *date=[NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
        NSString *str=[formeter stringFromDate:date];
        return str;
    }
    
    return [NSString stringWithFormat:@"%i",cha];
}

@end
