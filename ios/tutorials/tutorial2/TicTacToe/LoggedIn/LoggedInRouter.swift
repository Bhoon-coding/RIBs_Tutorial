//
//  LoggedInRouter.swift
//  TicTacToe
//
//  Created by BH on 2022/11/21.
//  Copyright © 2022 Uber. All rights reserved.
//

import RIBs

protocol LoggedInInteractable: Interactable, OffGameListener {
    var router: LoggedInRouting? { get set }
    var listener: LoggedInListener? { get set }
}

protocol LoggedInViewControllable: ViewControllable {
    func present(viewController: ViewControllable)
    func dismiss(viewController: ViewControllable)
}

final class LoggedInRouter: Router<LoggedInInteractable>, LoggedInRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: LoggedInInteractable,
         viewController: LoggedInViewControllable,
         offGameBuilder: OffGameBuildable) {
        self.viewController = viewController
        self.offGameBuilder = offGameBuilder
        super.init(interactor: interactor)
        interactor.router = self
    }
    
    override func didLoad() {
        super.didLoad()
        attachOffGame()
        
    }

    func cleanupViews() {
        // TODO: Since this router does not own its view, it needs to cleanup the views
        // it may have added to the view hierarchy, when its interactor is deactivated.
    }

    // MARK: - Private

    private let viewController: LoggedInViewControllable
    private let offGameBuilder: OffGameBuildable
    private var currentChild: ViewableRouting?
    
    private func attachOffGame() {
        let offGame = offGameBuilder.build(withListener: interactor)
        self.currentChild = offGame
        attachChild(offGame)
        viewController.present(viewController: offGame.viewControllable)
    }
}
