
import Cocoa

let files = [NSURL(fileURLWithPath: "/etc/hosts")]
NSWorkspace.sharedWorkspace().activateFileViewerSelectingURLs(files)
