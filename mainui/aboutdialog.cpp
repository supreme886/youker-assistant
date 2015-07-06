/*
 * Copyright (C) 2013 ~ 2015 National University of Defense Technology(NUDT) & Kylin Ltd.
 *
 * Authors:
 *  Kobe Lee    xiangli@ubuntukylin.com/kobe24_lixiang@126.com
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

#include "QDesktopWidget"

#include "aboutdialog.h"
#include <QtGui>
#include <QPropertyAnimation>
#include <QParallelAnimationGroup>

AboutDialog::AboutDialog(QWidget *parent, const QString &version, QString skin) :
    QDialog(parent)
{
    this->setWindowFlags(Qt::FramelessWindowHint);
//    this->setWindowFlags(Qt::WindowStaysOnTopHint);
    this->setFixedSize(442, 326);
    this->setStyleSheet("QDialog{border: 1px solid white;border-radius:1px;background-color: #ffffff;}");

    aboutGroup = NULL;
    contributorGroup = NULL;

    baseWidget = new QWidget(this);
    baseWidget->setGeometry(QRect(0, 0, 442, 82));
//    baseWidget->setStyleSheet("QWidget{background:transparent url(://res/menu-big-hover.png);}");
    baseWidget->setAutoFillBackground(true);
//    QPixmap label_pixmap(skin);
//    logo_label->setPixmap(label_pixmap);
//    logo_label->setFixedSize(label_pixmap.size());

//    QPixmap label_pixmap(skin);
//    qDebug() << label_pixmap.size();

    QPalette palette;
    palette.setBrush(QPalette::Background, QBrush(QPixmap(skin)));
    baseWidget->setPalette(palette);

    close_btn = new SystemButton(baseWidget);
    close_btn->setFocusPolicy(Qt::NoFocus);
    close_btn->loadPixmap(":/sys/res/sysBtn/close_button.png");

    iconLabel = new QLabel(baseWidget);
    iconLabel->setGeometry(QRect(380, 20, 44, 44));
    nameLabel = new QLabel(baseWidget);
    nameLabel->setGeometry(QRect(71, 0, 300, 30));
//    linkLabel = new QLabel();
//    iconLabel->setStyleSheet("QLabel{background-image:url(':/res/youker-assistant.png')}");

    QImage image(":/res/youker-assistant.png");
    image = image.scaled(QSize(44, 44), Qt::KeepAspectRatio, Qt::SmoothTransformation);
    iconLabel->setPixmap(QPixmap::fromImage(image));

    nameLabel->setStyleSheet("QLabel{color:#ffffff;font-family: 方正黑体_GBK;font-size: 12px;text-align: center;font-weight:bold;}");
    nameLabel->setAlignment(Qt::AlignCenter);
    nameLabel->setText(tr("Youker Assisant") + " " + version);
//    linkLabel->setAlignment(Qt::AlignRight);
//    linkLabel->setText(QString::fromLocal8Bit("<a style='color: green;' href = https://launchpad.net/youker-assistant> home page</a>"));

    aboutBtn = new QPushButton(baseWidget);
    aboutBtn->setText(tr("About"));
    aboutBtn->setGeometry(QRect(10, 50, 60, 24));
    contributorBtn = new QPushButton(baseWidget);
    contributorBtn->setText(tr("Contributor"));
    contributorBtn->setGeometry(QRect(75, 50, 60, 24));

    indicator = new QLabel(baseWidget);
    indicator->setStyleSheet("QLabel{background-image:url('://res/underline.png');background-position:center;}");
    indicator->setGeometry(QRect(10, 75, 60, 2));
//    aboutIndicator = new QLabel(baseWidget);
//    aboutIndicator->setGeometry(QRect(10, 75, 60, 2));
//    contributorIndicator = new QLabel(baseWidget);
//    contributorIndicator->setGeometry(QRect(75, 75, 60, 2));
//    aboutIndicator->setStyleSheet("QLabel{background-image:url('://res/underline.png');background-position:center;}");
//    contributorIndicator->setStyleSheet("QLabel{background-image:url('://res/underline.png');background-position:center;}");
//    contributorIndicator->hide();

//    aboutEdit = new QTextEdit(this);
    aboutEdit = new QTextBrowser(this);
    aboutEdit->setOpenLinks(true);
    aboutEdit->setOpenExternalLinks(true);
    contributorEdit = new QTextEdit(this);
    aboutEdit->setGeometry(QRect(17, 92, 408, 200));
    contributorEdit->setGeometry(QRect(17, 92, 408, 200));
    aboutEdit->setReadOnly(true);
    contributorEdit->setReadOnly(true);
    aboutEdit->append(tr("      Youker Assistant is a powerful system supporting software which is developed by Ubuntu Kylin team. Mainly for the naive user, it can help users manage the system. At present, It provides system junk scanning and cleaning, viewing the system hardware and software information , system customization, task manager, monitoring ball, and some other functions. \n      The software is still under development. Please visit www.ubuntukylin.com for more information. Welcome everyone to join with us. youker-assistant Homepage: "));
    aboutEdit->append(QString::fromLocal8Bit("<a href=\"https://launchpad.net/youker-assistant\">https://launchpad.net/youker-assistant</a>"));
    contributorEdit->setText(tr("Maintainer:\nUbuntu Kylin Team <ubuntukylin-members@list.launchpad.net>"));
    contributorEdit->hide();

    aboutBtn->setFocusPolicy(Qt::NoFocus);
    aboutBtn->setObjectName("transparentButton");
    contributorBtn->setFocusPolicy(Qt::NoFocus);
    contributorBtn->setObjectName("transparentButton");
    aboutBtn->setStyleSheet("QPushButton{background:transparent;text-align:center;font-family: 方正黑体_GBK;font-size:14px;color:#ffffff;}");//QPushButton:hover{color:#666666;}
    contributorBtn->setStyleSheet("QPushButton{background:transparent;text-align:center;font-family: 方正黑体_GBK;font-size:14px;color:#ffffff;}");//QPushButton:hover{color:#666666;}
//    aboutEdit->setStyleSheet("QLineEdit{border:1px solid #bebebe;}");
//    contributorEdit->setStyleSheet("QLineEdit{border:1px solid #bebebe;}");
    aboutEdit->setStyleSheet("QTextBrowser{border:none;font-family: 方正黑体_GBK;font-size:14px;}");
    contributorEdit->setStyleSheet("QTextEdit{border:none;font-family: 方正黑体_GBK;font-size:14px;}");
    okBtn = new QPushButton(this);
    okBtn->setGeometry(QRect(334, 295, 90, 25));
    okBtn->setObjectName("blackButton");
    okBtn->setFocusPolicy(Qt::NoFocus);
    okBtn->setText(tr("Close"));
    this->initAnimation();
    this->initConnect();
}

AboutDialog::~AboutDialog()
{
    if(aboutGroup != NULL)
    {
        delete aboutGroup;
        aboutGroup = NULL;
    }
    if(contributorGroup != NULL)
    {
        delete contributorGroup;
        contributorGroup = NULL;
    }
}

void AboutDialog::initAnimation()
{
    QRect mainAcitonRect(10, 75, 60, 2);
    QRect origAcitonRect(75, 75, 60, 2);

    QPropertyAnimation *aboutAnimation = new QPropertyAnimation(indicator, "geometry");
    aboutAnimation->setDuration(300);
    aboutAnimation->setStartValue(origAcitonRect);
    aboutAnimation->setEndValue(mainAcitonRect);

    aboutGroup = new QParallelAnimationGroup(this);
    aboutGroup->addAnimation(aboutAnimation);

    QPropertyAnimation *contributorAnimation = new QPropertyAnimation(indicator, "geometry");
    contributorAnimation->setDuration(300);
    contributorAnimation->setStartValue(mainAcitonRect);
    contributorAnimation->setEndValue(origAcitonRect);

    contributorGroup = new QParallelAnimationGroup(this);
    contributorGroup->addAnimation(contributorAnimation);
}

void AboutDialog::initConnect()
{
    connect(aboutBtn, SIGNAL(clicked()), this, SLOT(onAboutBtnClicked()));
    connect(contributorBtn, SIGNAL(clicked()), this, SLOT(onContributorBtnClicked()));
    connect(close_btn, SIGNAL(clicked()), this, SLOT(onCloseBtnClicked()));
    connect(okBtn, SIGNAL(clicked()), this, SLOT(onCloseBtnClicked()));
//    connect(title_bar,SIGNAL(closeDialog()), this, SLOT(onCloseBtnClicked()));
//    connect(linkLabel,SIGNAL(linkActivated(QString)),this,SLOT(openUrl(QString)));
}

void AboutDialog::onAboutBtnClicked()
{
    aboutGroup->start();
    aboutEdit->show();
//    aboutIndicator->show();
    contributorEdit->hide();
//    contributorIndicator->hide();
}

void AboutDialog::onContributorBtnClicked()
{
    contributorGroup->start();
    contributorEdit->show();
//    contributorIndicator->show();
    aboutEdit->hide();
//    aboutIndicator->hide();
}

void AboutDialog::resetTitleSkin(QString skin)
{
//    title_bar->resetBackground(skin);
    QPalette palette;
    palette.setBrush(QPalette::Background, QBrush(QPixmap(skin)));
    baseWidget->setPalette(palette);
}

void AboutDialog::onCloseBtnClicked()
{
    this->close();
}

void AboutDialog::openUrl(QString url)
{
    QDesktopServices::openUrl(QUrl(url));
}

void AboutDialog::mousePressEvent(QMouseEvent *event)
{
    if(event->button() == Qt::LeftButton)
    {
        mouse_press = true;
        drag_pos = event->globalPos() - this->frameGeometry().topLeft();
        event->accept();
    }
}

void AboutDialog::mouseReleaseEvent(QMouseEvent *)
{
    mouse_press = false;
}

void AboutDialog::mouseMoveEvent(QMouseEvent *event)
{
    if(mouse_press)
    {
        QPoint move_pos = event->globalPos();
        move(move_pos - drag_pos);
        event->accept();
    }
}
