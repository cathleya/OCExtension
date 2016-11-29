

#import "FEPopupView.h"
#import <QuartzCore/QuartzCore.h>

@interface TouchPeekView : UIView
{
}
@property (nonatomic, weak) FEPopupView *delegate;
@end

@interface FEPopupView(Private)
- (void)popup;
@end
	
@implementation TouchPeekView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if ([_delegate shouldBeDismissedFor:touches withEvent:event])
	{
        [_delegate dismissModal];
    }
}

@end

@implementation FEPopupView

#pragma mark - Prepare

- (id) initWithString:(NSString*)newValue
{
	return [self initWithString:newValue withFontOfSize:DEFAULT_TITLE_SIZE];
}

- (id) initWithString:(NSString*)newValue withFontOfSize:(float)newFontSize
{
	self = [super initWithFrame:CGRectZero];
	if (self != nil)
    {
		_title = [newValue copy];
		
        // Initialization code
		[self setBackgroundColor:[UIColor clearColor]];
		
		_fontSize = newFontSize;
		UIFont *font = [UIFont systemFontOfSize:_fontSize];
		
		CGSize titleRenderingSize = [_title sizeWithFont:font constrainedToSize:CGSizeMake(200, MAXFLOAT)];
		
		_contentBounds = CGRectMake(0, 0, 0, 0);
		_contentBounds.size = titleRenderingSize;
        
        _showRect = CGRectZero;
        
        _contentOffset = CONTENT_OFFSET;
		
		
	}
	return self;
}

- (id)initWithImage:(UIImage*)newImage
{
	self = [super initWithFrame:CGRectZero];
	if (self != nil)
    {
        _image = newImage;
		
        // Initialization code
		[self setBackgroundColor:[UIColor clearColor]];
		
		_contentBounds = CGRectMake(0, 0, 0, 0);
		_contentBounds.size = _image.size;
        
        _showRect = CGRectZero;
        
        _contentOffset = CONTENT_OFFSET;

		
	}
	return self;
}

- (id)initWithContentView:(UIView*)newContentView contentSize:(CGSize)contentSize
{
	self = [super initWithFrame:CGRectZero];
	if (self != nil)
    {
		_contentView = newContentView;
		
        // Initialization code
		[self setBackgroundColor:[UIColor clearColor]];
		
		_contentBounds = CGRectMake(0, 0, 0, 0);
		_contentBounds.size = contentSize;
        
        _showRect = CGRectZero;
        _contentOffset = CONTENT_OFFSET;
		
	}
	return self;
}

#pragma mark - Present modal

- (void)createAndAttachTouchPeekView
{
	UIWindow *window = [[UIApplication sharedApplication] keyWindow];

	[_peekView removeFromSuperview];
	_peekView = nil;
	_peekView = [[TouchPeekView alloc] initWithFrame:window.frame];
	[_peekView setDelegate:self];
	
	[window addSubview:_peekView];
}

- (void)presentModalAtPoint:(CGPoint)p inView:(UIView*)inView
{
	_animatedWhenAppering = YES;
	[self createAndAttachTouchPeekView];
	[self showAtPoint:[inView convertPoint:p toView:[[UIApplication sharedApplication] keyWindow]]
               inView:[[UIApplication sharedApplication] keyWindow]];
}

- (void)presentModalAtRect:(CGRect)rect inView:(UIView*)inView animated:(BOOL)animated
{
    
    _showRect = rect;
    CGPoint showPoint = CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y+rect.size.height);
    
    [self presentModalAtPoint:showPoint inView:inView animated:animated];
}

- (void)presentModalAtPoint:(CGPoint)p inView:(UIView*)inView animated:(BOOL)animated
{
	_animatedWhenAppering = animated;
	[self createAndAttachTouchPeekView];
	[self showAtPoint:[inView convertPoint:p toView:[[UIApplication sharedApplication] keyWindow]]
               inView:[[UIApplication sharedApplication] keyWindow]
             animated:animated];
}

#pragma mark - Show as normal view

- (void)showAtPoint:(CGPoint)p inView:(UIView*)inView
{
	[self showAtPoint:p inView:inView animated:NO];
}

- (void)showAtRect:(CGRect)rect inView:(UIView*)inView animated:(BOOL)animated
{
    CGPoint showPoint = CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y+rect.size.height);
    _showRect = rect;
    [self showAtPoint:showPoint inView:inView animated:animated];
};

- (void)showAtPoint:(CGPoint)p inView:(UIView*)inView animated:(BOOL)animated
{
    NSInteger iHeight = [[UIScreen mainScreen] bounds].size.height;
	if ((p.y + (_contentBounds.size.height + POPUP_ROOT_SIZE.height + 2 * _contentOffset.height + SHADOW_OFFSET.height)) > iHeight)
    {
		_direction = FEPopupViewUp;
        p.y -= _showRect.size.height;
        
	}
	else
    {
		_direction = FEPopupViewDown;

	}
	
	if (_direction & FEPopupViewUp)
    {

		_pointToBeShown = p;
		
		// calc content area
		_contentRect.origin.x = p.x - (int)_contentBounds.size.width/2;
		_contentRect.origin.y = p.y - _contentOffset.height - POPUP_ROOT_SIZE.height - _contentBounds.size.height;
		_contentRect.size = _contentBounds.size;
		
		// calc popup area
		_popupBounds.origin = CGPointMake(0, 0);
		_popupBounds.size.width = _contentBounds.size.width + _contentOffset.width + _contentOffset.width;
		_popupBounds.size.height = _contentBounds.size.height + _contentOffset.height + _contentOffset.height + POPUP_ROOT_SIZE.height;
		
		_popupRect.origin.x = _contentRect.origin.x - _contentOffset.width;
		_popupRect.origin.y = _contentRect.origin.y - _contentOffset.height;
		_popupRect.size = _popupBounds.size;
		
		// calc self size and rect
		_viewBounds.origin = CGPointMake(0, 0);
		_viewBounds.size.width = _popupRect.size.width + SHADOW_OFFSET.width + SHADOW_OFFSET.width;
		_viewBounds.size.height = _popupRect.size.height + SHADOW_OFFSET.height + SHADOW_OFFSET.height;
		
		_viewRect.origin.x = _popupRect.origin.x - SHADOW_OFFSET.width;
		_viewRect.origin.y = _popupRect.origin.y - SHADOW_OFFSET.height;
		_viewRect.size = _viewBounds.size;

		float left_viewRect = _viewRect.origin.x + _viewRect.size.width;
		
		// calc horizontal offset
		if (_viewRect.origin.x < 0)
        {
			_direction = _direction | FEPopupViewRight;
			_horizontalOffset = _viewRect.origin.x;
			
			if (_viewRect.origin.x - _horizontalOffset < _pointToBeShown.x - HORIZONTAL_SAFE_MARGIN)
            {
			}
			else
            {
				_pointToBeShown.x = HORIZONTAL_SAFE_MARGIN;
			}
			_viewRect.origin.x -= _horizontalOffset;
			_contentRect.origin.x -= _horizontalOffset;
			_popupRect.origin.x -= _horizontalOffset;
		}
		else if (left_viewRect > inView.frame.size.width)
        {
			_direction = _direction | FEPopupViewLeft;
			_horizontalOffset = inView.frame.size.width - left_viewRect;
			
			if (left_viewRect + _horizontalOffset > _pointToBeShown.x + HORIZONTAL_SAFE_MARGIN) {
			}
			else
            {
				_pointToBeShown.x = inView.frame.size.width - HORIZONTAL_SAFE_MARGIN;
			}
			_viewRect.origin.x += _horizontalOffset;
			_contentRect.origin.x += _horizontalOffset;
			_popupRect.origin.x += _horizontalOffset;
		}
	}
	else
    {
		_pointToBeShown = p;
		
		// calc content area
		_contentRect.origin.x = p.x - (int)_contentBounds.size.width/2;
		_contentRect.origin.y = p.y + _contentOffset.height + POPUP_ROOT_SIZE.height;
		_contentRect.size = _contentBounds.size;
		
		// calc popup area
		_popupBounds.origin = CGPointMake(0, 0);
		_popupBounds.size.width = _contentBounds.size.width + _contentOffset.width + _contentOffset.width;
		_popupBounds.size.height = _contentBounds.size.height + _contentOffset.height + _contentOffset.height + POPUP_ROOT_SIZE.height;
		
		_popupRect.origin.x = _contentRect.origin.x - _contentOffset.width;
		_popupRect.origin.y = _contentRect.origin.y - _contentOffset.height - POPUP_ROOT_SIZE.height;
		_popupRect.size = _popupBounds.size;
		
		// calc self size and rect
		_viewBounds.origin = CGPointMake(0, 0);
		_viewBounds.size.width = _popupRect.size.width + SHADOW_OFFSET.width + SHADOW_OFFSET.width;
		_viewBounds.size.height = _popupRect.size.height + SHADOW_OFFSET.height + SHADOW_OFFSET.height;
		
		_viewRect.origin.x = _popupRect.origin.x - SHADOW_OFFSET.width;
		_viewRect.origin.y = _popupRect.origin.y - SHADOW_OFFSET.height;
		_viewRect.size = _viewBounds.size;
		
		float left_viewRect = _viewRect.origin.x + _viewRect.size.width;
		
		// calc horizontal offset
		if (_viewRect.origin.x < 0)
        {
			_direction = _direction | FEPopupViewRight;
			_horizontalOffset = _viewRect.origin.x;
			
			if (_viewRect.origin.x - _horizontalOffset < _pointToBeShown.x - HORIZONTAL_SAFE_MARGIN)
            {
			}
			else
            {
				_pointToBeShown.x = HORIZONTAL_SAFE_MARGIN;
			}
			_viewRect.origin.x -= _horizontalOffset;
			_contentRect.origin.x -= _horizontalOffset;
			_popupRect.origin.x -= _horizontalOffset;
		}
		else if (left_viewRect > inView.frame.size.width)
        {
			_direction = _direction | FEPopupViewLeft;
			_horizontalOffset = inView.frame.size.width - left_viewRect;
			
			if (left_viewRect + _horizontalOffset > _pointToBeShown.x + HORIZONTAL_SAFE_MARGIN)
            {
			}
			else
            {
				_pointToBeShown.x = inView.frame.size.width - HORIZONTAL_SAFE_MARGIN;
			}
			_viewRect.origin.x += _horizontalOffset;
			_contentRect.origin.x += _horizontalOffset;
			_popupRect.origin.x += _horizontalOffset;
		}
	}
	
	// offset
	_contentRect.origin.x -= _viewRect.origin.x;
	_contentRect.origin.y -= _viewRect.origin.y;
	_popupRect.origin.x -= _viewRect.origin.x;
	_popupRect.origin.y -= _viewRect.origin.y;
	_pointToBeShown.x -= _viewRect.origin.x;
	_pointToBeShown.y -= _viewRect.origin.y;
	
	BOOL isAlreadyShown = (self.superview == inView);
	
	if (isAlreadyShown)
    {
		[self setNeedsDisplay];
		
		
		if (animated)
        {
			[UIView beginAnimations:@"move" context:nil];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		}
		self.frame = _viewRect;
		if (animated)
        {
			[UIView commitAnimations];
		}
	}
	else
    {
		// set frame
		[inView addSubview:self];
		self.frame = _viewRect;
		
		
		if (_contentView)
        {
			[self addSubview:_contentView];
			[_contentView setFrame:_contentRect];
		}
		
		// popup
		if (animated)
        {
           [self popup]; 
        }
	}
}

#pragma mark - Core Animation call back

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    [self.layer removeAllAnimations];
	[self removeFromSuperview];
}

#pragma mark - Make CoreAnimation object

- (CAKeyframeAnimation*)getAlphaAnimationForPopup
{
	
	CAKeyframeAnimation *alphaAnimation = [CAKeyframeAnimation	animationWithKeyPath:@"opacity"];
	alphaAnimation.removedOnCompletion = NO;
	alphaAnimation.values = [NSArray arrayWithObjects:
							 [NSNumber numberWithFloat:0],
							 [NSNumber numberWithFloat:1],
							 nil];
	alphaAnimation.keyTimes = [NSArray arrayWithObjects:
							   [NSNumber numberWithFloat:0],
							   [NSNumber numberWithFloat:0.6],
							   nil];
	return alphaAnimation;
}

- (CAKeyframeAnimation*)getPositionAnimationForPopup
{
	
	float r1 = 0.1;
	float r5 = 1;
	
	float y_offset =  (_popupRect.size.height/2 - POPUP_ROOT_SIZE.height);
	
	CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	CATransform3D tm1, tm5;
	
	if (_direction & FEPopupViewUp)
    {
		if (_direction & FEPopupViewLeft)
		{
            _horizontalOffset = -_horizontalOffset;
        }
		tm1 = CATransform3DMakeTranslation(_horizontalOffset * (1 - r1), y_offset * (1 - r1), 0);
		tm5 = CATransform3DMakeTranslation(_horizontalOffset * (1 - r5), y_offset * (1 - r5), 0);
	}
	else
    {
		if (_direction & FEPopupViewLeft)
			_horizontalOffset = -_horizontalOffset;		
		tm1 = CATransform3DMakeTranslation(_horizontalOffset * (1 - r1), -y_offset * (1 - r1), 0);
		tm5 = CATransform3DMakeTranslation(_horizontalOffset * (1 - r5), -y_offset * (1 - r5), 0);
	}
	tm1 = CATransform3DScale(tm1, r1, r1, 1);
	tm5 = CATransform3DScale(tm5, r5, r5, 1);
	
	positionAnimation.values = [NSArray arrayWithObjects:
								[NSValue valueWithCATransform3D:tm1],
								[NSValue valueWithCATransform3D:tm5],
								nil];
	positionAnimation.keyTimes = [NSArray arrayWithObjects:
								  [NSNumber numberWithFloat:0.0],
								  [NSNumber numberWithFloat:0.6],
								  nil];
	return positionAnimation;
}

#pragma mark - Popup and dismiss

- (void)popup
{
	
	CAKeyframeAnimation *positionAnimation = [self getPositionAnimationForPopup];
	CAKeyframeAnimation *alphaAnimation = [self getAlphaAnimationForPopup];
	
	CAAnimationGroup *group = [CAAnimationGroup animation];
	group.animations = [NSArray arrayWithObjects:positionAnimation, alphaAnimation, nil];
	group.duration = POPUP_ANIMATION_DURATION;
	group.removedOnCompletion = YES;
	group.fillMode = kCAFillModeForwards;
	
	[self.layer addAnimation:group forKey:@"hoge"];
}

- (BOOL)shouldBeDismissedFor:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	
	CGPoint p = [touch locationInView:self];
	return !CGRectContainsPoint(_contentRect, p);
}

- (void)dismissModal
{
	if ([_peekView superview])
    {
        [_delegate didDismissModal:self];
    }
		
	[_peekView removeFromSuperview];
	
	[self dismiss:_animatedWhenAppering];
}

- (void)dismiss:(BOOL)animtaed
{
	if (animtaed)
    {
        [self dismiss];
    }
	else
    {
		[self removeFromSuperview];
	}
}

- (void)dismiss
{
	CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];

	float r1 = 1.0;
	float r2 = 0.1;
	
	float y_offset =  (_popupRect.size.height/2 - POPUP_ROOT_SIZE.height);
	
	CAKeyframeAnimation *alphaAnimation = [CAKeyframeAnimation	animationWithKeyPath:@"opacity"];
	alphaAnimation.values = [NSArray arrayWithObjects:
							 [NSNumber numberWithFloat:1],
							 [NSNumber numberWithFloat:0],
							 nil];
	alphaAnimation.keyTimes = [NSArray arrayWithObjects:
							   [NSNumber numberWithFloat:0],
							   [NSNumber numberWithFloat:1],
							   nil];
	
	CATransform3D tm1, tm2;
	if (_direction & FEPopupViewUp)
    {
		tm1 = CATransform3DMakeTranslation(_horizontalOffset * (1 - r1), y_offset * (1 - r1), 0);
		tm2 = CATransform3DMakeTranslation(_horizontalOffset * (1 - r2), y_offset * (1 - r2), 0);
	}
	else
    {
		tm1 = CATransform3DMakeTranslation(_horizontalOffset * (1 - r1), -y_offset * (1 - r1), 0);
		tm2 = CATransform3DMakeTranslation(_horizontalOffset * (1 - r2), -y_offset * (1 - r2), 0);
		
	}
	tm1 = CATransform3DScale(tm1, r1, r1, 1);
	tm2 = CATransform3DScale(tm2, r2, r2, 1);
	
	positionAnimation.values = [NSArray arrayWithObjects:
								[NSValue valueWithCATransform3D:tm1],
								[NSValue valueWithCATransform3D:tm2],
								nil];
	positionAnimation.keyTimes = [NSArray arrayWithObjects:
								  [NSNumber numberWithFloat:0],
								  [NSNumber numberWithFloat:1.0],
								  nil];
	
	CAAnimationGroup *group = [CAAnimationGroup animation];
    group.removedOnCompletion = NO;
	group.fillMode = kCAFillModeForwards;
	group.animations = [NSArray arrayWithObjects:positionAnimation, alphaAnimation, nil];
	group.duration = DISMISS_ANIMATION_DURATION;
	group.delegate = self;
	
	[self.layer addAnimation:group forKey:@"hoge"];
}

#pragma mark - Drawing

- (void)makePathCircleCornerRect:(CGRect)rect radius:(float)radius popPoint:(CGPoint)popPoint
{
    CGContextRef context = UIGraphicsGetCurrentContext();
	
	if (_direction & FEPopupViewUp)
    {
		rect.size.height -= POPUP_ROOT_SIZE.height;
		
		// get points
		CGFloat minx = CGRectGetMinX( rect ), midx = CGRectGetMidX( rect ), maxx = CGRectGetMaxX( rect );
		CGFloat miny = CGRectGetMinY( rect ), midy = CGRectGetMidY( rect ), maxy = CGRectGetMaxY( rect );
		
		CGFloat popRightEdgeX = popPoint.x + (int)POPUP_ROOT_SIZE.width / 2;
		CGFloat popRightEdgeY = maxy;
		
		CGFloat popLeftEdgeX = popPoint.x - (int)POPUP_ROOT_SIZE.width / 2;
		CGFloat popLeftEdgeY = maxy;
		
		CGContextMoveToPoint(context, minx, midy);
		CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
		CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
		
		
		CGContextAddArcToPoint(context, maxx, maxy, popRightEdgeX, popRightEdgeY, radius);
		CGContextAddLineToPoint(context, popRightEdgeX, popRightEdgeY);
		CGContextAddLineToPoint(context, popPoint.x, popPoint.y);
		CGContextAddLineToPoint(context, popLeftEdgeX, popLeftEdgeY);
		CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
		CGContextAddLineToPoint(context, minx, midy);
		
	}
	else
    {
		rect.origin.y += POPUP_ROOT_SIZE.height;
		rect.size.height -= POPUP_ROOT_SIZE.height;
		
		// get points
		CGFloat minx = CGRectGetMinX( rect ), midx = CGRectGetMidX( rect ), maxx = CGRectGetMaxX( rect );
		CGFloat miny = CGRectGetMinY( rect ), midy = CGRectGetMidY( rect ), maxy = CGRectGetMaxY( rect );
		
		CGFloat popRightEdgeX = popPoint.x + (int)POPUP_ROOT_SIZE.width / 2;
		CGFloat popRightEdgeY = miny;
		
		CGFloat popLeftEdgeX = popPoint.x - (int)POPUP_ROOT_SIZE.width / 2;
		CGFloat popLeftEdgeY = miny;
		
		CGContextMoveToPoint(context, minx, midy);
		CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
		CGContextAddLineToPoint(context, popLeftEdgeX, popLeftEdgeY);
		CGContextAddLineToPoint(context, popPoint.x, popPoint.y);
		CGContextAddLineToPoint(context, popRightEdgeX, popRightEdgeY);
		CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
		CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
		CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	}
}

- (void)makeGrowingPathCircleCornerRect:(CGRect)rect radius:(float)radius
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	rect.origin.y += 1;
	rect.origin.x += 1;
	rect.size.width -= 2;
	
	
    // get points
    CGFloat minx = CGRectGetMinX( rect ), midx = CGRectGetMidX( rect ), maxx = CGRectGetMaxX( rect );
    CGFloat miny = CGRectGetMinY( rect ), midy = CGRectGetMidY( rect );
	
	CGFloat rightEdgeX = minx;
	CGFloat rightEdgeY = midy - 10;
	
	CGFloat leftEdgeX = maxx;
	CGFloat leftEdgeY = midy - 10;
	
    CGContextMoveToPoint(context, rightEdgeX, rightEdgeY);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    CGContextAddLineToPoint(context, leftEdgeX, leftEdgeY);
}

#pragma mark - Override

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	
	if ([self shouldBeDismissedFor:touches withEvent:event] && _peekView != nil)
    {
		[self dismissModal];
		return;
	}
}

- (void)drawRect:(CGRect)rect
{
	
	CGContextRef context = UIGraphicsGetCurrentContext();

#ifdef _CONFIRM_REGION
	CGContextFillRect(context, rect);
	CGContextSetRGBFillColor(context, 1, 0, 0, 1);
	CGContextFillRect(context, popupRect);
	CGContextSetRGBFillColor(context, 1, 1, 0, 1);
	CGContextFillRect(context, contentRect);
#endif
	
	// draw shadow, and base
	CGContextSaveGState(context);
	
	CGContextSetRGBFillColor(context, 0, 0, 0, ALPHA);
//	CGContextSetShadowWithColor (context, CGSizeMake(0, 2), 2, [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5] CGColor]);//去掉阴影
	[self makePathCircleCornerRect:_popupRect radius:CORNER_RADIOUS popPoint:_pointToBeShown];
	CGContextClosePath(context);
	CGContextFillPath(context);
	CGContextRestoreGState(context);

	
	// draw content
	if ([_title length])
    {
		CGContextSetRGBFillColor(context, 1, 1, 1, 1);
		UIFont *font = [UIFont systemFontOfSize:_fontSize];
        
        NSDictionary *attributes = @{NSFontAttributeName: font};
		[_title drawInRect:_contentRect withAttributes:attributes];
	}
	if (_image)
    {
		[_image drawInRect:_contentRect];
	}
}

#pragma mark - dealloc
- (void)dealloc
{
}


@end
