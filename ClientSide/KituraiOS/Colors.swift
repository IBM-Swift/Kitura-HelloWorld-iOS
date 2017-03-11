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

extension KituraTableViewController {
    class Colors {
        static let Running: UIColor = Colors.hexStringToUIColor(hex: "#7ed321")
        static let Stopped: UIColor = Colors.hexStringToUIColor(hex: "#9b9b9b")
        static let LogBar: UIColor = UIColor(red:CGFloat(32/255.0), green:CGFloat(147/255.0),
                                                                blue:CGFloat(224/255.0), alpha:1.0)
        static let MainStatusBar: UIColor = UIColor(red:CGFloat(32/255.0), green:CGFloat(147/255.0),
                                                                blue:CGFloat(224/255.0), alpha:0.84)

        private static func hexStringToUIColor (hex:String) -> UIColor {
            var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

            if (cString.hasPrefix("#")) {
                cString.remove(at: cString.startIndex)
            }
            if ((cString.characters.count) != 6) {
                return UIColor.gray
            }
            var rgbValue:UInt32 = 0
            Scanner(string: cString).scanHexInt32(&rgbValue)

            return UIColor(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
            )
        }
    }
}
