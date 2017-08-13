//
//  ViewController.swift
//  swift-vdom
//
//  Created by Sean Kelley on 8/12/17.
//  Copyright © 2017 Sean Kelley. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let label = UILabel()
        label.text = "butts"
        label.textColor = UIColor.black
        label.center = CGPoint(x: 100, y: 100)
        label.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        self.view.addSubview(label)
    }
}

class AbstractComponent<T> {
    let props: T
    let key: String?
    let children: [ AbstractComponent<Any> ]

    init(_ props: T? = nil, _ key: String? = nil, _ children: [ AbstractComponent<Any>? ]? = nil) {
        self.props = props!
        self.key = key
        self.children = self.normalizeChildren(children)
    }

    private func normalizeChildren(_ children: [ AbstractComponent<Any>? ]?) -> [ AbstractComponent<Any> ] {
        return [];
    }
}

class NativeComponent<T>: AbstractComponent<T> {
    open func createView() -> UIView? {
        return nil
    }
}

struct LabelProps {
    let text: String?
}

class VirtualLabel: NativeComponent<LabelProps> {
    override func createView() -> UIView {
        let view = UILabel()
        view.text = self.props.text!
        return view
    }
}

class Component<T>: AbstractComponent<T> {
    open func render() -> AbstractComponent<Any>? {
        return nil
    }
}

struct LabelWrapperProps {
    let butts: String
}

class LabelWrapper: Component<LabelWrapperProps> {
    override func render() -> AbstractComponent<Any> {
        return VirtualLabel(LabelProps(text: self.props.butts))
    }
}

class SimpleWrapper: Component<Void> {
    override func render() -> AbstractComponent<Any>? {
        return self.children[0];
    }
}

struct Tree {
    let node: NativeComponent<Any>
    let children: [ Tree ]
}

func render(component: Component<Any>) -> Tree? {
    let node = component.render()

    if (node == nil) {
        return nil
    } else if (node is NativeComponent) {
        return Tree(node: node as! NativeComponent<Any>, children: node!.children.map(render))
    } else {
    }
}
