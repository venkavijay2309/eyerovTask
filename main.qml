import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0
import DatagenItem 1.0

ApplicationWindow {
    id:window
    visible: true
    width: 800
    height: 600
    title: "Icon Movement"
    property real altitude: 0
    property real altitudeValue: 0
    property real altitudeReading: 0

    property real depth: 0
    property real depthValue: 0
    property real depthReading: 0

    property real prevX: 0
    property real prevY:0

    property bool clearSand: false
    property bool clearPath: false

    Rectangle{
        anchors.fill: parent
        color: "skyblue"
    }

    Rectangle {
        id: icon
        width: 100
        height: 80
        color: "transparent"
        x:iconX
        y:iconY

        Image {
            id: vehicleIcon
            source: "qrc:/rov_icon.png"
            width: 100
            height: 80
        }

        focus: true

        property int iconX: 0
        property int iconY: 0

        onIconXChanged: {
            if (iconX > window.width - icon.width) {
                iconX = 0
                clearSandFun()

                console.log("   clear....")
            }
            if (iconX < 0) {
                iconX = window.width - icon.width
            }
            updateSandHeight()
            updateDepth();
            sandPaint.requestPaint();
            altitudePaint.requestPaint();
            depthPaint.requestPaint();
            pathPaint.requestPaint();

        }

        onIconYChanged: {
            if (iconY > window.height - icon.height) {
                iconY = 0
            }
            if (iconY < 0) {
                iconY = window.height - icon.height
            }
        }


//        Keys.onPressed: {
//            switch (event.key) {
//                case Qt.Key_Up:
//                    iconY -= 10
//                    break;
//                case Qt.Key_Down:
//                    iconY += 10
//                    break;
//                case Qt.Key_Right:
//                    iconX += 1
//                    break;
//            }
//        }

        Timer {
            id:timer
                   interval: 100 // Adjust this value to control the speed of movement
                   repeat: true
                   running: true
                   onTriggered: {
                       icon.iconX += 1 // Adjust this value to control the distance of movement
                   }
               }
        function updateSandHeight() {
                    if (iconX >= window.width - icon.width) {
                        altitude = 0
                    } else {
                        altitude = altitudeValue
                    }

                }

        function updateDepth() {
                    if (iconX >= window.width - icon.width) {
                        depth = 0
                    } else {
                        depth = depthValue
                    }

                }

                function clearSandFun() {
                    altitude = 0
                    clearSand=true
                    clearPath=true
                }
    }

    Canvas {
        id:altitudePaint
        anchors.fill: parent

        function arrow(context, fromx, fromy, tox, toy,value) {
          const dx = tox - fromx;
          const dy = toy - fromy;
          const headlen = Math.sqrt(dx * dx + dy * dy) * 0.3; // length of head in pixels
          const angle = Math.atan2(dy, dx);
          context.beginPath();
          context.moveTo(fromx, fromy);
          context.lineTo(tox, toy);
          context.stroke();
          context.beginPath();
          context.moveTo(tox - 10*Math.cos(angle - Math.PI / 6), toy - 10 * Math.sin(angle - Math.PI / 6));
          context.lineTo(tox, toy );
          context.lineTo(tox - 10*Math.cos(angle + Math.PI / 6), toy - 10 * Math.sin(angle + Math.PI / 6));
          context.stroke();

          context.beginPath();
          context.moveTo(fromx - (-10)*Math.cos(angle - Math.PI / 6), fromy - (-10) * Math.sin(angle - Math.PI / 6));
          context.lineTo(fromx, fromy );
          context.lineTo(fromx - (-10)*Math.cos(angle + Math.PI / 6), fromy - (-10) * Math.sin(angle + Math.PI / 6));
          context.stroke();

          context.beginPath();
          context.fillStyle = "black";
          context.fillText(qsTr(" "+value.toFixed(2)+" m"),fromx ,fromy+((toy-fromy)/2));
          context.stroke();
        }
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            arrow(ctx, icon.iconX+50, icon.iconY+icon.height,icon.iconX+50,icon.iconY+icon.height+altitudeValue-5,altitudeReading)
        }
    }

    Canvas {
        id:depthPaint
        anchors.fill: parent

        function arrow(context, fromx, fromy, tox, toy,value) {
          const dx = tox - fromx;
          const dy = toy - fromy;
          const headlen = Math.sqrt(dx * dx + dy * dy) * 0.3; // length of head in pixels
          const angle = Math.atan2(dy, dx);
          context.beginPath();
          context.moveTo(fromx, fromy);
          context.lineTo(tox, toy);
          context.stroke();
          context.beginPath();
          context.moveTo(tox - 10*Math.cos(angle - Math.PI / 6), toy - 10 * Math.sin(angle - Math.PI / 6));
          context.lineTo(tox, toy );
          context.lineTo(tox - 10*Math.cos(angle + Math.PI / 6), toy - 10 * Math.sin(angle + Math.PI / 6));
          context.stroke();

          context.beginPath();
          context.moveTo(fromx - (-10)*Math.cos(angle - Math.PI / 6), fromy - (-10) * Math.sin(angle - Math.PI / 6));
          context.lineTo(fromx, fromy );
          context.lineTo(fromx - (-10)*Math.cos(angle + Math.PI / 6), fromy - (-10) * Math.sin(angle + Math.PI / 6));
          context.stroke();

          context.beginPath();
          context.fillStyle = "black";
          context.fillText(qsTr(" "+value.toFixed(2)+" m"),fromx ,fromy+((toy-fromy)/2));
          context.stroke();
        }
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            arrow(ctx, icon.iconX+50, icon.iconY,icon.iconX+50,0,depthReading)
        }
    }

    Canvas {
        id:sandPaint
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d")
            if(clearSand){
                clearSand=false
                ctx.reset()
            }
            ctx.beginPath()
            ctx.lineWidth = 1;
            ctx.strokeStyle = "sandybrown"
            ctx.moveTo(icon.iconX+50, height)
            ctx.lineTo(icon.iconX+50, icon.iconY+icon.height+altitudeValue)
            ctx.stroke()
        }
    }

    Canvas {
        id:pathPaint
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d")
            console.log("clearPath :: ",clearPath)
            if(clearPath){
                clearPath=false
                prevX=0;
                prevY=0;
                ctx.reset()
            }
            ctx.beginPath()
            ctx.lineWidth = 1;
            ctx.strokeStyle = "red"
            ctx.moveTo(prevX, prevY)
            ctx.lineTo(icon.iconX-5,icon.iconY+vehicleIcon.height/2)
            ctx.stroke()
            prevX=icon.iconX-5
            prevY=icon.iconY+vehicleIcon.height/2
        }
    }


    Datagen {
               id: dataGenerator
               onDepthChanged: {
                   // Update the depth value in QML
                   depthReading = depth;
                   window.depthValue=window.height-(window.height * (1 - (depth / 20)))
                   icon.iconY = window.height-(window.height * (1 - (depth / 20)))
               }
               onAltitudeChanged: {
                   // Update the altitude value in QML
                   altitudeReading=altitude
                   window.altitudeValue=window.height-(window.height * (1 - (altitude / 20)))
               }
           }

}
