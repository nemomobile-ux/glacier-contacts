/*
 * Copyright (C) 2011-2012 Robin Burchell <robin+mer@viroteck.net>
 * Copyright (C) 2018 Chupligin Sergey <neochapay@gmail.com>
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

import org.nemomobile.contacts 1.0
import org.nemomobile.qmlcontacts 1.0
import org.nemomobile.voicecall 1.0

Flickable {
    id: detailViewPortrait
    contentWidth: parent.width
    contentHeight: childrenRect.height
    flickableDirection: Flickable.VerticalFlick
    clip: true

    property Person contact
    property VoiceCallManager callManager

    Item {
        id: header
        height: avatar.height + Theme.itemSpacingMedium
        property int shortSize: parent.parent.width > parent.parent.height ? parent.parent.height : parent.parent.width
        ContactAvatarImage {
            id: avatar
            contact: detailViewPage.contact
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: Theme.itemSpacingMedium
            width: parent.shortSize * 0.3
            height: parent.shortSize * 0.3
        }

        Label {
            anchors.verticalCenter: avatar.verticalCenter
            anchors.left: avatar.right
            anchors.leftMargin: Theme.itemSpacingMedium
            text: contact.displayLabel
        }
    }

    Button {
        id: callButton
        anchors{
            top: header.bottom
            topMargin: Theme.itemSpacingMedium
            left: parent.left
            leftMargin: Theme.itemSpacingMedium
        }
        height: contact.phoneDetails.length > 0 ? Theme.itemHeightMedium - Theme.itemSpacingMedium : 0
        width: parent.width - Theme.itemSpacingMedium * 2
        visible: contact.phoneDetails.length > 0
        iconSource: "image://theme/icon-m-telephony-incoming-call"; // TODO: icon-m-toolbar-make-call
        text: qsTr("Call")
        onClicked: {
            if (contact.phoneNumbers.length == 1) {
                callManager.dial(callManager.defaultProviderId, contact.phoneNumbers[0])
                return
            }
        }
    }

    Button {
        id: smsButton
        anchors{
            top: callButton.bottom
            topMargin: Theme.itemSpacingMedium
            left: parent.left
            leftMargin: Theme.itemSpacingMedium
        }
        height: contact.phoneDetails.length > 0 ? Theme.itemHeightMedium - Theme.itemSpacingMedium : 0
        width: parent.width - Theme.itemSpacingMedium * 2
        visible: contact.phoneDetails.length > 0
        iconSource: "image://theme/icon-m-toolbar-send-chat";
        text: qsTr("SMS")
        onClicked: {
            if (contact.phoneDetails.length == 1) {
                messagesInterface.startSMS(contact.phoneNumbers[0])
                return
            }
        }
    }

    Button {
        id: mailButton
        anchors{
            top: smsButton.bottom
            topMargin: Theme.itemSpacingMedium
            left: parent.left
            leftMargin: Theme.itemSpacingMedium
        }
        height: contact.emailDetails.length > 0 ? Theme.itemHeightMedium - Theme.itemSpacingMedium : 0
        width: parent.width - Theme.itemSpacingMedium * 2
        visible: contact.emailDetails.length > 0
        iconSource: "image://theme/icon-m-toolbar-send-sms"; // TODO: icon-m-toolbar-send-email
        text: qsTr("Mail")
        onClicked: {
            console.log("TODO: integrate with mail client")
            if (contact.emailDetails.length == 0) {
                return
            }
        }
    }
}

