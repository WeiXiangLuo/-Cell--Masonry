//
//  LWXTableViewCell.h
//  AutoHeightMasonryDemo
//
//  Created by lwx on 2016/11/3.
//  Copyright © 2016年 lwx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LWXModel;

typedef void(^LWXHandleBlock)(BOOL isExpand);
@interface LWXTableViewCell : UITableViewCell

@property (nonatomic, copy) LWXHandleBlock expandBlock;



@property (nonatomic, strong) LWXModel *model;

@end
