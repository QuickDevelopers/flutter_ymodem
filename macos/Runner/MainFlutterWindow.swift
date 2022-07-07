import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
     let flutterViewController = FlutterViewController.init()
        let windowFrame = self.frame
        self.contentViewController = flutterViewController
        self.setFrame(windowFrame, display: true)
        // 不允许修改窗体大小
        self.setContentSize(NSSize(width: 800,height: 600))
        let window: NSWindow! = self.contentView?.window
        window.styleMask.remove(.resizable)

        YModemChannel(messenger: flutterViewController.engine.binaryMessenger)
        RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
