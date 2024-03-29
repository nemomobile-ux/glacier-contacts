/*
 * Copyright (C) 2011-2012 Robin Burchell <robin+mer@viroteck.net>
 * Copyright (C) 2017-2023 Chupligin Sergey <neochapay@gmail.com>
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

import QtQuick
import QtQuick.Controls

import Nemo
import Nemo.Controls

import Nemo.Dialogs 1.0

import org.nemomobile.qmlcontacts 1.0
import org.nemomobile.contacts 1.0

import "../components"

Page {
    id: groupedViewPage

    headerTools:  HeaderToolsLayout {
        id: hTools
        title: qsTr("Contacts")

        tools: [
            ToolButton{
                iconSource: "image://theme/user-plus"
                onClicked: {
                    app.push(Qt.resolvedUrl("ContactEditPage.qml"), {add : true});
                }
            }
        ]
        drawerLevels: [
            Button {
                anchors.horizontalCenter: (parent==undefined) ? undefined : parent.horizontalCenter;
                text: qsTr("Import contacts")
                onClicked: {
                    app.push(Qt.resolvedUrl("../components/ContactImportSheet.qml"))
                }
            }
        ]
    }

    SearchBox {
        id: searchbox
        placeHolderText: qsTr("Search")
        anchors.top: parent.top
        width: parent.width
        onSearchTextChanged: {
            app.contactListModel.search(searchbox.searchText);
        }

        visible: (gvp.count !== 0) || (searchText.length > 0)
    }

    Component {
        id: contactComponent
        Person {
        }
    }

    ContactListWidget {
        id: gvp
        anchors.top: searchbox.bottom
        width: parent.width
        anchors.bottom: parent.bottom
        clip: true
        onAddNewContact: {
            var editor = app.openSheet(Qt.resolvedUrl("ContactEditPage.qml"))
            editor.contact = contactComponent.createObject(editor)
        }

        searching: (searchbox.searchText.length > 0)
        model: app.contactListModel
        delegate: ContactListDelegate {
            id: card

            actions: [
                ActionButton{
                    id: editButton
                    iconSource: "image://theme/pencil"
                    onClicked: {
                        if (model.person.addressBook.isAggregate) {
                            app.push(Qt.resolvedUrl("ContactAggListPage.qml"), { contact: model.person })

                        } else {
                            app.push(Qt.resolvedUrl("ContactEditPage.qml"), { contact: model.person })
                        }
                    }
                },
                ActionButton{
                    id: deleteButton
                    iconSource:  "image://theme/trash"
                    onClicked: {
                        deleteConfirmationDialog.contact = model.person
                        deleteConfirmationDialog.visible = true
                    }
                }

            ]

            onClicked: app.push(Qt.resolvedUrl("ContactCardPage.qml"), { contact: model.person })
        }

    }

    ScrollDecorator {
        flickable: gvp
    }

    QueryDialog {
        id: exportCompleteDialog
        property string path

        acceptText: qsTr("Ok")
        headingText: qsTr("Export completed");
        subLabelText: qsTr("Export completed to ") + exportCompleteDialog.path

        visible: false
    }

    DeleteContactDialog {
        id: deleteConfirmationDialog
    }
}

