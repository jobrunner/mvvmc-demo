import Quick
import Nimble

@testable import MVVM_C

class AppCoordinatorSpec: QuickSpec {
    override func spec() {
        describe("AppCoordinator") { 
            var appCoordinator: AppCoordinator!
            
            beforeEach({
                let navigationController = UINavigationController()
                appCoordinator = AppCoordinator(navigationController: navigationController)
                appCoordinator.startWithEndpoint(nil)
            })
            
            describe("startWithEndpoint") {
                it("sets the list coordinator") {
                    if (appCoordinator.coordinators[CoordinatorType.List] is ListCoordinator) == false {
                        fail("Expected a ListCoordinator, got something else")
                    }
                }
                
                it("sets itself as the list coordinators delegate") {
                    let listCoordinator = appCoordinator.coordinators[CoordinatorType.List] as! ListCoordinator
                    
                    expect(listCoordinator.delegate!).to(beIdenticalTo(appCoordinator))
                }
            }
            
            describe("listCoordinatorDidFinish") {
                beforeEach({
                    let listCoordinator = appCoordinator.coordinators[CoordinatorType.List] as! ListCoordinator
                    appCoordinator.listCoordinatorDidFinish(listCoordinator: listCoordinator)
                })
                
                it("removes the list coordinator") {
                    expect(appCoordinator.coordinators[CoordinatorType.List]).to(beNil())
                }
            }
        }
    }
}
