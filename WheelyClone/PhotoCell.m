//
//  PhotoCell.m
//  WheelyClone
//
//  Created by Vitaly Berg on 19/04/15.
//  Copyright (c) 2015 Vitaly Berg. All rights reserved.
//

#import "PhotoCell.h"
#import "NSObject+JSON.h"
#import <HexColors/HexColor.h>
#import <SDWebImage/SDWebImageManager.h>

@interface PhotoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) id<SDWebImageOperation> operation;

@end

@implementation PhotoCell

- (void)fillPhoto:(id)photo {
    self.contentView.backgroundColor = [UIColor colorWithHexString:[photo[@"image"][@"color"] json_string]];
    self.photoImageView.alpha = 0;
    
    [self.operation cancel];
    
    __weak typeof(self) wself = self;
    
    NSURL *url = [NSURL URLWithString:photo[@"image"][@"url"]];
    self.operation = [[SDWebImageManager sharedManager] downloadImageWithURL:url options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (!wself) {
            return;
        }
        
        if (image) {
            wself.photoImageView.image = image;
            
            if (cacheType == SDImageCacheTypeNone) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.25 animations:^{
                        wself.photoImageView.alpha = 1;
                    } completion:^(BOOL finished) {
                    }];
                });
            } else {
                wself.photoImageView.alpha = 1;
            }
        }
    }];
}

+ (UINib *)nib {
    return [UINib nibWithNibName:@"PhotoCell" bundle:nil];
}

@end
