/*
 * Copyright (C) 2013 ~ 2014 National University of Defense Technology(NUDT) & Kylin Ltd.
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
import "../common" as Common
import "../bars" as Bars

Rectangle {
    id: desktopiconsetpage
    property bool on: true
    width: parent.width
    height: 475
    property string fontName: "Helvetica"
    property int fontSize: 12
    property color fontColor: "black"
    property int cursor_size: 24
    property string selected_icon_theme: ""//存放用户选择确认后的主题

    property int current_index//当前主题的索引
    property int default_index//系统默认主题的索引

    property string actiontitle: qsTr("Desktop Icons")//桌面图标设置
    property string actiontext: qsTr("Set the desktop icon theme and the visibility of desktop icons.")//设置桌面图标主题和桌面图标的可见性
    //背景
    Image {
        source: "../../img/skin/bg-middle.png"
        anchors.fill: parent
    }

    Component.onCompleted: {
        var iconlist = sessiondispatcher.get_icon_themes_qt();
        var current_icon_theme = sessiondispatcher.get_icon_theme_qt();
        showText.text = qsTr("[ Current icon theme is: ") + current_icon_theme + " ]";//[ 当前图标主题是：
        desktopiconsetpage.selected_icon_theme = current_icon_theme;
//        iconlist.unshift(current_icon_theme);
        var default_theme = sessiondispatcher.get_default_theme_sring_qt("icontheme");

        choices.clear();
        if(current_icon_theme == default_theme) {
            for(var i=0; i < iconlist.length; i++) {
                choices.append({"text": iconlist[i]});
                if (iconlist[i] == current_icon_theme) {
                    desktopiconsetpage.current_index = i;
                    desktopiconsetpage.default_index = i;
                }
            }
        }
        else {
            for(var j=0; j < iconlist.length; j++) {
                choices.append({"text": iconlist[j]});
                if (iconlist[j] == current_icon_theme) {
                    desktopiconsetpage.current_index = j;
                }
                else if (iconlist[j] == default_theme) {
                    desktopiconsetpage.default_index = j;
                }
            }
        }
        iconcombo.selectedIndex = desktopiconsetpage.current_index;


        if (sessiondispatcher.get_show_desktop_icons_qt()) {
            iconswitcher.switchedOn = true;
        }
        else {
            iconswitcher.switchedOn = false;
        }

        if (sessiondispatcher.get_show_homefolder_qt()) {
            folderswitcher.switchedOn = true;
        }
        else {
            folderswitcher.switchedOn = false;
        }

        if (sessiondispatcher.get_show_network_qt()) {
            networkswitcher.switchedOn = true;
        }
        else {
            networkswitcher.switchedOn = false;
        }

        if (sessiondispatcher.get_show_trash_qt()) {
            trashswitcher.switchedOn = true;
        }
        else {
            trashswitcher.switchedOn = false;
        }

        if (sessiondispatcher.get_show_devices_qt()) {
            deviceswitcher.switchedOn = true;
        }
        else {
            deviceswitcher.switchedOn = false;
        }
    }

    ListModel {
        id: choices
    }

    Column {
        spacing: 10
        anchors.top: parent.top
        anchors.topMargin: 44
        anchors.left: parent.left
        anchors.leftMargin: 80
        Row{
            spacing: 50
            Text {
                 text: desktopiconsetpage.actiontitle
                 font.bold: true
                 font.pixelSize: 14
                 color: "#383838"
             }
            Text {
                id: showText
                text: ""
                font.pixelSize: 14
                color: "#318d11"
            }
            //status picture
            Common.StatusImage {
                id: statusImage
                visible: false
                iconName: "green.png"
                text: qsTr("Completed")//已完成
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        Text {
            text: desktopiconsetpage.actiontext
            font.pixelSize: 12
            color: "#7a7a7a"
        }
    }

    Row {
        id: settitle
        anchors{
            left: parent.left
            leftMargin: 40
            top: parent.top
            topMargin: 120

        }
        Text{
            id: themetitle
            text: qsTr("Icon theme settings")//图标主题设置
            font.bold: true
            font.pixelSize: 12
            color: "#383838"
        }
        //横线
        Common.Separator {
            anchors.verticalCenter: parent.verticalCenter
            width: desktopiconsetpage.width - themetitle.width - 40 * 2
        }
    }

//    Row {
//        id: themeline
//        spacing: 135
//        anchors{
//            left: parent.left
//            leftMargin: 60
//            top: settitle.bottom
//            topMargin: 10

//        }
//        Row{
//            spacing: 40
//            Text {
//                id: iconthemelabel
//                text: qsTr("Icon theme")//图标主题
//                font.pixelSize: 12
//                color: "#7a7a7a"
//                anchors.verticalCenter: parent.verticalCenter
//            }
//            Common.ComboBox {
//                id: iconcombo
//                model: choices
//                width: 200
//                onSelectedTextChanged: {
//                        sessiondispatcher.set_icon_theme_qt(iconcombo.selectedText);
//                        //[ 当前图标主题是：
//                        showText.text = qsTr("[ Current icon theme is: ") + iconcombo.selectedText + " ]";//[ 当前图标主题是：
//                        statusImage.visible = true;
//                }
//            }
////            Common.Button {
////                id: okBtn
////                width: 94;height: 29
////                fontsize: 13
////                hoverimage: "green.png"
////                text: qsTr("OK")//确定
////                onClicked: {
////                    if (desktopiconsetpage.selected_icon_theme != iconcombo.selectedText) {
////                        desktopiconsetpage.selected_icon_theme = iconcombo.selectedText;
////                        sessiondispatcher.set_icon_theme_qt(iconcombo.selectedText);
////                        //[ 当前图标主题是：
////                        showText.text = qsTr("[ Current icon theme is: ") + iconcombo.selectedText + " ]";//[ 当前图标主题是：
////                        statusImage.visible = true;
////                    }
////                }
////            }
//        }
//        Common.Button {
//            hoverimage: "blue.png"
//            text: qsTr("Restore")//恢复默认
//            width: 94
//            height: 29
//            fontsize: 13
//            onClicked: {
//                sessiondispatcher.set_default_theme_qt("icontheme");
//                iconcombo.selectedIndex = desktopiconsetpage.default_index;
//                showText.text = qsTr("[ Current icon theme is: ") + iconcombo.selectedText + " ]";//[ 当前图标主题是：
//                statusImage.visible = true;
//            }
//        }
//    }


    //-----------------
    Row {
        id: themeline
        anchors{
            left: parent.left
            leftMargin: 60
            top: settitle.bottom
            topMargin: 10

        }
        spacing: 200
        Row {
            spacing: 20
            Text {
                id: iconthemelabel
                width: 170 - 50
                text: qsTr("Icon theme")//图标主题
                font.pixelSize: 12
                color: "#7a7a7a"
                anchors.verticalCenter: parent.verticalCenter
            }
            Common.ComboBox {
                id: iconcombo
                model: choices
                width: 170 + 50
                onSelectedTextChanged: {
                        sessiondispatcher.set_icon_theme_qt(iconcombo.selectedText);
                        //[ 当前图标主题是：
                        showText.text = qsTr("[ Current icon theme is: ") + iconcombo.selectedText + " ]";//[ 当前图标主题是：
                        statusImage.visible = true;
                }
            }
        }
        Common.Button {
            hoverimage: "blue.png"
            text: qsTr("Restore")//恢复默认
            width: 94
            height: 29
            fontsize: 13
            onClicked: {
                sessiondispatcher.set_default_theme_qt("icontheme");
                iconcombo.selectedIndex = desktopiconsetpage.default_index;
                showText.text = qsTr("[ Current icon theme is: ") + iconcombo.selectedText + " ]";//[ 当前图标主题是：
                statusImage.visible = true;
            }
        }
    }
    //---------------------------

    Row {
        id: icontitle
        anchors{
            left: parent.left
            leftMargin: 40
            top: themeline.bottom
            topMargin: 30
        }
        Text{
            id: showtitle
            text: qsTr("Desktop icon display control")//桌面图标显示控制
            font.bold: true
            font.pixelSize: 12
            color: "#383838"
        }
        //横线
        Common.Separator {
            anchors.verticalCenter: parent.verticalCenter
            width: desktopiconsetpage.width - showtitle.width - 40 * 2
        }
    }

    Column {
        anchors{
            left: parent.left
            leftMargin: 60
            top: icontitle.bottom
            topMargin: 10
        }
        spacing: 10
        Row {
            spacing: 200
            Row {
                spacing: 20
                Common.Label {
                    id: desktopiconlabel
                    width: 170
                    text: qsTr("Show Desktop Icons: ")//显示桌面图标：
                    font.pixelSize: 12
                    color: "#383838"
                    anchors.verticalCenter: parent.verticalCenter
                }
                Common.Switch {
                    id: iconswitcher
                    width: desktopiconlabel.width
                    onSwitched: {
                        if (iconswitcher.switchedOn) {
                            sessiondispatcher.set_show_desktop_icons_qt(true);
                        }
                        else if(!iconswitcher.switchedOn) {
                            sessiondispatcher.set_show_desktop_icons_qt(false);
                        }
                    }
                }
            }
            Common.Button {
                hoverimage: "blue.png"
                text: qsTr("Restore")//恢复默认
                width: 94
                height: 29
                fontsize: 13
                onClicked: {
                    sessiondispatcher.set_default_desktop_qt("showdesktopicons");
                    if (sessiondispatcher.get_show_desktop_icons_qt()) {
                        iconswitcher.switchedOn = true;
                    }
                    else {
                        iconswitcher.switchedOn = false;
                    }
                }
            }
        }


        Row {
            spacing: 200
            Row {
                spacing: 20
                Common.Label {
                    id: homefolderlabel
                    width: 170
                    text: qsTr("Home Folder: ")//主文件夹：
                    font.pixelSize: 12
                    color: "#383838"
                    anchors.verticalCenter: parent.verticalCenter
                }
                Common.Switch {
                    id: folderswitcher
                    width: homefolderlabel.width
                    onSwitched: {
                        if (folderswitcher.switchedOn) {
                            sessiondispatcher.set_show_homefolder_qt(true);
                        }
                        else if(!folderswitcher.switchedOn) {
                            sessiondispatcher.set_show_homefolder_qt(false);
                        }
                    }
                }
            }
            Common.Button {
                hoverimage: "blue.png"
                text: qsTr("Restore")//恢复默认
                width: 94
                height: 29
                fontsize: 13
                onClicked: {
                    sessiondispatcher.set_default_desktop_qt("homeiconvisible");
                    if (sessiondispatcher.get_show_homefolder_qt()) {
                        folderswitcher.switchedOn = true;
                    }
                    else {
                        folderswitcher.switchedOn = false;
                    }
                }
            }
        }

        Row {
            spacing: 200
            Row {
                spacing: 20
                Common.Label {
                    id: networklabel
                    width: 170
                    text: qsTr("Network: ")//网络：
                    font.pixelSize: 12
                    color: "#383838"
                    anchors.verticalCenter: parent.verticalCenter
                }
                Common.Switch {
                    id: networkswitcher
                    width: networklabel.width
                    onSwitched: {
                        if (networkswitcher.switchedOn) {
                            sessiondispatcher.set_show_network_qt(true);
                        }
                        else if(!networkswitcher.switchedOn) {
                            sessiondispatcher.set_show_network_qt(false);
                        }
                    }
                }
            }
            Common.Button {
                hoverimage: "blue.png"
                text: qsTr("Restore")//恢复默认
                width: 94
                height: 29
                fontsize: 13
                onClicked: {
                    sessiondispatcher.set_default_desktop_qt("networkiconvisible");
                    if (sessiondispatcher.get_show_network_qt()) {
                        networkswitcher.switchedOn = true;
                    }
                    else {
                        networkswitcher.switchedOn = false;
                    }
                }
            }
        }

        Row {
            spacing: 200
            Row {
                spacing: 20
                Common.Label {
                    id: trashlabel
                    width: 170
                    text: qsTr("Trash : ")//回收站：
                    font.pixelSize: 12
                    color: "#383838"
                    anchors.verticalCenter: parent.verticalCenter
                }
                Common.Switch {
                    id: trashswitcher
                    width: trashlabel.width
                    onSwitched: {
                        if (trashswitcher.switchedOn) {
                            sessiondispatcher.set_show_trash_qt(true);
                        }
                        else if(!trashswitcher.switchedOn) {
                            sessiondispatcher.set_show_trash_qt(false);
                        }
                    }
                }
            }
            Common.Button {
                hoverimage: "blue.png"
                text: qsTr("Restore")//恢复默认
                width: 94
                height: 29
                fontsize: 13
                onClicked: {
                    sessiondispatcher.set_default_desktop_qt("trashiconvisible");
                    if (sessiondispatcher.get_show_trash_qt()) {
                        trashswitcher.switchedOn = true;
                    }
                    else {
                        trashswitcher.switchedOn = false;
                    }
                }
            }
        }


        Row {
            spacing: 200
            Row {
                spacing: 20
                Common.Label {
                    id: devicelabel
                    width: 170
                    text: qsTr("Mounted Volumes: ")//已经挂载卷标：
                    font.pixelSize: 12
                    color: "#383838"
                    anchors.verticalCenter: parent.verticalCenter
                }
                Common.Switch {
                    id: deviceswitcher
                    width: devicelabel.width
                    onSwitched: {
                        if (deviceswitcher.switchedOn) {
                            sessiondispatcher.set_show_devices_qt(true);
                        }
                        else if(!deviceswitcher.switchedOn) {
                            sessiondispatcher.set_show_devices_qt(false);
                        }
                    }
                }
            }
            Common.Button {
                hoverimage: "blue.png"
                text: qsTr("Restore")//恢复默认
                width: 94
                height: 29
                fontsize: 13
                onClicked: {
                    sessiondispatcher.set_default_desktop_qt("volumesvisible");
                    if (sessiondispatcher.get_show_devices_qt()) {
                        deviceswitcher.switchedOn = true;
                    }
                    else {
                        deviceswitcher.switchedOn = false;
                    }
                }
            }
        }
    }//Column

    //顶层工具栏
    Bars.TopBar {
        id: topBar
        width: 28
        height: 26
        anchors.top: parent.top
        anchors.topMargin: 40
        anchors.left: parent.left
        anchors.leftMargin: 40
        opacity: 0.9
        onButtonClicked: {
            var num = sessiondispatcher.get_page_num();
            if (num == 0) {
                pageStack.push(homepage);
            }
            else if (num == 3) {
                pageStack.push(systemset);
            }
            else if (num == 4) {
                pageStack.push(functioncollection);
            }
        }
    }
    //底层工具栏
    Bars.ToolBar {
        id: toolBar
        showok: false
//        showrestore: true
        height: 50; anchors.bottom: parent.bottom; width: parent.width; opacity: 0.9
        onQuitBtnClicked: {
            var num = sessiondispatcher.get_page_num();
            if (num == 0) {
                pageStack.push(homepage);
            }
            else if (num == 3) {
                pageStack.push(systemset);
            }
            else if (num == 4) {
                pageStack.push(functioncollection);
            }
        }
        onOkBtnClicked: {
        }
//        onRestoreBtnClicked: {
//            var defaultdesktopcontrol = sessiondispatcher.get_default_desktop_bool_qt("showdesktopicons");
//            var defaultdocument = sessiondispatcher.get_default_desktop_bool_qt("homeiconvisible");
//            var defaultnetwork = sessiondispatcher.get_default_desktop_bool_qt("networkiconvisible");
//            var defaultrecyclebin = sessiondispatcher.get_default_desktop_bool_qt("trashiconvisible");
//            var defaultdevice = sessiondispatcher.get_default_desktop_bool_qt("volumesvisible");
            //20140219
//            sessiondispatcher.set_default_theme_qt("icontheme");
//            sessiondispatcher.set_default_desktop_qt("showdesktopicons");
//            if (sessiondispatcher.get_show_desktop_icons_qt()) {
//                iconswitcher.switchedOn = true;
//            }
//            else {
//                iconswitcher.switchedOn = false;
//            }
//            sessiondispatcher.set_default_desktop_qt("homeiconvisible");
//            if (sessiondispatcher.get_show_homefolder_qt()) {
//                folderswitcher.switchedOn = true;
//            }
//            else {
//                folderswitcher.switchedOn = false;
//            }
//            sessiondispatcher.set_default_desktop_qt("networkiconvisible");
//            if (sessiondispatcher.get_show_network_qt()) {
//                networkswitcher.switchedOn = true;
//            }
//            else {
//                networkswitcher.switchedOn = false;
//            }
//            sessiondispatcher.set_default_desktop_qt("trashiconvisible");
//            if (sessiondispatcher.get_show_trash_qt()) {
//                trashswitcher.switchedOn = true;
//            }
//            else {
//                trashswitcher.switchedOn = false;
//            }
//            sessiondispatcher.set_default_desktop_qt("volumesvisible");
//            if (sessiondispatcher.get_show_devices_qt()) {
//                deviceswitcher.switchedOn = true;
//            }
//            else {
//                deviceswitcher.switchedOn = false;
//            }


//            var defaultdesktopcontrol = sessiondispatcher.read_default_configure_from_qsetting_file("theme", "desktopcontrol");
//            var defaultdocument = sessiondispatcher.read_default_configure_from_qsetting_file("theme", "document");
//            var defaultnetwork = sessiondispatcher.read_default_configure_from_qsetting_file("theme", "network");
//            var defaultrecyclebin = sessiondispatcher.read_default_configure_from_qsetting_file("theme", "recyclebin");
//            var defaultdevice = sessiondispatcher.read_default_configure_from_qsetting_file("theme", "device");
//            var defaulttheme = sessiondispatcher.read_default_configure_from_qsetting_file("theme", "icontheme");

//            var desktopcontrolFlag;
//            var documentFlag;
//            var networkFlag;
//            var recyclebinFlag;
//            var deviceFlag;
//            if(iconswitcher.switchedOn) {
//                desktopcontrolFlag = "true";
//            }
//            else {
//                desktopcontrolFlag = "false";
//            }
//            if(folderswitcher.switchedOn) {
//                documentFlag = "true";
//            }
//            else {
//                documentFlag = "false";
//            }
//            if(networkswitcher.switchedOn) {
//                networkFlag = "true";
//            }
//            else {
//                networkFlag = "false";
//            }
//            if(trashswitcher.switchedOn) {
//                recyclebinFlag = "true";
//            }
//            else {
//                recyclebinFlag = "false";
//            }
//            if(deviceswitcher.switchedOn) {
//                deviceFlag = "true";
//            }
//            else {
//                deviceFlag = "false";
//            }

//            if((defaulttheme == desktopiconsetpage.selected_icon_theme) && (defaultdesktopcontrol == desktopcontrolFlag) && (defaultdocument == documentFlag) && (defaultnetwork == networkFlag) && (defaultrecyclebin == recyclebinFlag) && (defaultdevice == deviceFlag)) {
//                //友情提示：        桌面图标已经恢复为默认配置！
//                sessiondispatcher.showWarningDialog(qsTr("Tips: "), qsTr("Desktop icon has been restored to the default configuration!"), mainwindow.pos.x, mainwindow.pos.y);//友情提示：//桌面图标已经为默认配置！
//            }
//            else {
//                if(defaulttheme != desktopiconsetpage.selected_icon_theme) {
//                    sessiondispatcher.set_icon_theme_qt(defaulttheme);
//                    desktopiconsetpage.selected_icon_theme = defaulttheme;
//                    showText.text = qsTr("[ Current icon theme is: ") + defaulttheme + " ]";//[ 当前图标主题是：
//                    iconcombo.selectedIndex = 0;
//                }

//                if(defaultdesktopcontrol != desktopcontrolFlag) {
//                    if(defaultdesktopcontrol == "true") {
//                        iconswitcher.switchedOn = true;
//                        sessiondispatcher.set_show_desktop_icons_qt(true);
//                    }
//                    else {
//                        iconswitcher.switchedOn = false;
//                        sessiondispatcher.set_show_desktop_icons_qt(false);
//                    }
//                }
//                if(defaultdocument != documentFlag) {
//                    if(defaultdocument == "true") {
//                        folderswitcher.switchedOn = true;
//                        sessiondispatcher.set_show_homefolder_qt(true);
//                    }
//                    else {
//                        folderswitcher.switchedOn = false;
//                        sessiondispatcher.set_show_homefolder_qt(false);
//                    }
//                }
//                if(defaultnetwork != networkFlag) {
//                    if(defaultnetwork == "true") {
//                        networkswitcher.switchedOn = true;
//                        sessiondispatcher.set_show_network_qt(true);
//                    }
//                    else {
//                        networkswitcher.switchedOn = false;
//                        sessiondispatcher.set_show_network_qt(false);
//                    }
//                }
//                if(defaultrecyclebin != recyclebinFlag) {
//                    if(defaultrecyclebin == "true") {
//                        trashswitcher.switchedOn = true;
//                        sessiondispatcher.set_show_trash_qt(true);
//                    }
//                    else {
//                        trashswitcher.switchedOn = false;
//                        sessiondispatcher.set_show_trash_qt(false);
//                    }
//                }
//                if(defaultdevice != deviceFlag) {
//                    if(defaultdevice == "true") {
//                        deviceswitcher.switchedOn = true;
//                        sessiondispatcher.set_show_devices_qt(true);
//                    }
//                    else {
//                        deviceswitcher.switchedOn = false;
//                        sessiondispatcher.set_show_devices_qt(false);
//                    }
//                }
//                statusImage.visible = true;
//            }
//        }
    }
    Timer {
        interval: 5000; running: true; repeat: true
        onTriggered: statusImage.visible = false
    }
}
