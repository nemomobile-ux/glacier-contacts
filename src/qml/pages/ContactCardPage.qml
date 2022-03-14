/*
 * Copyright (C) 2011-2012 Robin Burchell <robin+mer@viroteck.net>
 * Copyright (C) 2017-2021 Chupligin Sergey <neochapay@gmail.com>
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
import org.nemomobile.voicecall 1.0

import "../components"

Page {
    id: detailViewPage
    property Person contact

    onContactChanged: {
        if ((contact === undefined) || (contact == null)) {
            return;
        }

        contact.fetchConstituents();
    }


    headerTools:  HeaderToolsLayout {
        id: hTools
        title: contact.displayLabel
        showBackButton: true
        tools: [
            ToolButton{
                iconSource: "image://theme/trash"
                onClicked:{
                    deleteConfirmationDialog.contact = contact
                    deleteConfirmationDialog.visible = true
                }
            }
            ,
            ToolButton{
                iconSource: "image://theme/pencil"
                onClicked: {
                    if (contact.addressBook.isAggregate) {
                        if (contact.constituents.length === 1) {
                            pageStack.push(Qt.resolvedUrl("ContactEditPage.qml"),
                                           { contact:  app.contactListModel.personById(contact.constituents[0])})
                        } else {
                            pageStack.push(Qt.resolvedUrl("ContactAggListPage.qml"), { contact: contact })
                        }

                    } else {
                        pageStack.push(Qt.resolvedUrl("ContactEditPage.qml"), { contact: contact })
                    }
                }
            },
            ToolButton{
                iconSource: contact.favorite ? "image://theme/bookmark" : "image://theme/bookmark-o"
                onClicked: {
                    if(contact.favorite)
                    {
                        contact.favorite = false
                    }
                    else
                    {
                        contact.favorite = true
                    }
                    app.contactListModel.savePerson(detailViewPage.contact)
                }
            }

        ]
    }

    VoiceCallManager {id:callManager}
    MessagesInterface { id: messagesInterface }

    Connections {
        target: contact
        function onContactRemoved() { pageStack.pop() }
    }

    Connections {
        target: deleteConfirmationDialog
        function onAccepted() { pageStack.pop(); }
    }

    ContactCardContentWidget {
        id: detailViewContact
        anchors.fill: parent
        contact: detailViewPage.contact
        callManager: callManager
    }

    ScrollDecorator {
        flickable: detailViewContact
    }


    DeleteContactDialog {
        id: deleteConfirmationDialog
    }
}

