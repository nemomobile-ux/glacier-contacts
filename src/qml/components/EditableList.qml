/*
 * Copyright (C) 2011-2012 Robin Burchell <robin+mer@viroteck.net>
 * Copyright (C) 2023 Chupligin Sergey <neochapay@gmail.com>
 * You may use this file under the terms of the BSD license as follows:
 *
 * "Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *   * Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in
 *     the documentation and/or other materials provided with the
 *     distribution.
 *   * Neither the name of Nemo Mobile nor the names of its contributors
 *     may be used to endorse or promote products derived from this
 *     software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
 */

import QtQuick
import QtQuick.Controls

import Nemo
import Nemo.Controls

import org.nemomobile.contacts 1.0

Repeater {
    id: root
    property string placeholderText
    property bool edited : false
    property variant originalData

    property string editable

    model: ListModel {
    }
    property bool isSetup: false

    function setModelData(modelData) {
        isSetup = false
        model.clear()

        if(modelData) {
            for (var i = 0; i < modelData.length; ++i) {
                root.model.append({ data: modelData[i][editable].toString() })
            }
        }

        root.model.append({ data: "" })
        originalData = modelData
        isSetup = true
    }

    function modelData() {
        var modelData = []

        // the -1 here is because we want to skip the always-added empty on the
        // end of the model.
        for (var i = 0; i < root.model.count; ++i) {
            var item = model.get(i).data
            modelData.push(item)

        }
        console.log("LOOK AT ME!", modelData)

        return modelData;
    }

    delegate: Item{
        id: mainLine
        width: root.width
        height: textField.height

        TextField {
            id: textField
            text: model.data
            placeholderText: root.placeholderText
            width: root.width-height

            onTextChanged: {
                if (!root.isSetup)
                    return

                root.model.get(index).data = text

                if (!root.originalData[index] && text !== "") {
                    edited = true
                } else if(root.originalData[index] && root.originalData[index] !== text) {
                    edited = true
                } else {
                    edited = false
                }
            }
        }

        Image{
            id: addNewButton
            width: mainLine.height*0.8
            height: width
            property bool isAddButton: ((model.data !== "") && (root.model.count > 1))

            source: isAddButton ? "image://theme/minus-circle" : "image://theme/plus-circle"

            anchors{
                top: mainLine.top
                topMargin: mainLine.height*0.1
                right: mainLine.right
                rightMargin: mainLine.height*0.1
            }

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    if (addNewButton.isAddButton) {
                        root.model.remove(index)
                    } else {
                        root.model.append({ data: "" })
                    }
                }
            }
        }
    }
}

