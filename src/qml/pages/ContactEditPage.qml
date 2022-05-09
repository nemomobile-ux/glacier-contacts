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

        data_firstName.text = contact.firstName
        data_middleName.text = contact.middleName
        data_last.text = contact.lastName
        data_avatar.contact = contact
        data_company.text = contact.companyName
        data_title.text = contact.title
        data_role.text = contact.role
        data_department.text = contact.department
        data_birthday.text = contact.birthday

        emailRepeater.setModelData(contact.emailDetails)
        phoneRepeater.setModelData(contact.phoneDetails)
        addressDetailsRepeater.setModelData(contact.addressDetails)
        nicknameDetailsRepeater.setModelData(contact.nicknameDetails)
        websiteRepeater.setModelData(contact.websiteDetails)
        anniversaryRepeater.setModelData(contact.anniversaryDetails)
        noteRepeater.setModelData(contact.noteDetails)
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
                    data_avatar.contact.avatarPath = avatar
                    pageStack.pop()
                });
            }
            ContactAvatarImage {
                id: data_avatar
                property url originalSource
                property bool edited: fullSource != originalSource
                width: parent.width - Theme.itemSpacingMedium
                height: parent.height - Theme.itemSpacingMedium
                anchors.centerIn: parent
                contact: newContactViewPage.contact
            }
        }

        Column {
            id: contactFields
            spacing: Theme.itemSpacingSmall
            anchors {
                top: avatarRect.bottom;
                left: parent.left
                right: parent.right;
                topMargin: Theme.itemSpacingMedium
                leftMargin: Theme.itemSpacingMedium
                rightMargin: Theme.itemSpacingMedium
            }

            TextField {
                id: data_firstName
                placeholderText: qsTr("First name")
                width: parent.width
                property bool edited: text !== contact.firstName
            }

            TextField {
                id: data_middleName
                placeholderText: qsTr("Middle name")
                width: parent.width
                property bool edited: text !== contact.middleName
            }

            TextField {
                id: data_last
                property bool edited: text !== contact.lastName
                width: parent.width
                placeholderText: qsTr("Last name")
            }

            EditableList {
                id: phoneRepeater
                width: parent.width
                editable: "number"
                placeholderText: qsTr("Phones")
            }

            EditableList {
                id: emailRepeater
                editable: "address"
                placeholderText: qsTr("Email address")
                width: parent.width
            }

            EditableList {
                id: websiteRepeater
                editable: "url"
                placeholderText: qsTr("Web site")
                width: parent.width
            }

            TextField {
                id: data_company
                property bool edited: text !== contact.companyName
                width: parent.width
                placeholderText: qsTr("Company")
            }

            TextField {
                id: data_title
                property bool edited: text !== contact.title
                width: parent.width
                placeholderText: qsTr("Title")
            }

            TextField {
                id: data_role
                property bool edited: text !== contact.role
                width: parent.width
                placeholderText: qsTr("Role")
            }

            TextField {
                id: data_department
                property bool edited: text !== contact.department
                width: parent.width
                placeholderText: qsTr("Department")
            }

            EditableList {
                id: nicknameDetailsRepeater
                editable: "nickname"
                width: parent.width
                placeholderText: qsTr("Nickname")
            }

            EditableList {
                id: addressDetailsRepeater
                width: parent.width
                editable: "address"
                placeholderText: qsTr("Address")

            }

            TextField {
                id: data_birthday
                property bool edited: text !== contact.birthday
                width: parent.width
                placeholderText: qsTr("Birthday")
            }

            EditableList {
                id: anniversaryRepeater
                editable: "originalDate"
                placeholderText: qsTr("Anniversary")
                width: parent.width
            }

            EditableList {
                id: noteRepeater
                editable: "note"
                placeholderText: qsTr("Note")
                width: parent.width
            }

        }
        Row {
            anchors{
                top: contactFields.bottom
                topMargin: Theme.itemSpacingMedium
                left: parent.left
                right: parent.rigth
            }
            width: parent.width

            Button{
                id: saveButton
                text: qsTr("Save")
                width: parent.width/2
                onClicked: saveContact()
                primary: true
                enabled: data_firstName.edited || data_middleName.edited || data_last.edited ||
                         data_company.edited || data_title.edited || data_role.edited || data_department.edited ||
                         data_avatar.edited || addressDetailsRepeater.edited ||  phoneRepeater.edited || emailRepeater.edited ||
                         websiteRepeater.edited || data_birthday.edited || anniversaryRepeater.edited || noteRepeater.edited
            }

            Button{
                id: cancelButton
                text: qsTr("Cancel")
                width: parent.width/2
                onClicked: pageStack.pop();
            }
        }
    }

    ScrollDecorator {
        flickable: contactsEditPageFlickable
    }



    function modelToList(model, format_function) {
        var details = []
        for(var i = 0; i < model.count; i++) {
            var item = model.get(i).data
            details.push(format_function(item))
        }
        return details;

    }

    function saveContact() {
        contact.firstName = data_firstName.text
        contact.middleName = data_middleName.text
        contact.lastName = data_last.text
        contact.companyName = data_company.text
        contact.title = data_title.text
        contact.role = data_role.text
        contact.department = data_department.text
        contact.avatarPath = data_avatar.contact.avatarPath

        contact.birthday = (data_birthday.text !== "") ? new Date(data_birthday.text) : undefined;

        contact.nicknameDetails = modelToList(nicknameDetailsRepeater.model, makeNicknameDetail)
        contact.addressDetails = modelToList(addressDetailsRepeater.model, makeAddressDetail)
        contact.phoneDetails = modelToList(phoneRepeater.model, makePhoneNumber);
        contact.emailDetails = modelToList(emailRepeater.model, makeEmailAddress);
        contact.websiteDetails = modelToList(websiteRepeater.model, makeWebsiteDetail)
        contact.anniversaryDetails = modelToList(anniversaryRepeater.model, makeAnniversaryDetail)
        contact.noteDetails = modelToList(noteRepeater.model, makeNoteDetail)

        contact.recalculateDisplayLabel()

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

    function makeAddressDetail(address) {
        return {
            type: Person.AddressType,
            label: 0,
            address: address,
        }
    }
    function makeWebsiteDetail(url) {
        return {
            type: Person.WebsiteType,
            label: 0,
            url: url,
        }
    }
    function makeAnniversaryDetail(originalDate) {
        return {
            type: Person.AnniversaryType,
            label: 0,
            originalDate: originalDate
        }
    }
    function makeNoteDetail(note) {
        return {
            type: Person.NoteType,
            label: 0,
            note: note
        }
    }

    function makeNicknameDetail(nickname) {
        return {
            type: Person.NicknameType,
            label: 0,
            nickname: nickname
        }
    }
}


