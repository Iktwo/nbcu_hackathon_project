#ifndef COOKIEJAR_H
#define COOKIEJAR_H

#include <QtNetwork>

class CookieJar : public QNetworkCookieJar
{
public:
    CookieJar(QObject* parent = 0);
    ~CookieJar();

    void save();
    void read();
};

#endif // COOKIEJAR_H
