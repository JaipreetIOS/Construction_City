#import "UIImageView+WebCache.h"
#import "objc/runtime.h"
#import "UIView+WebCacheOperation.h"
#import "UCZProgressView.h"
#import "UIImage+Extra.h"

static char imageURLKey;
static char TAG_ACTIVITY_INDICATOR;
static char TAG_UCZProgressView;
static char TAG_ACTIVITY_STYLE;
static char TAG_ACTIVITY_SHOW;
@implementation UIImageView (WebCache)

- (void)sd_setImageWithURL:(NSURL *)url {
    [self sd_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil];
}
-(void)ReloadImageWithUrl:(NSString*)url
{
    __block UIImageView *img = self;
    for (UIView *w in self.subviews) {
        [w removeFromSuperview];
    }
    if([[SDWebImageManager sharedManager] cachedImageExistsForURL:[NSURL URLWithString:url]])
    {
        UIImage *image = [[SDWebImageManager sharedManager] imageForcachedURL:[NSURL URLWithString:url]];
        img.image = image;
        for (UIView *vv in self.subviews)
        {
            if ([vv isKindOfClass:[UCZProgressView class]])
            {
                [vv removeFromSuperview];
            }
            else if ([vv isKindOfClass:[UIActivityIndicatorView class]])
            {
                [vv removeFromSuperview];
            }
        }
    }
    else{
        [self sd_setImageWithURL:[NSURL URLWithString:url] ProgressViewLarge:YES view:nil color:[UIColor blackColor] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!error) {
                [[SDWebImageManager sharedManager] saveImageToCache:image forURL:imageURL];
                img.image = image;
            }
        }];
    }
    
}


-(void)ReloadImageProgressWithUrl:(NSString *)url completed:(SDWebImageCompletionBlock)completedBlock

{
    __block UIImageView *img = self;
    for (UIView *w in self.subviews) {
        [w removeFromSuperview];
    }
    if([[SDWebImageManager sharedManager] cachedImageExistsForURL:[NSURL URLWithString:url]])
    {
        UIImage *image = [[SDWebImageManager sharedManager] imageForcachedURL:[NSURL URLWithString:url]];
        img.image = image;
        for (UIView *vv in self.subviews)
        {
            if ([vv isKindOfClass:[UCZProgressView class]])
            {
                [vv removeFromSuperview];
            }
            else if ([vv isKindOfClass:[UIActivityIndicatorView class]])
            {
                [vv removeFromSuperview];
            }
        }
        if (completedBlock) {
           
        }
    }
    else{
        [self setImageAndProgressViewWithURL:url withLargeProgressView:YES forView:nil withIndicatorColor:[UIColor blackColor] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!error) {
                [[SDWebImageManager sharedManager] saveImageToCache:image forURL:imageURL];
                img.image = image;
                if (completedBlock) {
                    completedBlock(image, error, cacheType, imageURL);
                }
            }
        }];
    }
}

-(void)ReloadImageProgressWithUrl:(NSString*)url
{
    __block UIImageView *img = self;
    for (UIView *w in self.subviews) {
        [w removeFromSuperview];
    }
    
    if([[SDWebImageManager sharedManager] cachedImageExistsForURL:[NSURL URLWithString:url]])
    {
        UIImage *image = [[SDWebImageManager sharedManager] imageForcachedURL:[NSURL URLWithString:url]];
        img.image = image;
        
        for (UIView *vv in self.subviews)
        {
            if ([vv isKindOfClass:[UCZProgressView class]])
            {
                [vv removeFromSuperview];
            }
            else if ([vv isKindOfClass:[UIActivityIndicatorView class]])
            {
                [vv removeFromSuperview];
            }
        }
    }
    else{
        [self setImageAndProgressViewWithURL:url withLargeProgressView:YES forView:nil withIndicatorColor:[UIColor blackColor] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!error)
            {
                [[SDWebImageManager sharedManager] saveImageToCache:image forURL:imageURL];
                img.image = image;
            }
        }];
    }    
}
- (void)sd_setImageWithURL:(NSURL *)url ProgressViewLarge:(BOOL)isLarge view:(UIView*)view color:(UIColor*)color completed:(SDWebImageCompletionBlock)completedBlock{
    
    [self addActivityIndicator];
    [self sd_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self removeActivityIndicator];
        if (completedBlock) {
            completedBlock(image,error,cacheType,imageURL);
        }
    }];
}

- (void)setImageAndProgressViewWithURL:(NSString*)url withLargeProgressView:(BOOL)isLarge forView:(UIView*)view withIndicatorColor:(UIColor*)color completed:(SDWebImageCompletionBlock)completedBlock
{
    //Set Default View as self frame
    UIView *viewToCenterIndicator = self;

    if (view)
    {
        viewToCenterIndicator = view;
    }

    [self addUCZIndicator];

    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil options:SDWebImageProgressiveDownload progress:^(float receivedSize, float expectedSize) {

        if (self.uczIndicator)
        {
            [self.uczIndicator setProgress:receivedSize/expectedSize animated:YES];
        }

    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if(!error)
        {
            [self.uczIndicator setProgress:1.0 animated:true];
            [self removeUczIndicator];

        }
        else
        {
                self.image = nil;
            [self.uczIndicator setProgress:1.0 animated:true];
            [self removeUczIndicator];
        }
        if (completedBlock) {
            completedBlock(image,error,cacheType,imageURL);
        }
    }];

}

-(void)layoutSubviews
{
    if (self.uczIndicator) {
        self.uczIndicator.frame = self.bounds;
    }
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:nil];
}

- (void)sd_setImageWithURL:(NSURL *)url completed:(SDWebImageCompletionBlock)completedBlock {
    [self sd_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:completedBlock];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:completedBlock];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:completedBlock];
}

- (void)sd_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock {
    [self sd_cancelCurrentImageLoad];

    objc_setAssociatedObject(self, &imageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    if (!(options & SDWebImageDelayPlaceholder)) {
        self.image = placeholder;
    }
    
    if (url) {
        __weak UIImageView *wself = self;
        id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            dispatch_main_sync_safe(^{
                if (!wself) return;
                if (image) {
                    wself.image = image;
                    [wself setNeedsLayout];
                } else {
                    if ((options & SDWebImageDelayPlaceholder)) {
                        wself.image = placeholder;
                        [wself setNeedsLayout];
                    }
                }
                if (completedBlock && finished) {
                    completedBlock(image, error, cacheType, url);
                }
            });
        }];
        [self sd_setImageLoadOperation:operation forKey:@"UIImageViewImageLoad"];
    } else {
        dispatch_main_async_safe(^{
            NSError *error = [NSError errorWithDomain:@"SDWebImageErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
            if (completedBlock) {
                completedBlock(nil, error, SDImageCacheTypeNone, url);
            }
        });
    }
}

- (void)sd_setImageWithPreviousCachedImageWithURL:(NSURL *)url andPlaceholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock {
    NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:url];
    UIImage *lastPreviousCachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
    
    [self sd_setImageWithURL:url placeholderImage:lastPreviousCachedImage ?: placeholder options:options progress:progressBlock completed:completedBlock];    
}

- (NSURL *)sd_imageURL {
    return objc_getAssociatedObject(self, &imageURLKey);
}

- (void)sd_setAnimationImagesWithURLs:(NSArray *)arrayOfURLs {
    [self sd_cancelCurrentAnimationImagesLoad];
    __weak UIImageView *wself = self;

    NSMutableArray *operationsArray = [[NSMutableArray alloc] init];

    for (NSURL *logoImageURL in arrayOfURLs) {
        id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:logoImageURL options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            dispatch_main_sync_safe(^{
                __strong UIImageView *sself = wself;
                [sself stopAnimating];
                if (sself && image) {
                    NSMutableArray *currentImages = [[sself animationImages] mutableCopy];
                    if (!currentImages) {
                        currentImages = [[NSMutableArray alloc] init];
                    }
                    [currentImages addObject:image];

                    sself.animationImages = currentImages;
                    [sself setNeedsLayout];
                }
                [sself startAnimating];
            });
        }];
        [operationsArray addObject:operation];
    }

    [self sd_setImageLoadOperation:[NSArray arrayWithArray:operationsArray] forKey:@"UIImageViewAnimationImages"];
}

- (void)sd_cancelCurrentImageLoad {
    [self sd_cancelImageLoadOperationWithKey:@"UIImageViewImageLoad"];
}

- (void)sd_cancelCurrentAnimationImagesLoad {
    [self sd_cancelImageLoadOperationWithKey:@"UIImageViewAnimationImages"];
}

#pragma mark - UIActivityIndicatorView -
- (UIActivityIndicatorView *)activityIndicator {
    return (UIActivityIndicatorView *)objc_getAssociatedObject(self, &TAG_ACTIVITY_INDICATOR);
}

- (void)setActivityIndicator:(UIActivityIndicatorView *)activityIndicator {
    objc_setAssociatedObject(self, &TAG_ACTIVITY_INDICATOR, activityIndicator, OBJC_ASSOCIATION_RETAIN);
}

- (void)setShowActivityIndicatorView:(BOOL)show{
    objc_setAssociatedObject(self, &TAG_ACTIVITY_SHOW, [NSNumber numberWithBool:show], OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)showActivityIndicatorView{
    return [objc_getAssociatedObject(self, &TAG_ACTIVITY_SHOW) boolValue];
}

- (void)setIndicatorStyle:(UIActivityIndicatorViewStyle)style{
    objc_setAssociatedObject(self, &TAG_ACTIVITY_STYLE, [NSNumber numberWithInt:style], OBJC_ASSOCIATION_RETAIN);
}

- (int)getIndicatorStyle{
    return [objc_getAssociatedObject(self, &TAG_ACTIVITY_STYLE) intValue];
}

- (void)addActivityIndicator {
    if (!self.activityIndicator) {
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:[self getIndicatorStyle]];
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        
        dispatch_main_async_safe(^{
            [self addSubview:self.activityIndicator];
            
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1.0
                                                              constant:0.0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1.0
                                                              constant:0.0]];
        });
    }
    
    dispatch_main_async_safe(^{
        [self.activityIndicator startAnimating];
    });
    
}


- (void)removeActivityIndicator {
    if (self.activityIndicator) {
        [self.activityIndicator removeFromSuperview];
        self.activityIndicator = nil;
    }
}
#pragma mark - UCZProgressView -
- (void)removeUczIndicator {
    if (self.uczIndicator) {
        [self.uczIndicator removeFromSuperview];
        self.uczIndicator = nil;
    }
}
- (UCZProgressView *)uczIndicator {
    return (UCZProgressView *)objc_getAssociatedObject(self, &TAG_UCZProgressView);
}
- (void)setUczIndicator:(UCZProgressView *)uczIndicator {
    objc_setAssociatedObject(self, &TAG_UCZProgressView, uczIndicator, OBJC_ASSOCIATION_RETAIN);
}
-(void)addUCZIndicator{
    
    if (!self.uczIndicator)
    {
        self.uczIndicator = [[UCZProgressView alloc] initWithFrame:self.bounds];
        self.uczIndicator.radius*=1;
        self.uczIndicator.showsText=YES;
        self.uczIndicator.textLabel.text=@"Loading...";
        self.uczIndicator.textColor = [UIColor blackColor];
        self.uczIndicator.frame = self.bounds;
        [self addSubview:self.uczIndicator];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.uczIndicator
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0
                                                          constant:0.0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.uczIndicator
                                                         attribute:NSLayoutAttributeLeading
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeading
                                                        multiplier:1.0
                                                          constant:0.0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.uczIndicator
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0
                                                          constant:0.0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.uczIndicator
                                                         attribute:NSLayoutAttributeTrailing
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeTrailing
                                                        multiplier:1.0
                                                          constant:0.0]];
    }
    
    [self.uczIndicator setProgress:0 animated:NO];
    
    
}
@end


@implementation UIImageView (WebCacheDeprecated)

- (NSURL *)imageURL {
    return [self sd_imageURL];
}

- (void)setImageWithURL:(NSURL *)url {
    [self sd_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:nil];
}

- (void)setImageWithURL:(NSURL *)url completed:(SDWebImageCompletedBlock)completedBlock {
    [self sd_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletedBlock)completedBlock {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletedBlock)completedBlock {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletedBlock)completedBlock {
    [self sd_setImageWithURL:url placeholderImage:placeholder options:options progress:progressBlock completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)cancelCurrentArrayLoad {
    [self sd_cancelCurrentAnimationImagesLoad];
}

- (void)cancelCurrentImageLoad {
    [self sd_cancelCurrentImageLoad];
}

- (void)setAnimationImagesWithURLs:(NSArray *)arrayOfURLs {
    [self sd_setAnimationImagesWithURLs:arrayOfURLs];
}
@end
