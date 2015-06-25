//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Cody Clingan on 3/24/15.
//  Copyright (c) 2015 Cody Fazio. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        //Hide buttons
        recordButton.enabled = true
        recordingInProgress.hidden = false
        stopButton.hidden = true
        pauseButton.hidden = true
        playButton.hidden = true
        recordingInProgress.text = ("Tap to Record")

    }

       
    @IBAction func recordAudiofromButton(sender: UIButton) {
        //Hide anything from the view not in use
        recordButton.enabled = false
        recordingInProgress.hidden = false
        stopButton.hidden = false
        playButton.enabled = false
        playButton.hidden = false
        pauseButton.hidden = false
        recordingInProgress.text = ("recording")
        recordAudio()
    }
    func recordAudio () {
        //Create path and naming convention for recorded file
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        //Create recording session and began recording
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.meteringEnabled = true
        audioRecorder.delegate = self 
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        //Create segue to effects scene, or reenable recording
        if (flag){
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else {
            println("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //Connect recorded file to effects
        if segue.identifier == "stopRecording" {
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    func createAlert(){
        //Create Action Sheet to display recording options when stop button is pressed
        let actionSheetController: UIAlertController = UIAlertController(title: "Recording Stopped", message: "What would you like to do?", preferredStyle: .ActionSheet)
        
        //Create and add the Cancel action
        let cancelRecording: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            self.audioRecorderDidFinishRecording(self.audioRecorder, successfully: false)
            self.recordingInProgress.text = "Tap to Record"
            self.pauseButton.hidden = true
            self.playButton.hidden = true
            }
            actionSheetController.addAction(cancelRecording)
        //Create use Recording action
        let useRecording: UIAlertAction = UIAlertAction(title: "Use Recording", style: .Default) { action -> Void in
            self.recordingInProgress.hidden = true
            self.audioRecorder.stop()
            var audioSession = AVAudioSession.sharedInstance()
            audioSession.setActive(false, error:nil)
        }
        actionSheetController.addAction(useRecording)
        //Create rerecording action
        let reRecord: UIAlertAction = UIAlertAction(title: "Record Again", style: .Default) { action -> Void in
            self.recordAudio()
        }
        actionSheetController.addAction(reRecord)
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
  

    @IBAction func stopRecording(sender: UIButton) {
            //Display action sheet
            createAlert()
           }
    @IBAction func pauseRecording(sender: UIButton) {
       //Pause recording and reset view with applicable buttons
        self.audioRecorder.pause()
        self.pauseButton.enabled = false
        self.playButton.enabled = true
        self.stopButton.enabled = false
        self.recordingInProgress.text = ("recording paused...")
    }
    
    @IBAction func resumeRecording(sender: UIButton) {
        //Play recording and reset view with applicable buttons
        self.audioRecorder.record()
        self.stopButton.enabled = true
        self.playButton.enabled = false
        self.pauseButton.enabled = true
        self.recordingInProgress.text = ("recording")
    }
    
    
}

