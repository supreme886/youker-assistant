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
#ifndef SYSTEMDISPATCHER_H
#define SYSTEMDISPATCHER_H

#include <QObject>
#include <QObject>
#include <QDBusInterface>
#include <QDBusConnection>
#include <QApplication>
#include <QString>
#include <QDeclarativeView>

class SystemDispatcher : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QNOTIFY myStringChanged)
    Q_PROPERTY(QNOTIFY finishCleanWork)
//    Q_PROPERTY(QString myString READ myString WRITE setmyString NOTIFY myStringChanged)
public:
    explicit SystemDispatcher(QObject *parent = 0);
    Q_INVOKABLE QString get_value(QString);
    Q_INVOKABLE int get_add_value();
    Q_INVOKABLE void send_btn_msg(QString);

    Q_INVOKABLE void check_screen_break_point();


    //---------------------------------
    //开机动画
    Q_INVOKABLE void custom_plymouth_qt(QString imagepath);
    Q_INVOKABLE QString show_file_dialog();
    Q_INVOKABLE int scan_history_records_qt();
    Q_INVOKABLE void clean_history_records_qt();
    Q_INVOKABLE QStringList scan_cookies_records_qt();
    Q_INVOKABLE void clean_cookies_records_qt(QStringList strlist);
    Q_INVOKABLE QStringList scan_unneed_packages_qt();
    Q_INVOKABLE void clean_package_cruft_qt(QStringList strlist);
    Q_INVOKABLE void clean_file_cruft_qt(QStringList strlist);
//    Q_INVOKABLE QMap<QString, QVariant> scan_cache_cruft_qt();


    Q_INVOKABLE void scan_cache_cruft_qt();
    Q_INVOKABLE QStringList get_apt_data();
    Q_INVOKABLE QStringList get_center_data();

    Q_INVOKABLE QStringList scan_apt_cruft_qt();
    Q_INVOKABLE QStringList scan_softwarecenter_cruft_qt();
    //---------------------------------







//    Q_INVOKABLE QMap<QString, QStringList> search_the_same_file(QString path);
    Q_INVOKABLE int get_the_record_qt(QString mode);
    Q_INVOKABLE void clean_the_browser_qt(QString mode);
    Q_INVOKABLE QMap<QString, QVariant> search_same_files(QString path);
    Q_INVOKABLE QStringList search_largest_file(QString path);

    //custom_plymouth
    QMap<QString, QVariant> myinfo;
    QMap<QString, QVariant> apt_center;
    QDBusInterface *systemiface;
    Q_INVOKABLE void set_str(QString str);
    Q_INVOKABLE QString get_str();
    QString notify_str;

//-------------
    QStringList apt_args;
    Q_INVOKABLE void set_apt_args(QString str);
    Q_INVOKABLE void del_apt_args(QString str);
    Q_INVOKABLE void clear_apt_args();
    Q_INVOKABLE QStringList get_apt_args();

    QStringList software_args;
    Q_INVOKABLE void set_software_args(QString str);
    Q_INVOKABLE void del_software_args(QString str);
    Q_INVOKABLE void clear_software_args();
    Q_INVOKABLE QStringList get_software_args();

    QStringList cookies_args;
    Q_INVOKABLE void set_cookies_args(QString str);
    Q_INVOKABLE void del_cookies_args(QString str);
    Q_INVOKABLE void clear_cookies_args();
    Q_INVOKABLE QStringList get_cookies_args();

    QStringList package_args;
    Q_INVOKABLE void set_package_args(QString str);
    Q_INVOKABLE void del_package_args(QString str);
    Q_INVOKABLE void clear_package_args();
    Q_INVOKABLE QStringList get_package_args();
//-------------


//    Q_INVOKABLE QString get_str(QString str);
//    Q_INVOKABLE QMap <int, QString> data;
//    Q_INVOKABLE QString getMyString();


    /*-------------------one key scan-------------------*/
    Q_INVOKABLE QMap<QString, QVariant> scan_by_one_key_qt();

signals:
    void myStringChanged(QString str);//绑定到QML的Handler：onMyStringChanged
    void finishCleanWork(QString msg);//绑定到QML的Handler：onFinishCleanWork

public slots:
    void handler_clear_rubbish(QString msg);
    QString show_signal(QString msg);
//    void setmyString(QString aString);
//    QString myString();
private:
    
};

#endif // SYSTEMDISPATCHER_H