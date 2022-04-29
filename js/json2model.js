///
///
/// feature: revert Json to Swift class
/// auther: xiaoyou
/// date: 2022.04.29
///
///


var fileManager = require('fs');
const { removeAllListeners, exit } = require('process');
var gettype = Object.prototype.toString;

String.prototype.firstUpperCase = function titleCase() {
    let newStr = this.slice(0,1).toUpperCase() + this.slice(1).toLowerCase()
    return newStr;
}

let br = "\n"
let tab = "\t"

var arguments = process.argv.splice(2)
var path = arguments[0]

console.log(arguments);

if (path) {
    console.log(path);
}else{
    console.log("需要指定要解析的 JSON 文件路径");
    exit(1);
}

var result = JSON.parse(fileManager.readFileSync(path))
console.log(result);


console.log("nihao".toUpperCase());
console.log("nihao".firstUpperCase());

var classArray = new Array()

parseObject("MyObj", result)

var stringAll = ""
for (var i = classArray.length - 1; i >= 0; i--){
    let clz = classArray[i]
    stringAll += "class " + clz.name + " {" + br

    for (let j = 0; j < clz.property.length; j++) {
        const element = clz.property[j];
        stringAll += tab + element + br
    }

    stringAll += "}" + br + br
}

console.log(stringAll);



function parseObject(k, result){
    let c = new Class(k)
    classArray.push(c)

    for (let i = 0; i < Object.getOwnPropertyNames(result).length; i++) {
        const key = Object.getOwnPropertyNames(result)[i];
        var value = result[key]
        let type = getType(value)

        if (type == "null") {
            continue
        }

        if (type == "String" || type == "Int" || type == "Double" || type == "Bool") {
            c.property.push("var " + key + ": " + type + "?")
            continue
        }

        if (type == "Object") {
            if (Object.getOwnPropertyNames(value).length == 0) { // dict with zero key
                c.property.push("var " + key + ": " + "[String: Any]" + "?")
            }else{
                parseObject(key.firstUpperCase(), value)
                c.property.push("var " + key + ": " + key.firstUpperCase() + "?")
            }

            continue
        }

        if (type == "Array") {
            if (value.length > 0){

                let obj = value[0]
                let objType = getType(obj)
                
                if (objType == "null") {
                    continue
                }

                if (objType == "Object") {
                    parseObject(key.firstUpperCase(), obj)
                    c.property.push("var " + key + ": " + "[" + key.firstUpperCase() + "]" + "?")
                }else{
                    c.property.push("var " + key + ": " + "[" + objType + "]" + "?")
                }

                continue
            }
        }
    }
}

function getType(obj){
    if (typeof obj == 'number') {

        if (Number.isInteger(obj)) {
            return "Int"
        }else{
            return "Double"
        }
    }

    if (typeof obj == "boolean") {
        return "Bool"
    }

    if (typeof obj == "string") {
        return "String"
    }

    if (typeof obj == "undefined") {
        return "Any"
    }

    if (typeof obj == "null") {
        return "Any"
    }

    if (typeof obj == "function") {
        return "null"
    }

    if (typeof obj == "object") {
        if (gettype.call(obj) == "[object Object]") {
            return "Object"
        }

        if (gettype.call(obj) == "[object Array]") {
            return "Array"
        }

        if (gettype.call(obj) == "[object Null]") {
            return "Any"
        }
    }
}

function Class(name){
    this.name = name
    this.property = new Array()
}
