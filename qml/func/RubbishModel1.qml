/*
 * Copyright (C) 2013 National University of Defense Technology(NUDT) & Kylin Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 1.1
//import Ubuntu.Components 0.1
//import Ubuntu.Components.ListItems 0.1
import RegisterMyType 0.1
import "common" as Common

Item {
    id: rubbishitem; width: parent.width; height: 420
    property Dispatcher dis: mydispather
    property bool inListView : false
    Rectangle {
        id: background
        anchors.fill: parent; color: "white"
        Item {
            id: views
            width: parent.width
            anchors.top: parent.top
            anchors.topMargin: titleBar.height// + 45
//            anchors.bottom: toolBar.top

            Component {
                id: statusDelegate
                RubbishStatus {
                    id: content
//                    width: listView.width//  - units.gu(1)
//                    height: childrenRect.height
                }
            }
            ListModel {
                id: streamModel
                ListElement {
                    title: "1、清理垃圾"
                    picture: "../img/icons/user.png"
                    detailstr: "清理系统垃圾，让系统运行跟流畅"
                    flags: "clear_rubbish"
                }
//                ListElement {
//                    title: "2、清理痕迹"
//                    picture: "../img/icons/at.png"
//                    detailstr: "清理使用计算机时留下的各种痕迹，保护个人隐私"
//                    flags: "clear_traces"
//                }
//                ListElement {
//                    title: "3、清理注册表"
//                    picture: "../img/icons/pen.png"
//                    detailstr: "清理电脑日常使用中产生的无用注册表项，提高系统性能"
//                    flags: "clear_registry"
//                }
            }
            //垃圾清理显示内容
            ListView {
                id: listView
    //            objectName: "listView"
                height: rubbishitem.height - titlebar.height// - units.gu(2)
                width: rubbishitem.width
    //            focus: true
    //            highlight: Rectangle { color: "white" }
                opacity: 1
                spacing: 10//units.gu(1)
                model: streamModel
                snapMode: ListView.NoSnap
                cacheBuffer: parent.height
                boundsBehavior: Flickable.DragOverBounds
                currentIndex: 0
                delegate: statusDelegate
                preferredHighlightBegin: 0
                preferredHighlightEnd: preferredHighlightBegin
                highlightRangeMode: ListView.StrictlyEnforceRange
            }

//            Scrollbar {
//                flickableItem: listView
//                align: Qt.AlignTrailing
//            }
        }

        //垃圾清理自定义标题栏
        Common.MyTitleBar {
            id: titleBar; width: parent.width; height: 45; opacity: 0.9
            btn_text: "开始扫描"
            title: "清理电脑中的垃圾"
            description:  "清理垃圾可以提高系统速度"
            btn_flag: "rubbish"
        }
    }
}










//Item {
//    id: rubbishitem
//    property Dispatcher dis: mydispather
//    Component {
//        id: statusDelegate
//        RubbishStatus {
//            id: content
//            width: listView.width//  - units.gu(1)
//            height: childrenRect.height
//        }
//    }
//    ListModel {
//        id: streamModel
//        ListElement {
//            title: "1、清理垃圾"
//            picture: "../img/icons/user.png"
//            detailstr: "清理系统垃圾，让系统运行跟流畅"
//            flags: "clear_rubbish"
//        }
//        ListElement {
//            title: "2、清理痕迹"
//            picture: "../img/icons/at.png"
//            detailstr: "清理使用计算机时留下的各种痕迹，保护个人隐私"
//            flags: "clear_traces"
//        }
//        ListElement {
//            title: "3、清理注册表"
//            picture: "../img/icons/pen.png"
//            detailstr: "清理电脑日常使用中产生的无用注册表项，提高系统性能"
//            flags: "clear_registry"
//        }
//    }

//    Column {
//        anchors.fill: parent
//        //垃圾清理自定义标题栏
//        Common.TitleBar {
//            id: titlebar
//            anchors.top: parent.top
//            anchors.topMargin: 80
//            width: parent.width
//            height: 45
//            opacity: 0.9
//            btn_text: "开始扫描"
//            title: "清理电脑中的垃圾"
//            description:  "清理垃圾可以提高系统速度"
//            btn_flag: "rubbish"
//        }
//        //垃圾清理显示内容
//        ListView {
//            id: listView
////            objectName: "listView"
//            height: rubbishitem.height - titlebar.height// - units.gu(2)
//            width: rubbishitem.width
////            focus: true
//            anchors.fill: parent
//            anchors.top: titlebar.bottom
//            anchors.topMargin: 133
////            highlight: Rectangle { color: "white" }
////            anchors {
////                top: updatesBanner.bottom
////                topMargin: 100//units.gu(1)
////            }
//            opacity: 1
//            spacing: units.gu(1)
//            model: streamModel
//            snapMode: ListView.NoSnap
//            cacheBuffer: parent.height
//            boundsBehavior: Flickable.DragOverBounds
//            currentIndex: 0
//            delegate: statusDelegate
//            preferredHighlightBegin: 0
//            preferredHighlightEnd: preferredHighlightBegin
//            highlightRangeMode: ListView.StrictlyEnforceRange
//        }
//        Scrollbar {
//            flickableItem: listView
//            align: Qt.AlignTrailing
//        }

//        Item {
//            id: updatesBanner
//            anchors {
//                top: parent.top
//                left: parent.left
//                right: parent.right
//            }
//            visible: true
//            height: visible ? units.gu(3) : 0
//            Text {
//                id: updatesText
//                anchors {
//                    centerIn: parent
//                    bottom: parent.bottom
//                }
//                text: ""
//                font.family: "Ubuntu"
//                font.bold: true
//                font.pointSize: 12
//                color: "gray"
//            }
//            MouseArea {
//                anchors.fill: parent
//                onClicked: {

//                }
//            }
//        }//Item
//    }//Column
//}//Item







//Rectangle {
//    color: "#f8f8f8"
//    Item {
//        id: clear_line
//        anchors {fill: parent; top: parent.top; topMargin: 80}
//        TitleBar {
//            id: titleBar
//            width: parent.width
//            height: 45
//            opacity: 0.9
//            btn_text: "开始扫描"
//            title: "清理电脑中的垃圾"
//            description:  "清理垃圾可以提高系统速度"
//        }
//    }


////    Item {
////        id: clear_line
////        anchors {fill: parent; top: parent.top; topMargin: 80; left: parent.left; leftMargin: 30}
////        Column {
////            Text {
////                text: "清理电脑中的插件"
////                font.pointSize: 11
////                color: "black"
////            }
////            Text {
////                text:  "清理插件可以给系统和浏览器“减负”，减少干扰，提供系统和浏览器速度"
////                font.pointSize: 9
////                color: "gray"
////            }
////        }
////        Button {
////            id: pluginBtn
////            width: 90
////            color: "gray"
////            anchors {
////                left: parent.left
////                leftMargin: 700
////            }
////            text: "开始扫描"
////            onClicked: {
////                //kobe: wait for adding function
//////                mydispather.send_btn_msg("clearfast")
//////                pageStack.pop()
//////                pageStack.push(clearprogress)
////            }
////        }
////    }


//    Rectangle {
//        anchors {fill: parent; top: parent.top; topMargin: 130; left: parent.left}
//        Component {
//            id: statusDelegate
//            RubbishStatus {
//                id: content
//                width: listView.width  - units.gu(1)
//                height: childrenRect.height
//    //            title1: title
//    //            title2: detailstr
//    //            icon_source: picture
//    //            ListView.onAdd: SequentialAnimation {
//    //                ScriptAction { script: {unseen++; console.log(column_0[0][0] + " " + column_0[0][1] + " " + column_0[0][2]) }}
//    //            }
//    //            Connections {
//    //                target: updateTimestampsTimer
//    //                onTriggered: {
//    //                    recalculateTimeString();
//    //                }
//    //            }
//            }
//        }
//        ListModel {
//            id: streamModel
//            ListElement {
//                title: "1、清理垃圾"
//                picture: "../img/icons/user.png"
//                detailstr: "清理系统垃圾，让系统运行跟流畅"
//                flags: "clear_rubbish"
//            }
//            ListElement {
//                title: "2、清理痕迹"
//                picture: "../img/icons/at.png"
//                detailstr: "清理使用计算机时留下的各种痕迹，保护个人隐私"
//                flags: "clear_traces"
//            }
//            ListElement {
//                title: "3、清理注册表"
//                picture: "../img/icons/pen.png"
//                detailstr: "清理电脑日常使用中产生的无用注册表项，提高系统性能"
//                flags: "clear_registry"
//            }

//        }

//        ListView {
//            id: listView
//            objectName: "listView"
//            height: parent.height - toolbar.height - units.gu(2)
//            width: parent.width
//            anchors {
//                top: updatesBanner.bottom
//                topMargin: units.gu(1)
//            }
//            opacity: 1
//            spacing: units.gu(1)
//            model: streamModel
//            snapMode: ListView.NoSnap
//            cacheBuffer: parent.height
//            boundsBehavior: Flickable.DragOverBounds
//            currentIndex: 0
//            delegate: statusDelegate

//            preferredHighlightBegin: 0
//            preferredHighlightEnd: preferredHighlightBegin
//            highlightRangeMode: ListView.StrictlyEnforceRange
//        }

//        Item {
//            id: updatesBanner
//            anchors {
//                top: parent.top
//                left: parent.left
//                right: parent.right
//            }
////            visible: unseen > 0
//            visible: true
//            height: visible ? units.gu(3) : 0
//            Text {
//                id: updatesText
//                anchors {
//                    centerIn: parent
//                    bottom: parent.bottom
//                }
//                text: ""
//                font.family: "Ubuntu"
//                font.bold: true
//                font.pointSize: 12
//                color: "gray"
//            }
//            MouseArea {
//                anchors.fill: parent
//                onClicked: {

//                }
//            }
//        }

//        Scrollbar {
//            flickableItem: listView
//            align: Qt.AlignTrailing
//        }
//    }
//}