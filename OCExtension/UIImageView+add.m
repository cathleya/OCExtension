
#import "UIImageView+add.h"
#import "UIView+add.h"


@implementation UIImageView (add)

+ (id)imageViewWithImg:(UIImage *)img
{
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectZero];
    view.image = img;
    [view sizeToFit];
    return view;
}

@end
