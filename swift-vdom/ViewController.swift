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

class Component<T> {
    let props: T
    let key: String?
    let children: [ Component<Any> ]

    init(_ props: T? = nil, _ key: String? = nil, _ children: [ Component<Any>? ]? = nil) {
        self.props = props!
        self.key = key
        self.children = self.normalizeChildren(children)
    }

    private func normalizeChildren(_ children: [ Component<Any>? ]?) -> [ Component<Any> ] {
        return [];
    }

    open func render() -> Component<Any>? {
        return nil
    }
}

class NativeComponent<T>: Component<T> {
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

struct LabelWrapperProps {
    let butts: String
}

class LabelWrapper: Component<LabelWrapperProps> {
    override func render() -> Component<Any> {
        // TODO: Why is VirtualLabel not assignable to Component<Any>?
        return VirtualLabel(LabelProps(text: self.props.butts))
    }
}


class SimpleWrapper: Component<Void> {
    override func render() -> Component<Any>? {
        return self.children[0];
    }
}

struct Tree {
    let type: Component<Any>.Type
    let node: Component<Any>
    let children: [ Tree ]
}

func compact<T>(array: [ T? ]) -> [ T ] {
    return array.filter({ t in t != nil }) as! [ T ]
}

func render(component: Component<Any>) -> Tree? {
    let node = component.render()
    if (node == nil) {
        return nil
    } else {
        return Tree(
            type: type(of: node!),
            node: node as! NativeComponent<Any>,
            children: compact(array: node!.children.map(render))
        )
    }

}
