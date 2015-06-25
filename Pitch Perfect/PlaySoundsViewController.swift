//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Cody Clingan on 3/24/15.
//  Copyright (c) 2015 Cody Fazio. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
   
    
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl , error: nil)
        audioPlayer.enableRate = true
    
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
    }
    
    func playAudio(rate:Float) {
         audioPlayer.stop()
         audioPlayer.currentTime = 0.0
         audioPlayer.play()
         audioPlayer.rate = rate
         stopButton.hidden = false
         audioEngine.stop()
         audioEngine.reset()
    }
    
    @IBAction func playSlow(sender: UIButton) {
      playAudio(0.5)
    
    }
    
    @IBAction func playFast(sender: UIButton) {
      playAudio(1.5)
     
    }

    @IBAction func stopAudio(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
        stopButton.hidden = true
    }
    @IBAction func playChipmunk(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    func playAudioWithVariablePitch (pitch: Float) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode ()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch ()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        stopButton.hidden = false
        audioPlayerNode.play()
        
    }
    
    
    @IBAction func playDarth(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    func playAudioWithReverb (reverb: Float) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode ()
        audioEngine.attachNode(audioPlayerNode)
        
        var changeReverbEffect = AVAudioUnitReverb ()
        changeReverbEffect.wetDryMix = reverb
        audioEngine.attachNode(changeReverbEffect)
        
        audioEngine.connect(audioPlayerNode, to: changeReverbEffect, format: nil)
        audioEngine.connect(changeReverbEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        stopButton.hidden = false
        audioPlayerNode.play()
        
    }

    
    @IBAction func playReverb(sender: UIButton) {
        playAudioWithReverb(100)
    }
    
    
}
