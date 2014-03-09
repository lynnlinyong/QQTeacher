//
//  CallOutAnnotationView.m
//  QQStudent
//
//  Created by lynn on 14-2-7.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "CallOutAnnotationView.h"

#define Arror_height  6

@implementation CallOutAnnotationView
@synthesize contentView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)dealloc{
    [contentView release];
    [super dealloc];
}

-(id)initWithAnnotation:(id<MAAnnotation>)annotation
        reuseIdentifier:(NSString *)reuseIdentifier
{    
    
    self = [super initWithAnnotation:annotation
                     reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.canShowCallout = NO;
        
        CalloutMapAnnotation *ann = annotation;
        if (ann.teacherObj.isId)
        {
            self.centerOffset = CGPointMake(0, -88);   //58
            self.frame = CGRectMake(0, 0, 200, 140);   //120
        }
        else
        {
            self.centerOffset = CGPointMake(0, -78);   //58
            self.frame = CGRectMake(0, 0, 200, 120);   //120
        }
        
        contentView     =      [[UIView alloc] initWithFrame:CGRectMake(5,
                                                                        5,
                                                                        self.frame.size.width-15,
                                                                        self.frame.size.height-15)];
        contentView.backgroundColor   = [UIColor clearColor];
        [self addSubview:contentView];
    }
    return self;
    
}

-(void)drawRect:(CGRect)rect{
    
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
    self.layer.shadowColor   = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
}

-(void)drawInContext:(CGContextRef)context
{
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor);
    
    [self getDrawPath:context];
    CGContextFillPath(context);
}

- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect   = self.bounds;
    CGFloat radius = 6.0;
    
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),

    // midy = CGRectGetMidY(rrect),
    maxy = CGRectGetMaxY(rrect)-10;
    CGContextMoveToPoint(context, midx+Arror_height, maxy);
    CGContextAddLineToPoint(context,midx, maxy+Arror_height);
    CGContextAddLineToPoint(context,midx-Arror_height, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}
@end
