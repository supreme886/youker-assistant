#include "httpauth.h"
#include <QObject>
#include <QDebug>
#include <QStringList>
HttpAuth::HttpAuth(QObject *parent) :
    QObject(parent)
{
    mManager = new QNetworkAccessManager(this);
    QObject::connect(mManager, SIGNAL(finished(QNetworkReply*)),this, SLOT(replyFinished(QNetworkReply*)));
}

void HttpAuth::sendPostRequest(const QUrl &url, const QByteArray &data){
    mUrl = url;
    QNetworkRequest request(mUrl);
//    request.setUrl(QUrl(strUrl));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    mManager->post(request, data);
}

void HttpAuth::replyFinished(QNetworkReply *reply){
    if(reply && reply->error() == QNetworkReply::NoError) {
        /*QByteArray*/QString data = reply->readAll();
        qDebug() << "Result:->";
        qDebug() << data;//"I AM HERE"
        QStringList tmp = data.split("<br>");
        qDebug() << QString("%1").arg(tmp.length());
        if(tmp.at(0) == "sccuss") {
            qDebug() << "login success";
            emit this->response(tmp.at(1), tmp.at(2), "1000");
        }
//        int len = data.size();
//        emit this->response(len);
    } else {
        qDebug() << "ERROR:->";
        qDebug() << reply->errorString();//"网络不能访问"
        qDebug() << QString("%1").arg((int)reply->error());//99
        emit this->error((int)reply->error());
    }
    reply->close();
}