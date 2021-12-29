cmake_minimum_required(VERSION 3.6.0)

project(glacier-contacts
	VERSION 0.7.0
	DESCRIPTION "The Glacier contacts")

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

include(FeatureSummary)
include(GNUInstallDirs)

set(INSTALL_QML_IMPORT_DIR "${CMAKE_INSTALL_FULL_LIBDIR}/qt/qml"
        CACHE PATH "Custom QML import installation directory")

set(QT_MIN_VERSION "5.11.0")
find_package(Qt5 COMPONENTS Gui Qml Quick LinguistTools REQUIRED)
find_package(Glacier 0.8 COMPONENTS App REQUIRED)
find_package(Qt5QuickCompiler)

add_subdirectory(src)

# Translations
file(GLOB TS_FILES translations/*.ts)
qt5_add_translation(QM_FILES ${TS_FILES})
add_custom_target(translations DEPENDS ${QM_FILES})
add_dependencies(glacier-contacts translations)

install(FILES ${QM_FILES}
	DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-contacts/translations)

install(FILES glacier-contacts.desktop
	DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/applications)
install(FILES icons/icon-app-contacts.png
	DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/glacier-contacts)
