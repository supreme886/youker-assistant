#-------------------------------------------------
#
# Project created by QtCreator 2015-01-21T08:48:08
#
#-------------------------------------------------
TARGET = kylin-assistant
DESTDIR = ../
TEMPLATE = app
CONFIG += c++11
CONFIG += qt warn_on
CONFIG += release
CONFIG += link_pkgconfig
PKGCONFIG += glib-2.0 gio-unix-2.0 gsettings-qt

QT += core dbus network charts svg KWindowSystem x11extras
LIBS += -lgsettings-qt
# 适配窗口管理器圆角阴影
LIBS +=-lpthread
LIBS +=-lX11
LIBS +=-lXrandr
LIBS +=-ludev

include(./qtsingleapplication.pri)

inst1.files += res/kylin-assistant.png
inst1.path = /usr/share/pixmaps
inst2.files += ../kylin-assistant.desktop
inst2.path = /usr/share/applications
inst3.files += res/default/
inst3.path = /var/lib/kylin-assistant-daemon/
inst4.files += res/custom/
inst4.path = /var/lib/kylin-assistant-daemon/
inst5.files += res/app-autostart-default.png
inst5.path = /usr/share/pixmaps
target.source += $$TARGET
target.path = /usr/bin
INSTALLS += inst1 \
    inst2 \
    inst3 \
    inst4 \
    inst5 \
    target

QMAKE_CPPFLAGS *= $(shell dpkg-buildflags --get CPPFLAGS)
QMAKE_CFLAGS   *= $(shell dpkg-buildflags --get CFLAGS)
QMAKE_CXXFLAGS *= $(shell dpkg-buildflags --get CXXFLAGS)
QMAKE_LFLAGS   *= $(shell dpkg-buildflags --get LDFLAGS)

isEqual(QT_MAJOR_VERSION, 5) {
    QT += widgets gui
}

unix {
    UI_DIR = .ui
    MOC_DIR = .moc
    OBJECTS_DIR = .obj
}

SOURCES += main.cpp \
    ../cleaner/cleandetailveiw.cpp \
    ../component/chartwidget.cpp \
    ../component/cpufmwidget.cpp \
    ../component/detailsbutton.cpp \
    ../component/drivepagewidget.cpp \
    ../component/fanwidget.cpp \
    ../component/generaldialog.cpp \
    ../component/myslider.cpp \
    ../component/temperature.cpp \
    drivewidget.cpp \
    listwidget.cpp \
    mainwindow.cpp \
    maintopwidget.cpp \
    middlewidget.cpp \
    mainbottomwidget.cpp \
    monitorwidget.cpp \
    optimizedwidget.cpp \
    qtsingleapplication/qtlockedfile.cpp \
    qtsingleapplication/qtlockedfile_unix.cpp \
    qtsingleapplication/qtlockedfile_win.cpp \
    qtsingleapplication/qtsinglecoreapplication.cpp \
    topbasewidget.cpp \
    bottomcontentwidget.cpp \
    infowidget.cpp \
    cleanerwidget.cpp \
    settingwidget.cpp \
    boxwidget.cpp \
    pluginmanager.cpp \
    aboutdialog.cpp \
    shadowwidget.cpp \
    dataworker.cpp \
    udevhotplugin.cpp \
    aboutwidget.cpp \
    ../component/kylinlistmodel.cpp \
    ../component/kylinbutton.cpp \
    ../component/kylinmenu.cpp \
    ../component/kylintoolbutton.cpp \
    ../component/kylinswitcher.cpp \
    ../component/systembutton.cpp \
    ../component/threadpool.cpp \
    ../component/mythread.cpp \
    ../component/selectlistwidget.cpp \
    ../component/selectlistitem.cpp \
    ../component/selectwidget.cpp \
    ../component/selectcategorywidget.cpp \
    ../component/mytitlebar.cpp \
    ../plugins/widgets/mytristatebutton.cpp \
    ../info/infounitwidget.cpp \
    ../info/infogui.cpp \
    ../info/infoitemline.cpp \
    ../info/infoitemsgroup.cpp \
    ../info/devicemanager.cpp \
    ../setting/settinglistview.cpp \
    ../setting/settingmodel.cpp \
    ../setting/settingdelegate.cpp \
    ../setting/themewidget.cpp \
    ../setting/iconwidget.cpp \
    ../setting/mousewidget.cpp \
    ../setting/soundwidget.cpp \
    ../setting/menuwidget.cpp \
    ../setting/panelwidget.cpp \
    ../setting/windowwidget.cpp \
    ../setting/fontwidget.cpp \
    ../setting/touchpadwidget.cpp \
    ../setting/energywidget.cpp \
    ../setting/filemanagerwidget.cpp \
    ../setting/theme/themeview.cpp \
    ../setting/theme/themedelegate.cpp \
    ../component/quibo.cpp \
    ../component/kylinfontdialog.cpp \
    ../component/loadinglabel.cpp \
    ../component/alertdialog.cpp \
    ../component/toolkits.cpp \
#    ../cleaner/cleanerdetailwidget.cpp \
    ../cleaner/cleanermainwidget.cpp \
    ../dbusproxy/youkersystemdbus.cpp \
    ../dbusproxy/youkersessiondbus.cpp \
    ../component/toolbutton.cpp \
    ../component/cleangroup.cpp \
    ../component/cleanbutton.cpp \
    ../component/cleansubgroup.cpp \
    ../component/cleansubbutton.cpp \
    ../component/basewidget.cpp \
    ../qdbusservice/systemdbus/data/systemdbusproxy.cpp \
    ../qdbusservice/systemdbus/data/systeminterface.cpp \
    ../qdbusservice/systemdbus/customdata.cpp \
    ../qdbusservice/systemdbus/customdatalist.cpp \
    xatom-helper.cpp

HEADERS  += mainwindow.h \
    ../cleaner/cleandetailveiw.h \
    ../component/chartwidget.h \
    ../component/cpufmwidget.h \
    ../component/detailsbutton.h \
    ../component/drivepagewidget.h \
    ../component/fanwidget.h \
    ../component/generaldialog.h \
    ../component/myslider.h \
    ../component/temperature.h \
    drivewidget.h \
    kpplication.h \
    listwidget.h \
    maintopwidget.h \
    middlewidget.h \
    mainbottomwidget.h \
    monitorwidget.h \
    optimizedwidget.h \
    qtsingleapplication/QtLockedFile \
    qtsingleapplication/QtSingleApplication \
    qtsingleapplication/qtlockedfile.h \
    qtsingleapplication/qtsinglecoreapplication.h \
    topbasewidget.h \
    bottomcontentwidget.h \
    infowidget.h \
    cleanerwidget.h \
    settingwidget.h \
    boxwidget.h \
    pluginmanager.h \
    aboutdialog.h \
    shadowwidget.h \
    dataworker.h \
    udevhotplugin.h \
    aboutwidget.h \
    ../component/plugininterface.h \
    ../component/kylinlistmodel.h \
    ../component/utils.h \
    ../component/kylinbutton.h \
    ../component/kylinmenu.h \
    ../component/kylintoolbutton.h \
    ../component/kylinswitcher.h \
    ../component/systembutton.h \
    ../component/threadpool.h \
    ../component/mythread.h \
    ../component/selectlistwidget.h \
    ../component/selectlistitem.h \
    ../component/selectwidget.h \
    ../component/selectcategorywidget.h \
    ../component/mytitlebar.h \
    ../plugins/widgets/mytristatebutton.h \
    ../info/infounitwidget.h \
    ../info/infogui.h \
    ../info/infoitemline.h \
    ../info/infoitemsgroup.h \
    ../info/devicemanager.h \
    ../setting/settingmodulelpage.h \
    ../setting/settinglistview.h \
    ../setting/settingmodel.h \
    ../setting/settingdelegate.h \
    ../setting/themewidget.h \
    ../setting/iconwidget.h \
    ../setting/mousewidget.h \
    ../setting/soundwidget.h \
    ../setting/menuwidget.h \
    ../setting/panelwidget.h \
    ../setting/windowwidget.h \
    ../setting/fontwidget.h \
    ../setting/touchpadwidget.h \
    ../setting/energywidget.h \
    ../setting/filemanagerwidget.h \
    ../setting/theme/themeview.h \
    ../setting/theme/themedelegate.h \
    ../component/quibo.h \
    ../component/kylinfontdialog.h \
    ../component/loadinglabel.h \
    ../component/alertdialog.h \
    ../component/toolkits.h \
#    ../cleaner/cleanerdetailwidget.h \
    ../cleaner/cleanermainwidget.h \
    ../dbusproxy/youkersystemdbus.h \
    ../dbusproxy/youkersessiondbus.h \
    ../component/toolbutton.h \
    ../component/cleangroup.h \
    ../component/cleanbutton.h \
    ../component/cleansubgroup.h \
    ../component/cleansubbutton.h \
    ../component/basewidget.h \
    ../qdbusservice/systemdbus/data/systemdbusproxy.h \
    ../qdbusservice/systemdbus/data/systeminterface.h \
    ../qdbusservice/systemdbus/data/systemdbushandler.h \
    ../qdbusservice/systemdbus/customdata.h \
    ../qdbusservice/systemdbus/customdatalist.h \
    xatom-helper.h

FORMS    += \
    ../component/quibo.ui \
    ../component/alertdialog.ui

RESOURCES += \
    img.qrc

INCLUDEPATH += qtsingleapplication
DEPENDPATH += qtsingleapplication

SOURCES += qtsingleapplication/qtsingleapplication.cpp qtsingleapplication/qtlocalpeer.cpp
HEADERS += qtsingleapplication/qtsingleapplication.h qtsingleapplication/qtlocalpeer.h

DISTFILES += \
    qtsingleapplication/qtsingleapplication.pri \
    qtsingleapplication/qtsinglecoreapplication.pri
