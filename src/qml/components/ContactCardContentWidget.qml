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
    contentHeight: header.height + actionsColumn.height + 2*Theme.itemSpacingMedium
    flickableDirection: Flickable.VerticalFlick
    clip: true

    property Person contact
    property VoiceCallManager callManager

    Item {
        id: header
        height: Math.max(avatar.height, contactDetails.childrenRect.height) + Theme.itemSpacingMedium
        width: parent.parent.width
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
        Column {

            id: contactDetails
            anchors.top: parent.top;
            anchors.left: avatar.right
            anchors.right: parent.right
            anchors.margins: Theme.itemSpacingMedium

            Label {

                text: contact.displayLabel
                font.pixelSize: Theme.fontSizeLarge
                anchors.left: parent.left;
                anchors.right: parent.right

                wrapMode:Text.Wrap
            }
            Label {
                text: contact.companyName
                anchors.left: parent.left;
                anchors.right: parent.right
                wrapMode:Text.Wrap
            }
            Label {
                text: (contact.addressDetails.length > 0) ? contact.addressDetails[0].address : ""
                anchors.left: parent.left;
                anchors.right: parent.right
                wrapMode:Text.Wrap
            }
        }
    }

    Column {
        id: actionsColumn
        anchors {
            top:  header.bottom
            left: parent.left
            right: parent.right
            margins: Theme.itemSpacingMedium
        }

        Repeater {
            model: contact.phoneDetails.length

            ListViewItemWithActions {
                id: callAction
                height: Theme.itemHeightLarge
                label: qsTr("Call")
                description: contact.phoneDetails[index].number
                icon:  "image://theme/phone"
                onClicked: {
                    callManager.dial(callManager.defaultProviderId, contact.phoneDetails[index].number)
                }
            }
        }
        Repeater {
            model: contact.phoneDetails.length
            ListViewItemWithActions {
                id: smsAction
                height: Theme.itemHeightLarge
                label: qsTr("SMS")
                description: contact.phoneDetails[index].number
                icon:  "image://theme/sms"
                onClicked: {
                    messagesInterface.startConversation(callManager.defaultProviderId, contact.phoneDetails[index].number)

                }
            }


        }

        Repeater {
            model: contact.emailDetails.length;
            ListViewItemWithActions {
                label: qsTr("Mail")
                description: contact.emailDetails[index].address
                icon: "image://theme/envelope"
                onClicked: {
                    console.log("TODO: integrate with mail client: " + contact.emailDetails[index].address)
                }

            }
        }

        ListViewItemWithActions {
            visible: !isNaN(contact.birthday)
            label: contact.birthday.toLocaleDateString()
            icon: "image://theme/calendar"
            onClicked: {
                console.log("TODO: integrate with calendar")
            }
        }

    }

}

