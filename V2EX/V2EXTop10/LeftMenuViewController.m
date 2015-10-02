//
//  LeftMenuViewController.m
//  V2EXTop10
//
//  Created by iURCoder on 9/25/15.
//  Copyright © 2015 NYB. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "NODEObject.h"
#import "ChildNodeObject.h"

NSArray *__nodeArr;

@interface LeftMenuViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *nodeTable;
    IBOutlet UIView *headerView;
}

@end



@implementation LeftMenuViewController

- (void)initTable{
 
    nodeTable.delegate = self;
    nodeTable.dataSource = self;
    nodeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)initData{
    
    NODEObject *nodeJS  = [[NODEObject alloc] initWithNodeName:@"技术" NodeCode:@"tect"];
    ChildNodeObject *cn1 = [[ChildNodeObject alloc] initWithChildNodeName:@"程序员" CNode:@"programmer"];
    ChildNodeObject *cn2 = [[ChildNodeObject alloc] initWithChildNodeName:@"Python" CNode:@"python"];
    ChildNodeObject *cn3 = [[ChildNodeObject alloc] initWithChildNodeName:@"iDev" CNode:@"idev"];
    ChildNodeObject *cn4 = [[ChildNodeObject alloc] initWithChildNodeName:@"Android" CNode:@"android"];
    ChildNodeObject *cn5 = [[ChildNodeObject alloc] initWithChildNodeName:@"Linux" CNode:@"linux"];
    ChildNodeObject *cn6 = [[ChildNodeObject alloc] initWithChildNodeName:@"node.js" CNode:@"nodejs"];
    ChildNodeObject *cn7 = [[ChildNodeObject alloc] initWithChildNodeName:@"云计算" CNode:@"cloud"];
    ChildNodeObject *cn8 = [[ChildNodeObject alloc] initWithChildNodeName:@"宽带症候群" CNode:@"bb"];
    NSArray *JSarr = @[cn1,cn2,cn3,cn4,cn5,cn6,cn7,cn8];
    nodeJS.childNodeArray = JSarr;
    
    NODEObject *nodeCY  = [[NODEObject alloc] initWithNodeName:@"创意" NodeCode:@"creative"];
    ChildNodeObject *cy1 = [[ChildNodeObject alloc] initWithChildNodeName:@"分享创造" CNode:@"create"];
    ChildNodeObject *cy2 = [[ChildNodeObject alloc] initWithChildNodeName:@"设计" CNode:@"design"];
    ChildNodeObject *cy3 = [[ChildNodeObject alloc] initWithChildNodeName:@"奇思妙想" CNode:@"ideas"];
    NSArray *CYarr = @[cy1,cy2,cy3];
    nodeCY.childNodeArray = CYarr;
    
    NODEObject *nodeHW  = [[NODEObject alloc] initWithNodeName:@"好玩" NodeCode:@"play"];
    ChildNodeObject *hw1 = [[ChildNodeObject alloc] initWithChildNodeName:@"分享发现" CNode:@"share"];
    ChildNodeObject *hw2 = [[ChildNodeObject alloc] initWithChildNodeName:@"电子游戏" CNode:@"games"];
    ChildNodeObject *hw3 = [[ChildNodeObject alloc] initWithChildNodeName:@"电影" CNode:@"movie"];
    ChildNodeObject *hw4 = [[ChildNodeObject alloc] initWithChildNodeName:@"剧集" CNode:@"tv"];
    ChildNodeObject *hw5 = [[ChildNodeObject alloc] initWithChildNodeName:@"音乐" CNode:@"music"];
    ChildNodeObject *hw6 = [[ChildNodeObject alloc] initWithChildNodeName:@"旅游" CNode:@"travel"];
    ChildNodeObject *hw7 = [[ChildNodeObject alloc] initWithChildNodeName:@"Android" CNode:@"android"];
    ChildNodeObject *hw8 = [[ChildNodeObject alloc] initWithChildNodeName:@"午夜俱乐部" CNode:@"afterdark"];
    NSArray *HWarr = @[hw1,hw2,hw3,hw4,hw5,hw6,hw7,hw8];
    nodeHW.childNodeArray = HWarr;
    
    NODEObject *nodeAP  = [[NODEObject alloc] initWithNodeName:@"Apple" NodeCode:@"apple"];
    ChildNodeObject *AP1 = [[ChildNodeObject alloc] initWithChildNodeName:@"Mac OS X" CNode:@"macosx"];
    ChildNodeObject *AP2 = [[ChildNodeObject alloc] initWithChildNodeName:@"iPhone" CNode:@"iphone"];
    ChildNodeObject *AP3 = [[ChildNodeObject alloc] initWithChildNodeName:@"iPad" CNode:@"ipad"];
    ChildNodeObject *AP4 = [[ChildNodeObject alloc] initWithChildNodeName:@"MBP" CNode:@"mbp"];
    ChildNodeObject *AP5 = [[ChildNodeObject alloc] initWithChildNodeName:@"iMac" CNode:@"imac"];
    ChildNodeObject *AP6 = [[ChildNodeObject alloc] initWithChildNodeName:@"Apple" CNode:@"apple"];
    NSArray *AParr = @[AP1,AP2,AP3,AP4,AP5,AP6];
    nodeAP.childNodeArray = AParr;
    
    NODEObject *nodeKGZ = [[NODEObject alloc] initWithNodeName:@"酷工作" NodeCode:@"jobs"];
    ChildNodeObject *kgz1 = [[ChildNodeObject alloc] initWithChildNodeName:@"酷工作" CNode:@"jobs"];
    ChildNodeObject *kgz2 = [[ChildNodeObject alloc] initWithChildNodeName:@"求职" CNode:@"cv"];
    ChildNodeObject *kgz3 = [[ChildNodeObject alloc] initWithChildNodeName:@"外包" CNode:@"outsourcing"];
    NSArray *KGZarr = @[kgz1,kgz2,kgz3];
    nodeKGZ.childNodeArray = KGZarr;
    
    NODEObject *nodeJY  = [[NODEObject alloc] initWithNodeName:@"交易" NodeCode:@"deals"];
    ChildNodeObject *jy1 = [[ChildNodeObject alloc] initWithChildNodeName:@"二手交易" CNode:@"all4all"];
    ChildNodeObject *jy2 = [[ChildNodeObject alloc] initWithChildNodeName:@"物物交换" CNode:@"exchange"];
    ChildNodeObject *jy3 = [[ChildNodeObject alloc] initWithChildNodeName:@"免费赠送" CNode:@"free"];
    ChildNodeObject *jy4 = [[ChildNodeObject alloc] initWithChildNodeName:@"域名" CNode:@"dn"];
    ChildNodeObject *jy5 = [[ChildNodeObject alloc] initWithChildNodeName:@"团购" CNode:@"tuan"];
    NSArray *JYarr = @[jy1,jy2,jy3,jy4,jy5];
    nodeJY.childNodeArray = JYarr;
    
    NODEObject *nodeCS  = [[NODEObject alloc] initWithNodeName:@"城市" NodeCode:@"city"];
    ChildNodeObject *cs1 = [[ChildNodeObject alloc] initWithChildNodeName:@"北京" CNode:@"beijing"];
    ChildNodeObject *cs2 = [[ChildNodeObject alloc] initWithChildNodeName:@"上海" CNode:@"shanghai"];
    ChildNodeObject *cs3 = [[ChildNodeObject alloc] initWithChildNodeName:@"深圳" CNode:@"shenzhen"];
    ChildNodeObject *cs4 = [[ChildNodeObject alloc] initWithChildNodeName:@"广州" CNode:@"guangzhou"];
    ChildNodeObject *cs5 = [[ChildNodeObject alloc] initWithChildNodeName:@"杭州" CNode:@"hangzhou"];
    ChildNodeObject *cs6 = [[ChildNodeObject alloc] initWithChildNodeName:@"成都" CNode:@"chengdu"];
    ChildNodeObject *cs7 = [[ChildNodeObject alloc] initWithChildNodeName:@"昆明" CNode:@"kunming"];
    ChildNodeObject *cs8 = [[ChildNodeObject alloc] initWithChildNodeName:@"纽约" CNode:@"nyc"];
    ChildNodeObject *cs9 = [[ChildNodeObject alloc] initWithChildNodeName:@"洛杉矶" CNode:@"la"];
    NSArray *CSarr = @[cs1,cs2,cs3,cs4,cs5,cs6,cs7,cs8,cs9];
    nodeCS.childNodeArray = CSarr;
    
    NODEObject *nodeWD  = [[NODEObject alloc] initWithNodeName:@"问与答" NodeCode:@"qna"];
    ChildNodeObject *wd1 = [[ChildNodeObject alloc] initWithChildNodeName:@"问与答" CNode:@"qna"];
    NSArray *WDarr = @[wd1];
    nodeWD.childNodeArray = WDarr;
    
    
    NODEObject *nodeHOT = [[NODEObject alloc] initWithNodeName:@"最热" NodeCode:@"hot"];
    nodeHOT.childNodeArray = [NSArray new];
    
    NODEObject *nodeALL = [[NODEObject alloc] initWithNodeName:@"全部" NodeCode:@"all"];
    nodeALL.childNodeArray = [NSArray new];
    
    NODEObject *nodeR2  = [[NODEObject alloc] initWithNodeName:@"R2" NodeCode:@"r2"];
    nodeR2.childNodeArray = [NSArray new];
    
    __nodeArr = @[nodeJS,nodeCY,nodeHW,nodeAP,nodeKGZ,nodeJY,nodeCS,nodeWD,nodeHOT,nodeALL,nodeR2];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableView

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 64;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return __nodeArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = nodeTable.backgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NODEObject *node = [__nodeArr objectAtIndex:indexPath.row];
    cell.textLabel.text = node.nodeName;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NODEObject *node = [__nodeArr objectAtIndex:indexPath.row];
    [self.delegate nodeSelectAtIndex:node.nodeCode Name:node.nodeName Index:indexPath.row];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
