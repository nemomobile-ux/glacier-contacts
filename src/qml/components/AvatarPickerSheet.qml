/*
 * Copyright (C) 2012 Jolla Ltd.
 * Copyright (C) 2011-2012 Robin Burchell <robin+mer@viroteck.net>
 * Copyright (C) 2018-2021 Chupligin Sergey <neochapay@gmail.com>
 *
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

import QtQuick 2.6

import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0

import Nemo.Thumbnailer 1.0
import org.nemomobile.gallery 1.0
import org.nemomobile.contacts 1.0

Page {
    id: avatarPickerSheet

    headerTools:  HeaderToolsLayout {
        id: hTools
        title: qsTr("Add contact photo")
        showBackButton: true
    }

    property Person contact
    signal avatarPicked(string pathToAvatar)

    Rectangle {
        color: Theme.backgroundColor
        width: parent.width
        height: parent.height-accept.height

        GalleryView {
            id: avatarGridView
            property string filePath
            property bool itemSelected: false

            width: parent.width
            height: parent.height

            model: GalleryModel { }
            delegate: GalleryDelegate {
                id: delegateInstance
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        avatarGridView.itemSelected = true
                        avatarGridView.currentIndex = index
                        avatarGridView.filePath = url
                    }
                }
                Rectangle {
                    color: Theme.accentColor
                    opacity: 0.3
                    visible: delegateInstance.GridView.isCurrentItem && avatarGridView.itemSelected
                    anchors.fill: parent
                }
            }
        }

        Label {
            id: noPhotoLabel
            text: qsTr("No photo")
            anchors.centerIn: parent
            visible: avatarGridView.model.count == 0
        }
    }


    Button {
        id: cancel
        width: parent.width / 2
        height: Theme.itemHeightLarge
        anchors {
            left: parent.left
            bottom: parent.bottom
        }
        text: qsTr("Cancel")
        onClicked: {
            if(avatarGridView.itemSelected) {
                avatarGridView.itemSelected = false
            } else {
                pageStack.pop()
            }
        }
    }
    Button {
        id: accept
        width: parent.width / 2
        height: Theme.itemHeightLarge
        text: qsTr("Select")

        enabled: avatarGridView.itemSelected

        anchors {
            left: cancel.right
            bottom: parent.bottom
        }
        onClicked: {
            avatarPicked(avatarGridView.filePath)
        }
    }
}


