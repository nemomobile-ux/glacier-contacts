/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import Qt 4.7
import MeeGo.Components 0.1

Item {
    id: webRect
    height: childrenRect.height
    width:  parent.width

    property variant newDetailsModel: null 
    property int rIndex: -1
    property bool updateMode: false 

    property string defaultWeb : qsTr("Site")
    property string bookmarkWeb : qsTr("Bookmark")
    property string favoriteWeb : qsTr("Favorite")

    function parseDetailsModel(existingDetailsModel, contextModel) {
        var arr = new Array(); 
        for (var i = 0; i < existingDetailsModel.length; i++)
            arr[i] = {"web": existingDetailsModel[i], "type": contextModel[i]};

        return arr;
    }

    function getNewDetailValues() {
        var webUrlList = new Array();
        var webTypeList = new Array();
        var count = 0;

        for (var i = 0; i < newDetailsModel.count; i++) {
            if (newDetailsModel.get(i).web != "") {
                webUrlList[count] = newDetailsModel.get(i).web;
                webTypeList[count] = newDetailsModel.get(i).type;
                count = count + 1;
            }
        }
        return {"urls": webUrlList, "types": webTypeList};
    }

    function getDetails(reset) {
        var arr = {"web": data_url.text, 
                   "type": urlComboBox.selectedTitle};

        if (reset)
            resetFields();

        return arr;
    }

    function resetFields() {
       data_url.text = "";
       urlComboBox.selectedTitle = bookmarkWeb;
    }

    DropDown {
        id: urlComboBox

        anchors {left: parent.left; leftMargin: 10;}
        titleColor: theme_fontColorNormal

        width: 250
        minWidth: width
        maxWidth: width + 50

        model: [favoriteWeb, bookmarkWeb]

        state: "notInUpdateMode"

        states: [
            State {
                name: "inUpdateMode"; when: (webRect.updateMode == true)
                PropertyChanges{target: urlComboBox; title: newDetailsModel.get(rIndex).type}
                PropertyChanges{target: urlComboBox; selectedTitle: newDetailsModel.get(rIndex).type}
            },
            State {
                name: "notInUpdateMode"; when: (webRect.updateMode == false)
                PropertyChanges{target: urlComboBox; title: bookmarkWeb}
                PropertyChanges{target: urlComboBox; selectedTitle: bookmarkWeb}
            }
        ]
    }

    TextEntry {
        id: data_url
        text: (updateMode) ? newDetailsModel.get(rIndex).web : ""
        defaultText: defaultWeb
        width: 400
        anchors {left:urlComboBox.right; leftMargin: 10;}
    }
}

