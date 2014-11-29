//
//  KamcordRecorder.h
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <QuartzCore/QuartzCore.h>

@interface KamcordRecorder : NSObject

/*
 *
 * OpenGL setup. Should be called once before any OpenGL rendering
 * is done.
 */
+ (BOOL)initWithEAGLContext:(EAGLContext *)context
                      layer:(CAEAGLLayer *)layer;

+ (BOOL)initWithEAGLContext:(EAGLContext *)context
                      layer:(CAEAGLLayer *)layer
                   rotation:(int)degrees;

/*
 *
 * Call this method to create framebuffers if you don't use MSAA.
 *
 */
+ (BOOL)createFramebuffers:(GLuint)defaultFramebuffer;

/*
 *
 * Call this method to create framebuffers if you use MSAA.
 *
 */
+ (BOOL)createFramebuffers:(GLuint)defaultFramebuffer
           msaaFramebuffer:(GLuint)msaaFramebuffer;

/*
 *
 * Call this method to create framebuffers without MSAA.
 * The resulting video will be cropped to the given boundaries.
 *
 */
+ (BOOL)createFramebuffers:(GLuint)defaultFramebuffer
                boundaries:(CGRect)boundaries;

/*
 *
 * Call this method to create framebuffers with MSAA.
 * The resulting video will be cropped to the given boundaries.
 *
 */
+ (BOOL)createFramebuffers:(GLuint)defaultFramebuffer
           msaaFramebuffer:(GLuint)msaaFramebuffer
                boundaries:(CGRect)boundaries;

/*
 *
 * Call this method to create framebuffers where the size of the screen
 * isn't equal to the size of the primary buffer. For the target size,
 * pass in the desired size of the primary buffer.
 *
 */
+ (BOOL)createFramebuffers:(GLuint)defaultFramebuffer
           msaaFramebuffer:(GLuint)msaaFramebuffer
               primarySize:(CGSize)primarySize;

/*
 *
 * Call this alongside any code you have that deletes your framebuffers.
 *
 */
+ (void)deleteFramebuffers;


/*
 *
 * Call every render loop before [context presentRenderbuffer:GL_RENDERBUFFER].
 * Pass the OpenGL framebuffer to which the renderbuffer you are presenting
 * is attached.  Returns NO on failure or if Kamcord is disabled.
 *
 * If you don't pass in a framebuffer, the default framebuffer is used.
 *
 */
+ (BOOL)beforePresentRenderbuffer:(GLuint)framebuffer;
+ (BOOL)beforePresentRenderbuffer;

/*
 *
 * Call every render loop after [context presentRenderbuffer:GL_RENDERBUFFER].
 *
 */
+ (BOOL)afterPresentRenderbuffer;

/*
 *
 * Call to capture a frame of video before the call to beforePresentRenderbuffer.
 * For instance if the game has a HUD, call captureFrame before drawing the HUD;
 * the HUD will not appear in the final video.
 *
 */
+ (BOOL)captureFrame;

/*
 *
 * Anywhere in your OpenGL code where you would normally bind your defaultFramebuffer
 * for rendering, instead bind [KamcordRecorder activeFramebuffer].
 *
 */
+ (GLuint)activeFramebuffer;
+ (GLuint)kamcordFramebuffer;   // Deprecated in V 1.6.1 in favor of: - (GLuint)activateFramebuffer;

/*
 *
 * Takes a snapshot of the current screen and returns an UIImage.
 *
 */
+ (UIImage *)snapshot;

/*
 *
 * Takes a snapshot of the next frame and calls back when the frame is captured.
 *
 * Returns YES if a snashot will be taken. Returns NO if you've previously called this
 * but haven't gotten a callback yet.
 *
 * @param   handler         The completion handler once the next frame's snapshot is ready.
 *                          If you passed in a non-nil destinationURL (below), the second
 *                          argument will be the local URL of the image on disk.
 * @param   destinationURL  If non-nil, the snapshot will be saved to the given local URL.
 *
 */
+ (BOOL)snapshotNextFrameWithCompletionHandler:(void(^)(UIImage * image, NSURL * imageURL))handler
                                     saveToURL:(NSURL *)destinationURL;

/*!
 *
 * Set the target video FPS. The default value is 30 FPS.
 *
 * Valid values are 30 or 60. Only newer devices can typically handle 60 FPS.
 *
 */
+ (void)setTargetVideoFPS:(NSUInteger)fps;
+ (NSUInteger)targetVideoFPS;

/*
 *
 * Returns whether KamcordRecorder believes the current frame is recording or not.
 *
 */
+ (BOOL)isRecording;

/*
 *
 * Sets the parent view controller. Identical to calling [Kamcord setParentViewController:...];
 *
 */
+ (void)setParentViewController:(UIViewController *)parentViewController;

@end
