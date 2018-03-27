//
//  CustomMapAnnotationView.m
//  YunDi_Student
//
//  Created by apple on 2018/1/24.
//  Copyright © 2018年 Fengyun Diyin Technologies (Beijing) Co., Ltd. All rights reserved.
//

#import "CustomMapAnnotationView.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"


#define kWidth  40.f
#define kHeight 42.f

#define kHoriMargin 5.f
#define kVertMargin 5.f

#define kPortraitWidth  24.f
#define kPortraitHeight 24.f


@interface CustomMapAnnotationView ()

@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic, strong) UIImageView *BGView;

@end

@implementation CustomMapAnnotationView



- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
      
        self.bounds = CGRectMake(0.f, 0.f, kWidth, kHeight);
//        self.backgroundColor = [UIColor redColor];

        
        

        
        
        
        UIImageView *view = [[UIImageView alloc]init];
        view.contentMode = UIViewContentModeScaleAspectFit;
        view.image = [UIImage imageNamed:@"张三"];
        //WithFrame:CGRectMake(kHoriMargin - 1, kVertMargin - 1, kPortraitWidth + 2, kPortraitHeight + 2)
//        view.backgroundColor = [UIColor colorWithRed:68/225.0 green:124/225.0 blue:54/225.0 alpha:1.0];
//        view.layer.masksToBounds = YES;
//        view.layer.cornerRadius = 21.0;
//        view.layer.rasterizationScale = [UIScreen mainScreen].scale;
//        view.layer.shouldRasterize = YES;
//        view.clipsToBounds = YES;
        self.BGView = view;
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        //文字
        UILabel *name = [[UILabel alloc]init];
        self.nameLabel = name;
        name.text = @"";
        name.font = [UIFont systemFontOfSize:7];
        name.textColor = [UIColor whiteColor];
        name.textAlignment = NSTextAlignmentCenter;
//        name.backgroundColor = [UIColor orangeColor];
        name.contentMode = UIViewContentModeScaleAspectFit;
        
        [self addSubview:name];
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
        
            make.centerX.equalTo(self).offset(-4.5);
            make.centerY.equalTo(self).offset(-3);
            make.size.mas_equalTo(CGSizeMake(26, 20));
        }];
        
        
        self.portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kHoriMargin, kVertMargin, kPortraitWidth, kPortraitHeight)];
        self.portraitImageView.layer.masksToBounds = YES;
        self.portraitImageView.layer.cornerRadius = 12.0;
        self.portraitImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.portraitImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.portraitImageView.layer.borderWidth = 0.0f;
        self.portraitImageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        self.portraitImageView.layer.shouldRasterize = YES;
        self.portraitImageView.clipsToBounds = YES;
        [self addSubview:self.portraitImageView];
        
        [self.portraitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kPortraitWidth, kPortraitHeight));
            make.center.equalTo(name);
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


//- (void)clickImage{
//
//    NSLog(@"+++++++");
//
//    [self setSelected:NO];
//
//}

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


- (void)setImg:(NSString *)img{
    
    _img = img;
    
#pragma mark - 图片缩小变模糊
    
    __weak typeof(self) weakself = self;
    NSURL *url = [NSURL URLWithString:img];
    
    
    
    [self.portraitImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_portrait"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        weakself.portraitImageView.image =  [weakself imageCompressForSize:image targetSize:CGSizeMake(kPortraitWidth, kPortraitHeight)];
        
    }];
}


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
