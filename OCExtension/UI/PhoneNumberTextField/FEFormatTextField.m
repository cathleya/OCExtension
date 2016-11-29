//
//  FEFormatTextField.m
//  Pet
//
//  Created by ios on 16/2/18.
//  Copyright © 2016年 Yourpet. All rights reserved.
//

#import "FEFormatTextField.h"

@implementation FEFormatTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addTarget:self
                 action:@selector(reformatAsContent:)
       forControlEvents:UIControlEventEditingChanged];
    }
    
    return self;
}


- (void)reformatAsContent:(UITextField *)textField
{
    static NSString* space = @" ";
    if ([textField.text isEqualToString:space])//等于空格时清除
    {
        textField.text = nil;
    }
    else if ([textField.text hasSuffix:space])//包含空格后缀时
    {
        [textField deleteBackward];
    }
    else
    {
        NSUInteger targetCursorPosition =
        [textField offsetFromPosition:textField.beginningOfDocument
                           toPosition:textField.selectedTextRange.start];
        
        
        NSString *content = [self removeNonDigits:textField.text andPreserveCursorPosition:&targetCursorPosition];
        
        content = [self insertSpacesIntoString:content andPreserveCursorPosition:&targetCursorPosition];
        
        textField.text = content;
        UITextPosition *targetPosition = [textField positionFromPosition:[textField beginningOfDocument]
                                                                  offset:targetCursorPosition];
        
        [textField setSelectedTextRange: [textField textRangeFromPosition:targetPosition toPosition:targetPosition]];
    }
    
}

- (NSString *)removeNonDigits:(NSString *)string andPreserveCursorPosition:(NSUInteger *)cursorPosition
{
    NSUInteger      originalCursorPosition = *cursorPosition;
    NSMutableString *digitsOnlyString = [NSMutableString new];
    
    for (NSUInteger i = 0; i < [string length]; i++)
    {
        unichar characterToAdd = [string characterAtIndex:i];
        
        if (!isspace(characterToAdd))
        {
            NSString *stringToAdd =
            [NSString stringWithCharacters:&characterToAdd
                                    length:1];
            
            [digitsOnlyString appendString:stringToAdd];
        }
        else
        {
            if (i < originalCursorPosition)
            {
                (*cursorPosition)--;
            }
        }
    }
    
    return digitsOnlyString;
}

- (NSString *)insertSpacesIntoString:(NSString *)string andPreserveCursorPosition:(NSUInteger *)cursorPosition
{
    NSMutableString *stringWithAddedSpaces = [NSMutableString new];
    NSUInteger      cursorPositionInSpacelessString = *cursorPosition;
    
    static int colCount = 4;//每4位为空格
    for (NSUInteger i = 0; i < [string length]; i++)
    {
        if (i > 0
            && i % colCount == 0)
        {
            [stringWithAddedSpaces appendString:@" "];
            if (i < cursorPositionInSpacelessString)
            {
                (*cursorPosition)++;
            }
        }
        
        unichar     characterToAdd = [string characterAtIndex:i];
        NSString    *stringToAdd =
        [NSString stringWithCharacters:&characterToAdd length:1];
        
        [stringWithAddedSpaces appendString:stringToAdd];
    }
    
    return stringWithAddedSpaces;
}


-(NSString*)content
{
    NSString* value = self.text;
    //移除格式化空格
    value = [value stringByReplacingOccurrencesOfString:@" " withString:@""];
    return value;
}

-(void)setContent:(NSString*)content
{
    self.text = content;
    
    [self reformatAsContent:self];
}


@end

