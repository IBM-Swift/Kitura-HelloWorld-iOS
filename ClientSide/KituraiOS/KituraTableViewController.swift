/*
 * Copyright IBM Corporation 2017
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import UIKit
import Kitura
import HeliumLogger
import KituraHelloWorld

class KituraTableViewController: UITableViewController {
    @IBOutlet weak var kituraSwitch: UISwitch!
    @IBOutlet weak var ipLabel: UILabel!
    @IBOutlet weak var imageQRCode: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusCell: UITableViewCell!
    @IBOutlet weak var kituraOutputTextView: UITextView!

    private var queue = DispatchQueue(label: "server_thread")
    private var router = Router()
    private var log = Log()
    private let port = 8090
    private let RunningMessage = "RUNNING"
    private let StoppedMessage = "STOPPED"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: false)
        statusCell.selectionStyle = UITableViewCellSelectionStyle.none
        UIApplication.shared.statusBarStyle = .lightContent

        log.mainViewController = self
        displayConnectionInformation()
        initializeKituraServer()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.backgroundColor = Colors.MainStatusBar
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.backgroundColor = nil
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func statusChanged(_ sender: UISwitch) {
        if sender.isOn == true {
            queue.async {
                Kitura.start()
            }
            statusCell.backgroundColor = Colors.Running
            statusLabel.text = RunningMessage
        } else {
            Kitura.stop()
            //Adding http server again ( https://github.com/IBM-Swift/Kitura/issues/1016 )
            Kitura.addHTTPServer(onPort: port, with: router)
            statusCell.backgroundColor = Colors.Stopped
            statusLabel.text = StoppedMessage
        }
    }

    func changeStatus(on: Bool) {
        if on == kituraSwitch.isOn {
            return
        }
        kituraSwitch.isOn = on
        statusChanged(kituraSwitch)
    }

    private func displayConnectionInformation() {
        let networkData = IPUtility.getMyIP()
        if let ip = networkData.ip {
            let url = getUrl(ip: ip, port: "\(port)")
            ipLabel.text = url
            displayQRCodeImage(url: url)
        }
    }

    private func initializeKituraServer() {
        let textViewOutputStream = TextViewOutputStream(Log: log)
        HeliumStreamLogger.use(outputStream: textViewOutputStream)
        router = RouterCreator.create()
        Kitura.addHTTPServer(onPort: port, with: router)
    }

    private func getUrl(ip: String, port: String) -> String {
        return ("http://" + ip + ":" + port)
    }

    private func generateQRImage(url: String) -> CIImage? {
        let urlData = url.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(urlData, forKey: "inputMessage")
            filter.setValue("Q", forKey: "inputCorrectionLevel")
            return filter.outputImage
        }
        return nil
    }

    private func displayQRCodeImage(url: String) {
        if let qrCodeImage = generateQRImage(url: url) {
            let scaleX = imageQRCode.frame.size.width / qrCodeImage.extent.size.width
            let scaleY = imageQRCode.frame.size.height / qrCodeImage.extent.size.height
            let transformedImage = qrCodeImage.applying(CGAffineTransform(scaleX: scaleX, y: scaleY))
            imageQRCode.image = UIImage(ciImage: transformedImage)
        }
    }

    private func prepareBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowLog" {
            if let logViewController = segue.destination as? LogViewController {
                log.logViewController = logViewController
                logViewController.log = log
                prepareBackButton()
                self.navigationController?.navigationBar.tintColor = UIColor.white
                self.navigationController?.navigationBar.barTintColor = Colors.LogBar
                self.navigationController?.navigationBar.titleTextAttributes =
                                                    [NSForegroundColorAttributeName: UIColor.white]
            }
        }
    }
}
