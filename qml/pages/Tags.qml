import QtQuick 2.0
import Sailfish.Silica 1.0
import "../JSONListModel"

Page {
    width: parent.width
    height: parent.height
    //property int stcount: 6

 /*   JSONListModel {
        id: getTags
        source: "http://all.api.radio-browser.info/json/tags"
        query: "$[?(@.stationcount>6)]"
    } */

    SilicaFlickable {
        anchors.fill: parent
        anchors.bottomMargin: playerPanel.visibleSize
        contentWidth: parent.width;
        contentHeight: flow.childrenRect.height + pHeader.height + (Theme.paddingLarge * 2)
        clip: true
        ScrollDecorator {}

        property int retning: 0
        onContentYChanged: {
            if (atYBeginning) showPlayer = true
            if (atYEnd) showPlayer = false
            }
            onMovementStarted: {
                retning = contentY
            }
            onVerticalVelocityChanged: {
                if (contentY > retning+10) showPlayer = false; else if (contentY < retning-10) showPlayer = true;
            }
            onMovementEnded: {
                //if (!showPlayer && contentY == -110) showPlayer = true
                    //console.log("verticalVolocity: "+verticalVelocity+" - contentY: "+contentY)
            }


            PageHeader {
                        id: pHeader
                        title: qsTr("Most popular tags")
                    }

        Flow {
            id: flow
            anchors.top: pHeader.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: Theme.paddingLarge
            spacing: Theme.paddingLarge

            Repeater {
                id: elements
                model: getTags.model
                Text {
                    id: tagtext
                    text: model.name;

                    font.pixelSize: (model.stationcount / 330) * (Theme.fontSizeHuge - Theme.fontSizeSmall) + Theme.fontSizeSmall

                    color: {
                        if (font.pixelSize < Theme.fontSizeMedium) Theme.secondaryColor;
                        else if (font.pixelSize >= Theme.fontSizeMedium) Theme.primaryColor
                    }

                    MouseArea {
                        id: m
                        anchors.fill: parent
                        onPressedChanged: pressed ? tagtext.color = Theme.highlightColor : tagtext.color = Theme.primaryColor
                        onClicked: window.pageStack.push(Qt.resolvedUrl("Search.qml"),
                                                                    {searchterm: model.name,searchby: "bytag"})
                    }
                }
            }
        }
        PullMenu {}
    }
    PlayerPanel { id:playerPanel}

}
