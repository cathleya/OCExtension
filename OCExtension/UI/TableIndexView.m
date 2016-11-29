
#import "TableIndexView.h"
#import "UIView+add.h"
#import "FEPrecompile.h"


#define LABEL_HEIGHT 18
#define PADDING 1

@implementation TableIndexView

@synthesize tableView = _tableView;

- (TableIndexView *)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (TableIndexView *)initWithFrame:(CGRect)frame tableView:(UITableView *)tableView
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tableView = tableView;
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
//        self.clipsToBounds = YES;
//        self.layer.cornerRadius = self.width*0.5;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height + 3);
    }
    return self;
}

// refreshing our index items
- (void)refreshIndexItems
{
    [self removeAllSubviews];
    NSArray* indexTitles = [self.delegate sectionIndexTitlesForIndexView:self];
    if (indexTitles && indexTitles.count > 0) {
        
        int indexTitlesCount = indexTitles.count;
        float y = ((self.height-PADDING*2)-LABEL_HEIGHT*indexTitlesCount)*0.5;
        
        for (int i=0; i<indexTitlesCount; i++) {
            
            UILabel *indexTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, y, self.frame.size.width, LABEL_HEIGHT)];
            indexTitleLabel.backgroundColor = [UIColor clearColor];
            indexTitleLabel.font = [UIFont systemFontOfSize:13.0f];
            indexTitleLabel.textColor = RGBHEX(0x999999);
            indexTitleLabel.text = [indexTitles objectAtIndex:i];
            indexTitleLabel.textAlignment = NSTextAlignmentCenter;
            indexTitleLabel.tag = i;
            y += LABEL_HEIGHT;
            [self addSubview:indexTitleLabel];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.delegate
        && [self.delegate respondsToSelector:@selector(touchBegin)]) {
        [self.delegate touchBegin];
    }
    
//    self.backgroundColor = [UIColor lightGrayColor];
    //UIView *tt = [self.view viewWithTag:10000];
    // 获取平移手势对象在索引按钮父视图的位置点
    CGPoint curPoint = [[touches anyObject] locationInView:self];
    // 循环所有父视图中的所有按钮视图
    for (UIView *view in self.subviews) {
        if ([view isMemberOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)view;
            // 如果该点包含在某一个UIButton的Rect里面，并且最后的按钮tag值不等于当前的tag值
            if (CGRectContainsPoint(view.frame, curPoint)) {
                //lastTag = button.tag;
                
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:label.tag] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }
    }
    
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint curPoint = [[touches anyObject] locationInView:self];
    // 循环所有父视图中的所有按钮视图
    for (UIView *view in self.subviews) {
        if ([view isMemberOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)view;
            // 如果该点包含在某一个UIButton的Rect里面，并且最后的按钮tag值不等于当前的tag值
            if (CGRectContainsPoint(view.frame, curPoint)) {
                //lastTag = button.tag;
                int numberOfRowsInSection = [self.tableView numberOfRowsInSection:label.tag];
                
                if (numberOfRowsInSection > 0) {
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:label.tag] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                } else {
                    self.tableView.contentOffset = CGPointMake(0.0, 0.0);
                }
            }
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    self.backgroundColor = [UIColor clearColor];
    if (self.delegate
        && [self.delegate respondsToSelector:@selector(touchEnd)]) {
        [self.delegate touchEnd];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
//    self.backgroundColor = [UIColor clearColor];
    if (self.delegate
        && [self.delegate respondsToSelector:@selector(touchEnd)]) {
        [self.delegate touchEnd];
    }
}

@end
