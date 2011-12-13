//
//  UITabbar_imtkoo.m
//  FaCaiWang
//
//  Created by pan ren on 11-12-2.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "UITabbar_imtkoo.h"

@implementation tabItem_imtkoo
@synthesize index;
@synthesize title;
@synthesize image;
@synthesize highlightImage;
@synthesize areaRect;
@synthesize imageDrawRect;
@synthesize highlightImageDrawRect;
@synthesize textDrawRect;

- (id)init
{
    self = [super init];
    if(self)
    {
        index = -1;
        areaRect = CGRectZero;
        imageDrawRect = CGRectZero;
        highlightImageDrawRect = CGRectZero;
        textDrawRect = CGRectZero;
    }
    return self;
}
- (void)dealloc
{
    [title release];
    [image release];
    [highlightImage release];
    [super dealloc];
}
@end


@implementation UITabbar_imtkoo
@synthesize tabItems;
@synthesize backgroundImage;
@synthesize backgroundColor;
@synthesize buttonCount;
@synthesize is_moving;
@synthesize curButtonSelected;
@synthesize selectedImage;
@synthesize selectedImageRect;
@synthesize textFont;
@synthesize textFontSize;
@synthesize textColor;
@synthesize textHighlightColor;
@synthesize text_offset_y;
@synthesize tabImage_offset_y;
@synthesize selectedImage_offset_y;
@synthesize delegate;

- (void)dealloc
{
    [backgroundImage release];
    [tabItems release];
    [backgroundColor release];
    [selectedImage release];
    [textFont release];
    [textColor release];
    [textHighlightColor release];
    [super dealloc];
}

- (void)addButtons:(NSInteger)count
{
    if(buttonCount < count)
    {
        NSLog(@"error:more button");
        return;
    }
    
    CGFloat button_width = self.bounds.size.width/count;
    CGFloat button_height = self.bounds.size.height;
    for(int i=0;i<count;i++)
    {
        tabItem_imtkoo* tabItem = [[tabItem_imtkoo alloc] init];
        tabItem.index = i;
        tabItem.areaRect = CGRectMake(i*button_width, self.bounds.origin.y, button_width, button_height);
        tabItem.textDrawRect = CGRectMake(i*button_width, self.bounds.size.height - textFontSize, button_width, textFontSize);
        [tabItems addObject:tabItem];
        [tabItem release];
    }
}

- (id)initWithFrame:(CGRect)frame buttonCount:(NSInteger)count
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        backgroundColor = [UIColor blackColor];
        buttonCount = count;
        curButtonSelected = -1;
        is_moving = NO;
        tabItems = [[NSMutableArray alloc] init];
        textFontSize = 10;
        textFont = [UIFont systemFontOfSize:textFontSize];
        textColor = [UIColor blackColor];
        textHighlightColor = [UIColor whiteColor];
        text_offset_y = -8;
        tabImage_offset_y = -5;
        selectedImage_offset_y = 0;
        [self addButtons:buttonCount];
    }
    return self;
}

- (void)setTabItem:(NSInteger)index image:(UIImage*)image highlightImage:(UIImage*)highlightImage tabTitle:(NSString*)title
{
    if(index >= buttonCount)
    {
        NSLog(@"error:more button");
        return;
    }
    tabItem_imtkoo* tabItem = [tabItems objectAtIndex:index];
    tabItem.title = title;
    tabItem.image = image;
    tabItem.highlightImage = highlightImage;
    tabItem.imageDrawRect = CGRectMake(tabItem.areaRect.origin.x + (tabItem.areaRect.size.width - tabItem.image.size.width)/2, tabItem.areaRect.origin.y, tabItem.image.size.width, tabItem.image.size.height);
    tabItem.highlightImageDrawRect = CGRectMake(tabItem.areaRect.origin.x + (tabItem.areaRect.size.width - tabItem.highlightImage.size.width)/2, tabItem.areaRect.origin.y, tabItem.highlightImage.size.width, tabItem.highlightImage.size.height);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    if(backgroundImage)
    {
        [backgroundImage drawInRect:self.bounds];
    }
    else
    {
        [backgroundColor setFill];
        CGContextFillRect(ctx, self.bounds);
    }
    
    for(tabItem_imtkoo* tabItem in tabItems)
    {
        if(curButtonSelected == tabItem.index)
        {
            [selectedImage drawInRect:CGRectMake(tabItem.areaRect.origin.x + selectedImageRect.origin.x, tabItem.areaRect.origin.y + selectedImageRect.origin.y + selectedImage_offset_y, selectedImageRect.size.width, selectedImageRect.size.height)];
            CGRect d = tabItem.imageDrawRect;
            d.origin.y += tabImage_offset_y;
            [tabItem.highlightImage drawInRect:d];
            [textHighlightColor set];
            d = tabItem.textDrawRect;
            d.origin.y += text_offset_y;
            [tabItem.title drawInRect:d withFont:textFont lineBreakMode:UILineBreakModeMiddleTruncation alignment:UITextAlignmentCenter];
        }
        else
        {
            CGRect d = tabItem.imageDrawRect;
            d.origin.y += tabImage_offset_y;
            [tabItem.highlightImage drawInRect:d];
            [tabItem.image drawInRect:d];
            [textColor set];
            d = tabItem.textDrawRect;
            d.origin.y += text_offset_y;
            [tabItem.title drawInRect:d withFont:textFont lineBreakMode:UILineBreakModeMiddleTruncation alignment:UITextAlignmentCenter];
        }
    }
}

- (void)setImageForSelected:(UIImage*)_selectedImage
{
    self.selectedImage = _selectedImage;
    CGFloat button_width = self.bounds.size.width/buttonCount;
    CGFloat button_height = self.bounds.size.height;
    selectedImageRect = CGRectMake((button_width - self.selectedImage.size.width)/2, (button_height - self.selectedImage.size.height)/2, self.selectedImage.size.width, self.selectedImage.size.height);
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint newLocation = [[touches anyObject] locationInView:self];
    for (tabItem_imtkoo* tabItem in tabItems)
    {
        if(CGRectContainsPoint(tabItem.areaRect, newLocation))
        {
            curButtonSelected = tabItem.index;
            NSLog(@"tab:%d", curButtonSelected);
            [delegate UITabbar_imtkoo_callback_forIndex:curButtonSelected];
            break;
        }
    }
    
    [self setNeedsDisplay];
    //[super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
}

- (void)setFontForText:(UIFont *)_textFont
{
    [textFont release];
    textFont = _textFont;
    textFontSize = textFont.pointSize;
}

- (void)setFontSizeForText:(CGFloat)_textSize
{
    textFontSize = _textSize;
    textFont = [textFont fontWithSize:textFontSize];
    for(tabItem_imtkoo* tabItem in tabItems)
    {
        CGRect t = tabItem.textDrawRect;
        t.origin.y = self.bounds.size.height - textFontSize;
        t.size.height = textFontSize;
        tabItem.textDrawRect = t;
    }
}

- (void)setColorForText:(UIColor *)_textColor
{
    [textColor release];
    textColor = _textColor;
}

- (void)setColorForHighlightText:(UIColor*)_textColor
{
    [textHighlightColor release];
    textHighlightColor = _textColor;
}

@end
