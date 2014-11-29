/*!
 *
 * Kamcord-CPP-Interface.h
 * Copyright (c) 2013 Kamcord. All rights reserved.
 *
 */

#ifndef __KAMCORD_CPP_INTERFACE_H__
#define __KAMCORD_CPP_INTERFACE_H__

// For convenience
#import "Kamcord-C-Interface.h"

// Only define for C++
#ifdef __cplusplus

class IKamcordDelegate;

// Tell Kamcord to send callbacks to a C++ instance that implements IKamcordDelegate
extern "C" {
    void Kamcord_SetDelegate(IKamcordDelegate * delegate);
}

// The C++ interface you must implement in order to receive KamcordDelegate callbacks
// (defined in <Kamcord/KamcordProtocols.h> via C++. Please refer to that file
// for more clarification on what each callback does.
class IKamcordDelegate
{
public:
    
    // Virtual destructor.
    virtual ~IKamcordDelegate() {};
    
    // Kamcord main UI will/did appear/disappear.
    virtual void mainViewWillAppear()       = 0;
    virtual void mainViewDidAppear()        = 0;
    virtual void mainViewWillDisappear()    = 0;
    virtual void mainViewDidDisappear()     = 0;
    
    // Kamcord watch-only view will/did appear/disappear.
    virtual void watchViewWillAppear()      = 0;
    virtual void watchViewDidAppear()       = 0;
    virtual void watchViewWillDisappear()   = 0;
    virtual void watchViewDidDisappear()    = 0;
    
    // When the movie player appears/disappears.
    virtual void moviePlayerDidAppear()     = 0;
    virtual void moviePlayerDidDisppear()   = 0;
    
    // When the share button is pressed.
    // If you want to save the title, you *must* strdup(...) it.
    virtual void shareButtonPressed(const char * title,
                                    bool shareToFacebook,
                                    bool shareToTwitter,
                                    bool shareToYouTube,
                                    bool shareWithEmail) = 0;
    
    // When the video begins to upload.
    // If you want to save the videoID or onlineVideoURL, you *must* strdup(...) them.
    virtual void videoWillUploadToURL(const char * videoID, const char * onlineVideoURL) = 0;
    
    // When the video upload progresses.
    // If you want to save the video ID, you *must* strdup(...) it.
    virtual void videoUploadProgressed(const char * videoID, float progress) = 0;
    
    // When the video upload finishes.
    // If you want to save the video ID, you *must* strdup(...) it.
    virtual void videoFinishedUploading(const char * videoID, bool success) = 0;
    
    // This app install was attributed to Kamcord
    virtual void attributedKamcordInstall() = 0;
};

#endif

#endif
