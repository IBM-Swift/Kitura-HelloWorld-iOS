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

import Foundation
import UIKit

class Log {
    weak var mainViewController: KituraTableViewController?
    weak var logViewController: LogViewController?
    var full = "Kitura IOS App started!\n" {
        didSet {
            updateTextView(textView: mainViewController?.kituraOutputTextView, text: full)
            updateTextView(textView: logViewController?.logTextView, text: full)
        }
    }

    private func updateTextView(textView: UITextView?, text: String, shouldScroll: Bool = true) {
        if let textView = textView {
            textView.text = text
            if shouldScroll {
                let range = NSMakeRange((textView.text.characters.count) - 1, 0)
                textView.scrollRangeToVisible(range)
                textView.isScrollEnabled = false //workaround to autoscrolling bug
                textView.isScrollEnabled = true
            }
        }
    }
}
