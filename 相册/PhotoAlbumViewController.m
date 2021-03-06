//
//  PhotoAlbumViewController.m
//  相册
//
//  Created by 胡林 on 2018/6/25.
//  Copyright © 2018年 com.hulin. All rights reserved.
//

#import "PhotoAlbumViewController.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "HLButton.h"
@interface PhotoAlbumViewController (){
    NSInteger num;
    NSInteger coordinates;
    NSString * newTmp;//沙盒路径
    NSMutableArray * deleteArray;//消息
}
#define SCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define SCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)
@property(nonatomic,strong)UIScrollView * PhotoAlbumScroll;
@property(nonatomic,strong)UIImageView * imageView;
@property(nonatomic,strong)UIImageView * imageViewMax;
@property(nonatomic,strong)HLButton* button;
@property(nonatomic,strong)UIButton* deleteButton;
@end

@implementation PhotoAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString * tmp =NSTemporaryDirectory();
    newTmp = [tmp stringByAppendingString:@"/eggDelete.plist"];
    deleteArray = [NSMutableArray array];
    [deleteArray writeToFile:newTmp atomically:YES];
    UIButton * quxiaoButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    quxiaoButton.frame =CGRectMake(300, 20, 50, 20);
    [quxiaoButton setTitle:@"取消" forState:(UIControlStateNormal)];
    [quxiaoButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [quxiaoButton addTarget:self action:@selector(quxiaoButton) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:quxiaoButton];
    
    self.PhotoAlbumScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_HEIGHT-100)];
    [self.view addSubview:self.PhotoAlbumScroll];
    self.imageViewMax = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.imageViewMax.backgroundColor = [UIColor redColor];
    [self.imageViewMax setUserInteractionEnabled:YES];
    self.imageViewMax.hidden =YES;
    [self.imageViewMax addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewMaxAction)]];
    [self.view addSubview: self.imageViewMax];
    NSInteger num = 0;
//
    for (int i =1; i < 8; i++) {
        _button = [HLButton buttonWithType:(UIButtonTypeCustom)];
        _deleteButton = [UIButton buttonWithType:(UIButtonTypeCustom)];

        NSInteger a = i%3;
        if (a == 0) {
            a = 3;
            num++;
        }
        NSLog(@"i =%d  a = %ld num = %ld",i ,(long)a,(long)num);
        if (a == 3) {

            _button.frame = CGRectMake(((a-1) * (SCREEN_WIDTH/3)) +10, (((SCREEN_WIDTH-130)/3) *1.8 * (num-1))+30, (SCREEN_WIDTH-130)/3, ((SCREEN_WIDTH-130)/3) *1.7);
        }else{
            _button.frame =CGRectMake(((a-1) * (SCREEN_WIDTH/3))+10, (((SCREEN_WIDTH-130)/3) *1.8 * (num))+30, (SCREEN_WIDTH-130)/3, ((SCREEN_WIDTH-130)/3) *1.7);
        }
        _deleteButton.frame = CGRectMake(_button.frame.size.width - 25, _button.frame.size.height - 25, 20, 20);
        [self.button addSubview:self.deleteButton];
        UIImage * deleteButtonImage = [UIImage imageNamed:@"boy"];
        [_deleteButton setImage:deleteButtonImage forState:(UIControlStateNormal)];
        _deleteButton.tag = i+200;
        UITapGestureRecognizer * deletetap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteButtonAction:)];
        deletetap.numberOfTapsRequired =1;
        deletetap.numberOfTouchesRequired = 1;
        [_deleteButton addGestureRecognizer:deletetap];

        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonActionClick:)];
        tap.numberOfTapsRequired =1;
        tap.numberOfTouchesRequired = 1;
        [_button addGestureRecognizer:tap];
        _button.tag = i+1000;


        UIImage * buttonImage = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
        [_button setImage:buttonImage forState:(UIControlStateNormal)];

        [self.PhotoAlbumScroll addSubview:_button];
        UILongPressGestureRecognizer * longTap =[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imglongTapClick:)];
        [_button addGestureRecognizer:longTap];
    }

   
}

-(void)imaageViewActionClick:(id)sender{
    UITapGestureRecognizer * singTag =(UITapGestureRecognizer * )sender;
    NSInteger tag =[singTag view].tag;
    NSLog(@"点击了第%ld图",(long)tag);
   
}
-(void)deleteButtonAction:(id)sender{
    UITapGestureRecognizer * singTag =(UITapGestureRecognizer * )sender;
    NSInteger tag =[singTag view].tag;
    NSLog(@"点击了第%ld张图的图标",(long)tag);

    NSMutableArray * arr =[NSMutableArray arrayWithContentsOfFile:newTmp];
    if (arr.count == 0) {
//        [arr addObject:[NSString stringWithFormat:@"%ld",tag]];
        [deleteArray addObject:[NSString stringWithFormat:@"%ld",(long)tag]];
        
    }else{
        for (int i = 0; i < arr.count; i++) {
            [deleteArray addObject:arr[i]];
        }
        [deleteArray addObject:[NSString stringWithFormat:@"%ld",(long)tag]];
        
    }
//    for (NSString *str in arr) {
//        if (![arr containsObject:str]) {
//             [arr addObject:[NSString stringWithFormat:@"%ld",tag]];
//        }
//    }
   
    NSLog(@"arr = %@",arr);
    NSLog(@"tag = %ld",(long)tag);
     NSLog(@"deleteArray = %@",deleteArray);
    
    
        for (int i=1; i < 9; i++) {
            UIButton *btn = (UIButton *)[self.view viewWithTag:tag];
            
            if (tag-200  == i ){
                NSLog(@"coordinates = %ld",(long)tag);
                UIImage * deleteButtonImage = [UIImage imageNamed:@"boy"];
                [btn setImage:deleteButtonImage forState:(UIControlStateNormal)];

            }else{
                NSLog(@" i = %d",i);
                UIImage * deleteButtonImage = [UIImage imageNamed:@"girl"];
                [btn setImage:deleteButtonImage forState:(UIControlStateNormal)];
            
            }
        }
        
    for (NSString * str in arr) {
         UIButton *btn = (UIButton *)[self.view viewWithTag:tag];
        if ([str integerValue] == tag) {
            NSLog(@"str==%@",str);
            UIImage * deleteButtonImage = [UIImage imageNamed:@"boy"];
            [btn setImage:deleteButtonImage forState:(UIControlStateNormal)];
            [deleteArray removeObject:str];
        }
    }
    
    
    NSMutableArray * array = [NSMutableArray array];
    for (NSString *str in deleteArray) {
        if (![array containsObject:str]) {
            [array addObject:str];
        }
    }
    [array writeToFile:newTmp atomically:YES];
    NSLog(@"array ==%@",array);
}
-(void)quxiaoButton{
    for (int i=0; i < 8; i++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:200+i];
        if (200 == i) {
            UIImage * deleteButtonImage = [UIImage imageNamed:@"girl"];
            [btn setImage:deleteButtonImage forState:(UIControlStateNormal)];
        }else{
            UIImage * deleteButtonImage = [UIImage imageNamed:@"boy"];
            [btn setImage:deleteButtonImage forState:(UIControlStateNormal)];
        }
    }
    
}
-(void)buttonActionClick:(id)sender{
    UITapGestureRecognizer * singTag =(UITapGestureRecognizer * )sender;
    NSInteger tag =[singTag view].tag - 1000;
    NSLog(@"单击了第%ld图",(long)tag);
    self.imageViewMax.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",(long)tag]];
    self.imageViewMax.hidden = NO;
}
-(void)imglongTapClick:(UILongPressGestureRecognizer *)sender{
    UITapGestureRecognizer * singTag =(UITapGestureRecognizer * )sender;
    NSInteger tag =[singTag view].tag - 1000;
    NSLog(@"长按了第%ld图",(long)tag);
    
    
}
-(void)imageViewMaxAction{
    self.imageViewMax.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
