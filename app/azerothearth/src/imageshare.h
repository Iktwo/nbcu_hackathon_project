#ifndef IMAGESHARE_H
#define IMAGESHARE_H

#include <QObject>

class ImageShare : public QObject
{
    Q_OBJECT
public:
    explicit ImageShare(QObject *parent = 0);

    Q_INVOKABLE void shareImage();

signals:

public slots:
};

#endif // IMAGESHARE_H
