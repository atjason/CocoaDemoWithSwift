
import Cocoa
import Foundation

extension String {
  func encode(_ characterSet: CharacterSet) -> String {
    return self.addingPercentEncoding(withAllowedCharacters: characterSet) ?? self
  }
}

let complexString = "\"#%<>/\\:;?@[]^`{|}"
print("Origional:         \t" + complexString)

// urlHostAllowed      "#%/<>?@\^`{|}
print("urlHostAllowed:    \t" + complexString.encode(.urlHostAllowed))

// urlPathAllowed      "#%;<>?[\]^`{|}
print("urlPathAllowed:    \t" + complexString.encode(.urlPathAllowed))

// urlQueryAllowed     "#%<>[\]^`{|}
print("urlQueryAllowed:   \t" + complexString.encode(.urlQueryAllowed))

// urlUserAllowed      "#%/:<>?@[\]^`
print("urlUserAllowed:    \t" + complexString.encode(.urlUserAllowed))

// urlPasswordAllowed  "#%/:<>?@[\]^`{|}
print("urlPasswordAllowed:\t" + complexString.encode(.urlPasswordAllowed))

// urlFragmentAllowed  "#%<>[\]^`{|}
print("urlFragmentAllowed:\t" + complexString.encode(.urlFragmentAllowed))
