import Foundation
import CommonCrypto

print("start run script")
// 检查是否有足够的参数
if CommandLine.arguments.count < 2 {
    print("Usage: \(CommandLine.arguments) <url> <httpMethod> <headers> <parameters>")
    exit(EXIT_FAILURE)
}

// 获取第一个参数（索引 1，因为索引 0 是脚本名称）
let parameter = CommandLine.arguments
print("Received parameter: \(parameter)")

var url: String = parameter[1]
var method: String = parameter[2]
var headers: [String: String] = parameter[3].asHeader()
var parameters: [String: Any] = parameter[4].asParams()

func correct(headers: [String: String], params: [String: Any]) -> (headers: [String: String], params: [String: Any]) {
    
    var headers = headers
    var parameters = params
    
    parameters.updateValue([
        "platform": "iPhone",
        "platformVersion": "18",
        "versionName": "2.1.0",
        "versionCode": "1",
        "timezone": "Asia/Shanghai",
        "width": "375",
        "height": "667",
    ], forKey: "client")
    
    let SECRETKEY = "b2zf3etid4beca121xasi9cwkfdc29p"
    
    let time = String(Int(Date().timeIntervalSince1970 * 1000))
    let string = parameters.toJsonString() + SECRETKEY + time
    
    let sign = string.md5
    print("parameters.toJsonString() == ", parameters.toJsonString())
    print("string = ",string)
    print("sign = ",sign)
    let token = "Ak+LXVNQVAMDUndoYHsK.Ak8NUEBQVBAoMHJgYWxFSExBRlRMAkwbKzl0bWdqQkNAWEgTVh0KAyUjOQVwKxIWEB4QVEYmB0x6XWBjY25GQUBeUQMNR1sRKC0eeycqEgMwCTgTDkBfF2IjPw==.z4UJm3rdQiKDc9onU9FC8XkhelqnmltT/LediF6hcsrAbCr1kdhBVpuN5BIV3cwEmPnMAivOrKw0c1tXr++U6w=="
    
    headers.updateValue(time, forKey: "Time")
    headers.updateValue(sign.uppercased(), forKey: "Sign")
    headers.updateValue(token, forKey: "Token")
    headers.updateValue("application/json", forKey: "Content-Type")
    //        headers.updateValue(userAgent, forKey: "User-Agent")
    return (headers, parameters)
}

func makeRequest(urlString: String, method: String) {
    var request = URLRequest(url: URL(string: urlString)!, timeoutInterval: Double.infinity)
    let headerDict = rlt.headers
    
    
    request.httpBody = rlt.params.toData()
    for (key,value) in headerDict {
        request.addValue(value, forHTTPHeaderField: key)
    }
    
    request.httpMethod = method
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else {
            print("返回值 data = nil, response = \(response)")
            
            if let error = error {
                print(["response": error.localizedDescription].toJsonString())
            }
            // 任务失败，释放信号
            semaphore.signal()
            return
        }
        
        var sucString = String(data: data, encoding: .utf8)!
        if sucString.isEmpty {
            sucString = response?.description ?? "请求完成，返回数据为空"
        }
        print("请求成功,结果如下:\n",sucString)
        print(["response": sucString].toJsonString())
        // 任务完成，释放信号
        semaphore.signal()
    }
    
    task.resume()
}

let rlt = correct(headers: headers, params: parameters)
let result = ["headers": rlt.0, "parameters": rlt.1]

let semaphore = DispatchSemaphore(value: 0)
makeRequest(urlString: url, method: method)
semaphore.wait()  // 等待信号

// ------------------- extensions --------------------

extension String {
    func asHeader() -> [String: String] {
        if isEmpty { return [:] }
        if let data =  data(using: .utf8) {
            do {
                let dict = try JSONSerialization.jsonObject(with: data) as? [String: String]
                return dict ?? ["error": "header 转换失败"]
            } catch {
                return ["error": error.localizedDescription]
            }
        }
        return [:]
    }
    
    func asParams() -> [String: Any] {
        if isEmpty { return [:] }
        if let data =  data(using: .utf8) {
            do {
                let dict = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                return dict ?? ["error": "params 转换失败"]
            } catch {
                return ["error": error.localizedDescription]
            }
        }
        return [:]
    }
    
    var md5: String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.deallocate()
        return hash as String
    }
}

extension Dictionary where Key == String {
    /// 将字典转为 json 字符串
    /// - Returns: json字符串
    func toJsonString() -> String {
        do {
            // 将字典转换为JSON数据
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [])
            
            // 将JSON数据转换为字符串并进行URL编码
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        } catch {
            print("Error converting dictionary to JSON: \(error)")
        }
        return ""
    }
    
    func toData() -> Data? {
        if let data = try? JSONSerialization.data(withJSONObject: self, options: .fragmentsAllowed) {
            return data
        }
        return nil
    }
}
