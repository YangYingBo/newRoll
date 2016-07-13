//
//  ViewController.m
//  NewRoll
//
//  Created by 求罩 on 15/9/30.
//  Copyright (c) 2015年 网易新闻滚动. All rights reserved.
//



#import "NewRollViewController.h"
#import "NewRollLabel.h"
#import "NewRollTableViewController.h"

@interface NewRollViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *topLabelScrollView;
@property (nonatomic,strong) UIScrollView *bigScrollView;
@property (nonatomic,strong) NSMutableArray *listArray;
@property (nonatomic,strong) NewRollLabel *myNewRollLabel;
@property (nonatomic,strong) NewRollTableViewController *myNewRollTabView;



@end

@implementation NewRollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"新闻";
    self.navigationController.navigationBar.translucent=NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.listArray = [[NSMutableArray alloc] initWithObjects:@"头条",@"NBA",@"手机",@"移动互联",@"娱乐",@"时尚",@"电影",@"科技", nil];
    
    [self initTopLabelScrollView];
    [self initBigScrollView];
    [self addNewRollLabel];
    [self addNewRollTabView];
    
    UIViewController *vc = [self.childViewControllers firstObject];
    vc.view.frame = self.bigScrollView.bounds;
    [self.bigScrollView addSubview:vc.view];
    
    NewRollLabel *newTitleLabel = [self.topLabelScrollView.subviews firstObject];
    newTitleLabel.scale = 1;
    
    
    
}
#pragma mark ====== 添加tabView到下面的bigScrollView
- (void)addNewRollTabView
{
    for (NSInteger i = 0; i < _listArray.count; i ++) {
        
        _myNewRollTabView = [[NewRollTableViewController alloc] initWithStyle:UITableViewStylePlain];
        _myNewRollTabView.indexNumber = 1;
        [self addChildViewController:_myNewRollTabView];
    }
    
    [_bigScrollView setContentSize:CGSizeMake(self.view.frame.size.width * _listArray.count, 0)];
}
#pragma mark ======= 添加label到顶部scrollView
- (void)addNewRollLabel
{
    NSLog(@"ssscaSCC     %lu",(unsigned long)self.listArray.count);
    
    for (NSInteger i= 0; i < self.listArray.count; i ++) {
        
        _myNewRollLabel = [[NewRollLabel alloc] initWithFrame:CGRectMake(70 * i, 0, 80, 40)];
        _myNewRollLabel.scale = 0.0;
        _myNewRollLabel.tag = i + 100;
        _myNewRollLabel.text = _listArray[i];
        _myNewRollLabel.userInteractionEnabled = YES;
        [_myNewRollLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToMyNewRollLabel:)]];
        [_topLabelScrollView addSubview:_myNewRollLabel];
    }
    [_topLabelScrollView setContentSize:CGSizeMake(70 * _listArray.count, 0)];
    
}

- (void)clickToMyNewRollLabel:(UITapGestureRecognizer *)tap
{
//    for (NSInteger i = 0; i < self.listArray.count; i ++) {
//        
//        NewRollLabel *scaleLabel = (NewRollLabel *)[_topLabelScrollView viewWithTag:i + 100];
//        scaleLabel.scale = 0;
//    }
    NewRollLabel *rollLabel = (NewRollLabel *)tap.view;
    rollLabel.scale = 1;
    CGFloat x = (rollLabel.tag - 100) * _bigScrollView.frame.size.width;
    NSLog(@"%f",x);
    [_bigScrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}


#pragma mark ===== 初始化顶部scrollView
- (void)initTopLabelScrollView
{
    self.topLabelScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
//    self.topLabelScrollView.backgroundColor = [UIColor redColor];
    self.topLabelScrollView.showsHorizontalScrollIndicator = NO;
    self.topLabelScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.topLabelScrollView];
    
}

#pragma mark ======= 初始化bigScrollView
- (void)initBigScrollView
{
    self.bigScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topLabelScrollView.frame), self.view.frame.size.width, self.view.frame.size.height - _topLabelScrollView.frame.size.height - 64 - 49)];
    self.bigScrollView.pagingEnabled = YES;
    self.bigScrollView.showsVerticalScrollIndicator = NO;
    self.bigScrollView.showsHorizontalScrollIndicator = NO;
    self.bigScrollView.delegate = self;
    [self.view addSubview:self.bigScrollView];
}


#pragma mark =======   bigScrollView的代理方法
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSLog(@"%s",__func__);
    NSLog(@"%f",scrollView.contentOffset.x);
    
//    for (NSInteger i = 0; i < self.listArray.count; i ++) {
//        
//        NewRollLabel *scaleLabel = (NewRollLabel *)[_topLabelScrollView viewWithTag:i + 100];
//        scaleLabel.scale = 0;
//    }
    
    NSInteger index = scrollView.contentOffset.x/scrollView.frame.size.width;
    
    //枚举对象使用  相当于for...in... idx相当于便利到的下标 obj相当于便利到的对象
    [self.topLabelScrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx != index) {
            NewRollLabel *temlabel = self.topLabelScrollView.subviews[idx];
            temlabel.scale = 0.0;
        }
        else
        {
            NSLog(@"当前表里到的对象   %@",obj);
        }
    }];
    
    NewRollLabel *indexLabel = (NewRollLabel *)_topLabelScrollView.subviews[index];
    indexLabel.scale = 1;
    CGFloat offset = indexLabel.center.x - self.topLabelScrollView.frame.size.width * 0.5;
    // topLabelScrollView滑动的最大偏移量
    CGFloat offsetMax = self.topLabelScrollView.contentSize.width - self.topLabelScrollView.frame.size.width;
    
    NSLog(@"偏移量     %f    %f",offset,offsetMax);
    if (offset < 0) {//offset小于零说明上面的label移动没有超过中间的位置 topLabelScrollView就没有必要移动
        
        offset = 0.0;
    }
    else if (offset > offsetMax)
    {
        offset = offsetMax;
    }
    
//    NSLog(@"偏移量     %f    %f",offset,offsetMax);
    CGPoint offPoint = CGPointMake(offset, 0);
    [_topLabelScrollView setContentOffset:offPoint animated:YES];
    
    NewRollTableViewController *newTabView = self.childViewControllers[index];
    newTabView.view.frame = scrollView.bounds;
    newTabView.indexNumber = index + 1;
    [self.bigScrollView addSubview:newTabView.view];
    
}
/*结束减速*/
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"%s",__func__);
    NSLog(@"%f",scrollView.contentOffset.x);
    [self scrollViewDidEndScrollingAnimation:scrollView];
}
/*结束拖拽*/
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"%s",__func__);
    NSLog(@"%f",scrollView.contentOffset.x);
}
/*将要开始减速*/
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"%s",__func__);
    NSLog(@"%f",scrollView.contentOffset.x);
}
/*将要开始拖拽*/
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"%s",__func__);
    NSLog(@"%f",scrollView.contentOffset.x);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
