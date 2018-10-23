VERSION = 0.7.0
PROJECT_NAME = glacier-contacts
TEMPLATE = app
CONFIG += ordered mobility hide_symbols
MOBILITY += contacts
QT += quick
TARGET = $$PROJECT_NAME
CONFIG -= app_bundle # OS X

LIBS += -lglacierapp

CONFIG += link_pkgconfig

SOURCES += src/main.cpp

OTHER_FILES += $${QML_FILES} $${JS_FILES}

target.path = /usr/bin/
INSTALLS += target

desktop.files = src/$${PROJECT_NAME}.desktop
desktop.path = /usr/share/applications
INSTALLS += desktop

icon.files = icon-app-contacts.png
icon.path = /usr/share/$${PROJECT_NAME}
INSTALLS += icon

privileges.files = rpm/glacier-contacts.privileges
privileges.path = /usr/share/mapplauncherd/privileges.d/
INSTALLS += privileges

qml.files = src/qml/*.qml
qml.files += src/qml/*.js
qml.path = /usr/share/$${PROJECT_NAME}/qml
INSTALLS += qml

# qml API we provide
api.files = src/qml/api/*
api.path = $$[QT_INSTALL_QML]/org/nemomobile/qmlcontacts
INSTALLS += api

TRANSLATIONS += translations/$${PROJECT_NAME}_en.ts\
                translations/$${PROJECT_NAME}_ru.ts
i18n_files.files = translations
i18n_files.path = /usr/share/$$TARGET
INSTALLS += i18n_files

DISTFILES += \
    src/qml/api/qmldir \
    src/qml/api/ContactListWidget.qml \
    src/qml/api/ContactListDelegate.qml \
    src/qml/api/ContactAvatarImage.qml \
    src/qml/AvatarPickerSheet.qml \
    src/qml/ContactCardContentWidget.qml \
    src/qml/ContactCardPage.qml \
    src/qml/ContactEditorSheet.qml \
    src/qml/ContactImportSheet.qml \
    src/qml/ContactListPage.qml \
    src/qml/DeleteContactDialog.qml \
    src/qml/EditableList.qml \
    src/qml/MessagesInterface.qml \
    src/qml/SearchBox.qml \
    src/glacier-contacts.desktop \
    rpm/glacier-contacts.spec \
    src/qml/glacier-contacts.qml \
    translations/glacier-contacts_en.ts \
    translations/glacier-contacts_ru.ts \
    icon-app-contacts.png

PKGCONFIG += glacierapp
