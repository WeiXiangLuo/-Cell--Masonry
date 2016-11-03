//
//  ViewController.m
//  AutoHeightMasonryDemo
//
//  Created by lwx on 2016/11/3.
//  Copyright © 2016年 lwx. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "LWXModel.h"
#import "LWXTableViewCell.h"


//自动计算行高
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"

static NSString *CellID = @"CellIdentifier";

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;//tableView

@property (nonatomic, strong) NSMutableArray *dataSource;//数据源

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.tableView = [UITableView new];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[LWXTableViewCell class] forCellReuseIdentifier:CellID];
    
}



#pragma mark - 获得随机数据
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
        
        int titleTotalLength = (int)[[self titleAll] length];
        int descTotalLength = (int)[[self descAll] length];
        for (NSUInteger i = 0; i < 40; ++i) {
            int titleLength = rand() % titleTotalLength + 15;
            if (titleLength > titleTotalLength - 1) {
                titleLength = titleTotalLength;
            }
            
            LWXModel *model = [[LWXModel alloc] init];
            model.title = [[self titleAll] substringToIndex:titleLength];
            model.uid = (int)i + 1;
            model.isExpand = YES;
            
            int descLength = rand() % descTotalLength + 20;
            if (descLength >= descTotalLength) {
                descLength = descTotalLength;
            }
            model.desc = [[self descAll] substringToIndex:descLength];
            
            [_dataSource addObject:model];
        }
    }
    
    return _dataSource;
}


- (NSString *)titleAll {
    return @"试用黄仪标的HYBMasonryAutoCellHeight框架，我是luoweixiang,我的邮箱是luoweixiang33@163.com。";
}

- (NSString *)descAll {
    return @"HYBMasonryAutoCellHeight是基于Masonry第三方开源库而实现的，如想更深入了解Masonry，可直接到github上的官方文档阅读，或可以到作者的博客中阅读相关文章：http://www.hybblog.com/masonryjie-shao/，如果阅读时有疑问，可直接联系作者（email或者QQ），最直接的方式就是在文章后面留言，作者会在收到反馈后的第一时间迅速查看，并给予相应的回复。欢迎留言，希望我们能成为朋友。";
}



#pragma mark - tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LWXTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID forIndexPath:indexPath];
    
    
    if (indexPath.row < self.dataSource.count) {
        
        LWXModel *model = self.dataSource[indexPath.row];
        cell.model = model;
        cell.expandBlock = ^(BOOL isExpand) {
            model.isExpand = isExpand;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        };
    }
    
    return cell;

}




- (CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    
    if (indexPath.row >= self.dataSource.count) {
        return 0.0f;
    }
    
    LWXModel *model = self.dataSource[indexPath.row];
    NSString *stateKey = nil;
    if (model.isExpand) {
        stateKey = @"expanded";
    }else{
        stateKey = @"unexpanded";
    }
    
    return [LWXTableViewCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
        
        LWXTableViewCell *cell = (LWXTableViewCell *)sourceCell;
        cell.model = model;
    } cache:^NSDictionary *{
        return @{kHYBCacheUniqueKey : [NSString stringWithFormat:@"%d",model.uid],
                 kHYBCacheStateKey : stateKey,
                  // 如果设置为YES，若有缓存，则更新缓存，否则直接计算并缓存
                 kHYBRecalculateForStateKey : @(NO) // 标识不用重新更新
                 };
    }];
    
}























@end
