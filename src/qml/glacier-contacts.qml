/*
 * Copyright 2011 Intel Corporation.
 * Copyright (C) 2017 Chupligin Sergey <neochapay@gmail.com>
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 	
 * http://www.apache.org/licenses/LICENSE-2.0
 */

import QtQuick 2.6

import QtQuick.Controls 1.0
import QtQuick.Controls.Nemo 1.0
import QtQuick.Controls.Styles.Nemo 1.0

import org.nemomobile.contacts 1.0

import "pages"

ApplicationWindow {
    id: app

    property variant accountItem

    initialPage: Component { ContactListPage {} }

    property PeopleModel contactListModel: PeopleModel {

// for testing purposes
//        Component.onCompleted: {
//            importContacts("../test/example.vcf")
//        }
    }
}

