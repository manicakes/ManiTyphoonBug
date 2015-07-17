import Typhoon

@objc
class BaseClass : NSObject {
    var otherInstance : OtherProtocol!
    
    func doIt() -> String {
        return self.otherInstance.doStuff()
    }
}

@objc
protocol OtherProtocol {
    func doStuff() -> String
}

@objc
class OtherImpl : NSObject, OtherProtocol {
    func doStuff() -> String {
        return "OtherClass"
    }
}

@objc
class StubClass : NSObject, OtherProtocol {
    func doStuff() -> String {
        return "Stubbed out"
    }
}

class BaseAssembly : TyphoonAssembly {
    dynamic func baseObject() -> AnyObject {
        return TyphoonDefinition.withClass(BaseClass.self,
            configuration: { (def : TyphoonDefinition!) -> Void in
                def.injectProperty("otherInstance", with: self.otherObject())
        })
    }
    
    dynamic func otherObject() -> AnyObject {
        return TyphoonDefinition.withClass(OtherImpl.self)
    }
}

var assembly = BaseAssembly()
assembly.activate()
var b = assembly.baseObject() as! BaseClass
b.doIt()

@objc
class TestAssembly : BaseAssembly {
    override func otherObject() -> AnyObject {
        return TyphoonDefinition.withClass(StubClass.self)
    }
}

var testAssembly = TestAssembly()
testAssembly.activate()
var c = testAssembly.baseObject() as! BaseClass
c.otherInstance // this shouldn't be nil
