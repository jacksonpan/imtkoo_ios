//
//  UITabbar_imtkoo.h
//  FaCaiWang
//
//  Created by pan ren on 11-12-2.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tabItem_imtkoo : NSObject
@property (nonatomic) NSInteger index;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) UIImage* image;
@property (nonatomic, strong) UIImage* highlightImage;
@property (nonatomic) CGRect areaRect;
@property (nonatomic) CGRect imageDrawRect;
@property (nonatomic) CGRect highlightImageDrawRect;
@property (nonatomic) CGRect textDrawRect;
@end


@interface UITabbar_imtkoo : UIView
@property (nonatomic, strong, readonly) NSMutableArray* tabItems;
@property (nonatomic, strong) UIImage* backgroundImage;
@property (nonatomic, strong) UIColor* backgroundColor;
@property (nonatomic, strong) UIImage* selectedImage;
@property (nonatomic) CGRect selectedImageRect;
@property (nonatomic) NSInteger buttonCount;
@property (nonatomic) BOOL is_moving;
@property (nonatomic) NSInteger curButtonSelected;
@property (nonatomic, strong) UIFont* textFont;
@property (nonatomic) CGFloat textFontSize;
@property (nonatomic, strong) UIColor* textColor;
@property (nonatomic, strong) UIColor* textHighlightColor;
@property (nonatomic) CGFloat text_offset_y;
@property (nonatomic) CGFloat tabImage_offset_y;
@property (nonatomic) CGFloat selectedImage_offset_y;



- (id)initWithFrame:(CGRect)frame buttonCount:(NSInteger)count;

- (void)setTabItem:(NSInteger)index image:(UIImage*)image highlightImage:(UIImage*)highlightImage tabTitle:(NSString*)title;

- (void)setImageForSelected:(UIImage*)_selectedImage;

- (void)setFontForText:(UIFont *)_textFont;

- (void)setFontSizeForText:(CGFloat)_textSize;

- (void)setColorForText:(UIColor *)_textColor;

- (void)setColorForHighlightText:(UIColor*)_textColor;
@end
