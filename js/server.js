var fs = require('fs')
var http = require('http')
var os = require("os");

// 监听端口号码
let portNumber = 8083

var server = http.createServer()

server.on("request", function(request, response){
    var url = request.url
    
    console.log(url)
    
    if (url === "/") {
        response.end('Hello world!')
        return
    }
    
    if (url === "/testZip.zip") {
        var name = url.substring(url.lastIndexOf('/'))
        var rs = fs.createReadStream(__dirname + "/" + name)
        
        response.writeHead(200, {
            'Content-Type': 'application/force-download',
            'Content-Disposition': 'attachment; filename=' + name
        })
        rs.pipe(response)
    }
    
    if (url === "/login") {
        response.end('Hello world!')
    }
    
});


server.listen(8083, function() {
    console.log("服务启动成功， 可以通过下面三种方式进行访问")
    console.log("通过 http://localhost:8083 进行访问")
    console.log("通过 http://" + (getIP()[0]) + ":8083 进行访问")
    console.log("通过 http://" + (getIP()[1]) + ":8083 进行访问")
})

function getIP() {
    var networkInterfaces = os.networkInterfaces();
    let {lo0, en0} = networkInterfaces

    let localMachineIP = lo0[0]["address"]
    let localNetIP = en0[1]["address"]

    return [localMachineIP, localNetIP]
}

