#ifndef API_H
#define API_H

#include <QObject>
#include <QtNetwork>
#include <QJsonObject>

class Api : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString appId READ appId WRITE setAppId NOTIFY appIdChanged)

public:
    explicit Api(QObject *parent = 0);
    ~Api();

    Q_INVOKABLE void post(QString url, QVariantMap parameters);
    Q_INVOKABLE void get(QString url);
    Q_INVOKABLE void get(QString url, QVariantMap parameters);

#ifdef Q_OS_IOS
   QByteArray getLocalCertificateData() {
       return m_localCertificateData;
   }
#endif

   QString appId() const
   {
       return m_appId;
   }

private:
    QFuture<QJsonObject> m_future;
    static QJsonObject parseJson(QByteArray response);

signals:
    void reply(QString url, QJsonObject data);

    void appIdChanged(QString appId);

public slots:

void setAppId(QString appId)
{
    if (m_appId == appId)
        return;

    m_appId = appId;
    emit appIdChanged(appId);
}

private slots:
    void replyFinished(QNetworkReply *reply);

private:
    QNetworkAccessManager *m_networkManager;

#ifdef Q_OS_IOS
    void *m_delegate;
    QByteArray m_localCertificateData;
#endif
    QString m_appId;
};

#endif // API_H
