/*
 * Copyright (C) 2012 Jolla Ltd.
 * Copyright (C) 2011-2012 Robin Burchell <robin+mer@viroteck.net>
 * Copyright (C) 2021 Chupligin Sergey <neochapay@gmail.com>
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

import org.nemomobile.qmlcontacts 1.0
import org.nemomobile.contacts 1.0

import "../components"

Page {
    id: newContactViewPage

    property bool add: false

    headerTools:  HeaderToolsLayout {
        id: hTools
        title: add ? qsTr("Add contact") : qsTr("Edit contact")
        showBackButton: true
    }

    property Person contact

    Connections {
        target: contact
        function onContactRemoved() {
            reject()
        }
    }

    Component.onCompleted: {
        if(add) {
            contact = newPreson
        }
    }

    Person {
        id: newPreson
    }

    onContactChanged: {
        data_first.text = contact.firstName
        data_last.text = contact.lastName
        data_avatar.contact = contact
        if (contact.avatarPath != "image://theme/user" ) {
            if (String(contact.avatarPath).startsWith("image://")) { // don't add thumbnail if already image provider
                data_avatar.originalSource = contact.avatarPath
            } else {
                data_avatar.originalSource = "image://nemothumbnail/" + contact.avatarPath
            }
        } else {
            data_avatar.originalSource = contact.avatarPath
        }

        emailRepeater.setModelData(contact.emailDetails)
        phoneRepeater.setModelData(contact.phoneDetails)
    }

    Flickable {
        id: contactsEditPageFlickable
        anchors.fill: parent

        contentHeight: contentItem.childrenRect.height + 2 * Theme.itemSpacingMedium;

        Button {
            id: avatarRect
            width: parent.width/3
            height: width

            anchors {
                top: parent.top;
                topMargin: Theme.itemSpacingMedium;
                horizontalCenter: parent.horizontalCenter
            }

            onClicked: {
                var avatarPicker = pageStack.push(Qt.resolvedUrl("../components/AvatarPickerSheet.qml"), { contact: contact })

                avatarPicker.avatarPicked.connect(function(avatar) {
                    data_avatar.source = avatar
                    pageStack.pop()
                });
            }
            ContactAvatarImage {
                id: data_avatar
                property string originalSource
                property bool edited: source != originalSource
                width: parent.width - Theme.itemSpacingMedium
                height: parent.height - Theme.itemSpacingMedium
                anchors.centerIn: parent
                contact: newContactViewPage.contact
            }
        }

        TextField {
            id: data_first
            placeholderText: qsTr("First name")
            property bool edited: text != contact.firstName
            anchors {
                top: avatarRect.bottom;
                topMargin: Theme.itemSpacingMedium
                left: parent.left;
                leftMargin: Theme.itemSpacingMedium
            }
            width: parent.width-Theme.itemSpacingMedium*2
            font.pixelSize: Theme.fontSizeLarge
        }

        TextField {
            id: data_last
            placeholderText: qsTr("Last name")
            property bool edited: text != contact.lastName
            anchors {
                top: data_first.bottom;
                topMargin: Theme.itemSpacingMedium;
                left: parent.left
                leftMargin: Theme.itemSpacingMedium
            }
            width: parent.width-Theme.itemSpacingMedium*2
            font.pixelSize: Theme.fontSizeLarge
        }


        Column {
            id: phones
            anchors{
                top: data_last.bottom
                topMargin: Theme.itemSpacingMedium
                left: parent.left
                leftMargin: Theme.itemSpacingMedium
            }
            spacing: Theme.itemSpacingSmall
            width: parent.width-Theme.itemSpacingMedium*2
            EditableList {
                id: phoneRepeater
                width: parent.width
                editable: "number"
                placeholderText: qsTr("Phones")
            }
        }


        Column {
            id: mails
            anchors{
                top: phones.bottom
                topMargin: Theme.itemSpacingMedium
                left: parent.left
                leftMargin: Theme.itemSpacingMedium
            }
            spacing: Theme.itemSpacingSmall
            width: parent.width-Theme.itemSpacingMedium*2
            EditableList {
                id: emailRepeater
                editable: "address"
                placeholderText: qsTr("Email address")
                width: parent.width
            }
        }


        Button{
            id: saveButton
            text: qsTr("Save")
            width: parent.width/2
            anchors{
                top: mails.bottom
                topMargin: Theme.itemSpacingMedium
                left: parent.left
            }
            onClicked: saveContact()
            primary: true
            enabled: data_first.edited || data_last.edited || data_avatar.edited || phoneRepeater.edited || emailRepeater.edited
        }

        Button{
            id: cancelButton
            text: qsTr("Cancel")
            width: parent.width/2
            anchors{
                top: mails.bottom
                topMargin: Theme.itemSpacingMedium
                left: saveButton.right
            }
            onClicked: pageStack.pop();
        }
    }

    ScrollDecorator {
        flickable: contactsEditPageFlickable
    }

    function saveContact() {
        contact.firstName = data_first.text
        contact.lastName = data_last.text
        contact.avatarPath = data_avatar.source

        /*Format phones*/
        var phoneDetails = []
        var phones = phoneRepeater.model
        for(var i=0; i < phones.count; i++) {
            var phone = phones.get(i).data
            phoneDetails.push(makePhoneNumber(phone))
        }
        contact.phoneDetails = phoneDetails

        /*Format mails*/
        var emailDetails = []
        var mails = emailRepeater.model
        for(var i=0; i < mails.count; i++) {
            var mail = mails.get(i).data
            emailDetails.push(makeEmailAddress(mail))
        }
        contact.emailDetails = emailDetails

        // TODO: this isn't asynchronous
        app.contactListModel.savePerson(contact)

        // TODO: revisit
        if (contact.dirty) {
            console.log("[saveContact] Unable to create new contact due to missing info");
        } else {
            console.log("[saveContact] Saved contact")
            onClicked: pageStack.pop();
        }
    }

    /*TODO: add types, labels and etc*/
    function makePhoneNumber(phone) {
        return {
            number: phone,
            type: Person.PhoneNumberType,
            subTypes: 0,
            label: 0,
            index: -1
        }
    }

    function makeEmailAddress(mail) {
        return {
            address: mail,
            type: Person.EmailAddressType,
            label: 0
        }
    }
}


