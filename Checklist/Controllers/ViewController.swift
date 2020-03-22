

import UIKit

class ViewController: UIViewController {
    var timer = Timer()
    
    var (hours, minutes , seconds) = (0, 0, 0)

   
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startOutlet: UIButton!
    @IBOutlet weak var pauseOutlet: UIButton!
    @IBOutlet weak var stopOutlet: UIButton!
    @IBOutlet var menuButton:UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    @IBAction func start(_ sender: UIButton) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.keepTimer), userInfo:nil, repeats: true)
        startOutlet.isEnabled = false
        pauseOutlet.isEnabled = true
        stopOutlet.isEnabled = true
    }
    
    @IBAction func pause(_ sender: UIButton) {
        timer.invalidate()
        startOutlet.isEnabled = true
        pauseOutlet.isEnabled = false
        stopOutlet.isEnabled = true
        
    }
    
    @IBAction func stop(_ sender: UIButton) {
        timer.invalidate()
        (hours, minutes , seconds) = (0, 0, 0)
        timeLabel.text = "00:00:00"
        startOutlet.isEnabled = true
        pauseOutlet.isEnabled = true
        stopOutlet.isEnabled = false
        
    }
    @objc func keepTimer(){
        seconds += 1
        if seconds == 60 {
            minutes += 1
            seconds = 0
        }
        if minutes == 60 {
            hours += 1
            minutes = 0
        }
        
        let secondsString = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        let minutesString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        let hoursString = hours > 9 ? "\(hours)" : "0\(hours)"
        timeLabel.text = "\(hoursString):\(minutesString):\(secondsString)"
    }
}

