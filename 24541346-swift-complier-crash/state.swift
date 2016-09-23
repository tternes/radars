import Foundation

protocol State {
    func onEnter()
    func onExit()
}

protocol Machine {
    var currentState: State? { get set }
    func moveToState(state: State) -> Machine
}

extension Machine {
    func moveToState(state: State) {
        currentState?.onExit()
        currentState?.onEnter()
    }
}

// Uncommenting the currentState var in StateMachine will cause a crash
struct CoffeeMaker : Machine {
    var currentState: State?
}
