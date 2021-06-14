import UIKit

class MessageDecryptor: NSObject {
    
    func decryptMessage(_ message: String) -> String {
        var decryptedMessage = message;
        
        while(decryptedMessage.contains("[")) {
            let openBracketIndex = decryptedMessage.firstIndex(of: "[")!;
            var repeatCount = ""
            var index = openBracketIndex
            
            if (index > decryptedMessage.startIndex) {
                index = decryptedMessage.index(before: openBracketIndex);
            }
             
            
            if (index > decryptedMessage.startIndex) {
                while let repeatNumber = Int(decryptedMessage[index...index]) {
                    let repeatNumberCharacter = Character(String(repeatNumber));
                    repeatCount.insert(repeatNumberCharacter, at: repeatCount.startIndex);
                    
                    index = decryptedMessage.index(before: index);
                }
            } else {
                repeatCount = String(decryptedMessage[index]);
            }
            
            var openBrackets = 1;
            var closedBrackets = 0;
            index = openBracketIndex;
            
            while(openBrackets - closedBrackets != 0) {
                index = decryptedMessage.index(after: index);
                
                if (decryptedMessage[index] == "[") {
                    openBrackets += 1;
                }
                
                if (decryptedMessage[index] == "]") {
                    closedBrackets += 1;
                }
            }
            
            let msgStartIndex = decryptedMessage.index(after: openBracketIndex);
                
            let msg = decryptedMessage[msgStartIndex..<index];
            let templateToReplace = Array(repeating: msg, count: Int(repeatCount) ?? 1).joined(separator: "");
            let replaceRangeStartIndex = decryptedMessage.index(openBracketIndex, offsetBy: Int(repeatCount) == nil ? 0 : -repeatCount.count)
            
            decryptedMessage.replaceSubrange(replaceRangeStartIndex...index, with: templateToReplace);
            repeatCount = ""
        }

        return decryptedMessage;
    }
}
