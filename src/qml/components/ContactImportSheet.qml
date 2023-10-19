/*
 * Copyright (C) 2011-2012 Robin Burchell <robin+mer@viroteck.net>
 * Copyright (C) 2012 Jolla Ltd.
 * Copyright (C) 2023 Chupligin Sergey <neochapay@gmail.com>
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

import org.nemomobile.contacts 1.0
import org.nemomobile.folderlistmodel 1.0
import org.nemomobile.filemuncher 1.0

import Nemo.Dialogs 1.0


Page {
    id: newContactViewPage

    headerTools: HeaderToolsLayout {
        title: qsTr("Import contacts")
        showBackButton: false;
    }

    onStatusChanged: {
        if (status === Page.Opening) {
            sheetContent.fileName = ""
            folderListModel.refresh()
        }
    }

    ListView {
        id: sheetContent
        anchors {
            top: parent.top;
            left: parent.left;
            right: parent.right;
            bottom: cancel.top;
            }

        property string fileName

        model: FolderListModel {
            id: folderListModel
            path: DocumentsLocation
            showDirectories: false
            nameFilters: [ "*.vcf" ]
        }

        delegate: FileListDelegate {
            iconVisible: false;
            showActions: false;
            selected: sheetContent.fileName === model.fileName
            onClicked: {
                sheetContent.fileName = model.fileName
            }
        }
    }

    Spinner {
        anchors.centerIn: parent;
        state: folderListModel.awaitingResults
    }

    Label {
        anchors.fill: parent;
        anchors.margins: Theme.itemSpacingSmall
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.Wrap
        visible: !folderListModel.awaitingResults && (folderListModel.rowCount() === 0)
        text: qsTr("Please copy *.vcf into %1").arg(DocumentsLocation)
    }

    Button {
        id: cancel
        width: parent.width / 2
        height: Theme.itemHeightLarge
        text: qsTr("Cancel")
        anchors {
            left: parent.left
            bottom: parent.bottom
        }
        onClicked: {
            app.pop()
        }
    }

    Button {
        id: accept
        width: parent.width / 2
        height: Theme.itemHeightLarge
        primary: true
        text: qsTr("Import")
        enabled: sheetContent.fileName !== ""
        anchors {
            left: cancel.right
            bottom: parent.bottom
        }
        onClicked: {
            doImport();
        }
    }


    function doImport() {
        // TODO: would be nice if folderlistmodel had a role for the full
        // resolved path
        console.log("Importing " + sheetContent.fileName)
        var count = app.contactListModel.importContacts(folderListModel.path + "/" + sheetContent.fileName)
        importCompletedDialog.contactCount = count
        importCompletedDialog.open()
    }

    Dialog {
        id: importCompletedDialog
        property int contactCount: 0
        inline: false;
        subLabelText: qsTr("Imported %n contacts", "ContactImportSheet", importCompletedDialog.contactCount)
        headingText: qsTr("Import completed")
        acceptText: qsTr("Ok")
        onAccepted: {
            app.pop();
        }
    }
}


