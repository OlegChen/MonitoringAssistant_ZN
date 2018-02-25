//
//  CustomMapAnnotationView.m
//  YunDi_Student
//
//  Created by apple on 2018/1/24.
//  Copyright © 2018年 Fengyun Diyin Technologies (Beijing) Co., Ltd. All rights reserved.
//

#import "CustomMapAnnotationView.h"
#import "Masonry.h"

#define kWidth  50.f
#define kHeight 60.f

#define kHoriMargin 5.f
#define kVertMargin 5.f

#define kPortraitWidth  40.f
#define kPortraitHeight 40.f


@interface CustomMapAnnotationView ()

@property (nonatomic, strong) UIImageView *portraitImageView;
//@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *BGView;

@end

@implementation CustomMapAnnotationView



- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
      
        self.bounds = CGRectMake(0.f, 0.f, kWidth, kHeight);
//        self.backgroundColor = [UIColor redColor];

        
        
        //下面箭头
        UIImageView *arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 13)];
        arrowImage.center = CGPointMake(kWidth/2.0, kHeight - 6);
        //arrowImage.backgroundColor = [UIColor orangeColor];
        arrowImage.contentMode = UIViewContentModeScaleAspectFit;
        arrowImage.image = [UIImage imageNamed:@"GreenArrow"];
        
        [self addSubview:arrowImage];
        
        
        
        UIImageView *view = [[UIImageView alloc]init];
        //WithFrame:CGRectMake(kHoriMargin - 1, kVertMargin - 1, kPortraitWidth + 2, kPortraitHeight + 2)
        view.backgroundColor = [UIColor colorWithRed:68/225.0 green:124/225.0 blue:54/225.0 alpha:1.0];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 21.0;
        view.layer.rasterizationScale = [UIScreen mainScreen].scale;
        view.layer.shouldRasterize = YES;
        view.clipsToBounds = YES;
        self.BGView = view;
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kPortraitWidth + 2, kPortraitHeight + 2));
            make.bottom.equalTo(arrowImage.mas_top).offset(0);
            make.centerX.equalTo(arrowImage);
        }];
        
        
        self.portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kHoriMargin, kVertMargin, kPortraitWidth, kPortraitHeight)];
        self.portraitImageView.layer.masksToBounds = YES;
        self.portraitImageView.layer.cornerRadius = 20.0;
        self.portraitImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.portraitImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.portraitImageView.layer.borderWidth = 3.0f;
        self.portraitImageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        self.portraitImageView.layer.shouldRasterize = YES;
        self.portraitImageView.clipsToBounds = YES;
        [self addSubview:self.portraitImageView];

        [self.portraitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kPortraitWidth, kPortraitHeight));
            make.center.equalTo(view);
        }];
        
        
        
        
        //点击手势
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesClicked:)];
//        self.portraitImageView.userInteractionEnabled = YES;
//        [self.portraitImageView addGestureRecognizer:tap];
        
        
    }
    return self;
}


//#pragma 图钉点击事件
//- (void)tapGesClicked:(UITapGestureRecognizer *)tap{
//    
//    NSLog(@"头像点击");
//    
//    if ([self.CustomAnnotationDelegate respondsToSelector:@selector(AnnotationHeaderImageClickWitht)]) {
//        
////        [self.CustomAnnotationDelegate AnnotationHeaderImageClickWithTeacherId:self.teacherId WithAnno:self];
//    }
//    
//}


- (void)clickImage{
    
    NSLog(@"+++++++");
    
    [self setSelected:NO];
    
}

//- (void)setTeacherModel:(TeacherListDataModel *)teacherModel{
//
//    _teacherModel = teacherModel;
//
//    [self.portraitImageView sd_setImageWithURL:[NSURL URLWithString:teacherModel.imgurl] placeholderImage:[UIImage imageNamed:@"headImage"]];
//
//#pragma mark - 图片缩小变模糊
//
//    __weak typeof(self) weakself = self;
//    NSURL *url = [NSURL URLWithString:teacherModel.imgurl];
//
//    [self.portraitImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"headImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//
//        weakself.portraitImageView.image =  [weakself imageCompressForSize:image targetSize:CGSizeMake(kPortraitWidth, kPortraitHeight)];
//
//    }];
//
//}


-(UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    
    CGFloat width = imageSize.width;
    
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = size.width;
    
    CGFloat targetHeight = size.height;
    
    CGFloat scaleFactor = 0.0;
    
    CGFloat scaledWidth = targetWidth;
    
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            
            scaleFactor = widthFactor;
            
        }
        
        else{
            
            scaleFactor = heightFactor;
            
        }
        
        scaledWidth = width * scaleFactor;
        
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            
        }
        
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 3.0);
    
    CGRect thumbnailRect = CGRectZero;
    
    thumbnailRect.origin = thumbnailPoint;
    
    thumbnailRect.size.width = scaledWidth;
    
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        
        NSLog(@"scale image fail");
        
    }
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
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