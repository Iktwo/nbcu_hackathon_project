#include "api.h"
#include "cookiejar.h"
#include <QDebug>
#include <QtConcurrent>

//#ifndef Q_OS_IOS
#include <QSsl>
#include <QSslCertificate>
//#endif

QT_BEGIN_NAMESPACE

Api::Api(QObject *parent) : QObject(parent),
    m_networkManager(0),
    m_appId("")
{
////#ifndef Q_OS_IOS
//    QFile file(":/qml/ssl/server.crt");
//    file.open(QIODevice::ReadOnly);
//    const QByteArray bytes = file.readAll();
//    const QSslCertificate certificate(bytes);
//    QSslSocket::addDefaultCaCertificate(certificate);
////#endif
    m_networkManager = new QNetworkAccessManager(this);
    CookieJar *cookieJar = new CookieJar(m_networkManager);
    cookieJar->read();
    m_networkManager->setCookieJar(cookieJar);
    connect(m_networkManager, SIGNAL(finished(QNetworkReply*)),
            this, SLOT(replyFinished(QNetworkReply*)));
}

Api::~Api()
{

}

void Api::post(QString url, QVariantMap parameters)
{
    m_future.cancel();
    QUrlQuery postData;
    QStringList keys = parameters.keys();
    for(int i = 0; i < keys.count(); i++)
    {
        QString key = keys.at(i);
        QString value = QVariant(parameters.value(key)).toString();

        postData.addQueryItem(key, value);
    }

    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader,
                      "Content-Type: application/json");

    request.setRawHeader("X-Parse-Application-Id", m_appId.toUtf8());

    // Set cookies, if available
    QList<QNetworkCookie> cookieList = m_networkManager->cookieJar()->cookiesForUrl(request.url().toString(QUrl::RemovePath));
    for(auto it = cookieList.begin(); it != cookieList.end(); ++it){
        request.setHeader(QNetworkRequest::CookieHeader, QVariant::fromValue(*it));
    }

    m_networkManager->post(request, postData.toString(QUrl::FullyEncoded).toUtf8());
}

void Api::get(QString url)
{
    m_future.cancel();
    qDebug() << Q_FUNC_INFO;
    this->get(url, QVariantMap());
}

void Api::get(QString url, QVariantMap parameters)
{
    m_future.cancel();
    qDebug() << Q_FUNC_INFO;
    QString urlCombined = url;
    QStringList keys =  parameters.keys();
    for(int i = 0; i < keys.length(); i++)
    {
        urlCombined += (i == 0 ? "?" : "&") + keys.value(i) + "=" + parameters.value(keys.value(i)).toString();
    }

    qDebug() << urlCombined;
    QNetworkRequest request(urlCombined);
    request.setHeader(QNetworkRequest::ContentTypeHeader,
                      "Content-Type: application/json");

    request.setRawHeader("X-Parse-Application-Id", m_appId.toUtf8());

    // TODO: Remove this, it's handled by QNetworkAccessManager
    // Set cookies, if necessary
    //    QList<QNetworkCookie> cookieList = m_networkManager->cookieJar()->cookiesForUrl(request.url().toString(QUrl::RemovePath));
    //    for(auto it = cookieList.begin(); it != cookieList.end(); ++it){
    //        request.setHeader(QNetworkRequest::CookieHeader, QVariant::fromValue(*it));
    //    }

    m_networkManager->get(request);
}

void Api::replyFinished(QNetworkReply *reply)
{
    qDebug() << Q_FUNC_INFO;
    //    QByteArray result = reply->readAll();
    // TODO: Async this fromJson
    //    QJsonDocument jsonDocument = QJsonDocument::fromJson(QString(result).toUtf8());
    //    QJsonObject jsonObject = jsonDocument.object();

    QVariant possibleRedirectUrl =
                reply->attribute(QNetworkRequest::RedirectionTargetAttribute);
    qDebug() << "redir:" << possibleRedirectUrl.toString();

    qDebug() << "error:" << reply->errorString();
    m_future = QtConcurrent::run(parseJson, reply->readAll());

    QJsonObject jsonObject = m_future.result();
    // TODO: Remove this, it's handled by QNetworkAccessManager
    // Save cookies, if necessary
    //    QList<QNetworkCookie> cookieList = qvariant_cast<QList<QNetworkCookie> >(reply->header(QNetworkRequest::SetCookieHeader));
    //    if(cookieList.count() > 0)
    //    {
    //        qDebug() << Q_FUNC_INFO << "saving cookie for url =" << reply->url().toString(QUrl::RemovePath);
    //        m_networkManager->cookieJar()->setCookiesFromUrl(cookieList, reply->url().toString(QUrl::RemovePath));
    //    }

    CookieJar *cookieJar = (CookieJar*)m_networkManager->cookieJar();
    cookieJar->save();

    qDebug() << reply->url();

    emit Api::reply(reply->url().toString(), jsonObject);
}

QJsonObject Api::parseJson(QByteArray response)
{
    QJsonDocument jsonDocument = QJsonDocument::fromJson(response);
    return jsonDocument.object();

    //    emit Api::reply(reply->url().toString(), jsonObject);
}

QT_END_NAMESPACE
