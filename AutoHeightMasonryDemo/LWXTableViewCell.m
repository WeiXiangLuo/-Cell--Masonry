//
//  LWXTableViewCell.m
//  AutoHeightMasonryDemo
//
//  Created by lwx on 2016/11/3.
//  Copyright © 2016年 lwx. All rights reserved.
//

#import "LWXTableViewCell.h"
#import "Masonry.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"
#import "LWXModel.h"

@interface LWXTableViewCell ()

@property (nonatomic, strong) UILabel *mainLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong)UIButton *button;
@property (nonatomic, assign) BOOL isExpandedNow;

@end


@implementation LWXTableViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //标题Label
        self.mainLabel = [[UILabel alloc] init];
        self.mainLabel.numberOfLines = 0;
        [self.contentView addSubview:self.mainLabel];
        
        [self.mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(20);
            make.right.mas_equalTo(-15);
            make.height.mas_lessThanOrEqualTo(80);
        }];
        
         CGFloat w = [UIScreen mainScreen].bounds.size.width;
        
        // 应该始终要加上这一句
        // 不然在6/6plus上就不准确了
        //自动适应宽度
        self.mainLabel.preferredMaxLayoutWidth = w - 30;
        
        
        //文本Lable
        self.descLabel = [UILabel new];
        [self.contentView addSubview:self.descLabel];
        self.descLabel.numberOfLines = 0;
        //自适应尺寸
        [self.descLabel sizeToFit];
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(self.mainLabel.mas_bottom).offset(15);
        }];
        // 应该始终要加上这一句
        // 不然在6/6plus上就不准确了
        // 原因：cell中的多行UILabel，如果其width不是固定的话（比如屏幕尺寸不同，width不同），要手动设置其preferredMaxLayoutWidth。 因为计算UILabel的intrinsicContentSize需要预先确定其width才行。
        self.descLabel.preferredMaxLayoutWidth = w - 30;
        
        //文本lable的单击手势
        self.descLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(onTap)];
        [self.descLabel addGestureRecognizer:tap];
        
        
        //按钮
        self.button = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.contentView addSubview:self.button];
        [self.button setTitle:@"我是cell的最后一个View" forState:UIControlStateNormal];
        [self.button setBackgroundColor:[UIColor greenColor]];
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(45);
            make.top.mas_equalTo(self.descLabel.mas_bottom).offset(40);
        }];
        
        
        //cell最后一个view的底层的距离
        self.hyb_bottomOffsetToCell = 20;
        // 或者下面的，必须加
        //    self.hyb_lastViewInCell = self.button;
        //    self.hyb_lastViewsInCell = @[self.button];
        self.isExpandedNow = YES;


    }
    return self;
}


#pragma mark - 配置数据
- (void)setModel:(LWXModel *)model {
    if (model != _model) {
        _model = model;
        [self configCellWithModel:model];
    }
}


/**
 内部方法 配置数据的详细方法

 @param model 数据源
 */
- (void)configCellWithModel:(LWXModel *)model {

    self.mainLabel.text = model.title;
    self.descLabel.text = model.desc;
    
    if (model.isExpand != self.isExpandedNow) {
        self.isExpandedNow = model.isExpand;
        
        if (self.isExpandedNow) {
            [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15);
                make.right.mas_equalTo(-15);
                make.top.mas_equalTo(self.mainLabel.mas_bottom).offset(15);
            }];
        } else {
            [self.descLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_lessThanOrEqualTo(60);
            }];
        }
    }
}




- (void)onTap {
    if (self.expandBlock) {
        self.expandBlock(!self.isExpandedNow);
    }
}


@end
