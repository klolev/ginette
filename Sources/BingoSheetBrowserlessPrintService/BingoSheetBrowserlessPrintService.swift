import Foundation
import BingoSheetPrintService

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public struct BingoSheetBrowserlessPrintService: BingoSheetPrintService {
    enum PrintError: Error {
        case httpError(Int)
        case emptyResponse
    }

    private let screenshotURL: URL

    public init(browserlessURL: String = ProcessInfo.processInfo.environment["BROWSERLESS_URL"] ?? "http://localhost:3000") {
        self.screenshotURL = URL(string: "\(browserlessURL)/screenshot")!
    }

    public func print(sheet: BingoSheetPrintInput) async throws -> Data {
        let tileSize = 100
        let width = tileSize * Int(sheet.size) + 50
        let height = tileSize * Int(sheet.size) + 100
        let html = generateHTML(for: sheet, width: width, height: height)

        let body: [String: Any] = [
            "html": html,
            "selector": "#card",
            "options": [
                "type": "jpeg",
                "quality": 90
            ],
            "viewport": ["width": width + 100, "height": height + 100, "deviceScaleFactor": 2],
            "gotoOptions": ["waitUntil": "domcontentloaded"]
        ]

        var request = URLRequest(url: screenshotURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                if let http = response as? HTTPURLResponse, http.statusCode != 200 {
                    continuation.resume(throwing: PrintError.httpError(http.statusCode))
                    return
                }
                continuation.resume(returning: data ?? Data())
            }.resume()
        }
    }

    private func hueAngle(for string: String) -> Int {
        var hash: UInt32 = 2166136261
        for byte in string.utf8 {
            hash ^= UInt32(byte)
            hash = hash &* 16777619
        }
        return Int(hash % 360)
    }

    private func escapeHTML(_ string: String) -> String {
        string
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
    }

    private func generateHTML(for sheet: BingoSheetPrintInput, width: Int, height: Int) -> String {
        let hue = hueAngle(for: sheet.playerName + sheet.gameName)
        let tileSize = 100

        var gridHTML = ""
        for row in 0..<Int(sheet.size) {
            gridHTML += "<div style='display:flex;'>"
            for col in 0..<Int(sheet.size) {
                let tile = sheet.tiles[row + col * Int(sheet.size)]
                let bg = tile.isFilled ? "hsl(\((hue + 340) % 360),82%,65%,0.15)" : "transparent"
                gridHTML += """
                <div style='width:\(tileSize)px;height:\(tileSize)px;border:1px solid rgba(0,0,0,0.2);position:relative;display:flex;align-items:center;justify-content:center;overflow:hidden;background:\(bg);flex-shrink:0;'>
                  <div style='position:absolute;top:0;left:0;font-size:12px;font-weight:bold;font-family:monospace;background:rgba(255,255,255,0.8);border:1px solid rgba(0,0,0,0.1);padding:2px 4px;'>\(escapeHTML(tile.id))</div>
                  <div class='tile-text' style='font-size:24px;font-weight:bold;text-align:center;padding:0 8px;word-break:break-word;color:black;'>\(escapeHTML(tile.value))</div>
                </div>
                """
            }
            gridHTML += "</div>"
        }

        return """
        <!DOCTYPE html>
        <html>
        <head>
        <meta charset='utf-8'>
        <style>*{box-sizing:border-box;margin:0;padding:0;} .emoji{padding:8px;}</style>
        </head>
        <body style='background:transparent;font-family:Arial,Helvetica,sans-serif;'>
        <div id='card' style='width:\(width)px;border-radius:15px;overflow:hidden;background:hsl(\((hue + 340) % 360),82%,65%);text-align:center;padding-bottom:16px;'>
            <div style='display:flex;align-items:center;padding:0 24px;height:90px;text-align:left;'>
              <div style='flex:1;min-width:0;'>
                <div style='color:white;font-size:32px;font-weight:700;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;'>\(escapeHTML(sheet.playerName))</div>
                <div style='color:white;font-size:16px;font-weight:300;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;'>\(escapeHTML(sheet.gameName))</div>
              </div>
              <div style='font-size:36px;width:50px;height:50px;display:flex;align-items:center;justify-content:center;background:rgba(255,255,255,0.2);border-radius:50%;flex-shrink:0;margin-left:12px;'>&#x1F475;</div>
            </div>
            <div style='margin:2px;border:1px solid rgba(0,0,0,0.5);background:white;display:inline-block;'>
              \(gridHTML)
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/@twemoji/api@latest/dist/twemoji.min.js"></script>
        <script>
        twemoji.parse(document.body,{folder:'svg',ext:'.svg'});
        document.querySelectorAll('.tile-text').forEach(el=>{
          const p=el.parentElement;let s=24;
          while(s>7&&(el.scrollHeight>p.clientHeight||el.scrollWidth>p.clientWidth)){s--;el.style.fontSize=s+'px';}
        });
        </script>
        </body>
        </html>
        """
    }
}
