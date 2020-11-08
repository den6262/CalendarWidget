
import Combine
import SwiftUI
import WidgetKit
import Foundation
import Apps4World

// MARK: - Main manager to handle data for app and widget
class WidgetManager: WidgetConfigurator, ObservableObject {
    
    /// Default initializer will retrieve all configurations
    override init() {
        super.init()
        retrieveWidgetConfigurations(appGroupId: Constants.appGroupId)
    }
    
    /// Font for the calendar text elements
    @Published public var selectedFont: String = "Arial"
    
    /// Text color index based on the colors array mentioned below
    @Published public var selectedTextColorIndex: Int = 0
    
    /// Text alignment in the widget
    @Published public var widgetTextAlignment: HorizontalAlignment = .leading
    
    @Published public var drawingImg: UIImage?
    
    /// Text alignment index for the picker
    @Published public var widgetTextAlignmentIndex: Int = 0
    
    /// Array of color index for the widget gradient
    @Published public var widgetGradientColors: [Int] = [2, 5]
    
    /// Background image
    @Published public var backgroundImage: UIImage?
    
    var img: UIImage?
    
    /// Background image opacity
    @Published public var isAlpha: Bool = true
    
    /// Main colors for the widget text and gradient
    var colors: [Color] {[
        Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),
        Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)), Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)),
        Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)), Color(#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)),
        Color(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)), Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)), Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)), Color(#colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)),
        Color(#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)), Color(#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)), Color(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)), Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)),
        Color(#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)), Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)), Color(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)), Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)),
        Color(#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)), Color(#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)), Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)), Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))
    ]}
    
    /// Main fonts for the widget text elements
    var fonts: [String] {[
        "Arial", "Papyrus", "Kefa", "Futura", "Party LET", "Copperplate", "Gill Sans", "Marker Felt", "Courier New",
        "Georgia", "Arial Rounded MT Bold", "Chalkboard SE", "Academy Engraved LET"
    ]}
    
    // MARK: - Read only properties for the widget
    var textFont: String {
        selectedFont
    }
    
    var textColor: Color {
        colors[selectedTextColorIndex]
    }
    
    var textAlignment: HorizontalAlignment {
        widgetTextAlignment
    }
    
    func dateComponent(_ component: Calendar.Component) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = component == .month ? "MMMM, d" : "EEEE"
        return dateFormatter.string(from: Date())
    }
    
    
    // MARK: - Public update widget functions
    override func updateTextAlignment(index: Int, saveConfigurations: Bool = true) {
        if index == 0 { widgetTextAlignment = .leading }
        else if index == 1 { widgetTextAlignment = .center }
        else if index == 2 { widgetTextAlignment = .trailing }
        if saveConfigurations { updateWidgetConfigurations() }
    }
    
    func updateTextColor(index: Int) {
        selectedTextColorIndex = index
        updateWidgetConfigurations()
    }
    
    func updateTextFont(index: Int) {
        selectedFont = fonts[index]
        updateWidgetConfigurations()
    }
    
    func updateOpacity(bool: Bool) {
        self.isAlpha = bool
    }
    
    func updateGradientSelection(index: Int) {
        if widgetGradientColors[0] == index {
            widgetGradientColors[1] = index
        } else {
            widgetGradientColors[0] = index
        }
        updateWidgetConfigurations()
    }
    
    func updateBackgroundImage(_ image: UIImage?) {
        DispatchQueue.main.async {
            self.backgroundImage = image
            self.updateWidgetConfigurations()
        }
    }
    
    var isShowGradientInfo: Bool {
        if !UserDefaults.standard.bool(forKey: "gradientTips") {
            UserDefaults.standard.setValue(true, forKey: "gradientTips")
            UserDefaults.standard.synchronize()
            return true
        }
        return false
    }
    
    
    // MARK: - Widget configurations
    override func updateWidgetConfigurations(data: [WidgetConfigurator.WidgetDataType : Any]? = nil) {
        let configurations: [WidgetConfigurator.WidgetDataType: Any] = [
            .font : selectedFont, .textColor : selectedTextColorIndex, .textAlignment : widgetTextAlignmentIndex,
            .gradient : widgetGradientColors, .appGroupId : Constants.appGroupId, .image: backgroundImage ?? 0
        ]
        super.updateWidgetConfigurations(data: configurations)
    }
    
    override func configure(data: [WidgetConfigurator.WidgetDataType : Any]) {
        selectedFont = data[.font] as? String ?? "Arial"
        selectedTextColorIndex = data[.textColor] as? Int ?? 0
        widgetTextAlignmentIndex = data[.textAlignment] as? Int ?? 0
        widgetGradientColors = data[.gradient] as? [Int] ?? [2, 3]
        backgroundImage = data[.image] as? UIImage
    }
}

extension UIImage {

    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
