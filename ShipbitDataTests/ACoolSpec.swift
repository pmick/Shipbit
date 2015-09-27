import Quick
import Nimble

class ACoolSpec: QuickSpec {
    override func spec() {
        describe("a dog") {
            it("should bark") {
                expect("bark").to(equal("bark"))
            }
        }
    }
}
