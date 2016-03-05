#include "cookiejar.h"
#include <QFile>
#include <QDebug>
#include <QDateTime>

#define COOKIE_PATH QStandardPaths::writableLocation(QStandardPaths::DataLocation) + QDir::separator()
#define COOKIE COOKIE_PATH + "cookies.data"

CookieJar::CookieJar(QObject* parent):
    QNetworkCookieJar(parent)
{
    QDir d;
    d.mkpath(COOKIE_PATH);
}

CookieJar::~CookieJar()
{

}

// TODO: Clean all this bullshit up, some dbag wrote it

void CookieJar::save()
{
    qDebug() << Q_FUNC_INFO;
    qDebug() << COOKIE_PATH;
    QFile f(COOKIE);
    if(!f.open(QIODevice::ReadWrite | QIODevice::Text))
    {
        return;
    }

    QList<QNetworkCookie> l = allCookies();
    foreach(QNetworkCookie c, l)
    {
        if(!c.name().isEmpty() && !c.value().isEmpty())
        {
            f.write(c.toRawForm()+"\n");
        }
    }
}

void CookieJar::read()
{
    qDebug() << Q_FUNC_INFO;
    qDebug() << COOKIE_PATH;
    QFile f(COOKIE);

    if(!f.exists())
    {
        return;
    }

    if (!f.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        return;
    }

    QList<QNetworkCookie> list;

    while(!f.atEnd())
    {
        QList<QByteArray> spl = f.readLine().split(';');
        QList<QByteArray> cookie = spl[0].split('=');

        if(cookie.length() < 2 || cookie[0].isEmpty() || cookie[1].isEmpty())
        {
            continue;
        }

        QMap<QByteArray, QByteArray> add;
        for(int cnt = 1; spl.length() > cnt; cnt++)
        {
            QList<QByteArray> t = spl[cnt].split('=');
            if(t.count() > 1)
            {
                add[t[0].trimmed()] = t[1].trimmed();
            }
        }

        QNetworkCookie c;
        c.setName(cookie[0]);
        c.setValue(cookie[1]);
        c.setPath(add["path"]);
        c.setDomain(add["domain"]);
        c.setExpirationDate(QDateTime::fromString(add["expires"]));
        list.append(c);
    }
    setAllCookies(list);
}
