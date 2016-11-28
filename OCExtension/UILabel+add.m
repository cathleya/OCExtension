

#import "UILabel+add.h"
#import "UIView+add.h"

@implementation UILabel (add)

- (void)sizeFitWithConstraintSize:(CGSize)constraintSize
{
    CGSize newSize = [self sizeThatFits:constraintSize];

    self.frame = CGRectMake(self.left, self.top, newSize.width, newSize.height);
}


- (void)setLabelLineSpace:(CGFloat)space
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = space;
    NSDictionary *attrbut = @{NSFontAttributeName:self.font,NSParagraphStyleAttributeName:paragraphStyle};
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:self.text attributes:attrbut];
    self.attributedText = attributedText;
}

@end
