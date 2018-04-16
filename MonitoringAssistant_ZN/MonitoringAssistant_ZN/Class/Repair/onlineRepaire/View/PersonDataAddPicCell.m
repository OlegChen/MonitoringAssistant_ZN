//
//  PersonDataAddPicCell.m
//  YunDiPiano_Teacher
//
//  Created by apple on 2017/11/9.
//  Copyright © 2017年 Chen. All rights reserved.
//

#define kCCellIdentifier_TweetSendImage @"personDataAddPicCollectionCell"


#import "PersonDataAddPicCell.h"

//#import "TweetSendImagesCell.h"
//#import "personDataAddPicCollectionCell.h"
#import "personDataAddPicCollectionCell.h"
#import "UICustomCollectionView.h"
//#import "MJPhotoBrowser.h"

@interface PersonDataAddPicCell ()

@property (strong, nonatomic) NSArray *curTweet;
@property (nonatomic,assign) BOOL isLoading;

@property (strong, nonatomic) UICustomCollectionView *mediaView;
@property (strong, nonatomic) NSMutableDictionary *imageViewsDict;

//@property (nonatomic ,weak) UILabel *tip;

@end


@implementation PersonDataAddPicCell

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        // Initialization code
        if (!self.mediaView) {
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            self.mediaView = [[UICustomCollectionView alloc] initWithFrame:CGRectMake(0, 43, [UIScreen mainScreen].bounds.size.width, Cell_Height) collectionViewLayout:layout];
            self.mediaView.scrollEnabled = NO;
            [self.mediaView setBackgroundView:nil];
            [self.mediaView setBackgroundColor:[UIColor whiteColor]];
            [self.mediaView registerClass:[personDataAddPicCollectionCell class] forCellWithReuseIdentifier:personDataAddPicCollectionCell_id];
            self.mediaView.dataSource = self;
            self.mediaView.delegate = self;
            [self addSubview:self.mediaView];
        }
        if (!_imageViewsDict) {
            _imageViewsDict = [[NSMutableDictionary alloc] init];
        }
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
       

        
        
    }
    return self;
}

//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//
//
//
//
//    }
//    return self;
//}
//- (void)setCurTweet:(NSArray *)curTweet{
//    if (_curTweet != curTweet) {
//        _curTweet = curTweet;
//    }
//    [self.mediaView setHeight:[PersonDataAddPicCell cellHeightWithObj:_curTweet.count] - 35];
//    [_mediaView reloadData];
//}

- (void)setDataArray:(NSArray *)array isLoading:(BOOL)isLoading{
    
    self.isLoading = isLoading;
    
    if (self.curTweet != array) {
        self.curTweet = array;
    }
    self.mediaView.frame = CGRectMake(0, 43, [UIScreen mainScreen].bounds.size.width, [PersonDataAddPicCell cellHeightWithObj:_curTweet.count] - 35);
//    [self.mediaView setHeight:[PersonDataAddPicCell cellHeightWithObj:_curTweet.count] - 35];
    [_mediaView reloadData];
    
}

- (void)awakeFromNib
{
    // Initialization code
}



+ (CGFloat)cellHeightWithObj:(NSInteger)obj{
    CGFloat cellHeight = 0;
    //    if (obj > 0) {
    NSInteger row;
    if (obj <= 0) {
        row = 1;
    }else{
        row = ceilf((float)(obj +1)/3.0);
    }
    cellHeight = ([personDataAddPicCollectionCell ccellSize].height +10) *row;
    //    }
    return cellHeight + 43 + 15 /*顶部 title*/;
}

#pragma mark Collection M
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger num = _curTweet.count;
    return num < 6? num+ 1: num;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    
    personDataAddPicCollectionCell *ccell = [collectionView dequeueReusableCellWithReuseIdentifier:kCCellIdentifier_TweetSendImage forIndexPath:indexPath];
    if (indexPath.row < _curTweet.count) {
        
        ccell.curTweetImg = _curTweet[indexPath.row];
        if (self.isLoading == YES && indexPath.row == _curTweet.count - 1) {
            
            [ccell startAnimation];
        }
        
    }else{
        ccell.curTweetImg = nil;
    }
    ccell.deleteTweetImageBlock = ^(UIImage *toDelete){
        if (weakSelf.deleteTweetImageBlock) {
            weakSelf.deleteTweetImageBlock(indexPath.row);
        }
    };
    [_imageViewsDict setObject:ccell.imgView forKey:indexPath];
    return ccell;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    //    self.tip.frame = CGRectMake(15, self.height - 30, SCREEN_WIDTH - 15, 30);
    
//    [self.tip mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.right.equalTo(self.contentView).offset(-15);
//        make.centerY.equalTo(self.contentView.mas_top).offset(17.5);
//    }];
    
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [personDataAddPicCollectionCell ccellSize];
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 40, 0, 40);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _curTweet.count) {
        if (_addPicturesBlock) {
            _addPicturesBlock();
        }
    }else{
        
        /*
        //        显示大图
        int count = (int)_curTweet.count;
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i<count; i++) {
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.url = [NSURL URLWithString:_curTweet[i]]; // 图片路径
            [photos addObject:photo];
        }
        // 2.显示相册
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = indexPath.row; // 弹出相册时显示的第一张图片是？
        browser.photos = photos; // 设置所有的图片
        [browser show];
        */
        
    }
}


@end
