//
//  FanBtn.m
//  扇形按钮
//
//  Created by jhtxch on 16/4/20.
//  Copyright © 2016年 jhtxch. All rights reserved.
//

#import "FanBtn.h"
#import <objc/runtime.h>

@interface FanBtn ()
{
    
}

@property (nonatomic ,weak) CAShapeLayer *shaperLayer;

@end
@implementation FanBtn

- (void)dealloc
{
    CGPathRelease(_path);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.opaque = YES;
        self.clipsToBounds = NO;
        _btnColor = [UIColor yellowColor];
        _lineColor = [UIColor redColor];
        
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

- (void)setCircleCenter:(CGPoint)circleCenter{
    
    CGFloat angle = [self positiveAngelWith:(self.startAngle + self.angle / 2)];
    CGFloat offsetX = cos(angle)  * 8;
    CGFloat offsetY = sin(angle)  * 8;
    CGPoint point = CGPointMake(circleCenter.x + offsetX, circleCenter.y + offsetY);

    _circleCenter = point;
}

#pragma mark - drawrect
- (void)drawRect:(CGRect)rect
{
    [self layoutFanShape];
    CGPoint centerPoint = [self.superview convertPoint:self.circleCenter toView:self];
    CGFloat centerX = centerPoint.x;
    CGFloat centerY = centerPoint.y;
    _path = CGPathCreateMutable();
    [self.btnColor setFill];
    [self.lineColor setStroke];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPathMoveToPoint(_path, NULL, centerX, centerY);
    CGPathAddArc(_path, NULL, centerX, centerY, self.radius - 1, self.startAngle, self.startAngle + self.angle, 0);
    CGPathCloseSubpath(_path);
    CGContextAddPath(context, _path);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    
    
    /*让半径等于期望半径的一半  lineWidth等于期望半径 就可以画圆*/
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    self.shaperLayer = layer;
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:centerPoint
                                                               radius:self.radius - 1
                                                           startAngle:self.startAngle                                                                 endAngle:self.startAngle + self.angle
                                                            clockwise:YES];
    [bezierPath addLineToPoint:centerPoint];
    layer.path = bezierPath.CGPath;
    layer.lineWidth = 4;
//    UIColor *color = [UIColor grayColor];
//    layer.strokeColor = color.CGColor;
    // 最好 为clearColor 设置颜色是方便观察
    layer.fillColor = self.btnColor.CGColor;
    
    //默认
    layer.lineCap = kCALineCapButt;
    [self.layer insertSublayer:layer atIndex:0];
    
    
}
#pragma mark - touch event
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    if (CGPathContainsPoint(self.shaperLayer.path, nil, [touch locationInView:self], nil)) {
        
        self.shaperLayer.fillColor = self.pressBtnColor.CGColor;

    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [super touchesEnded:touches withEvent:event];
    
    
    UITouch *touch = [touches anyObject];
    if (CGPathContainsPoint(self.shaperLayer.path, nil, [touch locationInView:self], nil)) {
        
        if ([self.delegate respondsToSelector:@selector(clickBtn:)]) {
            [self.delegate clickBtn:self];
        }
    }

    self.shaperLayer.fillColor = self.btnColor.CGColor;


}

#pragma mark layout
- (void)layoutFanShape
{
    //重置frame
    CGRect frame = self.frame;
    CGFloat x = self.circleCenter.x;
    CGFloat y = self.circleCenter.y;
    CGFloat wid = self.radius;
    CGFloat hlt = self.radius;
    frame = CGRectMake(x - wid, y - hlt, wid * 2, hlt * 2);
    self.frame = frame;
}

- (void)layoutTextLabel
{
    self.icon.frame = CGRectMake(0, 0, 45, 45);
    self.icon.center = [self textLabelPoint];
//    self.textLabel.transform = CGAffineTransformMakeRotation(self.startAngle + self.angle / 2  + M_PI / 2 + 2 * M_PI);
}

- (void)layoutSubviews
{
    if (!self.icon) {
        self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.icon.backgroundColor = [UIColor yellowColor];
        self.icon.image = [UIImage imageNamed:self.iconImgName];
        [self addSubview:self.icon];
        [self layoutTextLabel];
    }
    
    
}

- (CGPoint)textLabelPoint
{
    CGFloat angle = [self positiveAngelWith:(self.startAngle + self.angle / 2)];
    CGFloat offsetX = cos(angle) * .55 * self.radius;
    CGFloat offsetY = sin(angle) * .55 * self.radius;
    CGPoint point = CGPointMake(self.circleCenter.x + offsetX, self.circleCenter.y + offsetY);
    return point;
}
#pragma mark - other
//将坐标转换为0～2PI
- (CGFloat)positiveAngelWith:(CGFloat)angle
{
    CGFloat num = fabs(angle / M_PI);
    NSInteger count = num;
    count = count / 2;
    if (angle > 0) {
        angle = angle - 2 * M_PI * count;
    }else{
        angle = angle + (count + 1) * 2 * M_PI;
    }
    return angle;
}


@end
