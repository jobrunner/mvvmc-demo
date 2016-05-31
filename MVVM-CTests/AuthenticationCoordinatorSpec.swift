import Quick
import Nimble

@testable import MVVM_C

class AuthenticationCoordinatorSpec: QuickSpec {
    override func spec() {
        describe("AuthenticationCoordinator") {
            var authenticationCoordinator: AuthenticationCoordinator!
            var navigationController: UINavigationController!
            
            beforeEach {
                navigationController = UINavigationController()
                authenticationCoordinator = AuthenticationCoordinator(navigationController: navigationController)
                authenticationCoordinator.startWithEndpoint(nil)
            }
            
            describe("startWithEndpoint") {
                it("sets the authentication view controller as root view controller") {
                    expect(navigationController.topViewController).to(beAKindOf(MVVMCAuthenticationViewController))
                }
                
                it("sets the authentication view model of the controller") {
                    let authenticationViewController = navigationController.topViewController as! MVVMCAuthenticationViewController
                    
                    expect(authenticationViewController.viewModel).toNot(beNil())
                }
                
                it("sets itself as the authentication view models coordinator delegate") {
                    let authenticationViewController = navigationController.topViewController as! MVVMCAuthenticationViewController
                    
                    expect(authenticationViewController.viewModel!.coordinatorDelegate).to(beIdenticalTo(authenticationCoordinator))
                }
            }
            
            describe("authenticateViewModelDidLogin") {
                var mockDelegate: MockAuthenticationCoordinatorDelegate!
                
                beforeEach {
                    mockDelegate = MockAuthenticationCoordinatorDelegate()
                    authenticationCoordinator.delegate = mockDelegate
                    let viewModel = MVVMCAuthenticateViewModel()
                    authenticationCoordinator.authenticateViewModelDidLogin(viewModel: viewModel)
                }
                
                it("calls the delegates did finish function") {
                    expect(mockDelegate.wasCalled).to(beTrue())
                }
                
                it("passes itself to the did finish function") {
                    expect(mockDelegate.lastCaller).to(beIdenticalTo(authenticationCoordinator))
                }
            }
        }
    }
}

private class MockAuthenticationCoordinatorDelegate: AuthenticationCoordinatorDelegate {
    private(set) var wasCalled = false
    private(set) var lastCaller: AuthenticationCoordinator!
    
    func authenticationCoordinatorDidFinish(authenticationCoordinator authenticationCoordinator: AuthenticationCoordinator) {
        wasCalled = true
        lastCaller = authenticationCoordinator
    }
}
