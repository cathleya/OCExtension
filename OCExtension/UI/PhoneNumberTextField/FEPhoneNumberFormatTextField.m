//
//  FEPhoneNumberFormatTextField.m
//  Pet
//
//  Created by Tom on 15/05/06.
//  Copyright (c) 2015年 fanying. All rights reserved.
//

#import "FEPhoneNumberFormatTextField.h"

@implementation FEPhoneNumberFormatTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        
        [self addTarget:self
                 action:@selector(reformatAsPhoneNumber:)
       forControlEvents:UIControlEventEditingChanged];
    }

    return self;
}


- (void)reformatAsPhoneNumber:(UITextField *)textField
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
        
        if (isdigit(characterToAdd))
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
    
    static int firstIndex = 3;//第4位为空格
    static int secondIndex = 7; //第8位位空格
    for (NSUInteger i = 0; i < [string length]; i++)
    {
        if (i == firstIndex
            || i == secondIndex)
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


-(NSString*)phoneNumber
{
    NSString* value = self.text;
    //移除格式化空格
    value = [value stringByReplacingOccurrencesOfString:@" " withString:@""];
    return value;
}

-(void)setPhoneNumber:(NSString*)mobile
{
    self.text = mobile;
    
    [self reformatAsPhoneNumber:self];
}


@end
