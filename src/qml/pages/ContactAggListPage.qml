import QtQuick 2.6

import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0

import Nemo.Dialogs 1.0

import org.nemomobile.qmlcontacts 1.0
import org.nemomobile.contacts 1.0

import "../components"

Page {
    headerTools:  HeaderToolsLayout {
        id: hTools
        title: qsTr("Aggregated contact")
        showBackButton: true;
        tools: []

    }

    property Person contact

    onContactChanged: {
        if ((contact === undefined) || (contact == null)) {
            return;
        }

        contact.fetchConstituents();
    }

    Label {
        anchors.centerIn: parent;
        text: qsTr("Error: no aggregate contacts found");
        visible: contact.constituents.length === 0
    }

    ListView {
        anchors.fill: parent;
        model: contact.constituents.length
        delegate: ListViewItemWithActions{
            property Person p: app.contactListModel.personById(contact.constituents[index]);
            label: p.displayLabel;
            description: p.addressBook.name
            icon: "image://theme/address-book-o";

            onClicked: {
                onClicked: {
                    if (p.addressBook.isAggregate) {
                        pageStack.push(Qt.resolvedUrl("ContactAggListPage.qml"), { contact: p })
                    } else {
                        pageStack.push(Qt.resolvedUrl("ContactEditPage.qml"), { contact: p })
                    }
                }
            }
        }
    }

}
