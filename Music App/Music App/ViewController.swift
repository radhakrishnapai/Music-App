//
//  ViewController.swift
//  Music App
//
//  Created by Pai on 12/08/16.
//  Copyright © 2016 Pai. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController {
    var musicPlayer:MPMusicPlayerController? = nil
    var userMediaItemCollection:MPMediaItemCollection? = nil
    var nowPlayingTimer:NSTimer? = nil
    @IBOutlet weak var timeSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        musicPlayer = MPMusicPlayerController.applicationMusicPlayer()
        musicPlayer?.shuffleMode = MPMusicShuffleMode.Off
        musicPlayer?.repeatMode = MPMusicRepeatMode.None
    }
    
    override func viewWillAppear(animated: Bool) {
        registerForMusicPlayerNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        unregisterFromMusicPlayerNotifications()
    }
}

//MARK: Media Functions

extension ViewController {
    @IBAction func showMediaPicker() {
        let picker = MPMediaPickerController.init(mediaTypes: MPMediaType.AnyAudio)
        picker.delegate = self
        picker.allowsPickingMultipleItems = true
        picker.prompt = NSLocalizedString("Add songs to play", comment: "Prompt in media item picker")
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    @IBAction func playOrPauseMusic(sender: UIButton) {
        
        if let musicPlayer = musicPlayer {
            
            if musicPlayer.playbackState == MPMusicPlaybackState.Playing {
                musicPlayer.pause()
                sender.setTitle("Play", forState: UIControlState.Normal)
            } else {
                
                if let nowPlayingItem = musicPlayer.nowPlayingItem {
                    timeSlider.value = Float(musicPlayer.currentPlaybackTime/nowPlayingItem.playbackDuration)
                }
                else {
                    musicPlayer.setQueueWithQuery(MPMediaQuery.songsQuery())
                    timeSlider.value = 0.0
                }
                
                nowPlayingTimer = NSTimer.scheduledTimerWithTimeInterval(Double(timeSlider.maximumValue - timeSlider.value), target: self, selector: #selector(ViewController.updateSlider), userInfo: nil, repeats: true)
                
                sender.setTitle("Pause", forState: UIControlState.Normal)
                musicPlayer.play()
            }
        }
    }
    
    func updateSlider() {
        dispatch_async(dispatch_get_main_queue()) { 
            if let musicPlayer = self.musicPlayer {
                self.timeSlider.value = Float(musicPlayer.currentPlaybackTime/(musicPlayer.nowPlayingItem?.playbackDuration)!)
            }
        }
    }
    
    @IBAction func skipToNext(sender: AnyObject) {
        musicPlayer?.skipToNextItem()
    }
    
    @IBAction func skipToPrevious(sender: AnyObject) {
        musicPlayer?.skipToPreviousItem()
    }
    
    @IBAction func shuffleToggle(sender: UIButton) {
        if let musicPlayer = musicPlayer {
            switch musicPlayer.shuffleMode {
            case MPMusicShuffleMode.Default:
                musicPlayer.shuffleMode = MPMusicShuffleMode.Songs
                sender.setTitle("Shuffle Songs", forState: UIControlState.Normal)
                break
            case MPMusicShuffleMode.Songs:
                musicPlayer.shuffleMode = MPMusicShuffleMode.Albums
                sender.setTitle("Shuffle Albums", forState: UIControlState.Normal)
                break
            case MPMusicShuffleMode.Albums:
                musicPlayer.shuffleMode = MPMusicShuffleMode.Off
                sender.setTitle("Shuffle Off", forState: UIControlState.Normal)
                break
            case MPMusicShuffleMode.Off:
                musicPlayer.shuffleMode = MPMusicShuffleMode.Default
                sender.setTitle("Shuffle", forState: UIControlState.Normal)
                break
            }
        }
    }
    
    @IBAction func repeatToggle(sender: UIButton) {
         if let musicPlayer = musicPlayer {
            switch musicPlayer.repeatMode {
            case MPMusicRepeatMode.Default:
                musicPlayer.repeatMode = MPMusicRepeatMode.One
                sender.setTitle("Repeat One", forState: UIControlState.Normal)
                break
            case MPMusicRepeatMode.One:
                musicPlayer.repeatMode = MPMusicRepeatMode.All
                sender.setTitle("Repeat All", forState: UIControlState.Normal)
                break
            case MPMusicRepeatMode.All:
                musicPlayer.repeatMode = MPMusicRepeatMode.None
                sender.setTitle("Repeat Off", forState: UIControlState.Normal)
                break
            case MPMusicRepeatMode.None:
                musicPlayer.repeatMode = MPMusicRepeatMode.Default
                sender.setTitle("Repeat", forState: UIControlState.Normal)
                break
            }
        }
    }
    
    @IBAction func seekBackward(sender: AnyObject) {
        musicPlayer?.beginSeekingBackward()
    }
    
    @IBAction func seekForward(sender: AnyObject) {
        musicPlayer?.beginSeekingForward()
    }
    
    @IBAction func endSeeking(sender: AnyObject) {
        musicPlayer?.endSeeking()
    }
    
    @IBAction func setTimelinePosition(sender: AnyObject) {
        nowPlayingTimer?.invalidate()
        dispatch_async(dispatch_get_main_queue()) {
        if let timeInterval = self.musicPlayer?.nowPlayingItem?.playbackDuration {
            self.musicPlayer?.currentPlaybackTime = timeInterval * Double(self.timeSlider.value)
            self.nowPlayingTimer = NSTimer.scheduledTimerWithTimeInterval(Double(self.timeSlider.maximumValue - self.timeSlider.value), target: self, selector: #selector(ViewController.updateSlider), userInfo: nil, repeats: true)
        }
        }
    }
}

//MARK: Notifications

extension ViewController {
    func registerForMusicPlayerNotifications() {
        if let musicPlayer = musicPlayer {
            let notificationCenter = NSNotificationCenter.defaultCenter()
            notificationCenter.addObserver(self, selector: #selector(ViewController.nowPlayingItemDidChangeWithNotification), name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification, object: musicPlayer)
            notificationCenter.addObserver(self, selector: #selector(ViewController.playbackStateDidChangeWithNotification), name: MPMusicPlayerControllerPlaybackStateDidChangeNotification, object: musicPlayer)
            notificationCenter.addObserver(self, selector: #selector(ViewController.volumeDidChangeWithNotification), name: MPMusicPlayerControllerVolumeDidChangeNotification, object: musicPlayer)
            musicPlayer.beginGeneratingPlaybackNotifications()
        }
    }
    
    func unregisterFromMusicPlayerNotifications() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self, name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification, object: musicPlayer)
        notificationCenter.removeObserver(self, name: MPMusicPlayerControllerPlaybackStateDidChangeNotification, object: musicPlayer)
        notificationCenter.removeObserver(self, name: MPMusicPlayerControllerVolumeDidChangeNotification, object: musicPlayer)
        musicPlayer?.endGeneratingPlaybackNotifications()
    }

    func nowPlayingItemDidChangeWithNotification(notification:NSNotification) {
        
    }
    
    func playbackStateDidChangeWithNotification(notification:NSNotification) {
        
    }
    
    func volumeDidChangeWithNotification(notification:NSNotification) {
        
    }
}


//MARK: Media Picker Delegate

extension ViewController:MPMediaPickerControllerDelegate {
    
    func mediaPicker(mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.updateMediaQueueWithCollection(mediaItemCollection)
    }
    
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func updateMediaQueueWithCollection(collection:MPMediaItemCollection?) {
        if (collection != nil) {
            if userMediaItemCollection == nil {
                userMediaItemCollection = collection
                musicPlayer?.setQueueWithItemCollection(userMediaItemCollection!)
                musicPlayer?.play()
            } else {
                var wasPlaying = false
                
                if musicPlayer?.playbackState == MPMusicPlaybackState.Playing {
                    wasPlaying = true
                }
                var newItems = [MPMediaItem]()
                var oldItems = [MPMediaItem]()
                
                if let items = collection?.items {
                    newItems.appendContentsOf(items)
                }
                
                if let items = userMediaItemCollection?.items {
                    oldItems.appendContentsOf(items)
                }
                
                oldItems.appendContentsOf(newItems)
                
                let nowPlayingItem = musicPlayer?.nowPlayingItem
                let currentPlaybackTime = musicPlayer?.currentPlaybackTime
                userMediaItemCollection = MPMediaItemCollection(items: oldItems)
                musicPlayer?.setQueueWithItemCollection(userMediaItemCollection!)
                musicPlayer?.nowPlayingItem = nowPlayingItem
                musicPlayer?.currentPlaybackTime = currentPlaybackTime!
                
                if wasPlaying {
                    musicPlayer?.play()
                }
            }
        }
    }
}

