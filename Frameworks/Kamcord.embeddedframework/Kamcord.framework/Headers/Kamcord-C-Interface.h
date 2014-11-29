/*!
 *
 * Kamcord-C-Interface.h
 * Copyright (c) 2013 Kamcord. All rights reserved.
 *
 */

#ifndef __KAMCORD_C_INTERFACE_H__
#define __KAMCORD_C_INTERFACE_H__

#ifdef __cplusplus
extern "C" {
#endif
    
    /*
     *
     * The different places a user can share a replay to.
     *
     */
    typedef enum {
        KCShareDestinationFacebook = 0,
        KCShareDestinationTwitter,
        KCShareDestinationYouTube,
        KCShareDestinationEmail,
        KCShareDestinationWeChat,
        KCShareDestinationLine,
    } KCShareDestination;
    
    /*
     *
     *  Deprecated enum, here for compatibility
     *
     */
    __deprecated typedef enum {
        KC_SHARE_TARGET_FACEBOOK = 0,
        KC_SHARE_TARGET_TWITTER,
        KC_SHARE_TARGET_YOUTUBE,
        KC_SHARE_TARGET_EMAIL,
        KC_SHARE_TARGET_WECHAT,
        KC_SHARE_TARGET_LINE,
    } KC_SHARE_TARGET;
    
    /*******************************************************************
     *
     * Kamcord config
     *
     */
    
    /*
     *
     * Returns a C string which is the Kamcord version. You *must*
     * strdup this return value if you want to use it later.
     *
     */
    const char * Kamcord_Version();
    
    /*
     *
     * Automatically disable Kamcord on certain devices. Disabling Kamcord
     * on a device makes all medthod calls on those devices turn into NO-OPs.
     * Call this method before you call any other Kamcord methods.
     *
     * @param   disableiPod4G           Disable Kamcord on iPod1G, 2G, 3G, and 4G.
     * @param   disableiPod5G           Disable Kamcord on iPod5G.
     * @param   disableiPhone3GS        Disable Kamcord on iPhone 3GS.
     * @param   disableiPhone4          Disable Kamcord on iPhone 4.
     * @param   disableiPhone4S         Disable Kamcord on iPhone 4S.
     * @param   disableiPhone5          Disable Kamcord on iPhone 5.
     * @param   disableiPhone5C         Disable Kamcord on iPhone 5C.
     * @param   disableiPhone5S         Disable Kamcord on iPhone 5S.
     * @param   disableiPad1            Disable Kamcord on iPad 1.
     * @param   disableiPad2            Disable Kamcord on iPad 2.
     * @param   disableiPadMini         Disable Kamcord on iPad Mini.
     * @param   disableiPad3            Disable Kamcord on iPad 3.
     * @param   disableiPad4            Disable Kamcord on iPad 4.
     * @param   disableiPadAir          Disable Kamcord on iPad Air.
     *
     */
    void Kamcord_SetDeviceBlacklist(bool disableiPod4G,
                                    bool disableiPod5G,
                                    bool disableiPhone3GS,
                                    bool disableiPhone4,
                                    bool disableiPhone4S,
                                    bool disableiPhone5,
                                    bool disableiPhone5C,
                                    bool disableiPhone5S,
                                    bool disableiPad1,
                                    bool disableiPad2,
                                    bool disableiPadMini,
                                    bool disableiPad3,
                                    bool disableiPad4,
                                    bool disableiPadAir);
    
    /*
    void Kamcord_SetDeviceBlacklist(bool disableiPod4G,
                                    bool disableiPod5G,
                                    bool disableiPhone3GS,
                                    bool disableiPhone4,
                                    bool disableiPhone4S,
                                    bool disableiPhone5,
                                    bool disableiPhone5C,
                                    bool disableiPhone5S,
                                    bool disableiPhone6,
                                    bool disableiPhone6Plus,
                                    bool disableiPad1,
                                    bool disableiPad2,
                                    bool disableiPadMini,
                                    bool disableiPad3,
                                    bool disableiPad4,
                                    bool disableiPadAir);
     */
    
    /*
     *
     * Kamcord initialization. Must be called before you can start recording.
     *
     * @param   developerKey            Your Kamcord developer key.
     * @param   developerSecret         Your Kamcord developerSecret.
     * @param   appName                 The name of your application.
     * @param   parentViewController    The view controller that will present the Kamcord UI.
     *                                  This object must be an instance of UIViewController.
     *
     */
    void Kamcord_Init(const char * developerKey,
                      const char * developerSecret,
                      const char * appName,
                      void * parentViewController);
    
    
    /*
     *
     * Returns true if and only if Kamcord is enabled. Kamcord is by default
     * enabled, but is disabled if any of the following conditions are met:
     *
     *  - The version of iOS is < 5.0
     *  - The device has been blacklisted by Kamcord_SetDeviceBlacklist(...);
     *
     */
    bool Kamcord_IsEnabled();
    
    /*
     *
     * Enable or disable the live voice overlay. Note: enabling Voice Overlay only
     * enables the users to activate voice overlay in the Kamcord settings UI.
     * To activate Voice Overlay on behalf of the user (after you've enabled it with
     * this method), please use Kamcord_ActivateVoiceOverlay(...) below.
     *
     * @param   enabled             Whether to enable or disable the live voiced overlay feature.
     *                              By default, this is disabled.
     *
     */
    void Kamcord_SetVoiceOverlayEnabled(bool eanbled);
    
    /*
     *
     * Returns true if live voice overlay has been enabled.
     *
     */
    bool Kamcord_VoiceOverlayEnabled();
    
    /*
     *
     * Once the voice overlay is enabled, the user can go to the Kamcord UI
     * and activate the voice overlay. You can also do activate/deactivate voice
     * overlay for the user by calling the following method.
     *
     * @param   bool                Whether or not to activate voice overlay recording.
     *
     */
    void Kamcord_ActivateVoiceOverlay(bool activate);
    
    /*
     *
     * Returns true if the user's voice is being recorded on every video.
     *
     */
    bool Kamcord_VoiceOverlayActivated();

    /*******************************************************************
     *
     * Video recording
     *
     */
    
    /*
     *
     * Start video recording.
     *
     */
    void Kamcord_StartRecording();
    
    /*
     *
     * Stop video recording.
     *
     */
    void Kamcord_StopRecording();
    
    /*
     *
     * Pause video recording.
     *
     */
    void Kamcord_Pause();
    
    /*
     *
     * Resume video recording.
     *
     */
    void Kamcord_Resume();
    
    /*
     *
     * Returns true if the video is recording. Note that there might be a slight
     * delay after you call Kamcord_StartRecording() before this method returns true.
     *
     */
    bool Kamcord_IsRecording();
    
    /*
     *
     * Returns true if video recording is currently paused.
     *
     */
    bool Kamcord_IsPaused();
    
    
    /*
     *
     * After every video is recorded (i.e. after you call StopRecording()), you should
     * call this method to set the title for the video in case it is shared.
     *
     * We suggest you set the title to contain some game-specific information such as
     * the level, score, and other relevant game metrics.
     *
     * @param   title   The title of the last recorded video.
     *
     */
    void Kamcord_SetVideoTitle(const char * title);
    
    typedef enum {
        KCMetadataTypeLevel = 0,       // For a level played in the video.
        KCMetadataTypeScore,           // For a score for the video.
        KCMetadataTypeList,            // For a ',' delimited list of values, numerical value if given will apply to all.
        KCMetadataTypeOther = 1000,    // For arbitrary key to value metadata.
    } KCMetadataType;
    
    /*
     *
     * Previous enum, present here and deprecated for compatibility
     *
     */
    __deprecated typedef enum {
        KC_LEVEL = 0,       // For a level played in the video.
        KC_SCORE,           // For a score for the video.
        KC_LIST,            // For a ',' delimited list of values to apply to a key, numerical value if given will apply to all.
        KC_OTHER = 1000,    // For arbitrary key to value metadata.
    } KC_METADATA_TYPE;
    /*
     *
     * Set the ways users can share their videos. You can use this method to choose which
     * forms of social media users will have access to when they go to share a replay. By default
     * the sharing options are Facebook, Twitter, Youtube, Email. You must pass in
     * exactly four valid distinct KC_SHARE_TARGET enums, else nothing will be changed. The order
     * of these parameters will affect how the share options are laid out in the UI.
     *
     * Note: If you select KC_SHARE_TARGET_WECHAT as an option, you *MUST* call 
     *       Kamcord_SetWeChatAppID(...) with a valid WeChat App ID, else your
     *       user will not be able to share to WeChat.
     *
     * @param       target1             The top-left element of the share grid
     * @param       target2             The top-right element of the share grid
     * @param       target3             The bottom-left element of the share grid
     * @param       target4             The bottom-right element of the share grid
     *
     */
    void Kamcord_SetShareTargets(KCShareDestination target1,
                                 KCShareDestination target2,
                                 KCShareDestination target3,
                                 KCShareDestination target4);
    
    /*
     *
     * Set a piece of metadata for the recorded video
     * All metadata is cleared with the start of a recorded video
     *
     * @param       metadataType       The type of metaData (see KC_METADATA_TYPE for more info)
     * @param       displayKey         Describe what the metadata is
     * @param       displayValue       A string representation of the value for this metadata
     * @param       numericValue       A numeric representation of the value for this metadata
     *
     */
    void Kamcord_SetDeveloperMetadata(KCMetadataType metadataType,
                                      const char * displayKey,
                                      const char * displayValue);
    
    void Kamcord_SetDeveloperMetadataWithNumericValue(KCMetadataType metadataType,
                                                      const char * displayKey,
                                                      const char * displayValue,
                                                      double numericValue);
    
    /*
     * Returns true if there is at least one video matching the constraints
     *
     * @param      jsonDictionary           A json serialized dictionary of metadataDisplayKey ->
     *                                      value. A value is either a displayValue or a numericValue
     *                                      see Kamcord_SetDeveloperMetadata* for info
     *
     */
    bool Kamcord_VideoExistsWithMetadataConstraints(const char * jsonDictionary);
    
    
    /*
     * Used to play a video that conforms to the given constraints
     *
     * @param       jsonDictionary        see Kamcord_VideoExistsWithMetadataConstraints for explanation
     * @param     title                  An optional title to be displayed for the video.
     *                                   If NULL is passed in, the title that was shared with the
     *                                   video will be used.
     *
     */
    void Kamcord_ShowVideoWithMetadataConstraints(const char * jsonDictionary, const char * title);
    
    /*
     * Used to play the video with id 'videoID'
     *  
     * @param     videoID                The videoID for the desired video
     * @param     title                  An optional title to be displayed for the video.
     *                                   If NULL is passed in, the title that was shared with the
     *                                   video will be used.
     */
    void Kamcord_ShowVideoWithVideoID(const char * videoID, const char * title);
    
    /*
     *
     * Use this to record the OpenGL frame to video in its currently rendered state.
     * You can use this, for instance, after you draw your game scene but before
     * you draw your HUD. This will result in the recorded video only having
     * the scene without the HUD.
     *
     */
    void Kamcord_CaptureFrame();
    
    /*
     *
     * Set the video quality to standard or trailer. Please do *NOT* release your game
     * with trailer quality, as it makes immensely large videos with only a slight
     * video quality improvement over standard.
     *
     * The default and recommended quality seting is KC_STANDARD_VIDEO_QUALITY.
     *
     * @param   quality     The desired video quality.
     *
     */
    typedef enum {
        KCVideoQualityStandard   = 0,
        KCVideoQualityTrailer    = 1,    // Should only be used to make trailers. Do *NOT* release your game with this setting.
    } KCVideoQuality;
    
    /*
     *
     * Previous enum, present here and deprecated for compatibility
     *
     */
    __deprecated typedef enum {
        KC_STANDARD_VIDEO_QUALITY   = 0,
        KC_TRAILER_VIDEO_QUALITY    = 1,    // Should only be used to make trailers. Do *NOT* release your game with this setting.
    } KC_VIDEO_QUALITY;
    
    void Kamcord_SetVideoQuality(KCVideoQuality videoQuality);
    
    /*
     *
     * For iOS, if you have a custom audio engine that's not OpenAL or FMOD and want to
     * record audio along with the video, please set the audio stream parameters
     * on startup. The audio bytes *MUST* be linear PCM with 1 frame per packet.
     *
     * @param   sampleRate      The number of sample frames per second in the data stream.
     * @param   iOSFormatFlags  The format flags as defined in <CoreAudio/CoreAudioTypes.h>.
     * @param   bytesPerSample  The number of bytes per audio sample. This is typically 2 (16-bit)
     *                          or 4 (32-bit). Do *NOT* account for whether or not the audio
     *                          stream is mono or stereo (i.e. numChannels below is 1 or 2).
     *                          This is the number of bytes per mono channel. If you set
     *                          numChannels below to 2, we will take that into account in
     *                          our internal calculations.
     * @param   numChannels     How many channels are encoded in the input stream.
     *                          Valid values are 1 or 2.
     *
     * As an example, here is the setting that Kamcord's OpenAL implementation uses:
     *
     *      sampleRate      : 44100.0
     *      iosFormatFlags  : kAudioFormatFlagIsSignedInteger | kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked
     *      bytesPerSample  : sizeof(AudioSampleType) (this is equal to 2 bytes per sample)
     *      numChannels     : 2
     *
     *
     */
    void Kamcord_SetAudioStreamDescription(float sampleRate,
                                           unsigned int iOSFormatFlags,
                                           unsigned int bytesPerSample,
                                           unsigned int numChannels);
    
    /*
     *
     * Write the following audio bytes (with the format set by Kamcord_SetAudioStreamDescription)
     * to the video. If no video is being recorded, this method does nothing.
     *
     * @param   data        The pointer to the audio data byte stream.
     * @param   numSamples  The number of audio samples in this data buffer.
     *
     */
    void Kamcord_WriteAudioBytes(void * data, unsigned int numSamples);
    
    /*
     *
     * Set the recorded audio quality. We recommend you use the defaults, which are:
     *
     *     - Num Channels: 2
     *     - Frequency: 44100
     *     - Bitrate: 64000
     *
     * The audio recording settings for single core devices cannot be changed due
     * to performance reasons.
     *
     * @param   numChannels     The number of audio channels in the recording. Can be 1 or 2.
     * @param   frequency       The recording frequency in Hz.
     * @param   bitrate         The recording bitrate in bits per second.
     *
     */
    void Kamcord_SetAudioRecordingProperties(unsigned int numChannels,
                                             unsigned int frequency,
                                             unsigned int bitrate);
    
    /*******************************************************************
     *
     * Kamcord UI
     *
     */
    
    /*
     *
     * Show the Kamcord view, which will let the user share the most
     * recently recorded video.
     *
     */
    void Kamcord_ShowView();
    
    /*
     *
     * Show the watch view, which has a feed of videos shared by other users.
     *
     */
    void Kamcord_ShowWatchView();
    
    /*
     *
     * Shows the Gameplay of the Week view in the default view controller.
     *
     */
    void Kamcord_ShowPushNotifView();
    
    /*******************************************************************
     *
     * Share settings
     *
     */
    
    /*
     *
     * For native iOS 6 Facebook integration, set your Facebook App ID
     * so all Facebook actions will happen through your game's Facebook app.
     *
     * @param   facebookAppID   Your app's Facebook App ID.
     *
     */
    void Kamcord_SetFacebookAppID(const char * facebookAppID);
    
    /*
     *
     * For iOS 6+, if you have a Facebook app you'd like to share from, you can set its
     * Facebook App ID here for native iOS 6 sharing. Setting sharedAuth to YES
     * will give Kamcord access to the app's Facebook auth instead of Kamcord requesting
     * its own permissions. To use sharedAuth, you *MUST* request the publish_actions
     * permission and be using Facebook SDK 3.1 or later. The advantage of sharedAuth is
     * that the user is not prompted for auth again. If you aren't using the Facebook SDK
     * in your game, you can set sharedAuth to NO and we'll take care of things using the
     * Kamcord Facebook app.
     *
     * @param       facebookAppId   The Facebook App ID.
     * @param       sharedAuth      Whether Facebook auth should be shared between the app and Kamcord.
     *
     */
    void Kamcord_SetFacebookAppIDAndShareAuth(const char * facebookAppID, bool useSharedAuth);
    
    /*
     *
     * Optional method that will log Kamcord out of the shared Facebook auth. If Facebook auth
     * sharing is not enabled, this method does nothing. This method should typically be called
     * when the user logs out of Facebook (outside of Kamcord) and if you want to also nullify
     * Kamcord's shared Facebook auth. If not, then the user will still be able to share to Facebook
     * via the shared Facebook auth.
     *
     */
    void Kamcord_LogoutOfSharedFacebookAuth();
    
    /*
     *
     * Sets the WeChat App ID so that you can set it as a share target in the share grid.
     *
     * @param       weChatAppId   The WeChat App ID.
     *
     */
    void Kamcord_SetWeChatAppID(const char * weChatAppID);
    
    /*
     *
     * Set the description for when the user shares to Facebook.
     *
     * @param   description     Your app's description when a user shares a video on Facebook.
     *
     */
    void Kamcord_SetFacebookDescription(const char * description);
    
    /*
     *
     * Set the video description and tags for YouTube.
     *
     * @param   description     The video's description when it's shared on YouTube.
     * @param   tags            The video's tags when it's shared on YouTube.
     *
     */
    void Kamcord_SetYouTubeSettings(const char * description,
                                    const char * tags);

    /*
     *
     * Set the default tweet.
     *
     * @param   tweet           The default tweet.
     *
     */
    void Kamcord_SetDefaultTweet(const char * tweet);
    
    /*
     *
     * The Twitter description for the embedded video.
     *
     * @param   twitterDescription  The twitter description for the embedded video.
     *
     */
    void Kamcord_SetTwitterDescription(const char * twitterDescription);

    /*
     *
     * Set the default email subject.
     *
     * @param   subject         The default subject if the user shares via email.
     *
     */
    void Kamcord_SetDefaultEmailSubject(const char * subject);

    /*
     *
     * Set the default email body.
     *
     * @param   body            The default email body if the user shares via email.
     *
     */
    void Kamcord_SetDefaultEmailBody(const char * body);
    
    
    /*******************************************************************
     * 
     * Sundry Methods
     *
     */
    
    /*
     *
     * Set the FPS of the recorded video. Valid values are 30 and 60 FPS.
     * The default setting is 30 FPS.
     *
     * @param   videoFPS        The recorded video's FPS.
     *
     */
    void Kamcord_SetVideoFPS(int videoFPS);
    
    /*
     *
     * Returns the FPS of the recorded video.
     *
     */
    int Kamcord_VideoFPS();
    
    /*
     *
     * To prevent videos from becoming too long, you can use this method
     * and Kamcord will only record the last given seconds of the video.
     *
     * For instance, if you set seconds to 300, then only the last 5 minutes
     * of video will be recorded and shared. The default setting is 300 seconds
     * with a maximum of up to 1 hour = 60 * 60 = 3600 seconds.
     *
     * @param   seconds         The maximum length of a recorded video.
     *
     */
    void Kamcord_SetMaximumVideoLength(unsigned int seconds);
    
    /*
     *
     * Returns the maximum video length.
     *
     */
    unsigned int Kamcord_MaximumVideoLength();
    
    /*
     *
     * Should we pause/unpause the game engine when the Kamcord UI appears/disappears?
     * By default, set to true. Works for cocos2d(-x), GLKit, SpriteKit, and Unity.
     *
     * @param   shouldPause     Should we pause the game engine when the Kamcord UI appears?
     *
     */
    void Kamcord_SetShouldPauseGameEngine(bool shouldPause);
    bool Kamcord_ShouldPauseGameEngine();
    
    /*
     *
     * Requires users to verify they are old enough before allowing them to turn on voice overlay.
     *
     * @param       restricted  Require age check before allowing the user to enable voice overlay?
     *
     */
    void Kamcord_SetAgeRestrictionEnabled(bool restricted);
    
    /*
     *
     * Returns a boolean indicating whether or not the user is required to be of age in order
     * to use turn on voice overlay.
     *
     */
    bool Kamcord_IsAgeRestrictionEnabled();
    
    /*******************************************************************
     *
     * Gameplay of the week
     *
     */
    
    /*
     *
     * Enable automatic gameplay of the week push notifications.
     *
     * @param   notificationsEnabled    Enable video push notifications?
     *
     */
    void Kamcord_SetNotificationsEnabled(bool notificationsEnabled);
    
    /*
     *
     * Fire a test gameplay of the week push notfication.
     *
     */
    void Kamcord_FireTestNotification();
    
    /*******************************************************************
     *
     * OpenGL (if using KamcordRecorder and a custom game engine)
     *
     */
    
    /*
     *
     * Returns the current framebuffer that the engine should render to if it wants
     * the results of that render to appear on the screen.
     *
     * @returns The active framebuffer.
     *
     */
    int KamcordRecorder_ActiveFramebuffer();
    
    /*******************************************************************
     *
     * Deprecated methods
     *
     */
    
    /*
     * As of 1.7.3, this has been deprecated in favor of setDeveloperMetadata:...
     *
     * The metadata documentation can be found here: https://github.com/kamcord/kamcord-ios-sdk/wiki/Kamcord-Settings-and-Features#general-video-metadata
     *
     * Set the level and score for the recorded video.
     * This metadata is used to rank videos in the watch view.
     *
     * @param   level   The level for the last recorded video.
     * @param   score   The score the user just achieved on the given level.
     *
     */
    void Kamcord_SetLevelAndScore(const char * level, double score) __deprecated;
    
    /*******************************************************************
     *
     * Private API
     *
     */
    void Kamcord_SetMode(long long unsigned mode);
    
#ifdef __cplusplus
}
#endif

#endif
