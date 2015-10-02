//
//  HomeViewController.m
//  V2EXTop10
//
//  Created by iURCoder on 9/24/15.
//  Copyright © 2015 NYB. All rights reserved.
//


#import "HomeViewController.h"
#import "ArticleTableViewCell.h"
#import "UIColor+V2Color.h"
#import "UIImageView+WebCache.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "MJRefresh.h"
#import "MJDIYHeader.h"
#import "DetailViewController.h"
#import "LeftMenuViewController.h"
#import "V2DataManager.h"
#import "LISTObject.h"
#import "ChildNodeObject.h"
#import "NODEObject.h"
#import "Reachability.h"
#import "MSGStatusToast.h"

extern NSArray *  __nodeArr;

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,nodeSelectDelegate>
{
    
    /** cell 标题宽度 */
    CGFloat cellTitltWidth;
    
    /** 刷新头 */
    MJDIYHeader *header;
    
    /** 页码 */
    NSInteger page;
    
    /** 父节点code */
    NSString *fatherNodeCode;
    
    /** 子节点code */
    NSString *childNodeCode;
    
    /** 子节点name */
    NSString *childNodeName;
    
    /** 子节点菜单背景view */
    UIView *nodeBGView;
    
    /** 子节点菜单开关按钮 */
    UIButton *childNodeButton;
    
    /** 子节点菜单table */
    UITableView *childNodeTable;
    
    /** 子节点对象数组 */
    NSArray *childNodeArr;
    
    /** 刷新的是否是子节点 */
    BOOL isRequestChildNode;
}

/** tableview */
@property (nonatomic, weak  ) IBOutlet UITableView      * mainTable;

/** headerView */
@property (nonatomic, strong) IBOutlet UIView           * headerView;

/** infoData */
@property (nonatomic, strong) NSMutableArray            * articleDataArray;

@end

@implementation HomeViewController

- (void)viewWillAppear:(BOOL)animated
{
    /** 开启左滑 */
    [self.navigationController.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    /** 禁止左滑 */
    [self.navigationController.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    
}

#pragma mark -init view

- (void)initTable
{

    self.mainTable.delegate = self;
    self.mainTable.dataSource = self;
    self.mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}


- (void)initHeaderButton
{
    
    UIButton *leftButt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 33, 14)] ;
    [leftButt setBackgroundImage:[UIImage imageNamed:@"nav_menu_icon"] forState:UIControlStateNormal];
    [leftButt addTarget:self action:@selector(leftDrawerButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButt];
    self.navigationItem.leftBarButtonItem = leftItem ;
    
}

- (void)initNodeBGView{
    
    nodeBGView                     = [[UIView alloc] init];
    nodeBGView.frame               = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 0);
    nodeBGView.backgroundColor     = [UIColor V2NavBackgroundColor];
    nodeBGView.clipsToBounds       = YES;
    childNodeTable                 = [[UITableView alloc] initWithFrame:nodeBGView.frame style:UITableViewStylePlain];
    childNodeTable.delegate        = self;
    childNodeTable.scrollEnabled   = NO;
    childNodeTable.dataSource      = self;
    UIColor *BGColor               = [UIColor V2NavBackgroundColor];
    childNodeTable.backgroundColor = BGColor;
    childNodeTable.separatorStyle  = UITableViewCellSeparatorStyleSingleLineEtched;
    [nodeBGView addSubview:childNodeTable];
    [self.view addSubview:nodeBGView];
}

#pragma maek  - Get DATA

- (void)loadData{
    [[V2DataManager shareManager] getArticleListWithNodeCode:isRequestChildNode ? childNodeCode : fatherNodeCode
                                                codeName:childNodeName
                                                requestChild:isRequestChildNode
                                                        Page:page
                                                     isCache:YES
                                              isStorageCache:YES
                                             V2RequestPolicy:V2FallUseCache
                                                     Success:^(NSArray *listArray) {
                                                         [self.articleDataArray removeAllObjects];
                                                         [self.articleDataArray addObjectsFromArray:listArray];
                                                         
                                                         if (self.articleDataArray.count != 0) {
                                                             
                                                             [self.mainTable reloadData];
                                                         }
                                                         
                                                         [header endRefreshing];
                                                         [self.mainTable.footer endRefreshing];
                                                         
                                                     }
                                                     failure:^(NSError *error) {
                                                         
                                                         [header endRefreshing];
                                                         [self.mainTable.footer endRefreshing];
                                                         
                                                     }];
}


- (void)viewDidLoad
{
   /** 默认刷新的不是子节点 */
    isRequestChildNode = NO;
    
    /** 页码 */
    page = 1;
    
    /** 默认父节点名字 */
    fatherNodeCode = @"all";
    
    /** 左边菜单遵守协议 */
    LeftMenuViewController *left = (LeftMenuViewController *)self.mm_drawerController.leftDrawerViewController;
    left.delegate = self;
    
    /** 默认父节点对象 */
    NODEObject * node = [__nodeArr objectAtIndex:9];
    
    /** 获取父节点对象的子节点对象数组 */
    childNodeArr = node.childNodeArray;
    
    /** 实例化子节点菜单 */
    [self initNodeBGView];
    
    cellTitltWidth = CGRectGetWidth([UIScreen mainScreen].bounds) - 32;
    
    
    // Nav Menu
    childNodeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    [childNodeButton setTitle:@"全部" forState:UIControlStateNormal];
    [childNodeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    childNodeButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    childNodeButton.tag=0;
    [childNodeButton addTarget:self action:@selector(childButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = childNodeButton;
    
    
    [super viewDidLoad];
    
    [self initTable];
    
    [self initHeaderButton];
   
    /** 初始化数据对象数组 */
    self.articleDataArray = [NSMutableArray array];
    
    
    /** 下拉刷新进此方法 */
    header=[MJDIYHeader headerWithRefreshingBlock:^{
        
        if (![self hasNetWorking]) {
            [[MSGStatusToast shareMSGToast] showError:@"网络连接异常,检查网络连接" autoHide:YES];
            [header endRefreshing];
        }
        page = 1;
        
        /** 请求数据 */
        [self loadData];
        
    }];
    [header placeSubviews];
    self.mainTable.header=header;
    
    /** 开始刷新 */
    [header beginRefreshing];
    
    
    /** 上拉加载 */
    self.mainTable.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (![self hasNetWorking]) {
            [[MSGStatusToast shareMSGToast] showError:@"网络连接异常,检查网络连接" autoHide:YES];
            [self.mainTable.footer endRefreshing];
        }
        if (isRequestChildNode) {
            page += 1;
            [self loadData];
        }else{
            
            [self.mainTable.footer endRefreshing];
        }
    }];
    
    
    
    
    
}


#pragma mark childMenuAction

- (void)childButtonAction:(UIButton *)sender{
    
    
    
    if (sender.tag == 0) {
        /** 刷新子节点数据 */
        [childNodeTable reloadData];
        childNodeTable.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), childNodeArr.count*44);
        [UIView animateWithDuration:0.25 animations:^{
            nodeBGView.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), childNodeArr.count*44);
            
        }];
        sender.tag = 1;
    }else{
        
        [UIView animateWithDuration:0.25
                         animations:^{
                             nodeBGView.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 0);
                         }
                         completion:^(BOOL finished) {
                             childNodeTable.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 0);
                         }];
        sender.tag = 0;
    }
    
    
}

#pragma mark 抽屉效果

-(void)leftDrawerButtonPress:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma mark UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([tableView isEqual:childNodeTable]) {
        return 0;
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if ([tableView isEqual:childNodeTable]) {
        return [UIView new];
    }else{
        self.headerView.frame = [UIScreen mainScreen].bounds;
        return self.headerView;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    if ([tableView isEqual:childNodeTable]) {
        
        return 44;
        
    }else{
        
        LISTObject * news = [self.articleDataArray objectAtIndex:indexPath.row];
        NSString *dataString = news.articleTitle;
        UIFont *dataFont = [UIFont systemFontOfSize:14];
        CGSize titleSize = [dataString boundingRectWithSize:CGSizeMake(cellTitltWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:dataFont} context:nil].size;
        
        return 107 + titleSize.height;
    }
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:childNodeTable]) {
        return childNodeArr.count;
    }else{
        
        return self.articleDataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([tableView isEqual:childNodeTable]) {
        static NSString *cellID = @"node";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.backgroundColor = [UIColor V2NavBackgroundColor];
        }
        
        
        /** 取出对应的子节点对象 */
        ChildNodeObject *childNode = [childNodeArr objectAtIndex: indexPath.row];
        
        cell.textLabel.text = childNode.childNodeName;
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        
        return cell;
        
    }else{
        static NSString *cellID = @"cell";
        ArticleTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            NSArray * cellArray = [[NSBundle mainBundle] loadNibNamed:@"ArticleTableViewCell" owner:self options:nil];
            cell = [cellArray objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.userAvatar.layer.cornerRadius = CGRectGetWidth(cell.userAvatar.frame) * 0.5f;
            cell.userAvatar.layer.masksToBounds = YES;
            cell.frame = [UIScreen mainScreen].bounds;
        }
        
       
        LISTObject * news = [self.articleDataArray objectAtIndex:indexPath.row];
        
        cell.articleTitltLable.text = news.articleTitle;
        cell.createdLable.text = [NSString stringWithFormat:@"%@/%@ 回复",news.createdDate,news.replayCount];
        cell.userName.text = [NSString stringWithFormat:@"@%@",news.userName];
        [cell.userAvatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http:%@",news.userAvatar]] placeholderImage:[UIImage imageNamed:@"avatar_plasehoder"]];
        cell.nodeName.text = news.nodeName;
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([tableView isEqual:childNodeTable]) {
        
        /** 选取子节点的时候重置页码 */
        page = 1;
        
        /** 是否刷新的是子节点 */
        isRequestChildNode = YES;
        
        /** 获取子节点对象 */
        ChildNodeObject *childNode = [childNodeArr objectAtIndex:indexPath.row];
        
        /** 获取子节点code */
        childNodeCode = childNode.childNodeCode;
        
        /** 获取子节点name */
        childNodeName = childNode.childNodeName;
        
        /** 改变title名字 */
        [childNodeButton setTitle:childNode.childNodeName forState:UIControlStateNormal];
        
        /** 关闭子节点菜单 */
        childNodeButton.tag = 1;
        [self childButtonAction:childNodeButton];
        
        /** 判断选区的内容是否需要登录权限 */
        if ([childNodeCode isEqualToString:@"outsourcing"]||[childNodeCode isEqualToString:@"all4all"]||[childNodeCode isEqualToString:@"exchange"]||[childNodeCode isEqualToString:@"free"]||[childNodeCode isEqualToString:@"dn"]||[childNodeCode isEqualToString:@"tuan"]) {
            
            [self.articleDataArray removeAllObjects];
            [self.mainTable reloadData];
            
        }else{
            
            /** 请求数据 */
            [self.mainTable.header beginRefreshing];

        }
        
    }else{
        
        DetailViewController *detailVC = [[DetailViewController alloc] init];
        detailVC.info = [self.articleDataArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }
    
}

#pragma mark father node selected

- (void)nodeSelectAtIndex:(NSString *)code Name:(NSString *)name Index:(NSInteger)index{
    
    /** 选取父节点的时候重置页码 */
    page = 1;
    
    /** 是否刷新了子节点 */
    isRequestChildNode = NO;
    
    /** 父节点code */
    fatherNodeCode = code;

    /** 对应的父节点对象 */
    NODEObject * node = [__nodeArr objectAtIndex:index];
    
    /** 选取父节点的时候取出对应的子节点数组 */
    childNodeArr = node.childNodeArray;

    /** 设置header title */
    if (childNodeArr.count != 0) {
        [childNodeButton setTitle:[NSString stringWithFormat:@"%@ ▽",name] forState:UIControlStateNormal];
    }else{
        [childNodeButton setTitle:name forState:UIControlStateNormal];
    }
    
    /** 关闭抽屉并刷新 */
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        [self.mainTable.header beginRefreshing];
    }];
    
    /** 关闭子节点菜单 */
    childNodeButton.tag = 1;
    [self childButtonAction:childNodeButton];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- ( BOOL )hasNetWorking
{
    
    
    
    
    Reachability *reacha = [Reachability reachabilityWithHostName:@"http://v2ex.com"];
    
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



@end
