#ifndef DATAGENERATOR_H
#define DATAGENERATOR_H
#include <QObject>
#include <QTimer>
class DataGenerator : public QObject
{
    Q_OBJECT
public:
    explicit DataGenerator(QObject *parent = nullptr);
signals:
    void depthChanged(double depth);
    void altitudeChanged(double altitude);
private slots:
    void generateData();
private:
    QTimer *timer;
    int c = 0;
};

#endif // DATAGENERATOR_H
