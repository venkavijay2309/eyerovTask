#include "datagenerator.h"
#include <QRandomGenerator>
#include <QtCore/QtMath>
DataGenerator::DataGenerator(QObject *parent)
    : QObject(parent)
{
    timer = new QTimer(this);
    connect(timer, &QTimer::timeout, this, &DataGenerator::generateData);
    timer->start(1000); // Update data every 1 second
}
void DataGenerator::generateData()
{
    c++;
    // Generate random values for depth and altitude
    double f = (double) rand() / RAND_MAX;
    double depth = 0 + f * (20 - 0);
    double f1 = (double) rand() / RAND_MAX;
    double altitude = 0 + f * (20 - 0);
    emit depthChanged(depth);
    emit altitudeChanged(qSin(1000 * c) + altitude);
}
