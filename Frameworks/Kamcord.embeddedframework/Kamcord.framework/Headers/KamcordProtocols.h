/*
 *
 * KamcordProtocols.h
 *
 * This declaration contains the KamcordDelegate protocol
 * to receive callbacks about the lifetime of a video.
 *
 */

#import <CoreGraphics/CoreGraphics.h>

/*****************************************************************
 *
 * General Kamcord callbacks
 *
 */
@protocol KamcordDelegate <NSObject>

@optional

/*
 *
 * Called when the Kamcord view appears and disappears.
 *
 */
- (void)mainViewWillAppear;
- (void)mainViewDidAppear;
- (void)mainViewWillDisappear;
- (void)mainViewDidDisappear;

/*
 *
 * Called when the Kamcord watch-only or gameplay of the week view appears and disappears
 *
 */
- (void)watchViewWillAppear;
- (void)watchViewDidAppear;
- (void)watchViewWillDisappear;
- (void)watchViewDidDisappear;

/*
 *
 * Called when the movie player appears and disappears.
 *
 */
- (void)moviePlayerDidAppear;
- (void)moviePlayerDidDisappear;

/*
 *
 * Called when the interstitial player apppears and disappears.
 *
 */
- (void)interstitialPlayerDidAppear;
- (void)interstitialPlayerDidDisappear;

/*
 *
 * Called when a thumbnail image for the video is ready.
 *
 * @param       thumbnail       The CGImageRef of the thumbnail for the latest recorded video.
 *
 */
- (void)thumbnailReady:(CGImageRef)thumbnail;


/*
 *
 * Called when the video has finished processing.
 *
 * @param       success         Success will be true if the video processed successfully.
 *
 */
- (void)videoFinishedProcessing:(BOOL)success;

#if KC_IS_UNITY
/*
 *
 * Called when the thumbnail image for the video is ready.
 *
 * @param       thumbnailFilepath   The local file path to the thumbnail saved to disk.
 *
 */
- (void)thumbnailReadyAtFilePath:(NSString *)thumbnailFilepath;
#endif


- (void)ageStatusUpdated:(NSInteger)status;

/*
 *
 * This is called when the user presses the share button and has successfully
 * authorized with Facebook/Twitter/YouTube. This callback does NOT
 * indicate that the share will successfully begin. The callback below
 * named video:willUploadToURL: indicates that the video will actually
 * begin uploading.
 *
 * @param       user title          The video title that the user entered.
 * @param       facebook            Share to Facebook selected?
 * @param       twitter             Share to Twitter selected?
 * @param       youtube             Share to YouTube selected?
 * @param       email               Share via email selected?
 *
 */
- (void)shareButtonPressedWithUserTitle:(NSString *)userTitle
                        shareToFacebook:(BOOL)facebook
                         shareToTwitter:(BOOL)twitter
                         shareToYouTube:(BOOL)youtube
                         shareWithEmail:(BOOL)email;


/*
 *
 * Called when the video has started uploading.
 *
 * @param       videoID     The Kamcord video ID.
 * @param       videoURL    The web URL of the video once it becomes uploaded.
 *
 */
- (void)  video:(NSString *)videoID
willUploadToURL:(NSString *)videoURL;

/*
 *
 * Called while the video upload is progressing.
 *
 * @param       videoID             The Kamcord video ID.
 * @param       progress            The progress from 0.0 to 1.0.
 *
 */
- (void)   video:(NSString *)videoID
uploadProgressed:(float)progress;

/*
 *
 * Called when the video has finished uploading or failed to upload.
 *
 * @param       videoID             The Kamcord video ID that can be used to query for information
 *                                  about the video.
 * @param       success             Did the video upload successfully? If the value is NO, there
 *                                  was most likely an issue with the connection quality.
 *
 */
- (void)               video:(NSString *)videoID
finishedUploadingWithSuccess:(BOOL)success;

/*
 *
 * Called when a Facebook share completes.
 *
 * @param       videoID             The Kamcord video ID.
 * @param       success             Whether or not the Facebook share was successful.
 *
 */
- (void)      video:(NSString *)videoID
wasSharedToFacebook:(BOOL)success;

/*
 *
 * Called when a Twitter share completes.
 *
 * @param       videoID             The Kamcord video ID.
 * @param       success             Whether or not the Twitter share was successful.
 *
 */
- (void)     video:(NSString *)videoID
wasSharedToTwitter:(BOOL)success;

/*
 *
 * Called when the video WILL be shared to YouTube by the Kamcord servers.
 *
 * @param       videoID             The Kamcord video ID.
 *
 */
- (void)videoWillBeSharedToYouTube:(NSString *)videoID;

/*
 *
 * Called when this app install is attributed from a click inside the Kamcord mobile app.
 *
 */
- (void)attributedKamcordInstall;

@end
